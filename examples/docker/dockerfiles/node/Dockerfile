FROM azul/zulu-openjdk:8u192

RUN apt-get update && apt-get install -y wget curl collectd libcurl4 libyajl2

WORKDIR /app

# download the corda node jar
# RUN curl https://software.r3.com/artifactory/corda-releases/net/corda/corda/4.7.1-RC02/corda-4.7.1-RC02.jar -o corda.jar -s

# download the otel java agent
RUN curl -LJO https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v0.17.0/opentelemetry-javaagent-all.jar

# download the jmx prometheus java agent
RUN curl -LJO https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.13.0/jmx_prometheus_javaagent-0.13.0.jar

# copy in the splunk forwarder install archive
COPY ./unix-agent.tgz /app/unix-agent.tgz

COPY ./entrypoint.sh /app/entrypoint.sh

# env vars for splunk uf
ENV SPLUNK_URL="splunk"
# ENV RECEIVER_PORT="9997"
# ENV UDP_PORT="1998"
ENV HEC_TOKEN="11111111-1111-1111-1111-1111111111113"
ENV HEC_PORT=8088
ENV METRIC_USE_UDP="NO"
ENV METRIC_BUFFER_SIZE="9000"
ENV INSTALL_LOCATION="/opt/"
ENV SAI_ENABLE_DOCKER=
ENV DIMENSIONS=
ENV METRIC_TYPES=cpu,uptime,df,disk,interface,load,memory,processmon
ENV METRIC_OPTS=cpu.by_cpu
ENV LOG_SOURCES="/etc/collectd/collectd.log%collectd,\$SPLUNK_HOME/var/log/splunk/*.log*%uf,/var/log/syslog%syslog,/var/log/daemon.log%syslog,/var/log/auth.log%syslog"
ENV AUTHENTICATED_INSTALL=No

# unpack and install splunk uf & collectd
RUN tar -xzf unix-agent.tgz

WORKDIR /app/unix-agent

RUN bash install_uf.sh
RUN bash install_agent.sh

WORKDIR /app
RUN rm -rf unix-agent && rm -rf unix-agent.tgz

# copy over configs for splunk uf
COPY ./fwdr_inputs.conf /opt/splunkforwarder/etc/apps/splunk_app_infra_uf_config/local/inputs.conf
COPY ./fwdr_outputs.conf /opt/splunkforwarder/etc/apps/splunk_app_infra_uf_config/local/outputs.conf

ENTRYPOINT ["./entrypoint.sh"]
