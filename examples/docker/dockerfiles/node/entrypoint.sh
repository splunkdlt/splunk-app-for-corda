#!/bin/bash

java -Dcapsule.jvm.args="-Xmx1G -XX:+HeapDumpOnOutOfMemoryError" -Dlog4j.configurationFile=logging.xml -jar corda.jar run-migration-scripts --core-schemas --app-schemas --allow-hibernate-to-manage-app-schema && \
OTEL_EXPORTER=otlp_span java -Dcapsule.jvm.args="-Xmx1G -XX:+HeapDumpOnOutOfMemoryError -javaagent:./jmx_prometheus_javaagent-0.13.0.jar=0.0.0.0:8080:config.yaml -javaagent:./opentelemetry-javaagent-all.jar" -Dlog4j.configurationFile=logging.xml -jar corda.jar --logging-level=INFO
