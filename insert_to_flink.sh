#!/bin/bash

# Variables
FLINK_CONTAINER_NAME="flink-jobmanager"  # Name of the Flink container
FLINK_SQL_FILE="./flink_sink_mysql_to_elk.sql"  # Path to the SQL file

# Check if the SQL file exists
if [ ! -f "$FLINK_SQL_FILE" ]; then
  echo "Error: SQL file not found at $FLINK_SQL_FILE"
  exit 1
fi

# Copy the SQL file to the Flink container
echo "Copying SQL file to Flink container..."
docker cp "$FLINK_SQL_FILE" "$FLINK_CONTAINER_NAME:/tmp/flink_sql_commands.sql"

# Check if the copy was successful
if [ $? -ne 0 ]; then
  echo "Error: Failed to copy SQL file to Flink container."
  exit 1
fi

# Execute Flink SQL commands in the container
echo "Executing Flink SQL commands in the container..."
docker exec -i "$FLINK_CONTAINER_NAME" /opt/flink/bin/sql-client.sh -f /tmp/flink_sql_commands.sql

# Check if the execution was successful
if [ $? -ne 0 ]; then
  echo "Error: Failed to execute Flink SQL commands."
  exit 1
fi

echo "Flink SQL commands executed successfully!"