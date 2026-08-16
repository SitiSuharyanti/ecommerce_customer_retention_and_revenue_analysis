CREATE TABLE customers (
    customer_id VARCHAR(32) PRIMARY KEY,
    customer_unique_id VARCHAR(32),
    customer_zip_code_prefix VARCHAR(10),
    customer_city TEXT,
    customer_state VARCHAR(2)
);

CREATE TABLE orders (
    order_id VARCHAR(32) PRIMARY KEY,
    customer_id VARCHAR(32) REFERENCES customers(customer_id),
    order_status VARCHAR(20),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date DATE,
    is_delivered BOOLEAN
);

CREATE TABLE payments (
    order_id VARCHAR(32) REFERENCES orders(order_id),
    payment_sequential INTEGER,
    payment_type VARCHAR(20),
    payment_installments INTEGER,
    payment_value NUMERIC(10,2)
);

CREATE TABLE reviews_for_orders (
    review_id VARCHAR(32),
    order_id VARCHAR(32) REFERENCES orders(order_id),
    review_score SMALLINT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);

CREATE TABLE reviews_unique (
    review_id VARCHAR(32),
    order_id VARCHAR(32) REFERENCES orders(order_id),
    review_score SMALLINT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);

COPY customers FROM 'D:/JOB HUNT/DATA ANALYST/PORTFOLIO 4 E-COMMERCE CUSTOMER RETENTION & REVENUE ANALYSIS/data/processed/customers_cleaned.csv' DELIMITER ',' CSV HEADER;
COPY orders FROM 'D:/JOB HUNT/DATA ANALYST/PORTFOLIO 4 E-COMMERCE CUSTOMER RETENTION & REVENUE ANALYSIS/data/processed/orders_cleaned.csv' DELIMITER ',' CSV HEADER;
COPY payments FROM 'D:/JOB HUNT/DATA ANALYST/PORTFOLIO 4 E-COMMERCE CUSTOMER RETENTION & REVENUE ANALYSIS/data/processed/payments_cleaned.csv' DELIMITER ',' CSV HEADER;
COPY reviews_for_orders FROM 'D:/JOB HUNT/DATA ANALYST/PORTFOLIO 4 E-COMMERCE CUSTOMER RETENTION & REVENUE ANALYSIS/data/processed/reviews_for_orders_cleaned.csv' DELIMITER ',' CSV HEADER;
COPY reviews_unique FROM 'D:/JOB HUNT/DATA ANALYST/PORTFOLIO 4 E-COMMERCE CUSTOMER RETENTION & REVENUE ANALYSIS/data/processed/reviews_unique_cleaned.csv' DELIMITER ',' CSV HEADER;