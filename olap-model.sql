-- SCHEMA FOR Staging and core olap db
-- Used to differentiate the proses of ETL so it damageless to OLTP.
CREATE SCHEMA IF NOT EXISTS staging;
CREATE SCHEMA IF NOT EXISTS core;

--- Staging DB
--

CREATE TABLE staging.stg_order_details (
    order_id TEXT,
    product_id TEXT,
    unit_price TEXT,
    quantity TEXT,
    discount TEXT,
    extracted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE staging.stg_orders (
    order_id TEXT,
    customer_id TEXT,
    employee_id TEXT,
    order_date TEXT,
    required_date TEXT,
    shipped_date TEXT,
    ship_via TEXT,
    freight TEXT,
    ship_name TEXT,
    ship_address TEXT,
    ship_city TEXT,
    ship_region TEXT,
    ship_postal_code TEXT,
    ship_country TEXT,
    extracted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE staging.stg_products (
    product_id TEXT,
    product_name TEXT,
    supplier_id TEXT,
    category_id TEXT,
    quantity_per_unit TEXT,
    unit_price TEXT,
    units_in_stock TEXT,
    units_on_order TEXT,
    reorder_level TEXT,
    discontinued TEXT,
    extracted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE staging.stg_customers (
    customer_id TEXT,
    company_name TEXT,
    contact_name TEXT,
    contact_title TEXT,
    address TEXT,
    city TEXT,
    region TEXT,
    postal_code TEXT,
    country TEXT,
    phone TEXT,
    fax TEXT,
    extracted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- CORE OLAP DB
CREATE TABLE IF NOT EXISTS core.dim_customer(
    customer_key SERIAL PRIMARY KEY,
    customer_id VARCHAR(5) NOT NULL UNIQUE,
    company_name VARCHAR(40) NOT NULL,
    contact_name VARCHAR(30) NOT NULL,
    city VARCHAR(15),
    region VARCHAR(15),
    country VARCHAR(15),
    inserted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS core.dim_products (
    product_key SERIAL PRIMARY KEY,
    product_id INT NOT NULL UNIQUE,
    product_name VARCHAR(40) NOT NULL,
    category_name VARCHAR(15),
    unit_price NUMERIC(12,2),
    inserted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS core.dim_date (
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
    is_weekend BOOLEAN NOT NULL,
    inserted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS core.fact_sales (
    fact_key SERIAL PRIMARY KEY,
    product_key INT REFERENCES dim_products(product_key),
    customer_key INT REFERENCES dim_customer(customer_key),
    date_key INT REFERENCES dim_date(date_key),
    order_id INT NOT NULL,
    quantity INT,
    unit_price NUMERIC(12,2) NOT NULL,
    discount_amount NUMERIC(12,2) NOT NULL,
    net_revenue NUMERIC(12,2) NOT NULL,

    inserted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);