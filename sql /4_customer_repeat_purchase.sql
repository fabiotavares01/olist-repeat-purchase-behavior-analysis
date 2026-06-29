--- Create the table: customer_repeat_purchase

CREATE TABLE customer_repeat_purchase AS
WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        o.order_id,
        o.order_purchase_date,
        r.review_score,
        r.review_tier,
        r.review_answer_timestamp,
        ROW_NUMBER() OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_date
        ) AS order_rank
    FROM clean_customers c
    JOIN clean_orders o ON c.customer_id = o.customer_id
    LEFT JOIN clean_order_reviews r ON o.order_id = r.order_id
),
first_order AS (
    SELECT
        customer_unique_id,
        order_id AS first_order_id,
        order_purchase_date AS first_order_date,
        review_score,
        review_tier,
        review_answer_timestamp
    FROM customer_orders
    WHERE order_rank = 1
),
second_order AS (
    SELECT
        customer_unique_id,
        order_id AS second_order_id,
        order_purchase_date AS second_order_date
    FROM customer_orders
    WHERE order_rank = 2
),
first_order_category AS (
    SELECT DISTINCT ON (oi.order_id)
        oi.order_id,
        p.product_category_name
    FROM clean_order_items oi
    JOIN clean_products p ON oi.product_id = p.product_id
    ORDER BY oi.order_id, oi.price DESC
)
SELECT
    f.customer_unique_id,
    f.first_order_id,
    f.first_order_date,
    f.review_score,
    f.review_tier,
    f.review_answer_timestamp,
    fc.product_category_name,
    s.second_order_date,
    CASE
        WHEN s.second_order_date IS NULL THEN 'No Repeat'
        WHEN s.second_order_date <= f.review_answer_timestamp + INTERVAL '6 months' THEN 'Repeat Within 6 Months'
        WHEN s.second_order_date > f.review_answer_timestamp + INTERVAL '6 months' THEN 'Repeat After 6 Months'
    END AS repeat_purchase_status
FROM first_order f
LEFT JOIN second_order s ON f.customer_unique_id = s.customer_unique_id
LEFT JOIN first_order_category fc ON f.first_order_id = fc.order_id
WHERE f.review_answer_timestamp <= (SELECT MAX(review_answer_timestamp) FROM clean_order_reviews) - INTERVAL '6 months';
