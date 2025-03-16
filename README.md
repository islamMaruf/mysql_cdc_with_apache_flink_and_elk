# Flink CDC with MySQL and Elasticsearch

This project demonstrates how to use **Apache Flink** to capture **Change Data Capture (CDC)** from a **MySQL** database, enrich the data, and sink it into **Elasticsearch**. The setup includes the following components:

- **Apache Flink**: For real-time data processing and streaming.
- **MySQL (Debezium)**: As the source database with CDC enabled.
- **Elasticsearch**: As the sink for storing enriched data.
- **Kibana**: For visualizing the data stored in Elasticsearch.

The project is containerized using **Docker** and orchestrated with **Docker Compose**, making it easy to set up and run locally.

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Project Structure](#project-structure)
3. [Getting Started](#getting-started)
4. [Flink SQL Commands](#flink-sql-commands)
5. [Sample Data](#sample-data)
6. [Enriched Data in Elasticsearch](#enriched-data-in-elasticsearch)
7. [Accessing Services](#accessing-services)
8. [Troubleshooting](#troubleshooting)
9. [License](#license)
10. [Contributing](#contributing)

---

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

---

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

bashCopy

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   ./scripts/init_mysql.sh   `

This script:

*   Copies the mysql\_data.sql file into the MySQL container.
    
*   Executes the SQL script to create the mydb database, products, and orders tables, and inserts sample data.
    

### 4\. Execute Flink SQL Commands

Run the script to execute Flink SQL commands:

bashCopy

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   ./scripts/execute_flink_sql.sh   `

This script:

*   Copies the flink\_sink\_mysql\_to\_elk.sql file into the Flink JobManager container.
    
*   Executes the SQL commands to set up CDC source tables and Elasticsearch sink tables.
    

Flink SQL Commands
------------------

The Flink SQL commands define the following:

### 1\. MySQL CDC Source Tables

*   mysql\_products: Captures changes from the products table in MySQL.
    
*   mysql\_orders: Captures changes from the orders table in MySQL.
    

### 2\. Elasticsearch Sink Table

*   elasticsearch\_orders: Stores enriched order data in Elasticsearch.
    

### 3\. Data Enrichment

The following SQL query joins mysql\_orders with mysql\_products to enrich order data with product details and inserts the result into elasticsearch\_orders:

sqlCopy

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   INSERT INTO elasticsearch_orders  SELECT      o.order_id,      o.order_date,      o.customer_name,      o.price,      o.product_id,      o.order_status,      p.name AS product_name,      p.description AS product_description  FROM mysql_orders AS o  LEFT JOIN mysql_products AS p ON o.product_id = p.id;   `

Sample Data
-----------

### Products Table

**idnamedescription**101scooterSmall 2-wheel scooter102car battery12V car battery10312-pack drill bits12-pack of drill bits with sizes ranging from #40 to #3104hammer12oz carpenter's hammer105hammer14oz carpenter's hammer106hammer16oz carpenter's hammer107rocksbox of assorted rocks108jacketwater resistent black wind breaker109spare tire24 inch spare tire

### Orders Table

**order\_idorder\_datecustomer\_namepriceproduct\_idorder\_status**100012020-07-30 10:08:22Jark50.50102false100022020-07-30 10:11:09Sally15.00105false100032020-07-30 12:00:30Edward25.25106false

Enriched Data in Elasticsearch
------------------------------

The enriched data in Elasticsearch (enriched\_orders index) will include:

*   **Order Details**:
    
    *   order\_id
        
    *   order\_date
        
    *   customer\_name
        
    *   price
        
    *   product\_id
        
    *   order\_status
        
*   **Product Details**:
    
    *   product\_name
        
    *   product\_description
        

Accessing Services
------------------

*   **Flink Web UI**: Open [http://localhost:8082](http://localhost:8082/) to monitor Flink jobs.
    
*   **Kibana**: Open [http://localhost:5601](http://localhost:5601/) to visualize the data in Elasticsearch.
    
*   **Elasticsearch**: Accessible at [http://localhost:9200](http://localhost:9200/).
    

Troubleshooting
---------------

### 1\. Flink JobManager Not Starting

Ensure that MySQL and Elasticsearch are healthy before starting Flink.

Check the logs using:

bashCopy

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   docker logs flink-jobmanager   `

### 2\. Elasticsearch Not Responding

Ensure that the discovery.type is set to single-node in the docker-compose.yml file.

Check the logs using:

bashCopy

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   docker logs elasticsearch   `

### 3\. MySQL Data Not Initialized

Ensure that the init\_mysql.sh script ran successfully.

Check the logs using:

bashCopy

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   docker logs mysql-cdc   `

License
-------

This project is licensed under the MIT License. See the [LICENSE](https://license/) file for details.

Contributing
------------

Contributions are welcome! Please follow these steps:

1.  Fork the repository.
    
2.  Create a new branch for your feature or bug fix.
    
3.  Submit a pull request with a detailed description of your changes.
    

Acknowledgments
---------------

*   [Apache Flink](https://flink.apache.org/)
    
*   [Debezium](https://debezium.io/)
    
*   [Elasticsearch](https://www.elastic.co/elasticsearch/)
    
*   [Kibana](https://www.elastic.co/kibana/)

