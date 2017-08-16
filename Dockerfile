FROM java:8-alpine
MAINTAINER p4km9y

ARG KAFKA_HEAP_OPTS
ENV KAFKA_HEAP_OPTS ${KAFKA_HEAP_OPTS:-"-Xmx378m -Xms192m"}

ENV KAFKA_VERSION 0.11.0.0
ENV SCALA_VERSION=2.12

ENV KAFKA_BROKER_ID -1
ENV LOG_RETENTION_HOURS 240
# ENV ZOOKEEPER_CONNECT ""

RUN apk add --update unzip curl jq bash && rm -rf /var/cache/apk/*

COPY download.sh /tmp/download.sh

RUN mkdir /opt \
    && chmod a+x /tmp/download.sh && sync && /tmp/download.sh \
    && tar xfz /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt \
    && rm /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz \
    && ln -s /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} /opt/kafka \
    && mkdir /opt/kafka/data

RUN addgroup -S kafka \
    && adduser -S -H -g kafka kafka \
    && chown -R kafka:root /opt/kafka/

USER kafka

VOLUME ["/opt/kafka/data"]

EXPOSE 9092

CMD /opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties \
    --override log.dirs=/opt/kafka/data \
    --override delete.topic.enable=true \
    --override log.retention.hours=$LOG_RETENTION_HOURS \
    --override advertised.host.name=`ip -4 addr show scope global dev eth0 | grep inet | awk '{print \$2}' | cut -d / -f 1 | head -1` \
    --override zookeeper.connect=$ZOOKEEPER_CONNECT \
    --override broker.id=$KAFKA_BROKER_ID
