#!/bin/bash

# Variables
MYSQL_CONTAINER_NAME="mysql-cdc"  # Name of the MySQL container
LOCAL_SQL_FILE="./mysql_data.sql"  # Path to the local SQL file
DOCKER_SQL_PATH="/tmp/init_mysql.sql"  # Path to the SQL file inside the MySQL container

# Check if the SQL file exists
if [ ! -f "$LOCAL_SQL_FILE" ]; then
  echo "Error: SQL file not found at $LOCAL_SQL_FILE"
  exit 1
fi

# Copy the SQL file to the MySQL Docker container
echo "Copying SQL file to MySQL Docker container..."
docker cp "$LOCAL_SQL_FILE" "$MYSQL_CONTAINER_NAME:$DOCKER_SQL_PATH"

# Check if the copy was successful
if [ $? -ne 0 ]; then
  echo "Error: Failed to copy SQL file to MySQL Docker container."
  exit 1
fi

# Execute the SQL script inside the MySQL Docker container
echo "Executing SQL script in MySQL Docker container..."
docker exec -i "$MYSQL_CONTAINER_NAME" mysql -u root -psecret -e "source $DOCKER_SQL_PATH"

# Check if the SQL execution was successful
if [ $? -ne 0 ]; then
  echo "Error: Failed to execute SQL script in MySQL Docker container."
  exit 1
fi

echo "MySQL SQL script executed successfully!"

# Check if the CQL execution was successful
if [ $? -ne 0 ]; then
  echo "Error: Failed to execute CQL script in Cassandra Docker container."
  exit 1
fi

echo "Cassandra keyspace and table created successfully!"