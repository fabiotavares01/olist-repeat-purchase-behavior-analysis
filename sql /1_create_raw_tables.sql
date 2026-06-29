--- Create the raw tables:

-- customers

CREATE TABLE customers (
	customer_id VARCHAR(32),
	customer_unique_id VARCHAR(32),
	customer_zip_code_prefix VARCHAR(10),
	customer_city VARCHAR(100),
	customer_state VARCHAR(2)
);

-- geolocation

CREATE TABLE geolocation (
	geolocation_zip_code_prefix VARCHAR(10),
	geolocation_lat DECIMAL(10, 8),
	geolocation_lng DECIMAL(11, 8),
	geolocation_city VARCHAR(100),
	geolocation_state VARCHAR(2)
);

-- order_items

CREATE TABLE order_items (
	order_id VARCHAR(32),
	order_item_id INT,
	product_id VARCHAR(32),
	seller_id VARCHAR(32),
	shipping_limit_date DATE,
	price DECIMAL(10, 2),
	freight_value DECIMAL(10, 2)
);

-- order_reviews

CREATE TABLE order_reviews (
	review_id VARCHAR(32),
	order_id VARCHAR(32),
	review_score INT,
	review_comment_title TEXT,
	review_comment_message TEXT,
	review_creation_date DATE,
	review_answer_timestamp DATE
);

-- orders

CREATE TABLE orders (
	order_id VARCHAR(32),
	customer_id VARCHAR(32),
	order_status VARCHAR(20),
	order_purchase_timestamp DATE,
	order_approved_at DATE,
	order_delivered_carrier_date DATE,
	order_delivered_customer_date DATE,
	order_estimated_delivery_date DATE	
);

-- products

CREATE TABLE products (
	product_id VARCHAR(32),
	product_category_name VARCHAR(100),
	product_name_lenght INT,
	product_description_lenght INT,
	product_photos_qty INT,
	product_weight_g INT,
	product_length_cm INT,
	product_height_cm INT,
	product_width_cm INT
);

-- sellers

CREATE TABLE sellers (
	seller_id VARCHAR(32),
	seller_zip_code_prefix VARCHAR(10),
	seller_city VARCHAR(100),
	seller_state VARCHAR(2)
);

-- product_category_name_translation

CREATE TABLE product_category_name_translation (
	product_category_name VARCHAR(100),
	product_category_name_english VARCHAR(100)
);
