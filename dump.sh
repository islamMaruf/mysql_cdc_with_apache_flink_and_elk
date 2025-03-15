#!/bin/bash

# Variables
CONTAINER_NAME="mysql-cdc"  # Name of the MySQL container
LOCAL_SQL_FILE="./mysql_data.sql"  # Path to the local SQL file
DOCKER_SQL_PATH="/tmp/init_mysql.sql"  # Path to the SQL file inside the container

# Check if the SQL file exists
if [ ! -f "$LOCAL_SQL_FILE" ]; then
  echo "Error: SQL file not found at $LOCAL_SQL_FILE"
  exit 1
fi

# Copy the SQL file to the Docker container
echo "Copying SQL file to Docker container..."
docker cp "$LOCAL_SQL_FILE" "$CONTAINER_NAME:$DOCKER_SQL_PATH"

# Check if the copy was successful
if [ $? -ne 0 ]; then
  echo "Error: Failed to copy SQL file to Docker container."
  exit 1
fi

# Execute the SQL script inside the Docker container
echo "Executing SQL script in Docker container..."
docker exec -i "$CONTAINER_NAME" mysql -u root -psecret -e "source $DOCKER_SQL_PATH"

# Check if the SQL execution was successful
if [ $? -ne 0 ]; then
  echo "Error: Failed to execute SQL script in Docker container."
  exit 1
fi

echo "SQL script executed successfully!"