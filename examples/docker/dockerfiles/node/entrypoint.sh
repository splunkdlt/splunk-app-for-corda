#!/bin/bash

# Copyright 2021 Splunk Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# update collectd hostname
sed -i 's/Hostname    ".*"/Hostname    "'"$CONTAINER_NAME"'"/' /etc/collectd/collectd.conf

collectd && \
/opt/splunkforwarder/bin/splunk set servername $CONTAINER_NAME && \
/opt/splunkforwarder/bin/splunk set default-hostname $CONTAINER_NAME && \
/opt/splunkforwarder/bin/splunk start --accept-license && \
java -Dcapsule.jvm.args="-Xmx1G -XX:+HeapDumpOnOutOfMemoryError" -Dlog4j.configurationFile=logging.xml -jar corda.jar run-migration-scripts --core-schemas --app-schemas --allow-hibernate-to-manage-app-schema && \
OTEL_EXPORTER=otlp_span java -Dcapsule.jvm.args="-Xmx1G -XX:+HeapDumpOnOutOfMemoryError -javaagent:./jmx_prometheus_javaagent-0.13.0.jar=0.0.0.0:8080:config.yaml -javaagent:./opentelemetry-javaagent-all.jar" -Dlog4j.configurationFile=logging.xml -jar corda.jar --logging-level=INFO
