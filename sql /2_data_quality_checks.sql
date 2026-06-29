--- Data cleaning: checking for duplicates and NULL values


--- Cheking for duplicates:

-- customers

SELECT 
	customer_id, 
	COUNT(*) 
FROM customers
GROUP BY customer_id 
HAVING COUNT(*) > 1;

-- geolocation 

SELECT 
	geolocation_zip_code_prefix, 
	geolocation_lat, geolocation_lng, 
	COUNT(*)
FROM geolocation
GROUP BY 
	geolocation_zip_code_prefix, 
	geolocation_lat, 
	geolocation_lng
HAVING COUNT(*) > 1;

-- order_items

SELECT 
	order_id, 
	order_item_id, 
	COUNT(*) 
FROM order_items
GROUP BY 
	order_id, 
	order_item_id 
	HAVING COUNT(*) > 1;

-- order_reviews

SELECT 
	order_id, 
	review_id, 
	COUNT(*) 
FROM order_reviews
GROUP BY 
	order_id, 
	review_id 
HAVING COUNT(*) > 1;

-- orders

SELECT 
	order_id, 
	COUNT(*) 
FROM orders
GROUP BY order_id 
HAVING COUNT(*) > 1;

-- products

SELECT 
	product_id, 
	COUNT(*) 
FROM products
GROUP BY product_id 
HAVING COUNT(*) > 1;

-- sellers

SELECT 
	seller_id, 
	COUNT(*) 
FROM sellers
GROUP BY seller_id 
HAVING COUNT(*) > 1;

-- product_category_name_translation

SELECT 
	product_category_name,
	COUNT(*) 
FROM product_category_name_translation
GROUP BY product_category_name 
HAVING COUNT(*) > 1;



--- Checking for NULL vaues

-- customers

SELECT
	COUNT(*) FILTER (WHERE customer_id IS NULL) AS customer_id,
	COUNT(*) FILTER (WHERE customer_unique_id IS NULL) AS customer_unique_id,
	COUNT(*) FILTER (WHERE customer_zip_code_prefix IS NULL) AS customer_zip_code_prefix,
	COUNT(*) FILTER (WHERE customer_city IS NULL) AS customer_city,
	COUNT(*) FILTER (WHERE customer_state IS NULL) AS customer_state
FROM customers; 

-- geolocation

SELECT 
	COUNT(*) FILTER (WHERE geolocation_zip_code_prefix IS NULL) AS geolocation_zip_code_prefix,
	COUNT(*) FILTER (WHERE geolocation_lat IS NULL) AS geolocation_lat,
	COUNT(*) FILTER (WHERE geolocation_lng IS NULL) AS geolocation_lng,
	COUNT(*) FILTER (WHERE geolocation_city IS NULL) AS geolocation_city,
	COUNT(*) FILTER (WHERE geolocation_state IS NULL) AS geolocation_state
FROM geolocation; 

-- order_items

SELECT
	COUNT(*) FILTER (WHERE order_id IS NULL) AS order_id,
	COUNT(*) FILTER (WHERE order_item_id IS NULL) AS order_item_id,
	COUNT(*) FILTER (WHERE product_id IS NULL) AS product_id,
	COUNT(*) FILTER (WHERE seller_id IS NULL) AS seller_id,
	COUNT(*) FILTER (WHERE shipping_limit_date IS NULL) AS shipping_limit_date,
	COUNT(*) FILTER (WHERE price IS NULL) AS price,
	COUNT(*) FILTER (WHERE freight_value IS NULL) AS freight_value
FROM order_items; 

-- order_reviews

SELECT
	COUNT(*) FILTER (WHERE review_id IS NULL) AS review_id,
	COUNT(*) FILTER (WHERE order_id IS NULL) AS order_id,
	COUNT(*) FILTER (WHERE review_score IS NULL) AS review_score,
	COUNT(*) FILTER (WHERE review_comment_title IS NULL) AS review_comment_title,
	COUNT(*) FILTER (WHERE review_comment_message IS NULL) AS review_comment_message,
	COUNT(*) FILTER (WHERE review_creation_date IS NULL) AS review_creation_date,
	COUNT(*) FILTER (WHERE review_answer_timestamp IS NULL) AS review_answer_timestamp
FROM order_reviews; 

-- orders

SELECT
	COUNT(*) FILTER (WHERE order_id IS NULL) AS order_id,
	COUNT(*) FILTER (WHERE customer_id IS NULL) AS customer_id,
	COUNT(*) FILTER (WHERE order_status IS NULL) AS order_status,
	COUNT(*) FILTER (WHERE order_purchase_timestamp IS NULL) AS order_purchase_timestamp,
	COUNT(*) FILTER (WHERE order_approved_at IS NULL) AS order_approved_at,
	COUNT(*) FILTER (WHERE order_delivered_carrier_date IS NULL) AS order_delivered_carrier_date,
	COUNT(*) FILTER (WHERE order_delivered_customer_date IS NULL) AS order_delivered_customer_date,
	COUNT(*) FILTER (WHERE order_estimated_delivery_date IS NULL) AS order_estimated_delivery_date
FROM orders; 

-- product_category_name_translation

SELECT
	COUNT(*) FILTER (WHERE product_category_name IS NULL) AS product_category_name,
	COUNT(*) FILTER (WHERE product_category_name_english IS NULL) AS product_category_name_english
FROM product_category_name_translation;

-- products

SELECT 
	COUNT(*) FILTER (WHERE product_id IS NULL) AS product_id,
	COUNT(*) FILTER (WHERE product_category_name IS NULL) AS product_category_name,
	COUNT(*) FILTER (WHERE product_name_lenght IS NULL) AS product_name_lenght,
	COUNT(*) FILTER (WHERE product_description_lenght IS NULL) AS product_description_lenght,
	COUNT(*) FILTER (WHERE product_photos_qty IS NULL) AS product_photos_qty,
	COUNT(*) FILTER (WHERE product_weight_g IS NULL) AS product_weight_g,
	COUNT(*) FILTER (WHERE product_length_cm IS NULL) AS product_length_cm,
	COUNT(*) FILTER (WHERE product_height_cm IS NULL) AS product_height_cm,
	COUNT(*) FILTER (WHERE product_width_cm IS NULL) AS product_width_cm
FROM products; 

-- sellers

SELECT
	COUNT(*) FILTER (WHERE seller_id IS NULL) AS seller_id,
	COUNT(*) FILTER (WHERE seller_zip_code_prefix IS NULL) AS seller_zip_code_prefix,
	COUNT(*) FILTER (WHERE seller_city IS NULL) AS seller_city,
	COUNT(*) FILTER (WHERE seller_state IS NULL) AS seller_state
FROM sellers; 
