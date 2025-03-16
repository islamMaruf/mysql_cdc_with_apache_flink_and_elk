# Flink CDC with MySQL and Elasticsearch

This project demonstrates how to use **Apache Flink** to capture **Change Data Capture (CDC)** from a **MySQL** database, enrich the data, and sink it into **Elasticsearch**. The setup includes the following components:

- **Apache Flink**: For real-time data processing and streaming.
- **MySQL (Debezium)**: As the source database with CDC enabled.
- **Elasticsearch**: As the sink for storing enriched data.
- **Kibana**: For visualizing the data stored in Elasticsearch.

The project is containerized using **Docker** and orchestrated with **Docker Compose**, making it easy to set up and run locally.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Project Structure](#project-structure)
3. [Getting Started](#getting-started)
4. [Flink SQL Commands](#flink-sql-commands)
5. [Sample Data](#sample-data)
6. [Enriched Data in Elasticsearch](#enriched-data-in-elasticsearch)
7. [Accessing Services](#accessing-services)
8. [Troubleshooting](#troubleshooting)

## Project Structure

The project is organized as follows:

```text
flink-cdc-mysql-elasticsearch/
├── docker-compose.yml # Docker Compose configuration for all services
├── flink_sink_mysql_to_elk.sql # Flink SQL commands for CDC and Elasticsearch sink
├── mysql_data.sql # SQL script to initialize MySQL with sample data
├── scripts/ # Helper scripts for initializing and running the setup
│ ├── init_mysql.sh # Script to initialize MySQL with sample data
│ └── execute_flink_sql.sh # Script to execute Flink SQL commands
└── README.md # This README file
```

## Prerequisites

Before running the project, ensure you have the following installed:

- **Docker**: [Install Docker](https://docs.docker.com/get-docker/)
- **Docker Compose**: [Install Docker Compose](https://docs.docker.com/compose/install/)

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/flink-cdc-mysql-elasticsearch.git
cd flink-cdc-mysql-elasticsearch
```

### 2. Build and Start the Docker Containers

Run the following command to build and start all the services:

```bash
docker-compose up --build
```

This will start the following services:

- ***Flink JobManager***: Manages Flink jobs.
- ***Flink TaskManager***: Executes Flink tasks.
- ***MySQL (Debezium)***: Source database with CDC enabled.  
- ***Elasticsearch***: Sink for storing enriched data.  
- ***Kibana***: For visualizing data in Elasticsearch.

### 3. Initialize MySQL Data

Run the script to initialize the MySQL database with sample data:

```bash
./scripts/init_mysql.sh
```

This script will:

- ****Copies the mysql\_data.sql file into the MySQL container.****

- ****Executes the SQL script to create the mydb database, products, and orders tables, and inserts sample data.****

### 4. Execute Flink SQL Commands

Run the script to execute Flink SQL commands:

```bash
./scripts/execute_flink_sql.sh   
```

This script will:

- ****Copies the flink\_sink\_mysql\_to\_elk.sql file into the Flink JobManager container.****

- ****Executes the SQL commands to set up CDC source tables and Elasticsearch sink tables.****

## Flink SQL Commands

The Flink SQL commands define the following:

### 1. MySQL CDC Source Tables

- ****mysql_products:**** Captures changes from the products table in MySQL.

- ****mysql_orders:**** Captures changes from the orders table in MySQL.

### 2. Elasticsearch Sink Table

- ****elasticsearch_orders:**** Stores enriched order data in Elasticsearch.

### 3. Data Enrichment

The following SQL query joins mysql_orders with mysql\_products to enrich order data with product details and inserts the result into elasticsearch_orders:

```sql
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
```

## Sample Data

### Products Table

| id  | name               | description                                |
|-----|--------------------|--------------------------------------------|
| 101 | scooter            | Small 2-wheel scooter                      |
| 102 | car battery        | 12V car battery                            |
| 103 | 12-pack drill bits | 12-pack of drill bits with sizes ranging from #40 to #3 |
| 104 | hammer             | 12oz carpenter's hammer                    |
| 105 | hammer             | 14oz carpenter's hammer                    |
| 106 | hammer             | 16oz carpenter's hammer                    |
| 107 | rocks              | box of assorted rocks                      |
| 108 | jacket             | water resistent black wind breaker         |
| 109 | spare tire         | 24 inch spare tire                         |

### Orders Table

| order_id | order_date          | customer_name | price | product_id | order_status |
|----------|---------------------|---------------|-------|------------|--------------|
| 10001    | 2020-07-30 10:08:22 | Jark          | 50.50 | 102        | false        |
| 10002    | 2020-07-30 10:11:09 | Sally         | 15.00 | 105        | false        |
| 10003    | 2020-07-30 12:00:30 | Edward        | 25.25 | 106        | false        |

## Enriched Data in Elasticsearch

The enriched data in Elasticsearch (enriched_orders index) will include:

- **Order Details**:
  - order_id
  - order_date
  - customer_name
  - price
  - product_id
  - order_status

- **Product Details**:
  - product_name
  - product_description

When the enriched data is stored in Elasticsearch, it will have a structured JSON-like format.

Below is an example of how the enriched data (combining orders and products) would look in Elasticsearch:

  ```json
  [
    {
        "order_id": 10001,
        "order_date": "2020-07-30T10:08:22",
        "customer_name": "Jark",
        "price": 50.50,
        "product_id": 102,
        "order_status": false,
        "product_name": "car battery",
        "product_description": "12V car battery"
    },
    {
        "order_id": 10002,
        "order_date": "2020-07-30T10:11:09",
        "customer_name": "Sally",
        "price": 15.00,
        "product_id": 105,
        "order_status": false,
        "product_name": "hammer",
        "product_description": "14oz carpenter's hammer"
    },
    {
        "order_id": 10003,
        "order_date": "2020-07-30T12:00:30",
        "customer_name": "Edward",
        "price": 25.25,
        "product_id": 106,
        "order_status": false,
        "product_name": "hammer",
        "product_description": "16oz carpenter's hammer"
    }
  ]

  ```

### Elasticsearch Index Structure

The data will be stored in an Elasticsearch index (e.g., enriched_orders). Here’s an example of the index mapping:
```json
{
  "mappings": {
    "properties": {
      "order_id": { "type": "integer" },
      "order_date": { "type": "date" },
      "customer_name": { "type": "text" },
      "price": { "type": "float" },
      "product_id": { "type": "integer" },
      "order_status": { "type": "boolean" },
      "product_name": { "type": "text" },
      "product_description": { "type": "text" }
    }
  }
}
```

Visualizing in Kibana
Once the data is in Elasticsearch, you can use Kibana to visualize it. For example:

1. Create a Discover view to explore the enriched orders.

2. Build Dashboards to monitor order trends, product popularity, or customer behavior.

3, This structure ensures that the enriched data is well-organized and ready for querying, analysis, and visualization in Elasticsearch and Kibana.

## Accessing Services

- **Flink Web UI**: Open [http://localhost:8082](http://localhost:8082/) to monitor Flink jobs.

- **Kibana**: Open [http://localhost:5601](http://localhost:5601/) to visualize the data in Elasticsearch.

- **Elasticsearch**: Accessible at [http://localhost:9200](http://localhost:9200/).

## Troubleshooting

### 1. Flink JobManager Not Starting

Ensure that MySQL and Elasticsearch are healthy before starting Flink.

Check the logs using:

```bash 
docker logs flink-jobmanager
```

### 2. Elasticsearch Not Responding

Ensure that the discovery.type is set to single-node in the docker-compose.yml file.

Check the logs using:

```bash
docker logs elasticsearch
```

### 3. MySQL Data Not Initialized

Ensure that the init_mysql.sh script ran successfully.

Check the logs using:

```bash
docker logs mysql-cdc
```

## Acknowledgments

- [Apache Flink](https://flink.apache.org/)

- [Debezium](https://debezium.io/)

- [Elasticsearch](https://www.elastic.co/elasticsearch/)

- [Kibana](https://www.elastic.co/kibana/)
