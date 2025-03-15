SET execution.checkpointing.interval = 3s;

CREATE TABLE products (
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

  CREATE TABLE orders (
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

 CREATE TABLE enriched_orders (
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


 INSERT INTO enriched_orders
 SELECT o.*, p.name, p.description
 FROM orders AS o
 LEFT JOIN products AS p ON o.product_id = p.id;