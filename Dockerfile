FROM java:openjdk-8
MAINTAINER p4km9y

ARG KAFKA_HEAP_OPTS
ENV KAFKA_HEAP_OPTS ${KAFKA_HEAP_OPTS:-"-Xmx512m -Xms256m"}
ENV KAFKA_BROKER_ID 1

ENV ZOOKEEPER_CONNECT localhost:2181
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

COPY wait-for-it.sh /

RUN current=http://www.apache.org/dist/kafka/0.10.0.0 && \
    ref=$(wget -qO - ${current} | grep -v src\\. | grep -v doc | sed -n 's/.*href="\(kafka.*\.tgz\)".*/\1/p' | tail -1) && \
    wget -O - ${current}/${ref} | gzip -dc | tar x -C /opt/ -f - && \
    dir=`ls /opt | grep kafka` && \
    ln -s /opt/${dir} /opt/kafka

RUN adduser --no-create-home --home /opt/kafka --system --disabled-password --disabled-login kafka && \
    chown -R kafka:root /opt/kafka/

USER kafka

EXPOSE 9092

CMD /opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties --override zookeeper.connect=$ZOOKEEPER_CONNECT --override broker.id=$KAFKA_BROKER_ID

