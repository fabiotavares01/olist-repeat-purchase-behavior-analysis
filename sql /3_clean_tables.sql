--- Clean tables 


-- Create this extension to use UNACCENT to remove accents from words

CREATE EXTENSION IF NOT EXISTS unaccent


-- Create the clean tables:

-- customers

CREATE TABLE clean_customers AS
SELECT
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    INITCAP(UNACCENT(customer_city)) AS customer_city,
    customer_state
FROM customers;

-- geolocation

CREATE TABLE clean_geolocation AS
SELECT
    geolocation_zip_code_prefix,
    AVG(geolocation_lat) as geolocation_lat,
    AVG(geolocation_lng) as geolocation_lng,
    INITCAP(UNACCENT(MAX(geolocation_city))) as geolocation_city,
    MAX(geolocation_state) as geolocation_state
FROM geolocation
WHERE geolocation_lat BETWEEN -33.75 AND 5.27
  AND geolocation_lng BETWEEN -73.99 AND -34.73
GROUP BY geolocation_zip_code_prefix;

-- order_items

CREATE TABLE clean_order_items AS
SELECT
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value
FROM order_items;

-- order_reviews

CREATE TABLE clean_order_reviews AS
SELECT
    DISTINCT ON (order_id) 
    order_id,
    review_id,
    review_score,
    CASE
        WHEN review_score BETWEEN 1 AND 2 THEN 'Detractor'
        WHEN review_score = 3 THEN 'Neutral'
        WHEN review_score BETWEEN 4 AND 5 THEN 'Promoter'
    END AS review_tier,
    CASE
        WHEN review_comment_title IS NOT NULL 
            THEN review_comment_title
        WHEN review_comment_title IS NULL AND review_comment_message IS NULL 
            THEN 'NO REVIEW'
        WHEN review_comment_title IS NULL AND review_comment_message IS NOT NULL 
            THEN 'NO COMMENT TITLE'
    END AS review_comment_title,
    CASE 
        WHEN review_commen0t_message IS NOT NULL
            THEN review_comment_message
        WHEN review_comment_message IS NULL AND review_comment_title IS NOT NULL
            THEN 'NO COMMENT MESSAGE'
        WHEN review_comment_message IS NULL AND review_comment_title IS NULL
            THEN 'NO REVIEW'
    END AS review_comment_message,
    review_creation_date::DATE AS review_creation_date,
    review_answer_timestamp::DATE AS review_answer_timestamp,
    review_answer_timestamp::DATE - review_creation_date::DATE AS days_to_response
FROM order_reviews
ORDER BY order_id, review_answer_timestamp DESC;

-- orders

CREATE TABLE clean_orders AS
SELECT
    order_id,
    customer_id,
    INITCAP(order_status) AS order_status,
    order_purchase_timestamp::DATE AS order_purchase_date,
    COALESCE(
        order_approved_at,
        order_purchase_timestamp + (
            SELECT MAKE_INTERVAL(days => PERCENTILE_CONT(0.5) WITHIN GROUP (
                ORDER BY (order_approved_at - order_purchase_timestamp)
            )::int)
            FROM orders
            WHERE order_purchase_timestamp IS NOT NULL
            AND order_approved_at IS NOT NULL
            AND order_status IN ('shipped', 'invoiced', 'approved', 'processing', 'delivered')
        )
    )::date AS order_approved_at,
    COALESCE(
        order_delivered_carrier_date,
        order_approved_at + (
            SELECT MAKE_INTERVAL(days => PERCENTILE_CONT(0.5) WITHIN GROUP (
                ORDER BY (order_delivered_carrier_date - order_approved_at)
            )::int)
            FROM orders
            WHERE order_approved_at IS NOT NULL
            AND order_delivered_carrier_date IS NOT NULL
            AND order_status IN ('shipped', 'delivered')
        )
    )::date AS order_delivered_carrier_date,
    COALESCE(
        order_delivered_customer_date,
        order_delivered_carrier_date + (
            SELECT MAKE_INTERVAL(days => PERCENTILE_CONT(0.5) WITHIN GROUP (
                ORDER BY (order_delivered_customer_date - order_delivered_carrier_date)
            )::int)
            FROM orders
            WHERE order_delivered_carrier_date IS NOT NULL
            AND order_delivered_customer_date IS NOT NULL
            AND order_status = 'delivered'
        )
    )::date AS order_delivered_customer_date,
    order_estimated_delivery_date::DATE AS order_estimated_delivery_date,
    CASE
        WHEN order_status != 'delivered' AND order_delivered_customer_date IS NULL THEN 'NOT DELIVERED'
        WHEN order_delivered_customer_date::DATE <= order_estimated_delivery_date::DATE THEN 'ON TIME'
        WHEN order_delivered_customer_date::DATE > order_estimated_delivery_date::DATE THEN 'LATE'
    END AS delivery_status,
    order_delivered_customer_date::DATE - order_estimated_delivery_date::DATE AS days_difference
FROM orders
WHERE order_status NOT IN ('cancelled', 'unavailable');

-- products

CREATE TABLE clean_products AS
SELECT
    product_id,
    COALESCE(INITCAP(REPLACE(pt.product_category_name_english, '_', ' ')), 'Unknown') AS product_category_name,
    COALESCE(product_name_lenght, (SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY product_name_lenght) FROM products WHERE product_name_lenght IS NOT NULL)) AS product_name_lenght,
    COALESCE(product_description_lenght, (SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY product_description_lenght) FROM products WHERE product_description_lenght IS NOT NULL)) AS product_description_lenght,
    COALESCE(product_photos_qty, (SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY product_photos_qty) FROM products WHERE product_photos_qty IS NOT NULL)) AS product_photos_qty,
    COALESCE(product_weight_g, (SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY product_weight_g) FROM products WHERE product_weight_g IS NOT NULL)) AS product_weight_g,
    COALESCE(product_length_cm, (SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY product_length_cm) FROM products WHERE product_length_cm IS NOT NULL)) AS product_length_cm,
    COALESCE(product_height_cm, (SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY product_height_cm) FROM products WHERE product_height_cm IS NOT NULL)) AS product_height_cm,
    COALESCE(product_width_cm, (SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY product_width_cm) FROM products WHERE product_width_cm IS NOT NULL)) AS product_width_cm
FROM products AS p
LEFT JOIN product_category_name_translation AS pt
ON p.product_category_name = pt.product_category_name;

-- sellers

CREATE TABLE clean_sellers AS
WITH ranked_sellers AS (
    SELECT 
        seller_id,
        seller_zip_code_prefix,
        INITCAP(UNACCENT(seller_city)) AS seller_city,
        seller_state,
        'Seller ' || ROW_NUMBER() OVER (ORDER BY seller_state, seller_city) AS seller_name
    FROM sellers
)
SELECT *
FROM ranked_sellers;
