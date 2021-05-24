FROM azul/zulu-openjdk:8u192

RUN apt-get update && apt-get install -y curl libcurl4

WORKDIR /app

RUN curl https://software.r3.com/artifactory/corda-releases/net/corda/corda-tools-network-bootstrapper/4.7.1-RC02/corda-tools-network-bootstrapper-4.7.1-RC02.jar -o corda-tools-network-bootstrapper.jar -s

CMD java -jar corda-tools-network-bootstrapper.jar --dir bootstrap
