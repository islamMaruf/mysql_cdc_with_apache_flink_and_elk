-- Create MySQL CDC Source Table for 'products'
CREATE TABLE mysql_products (
    id INT,
    name STRING,
    description STRING,
    PRIMARY KEY (id) NOT ENFORCED
) WITH (
    'connector' = 'mysql-cdc',
    'hostname' = 'mysql-cdc',
    'port' = '3306',
    'username' = 'root',
    'password' = 'secret',
    'database-name' = 'mydb',
    'table-name' = 'products'
);

-- Create MySQL CDC Source Table for 'orders'
CREATE TABLE mysql_orders (
    order_id INT,
    order_date TIMESTAMP(0),
    customer_name STRING,
    price DECIMAL(10, 5),
    product_id INT,
    order_status BOOLEAN,
    PRIMARY KEY (order_id) NOT ENFORCED
) WITH (
    'connector' = 'mysql-cdc',
    'hostname' = 'mysql-cdc',
    'port' = '3306',
    'username' = 'root',
    'password' = 'secret',
    'database-name' = 'mydb',
    'table-name' = 'orders'
);

-- Create Elasticsearch Sink Table for 'enriched_orders'
CREATE TABLE elasticsearch_orders (
    order_id INT,
    order_date TIMESTAMP(0),
    customer_name STRING,
    price DECIMAL(10, 5),
    product_id INT,
    order_status BOOLEAN,
    product_name STRING,
    product_description STRING,
    PRIMARY KEY (order_id) NOT ENFORCED
) WITH (
    'connector' = 'elasticsearch-7',
    'hosts' = 'http://elasticsearch:9200',
    'index' = 'enriched_orders'
);

-- Create Cassandra Sink Table for 'enriched_orders'
CREATE TABLE cassandra_orders (
    order_id INT,
    order_date TIMESTAMP(0),
    customer_name STRING,
    price DECIMAL(10, 5),
    product_id INT,
    order_status BOOLEAN,
    product_name STRING,
    product_description STRING,
    PRIMARY KEY (order_id) NOT ENFORCED
) WITH (
    'connector' = 'cassandra',
    'hosts' = 'cassandra:9042',
    'table-name' = 'enriched_orders',
    'keyspace' = 'flink_ks'
);

-- Insert enriched data into Elasticsearch
INSERT INTO elasticsearch_orders
SELECT
    o.order_id,
    o.order_date,
    o.customer_name,
    o.price,
    o.product_id,
    o.order_status,
    p.name AS product_name,
    p.description AS product_description
FROM mysql_orders AS o
LEFT JOIN mysql_products AS p ON o.product_id = p.id;

-- Insert enriched data into Cassandra
INSERT INTO cassandra_orders
SELECT
    o.order_id,
    o.order_date,
    o.customer_name,
    o.price,
    o.product_id,
    o.order_status,
    p.name AS product_name,
    p.description AS product_description
FROM mysql_orders AS o
LEFT JOIN mysql_products AS p ON o.product_id = p.id;