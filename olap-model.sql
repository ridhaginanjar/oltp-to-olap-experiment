CREATE TABLE IF NOT EXISTS dim_customer(
    customer_key SERIAL PRIMARY KEY,
    customer_id VARCHAR(5) NOT NULL,
    company_name VARCHAR(40) NOT NULL,
    contact_name VARCHAR(30),
    city VARCHAR(15),
    region VARCHAR(15),
    country VARCHAR(15)
)

CREATE TABLE IF NOT EXISTS dim_products (
    product_key SERIAL PRIMARY KEY,
    product_id INT,
    product_name VARCHAR(40) NOT NULL,
    category_name VARCHAR(15) NOT NULL,
    unit_price INT
)

CREATE TABLE IF NOT EXISTS dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE NOT NULL,
    year INT NOT NULL,
    quarter INT NOT NULL,
    month INT NOT NULL,
    month_name VARCHAR(10) NOT NULL,
    day_of_month INT NOT NULL,
    day_of_week INT NOT NULL,
    day INT NOT NULL,
    day_name VARCHAR(10) NOT NULL,
    week INT NOT NULL,
    is_weekend BOOLEAN NOT NULL
)

CREATE TABLE IF NOT EXISTS fact_sales (
    fact_key SERIAL PRIMARY KEY,
    product_key INT REFERENCES dim_products(product_key),
    customer_key INT REFERENCES dim_customer(customer_key),
    date_key INT REFERENCES dim_date(date_key),
    quantity INT,
    unit_price DECIMAL,
    discount_amount DECIMAL,
    net_revenue DECIMAL,

    inserted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)