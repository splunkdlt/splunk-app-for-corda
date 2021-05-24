FROM azul/zulu-openjdk:8u192

RUN apt-get update && apt-get install -y curl libcurl4

WORKDIR /app

COPY ./entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
