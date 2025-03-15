-- cassandra_setup.cql
CREATE KEYSPACE IF NOT EXISTS flink_ks WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

USE flink_ks;

CREATE TABLE IF NOT EXISTS enriched_orders (
    order_id INT PRIMARY KEY,
    order_date TIMESTAMP,
    customer_name TEXT,
    price DECIMAL,
    product_id INT,
    order_status BOOLEAN,
    product_name TEXT,
    product_description TEXT
);