FROM azul/zulu-openjdk:8u192

RUN apt-get update && apt-get install -y wget curl collectd libcurl4 libyajl2

WORKDIR /app

# download the corda node jar
# RUN curl https://software.r3.com/artifactory/corda-releases/net/corda/corda/4.7.1-RC02/corda-4.7.1-RC02.jar -o corda.jar -s

# download the otel java agent
RUN curl -LJO https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v0.17.0/opentelemetry-javaagent-all.jar

# download the jmx prometheus java agent
RUN curl -LJO https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.13.0/jmx_prometheus_javaagent-0.13.0.jar

COPY ./entrypoint.sh /app/entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
