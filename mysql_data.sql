-- Create database if it doesn't exist
CREATE DATABASE IF NOT EXISTS mydb;

USE mydb;

-- Create products table if it doesn't exist
CREATE TABLE IF NOT EXISTS products (
    id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(512)
);

ALTER TABLE products AUTO_INCREMENT = 101;

-- Insert products data (ignore duplicates)
INSERT IGNORE INTO products (id, name, description)
VALUES
    (101, "scooter", "Small 2-wheel scooter"),
    (102, "car battery", "12V car battery"),
    (
        103,
        "12-pack drill bits",
        "12-pack of drill bits with sizes ranging from #40 to #3"
    ),
    (104, "hammer", "12oz carpenter's hammer"),
    (105, "hammer", "14oz carpenter's hammer"),
    (106, "hammer", "16oz carpenter's hammer"),
    (107, "rocks", "box of assorted rocks"),
    (
        108,
        "jacket",
        "water resistent black wind breaker"
    ),
    (109, "spare tire", "24 inch spare tire");

-- Create orders table if it doesn't exist
CREATE TABLE IF NOT EXISTS orders (
    order_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    order_date DATETIME NOT NULL,
    customer_name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 5) NOT NULL,
    product_id INTEGER NOT NULL,
    order_status BOOLEAN NOT NULL -- Whether order has been placed
) AUTO_INCREMENT = 10001;

-- Insert orders data (ignore duplicates)
INSERT IGNORE INTO orders (
    order_id,
    order_date,
    customer_name,
    price,
    product_id,
    order_status
)
VALUES
    (
        10001,
        '2020-07-30 10:08:22',
        'Jark',
        50.50,
        102,
        false
    ),
    (
        10002,
        '2020-07-30 10:11:09',
        'Sally',
        15.00,
        105,
        false
    ),
    (
        10003,
        '2020-07-30 12:00:30',
        'Edward',
        25.25,
        106,
        false
    );