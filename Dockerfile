# Use Flink 1.16.0 base image
FROM flink:1.16.0-scala_2.12

# Set working directory
WORKDIR /opt/flink

# Create log directory and set permissions
RUN mkdir -p /opt/flink/log && chown -R flink:flink /opt/flink/log

# Download required JAR dependencies
RUN wget -q -O /opt/flink/lib/flink-sql-connector-elasticsearch7-1.16.0.jar \
        https://repo1.maven.org/maven2/org/apache/flink/flink-sql-connector-elasticsearch7/1.16.0/flink-sql-connector-elasticsearch7-1.16.0.jar && \
    wget -q -O /opt/flink/lib/flink-sql-connector-mysql-cdc-2.4.0.jar \
        https://repo1.maven.org/maven2/com/ververica/flink-sql-connector-mysql-cdc/2.4.0/flink-sql-connector-mysql-cdc-2.4.0.jar && \
    wget -q -O /opt/flink/lib/flink-connector-cassandra_2.12-1.16.0.jar \
        https://repo1.maven.org/maven2/org/apache/flink/flink-connector-cassandra_2.12/1.16.0/flink-connector-cassandra_2.12-1.16.0.jar && \
    chown flink:flink /opt/flink/lib/flink-*.jar && \
    chmod 644 /opt/flink/lib/flink-*.jar

# Expose Flink UI port
EXPOSE 8081

# Switch to the flink user
USER flink

# Start Flink JobManager
CMD ["bin/jobmanager.sh", "start-foreground"]