FROM openjdk:8-jdk-alpine

WORKDIR /tests

RUN apk --no-cache add bash curl wget py-pip python3

# install Spark
ENV SPARK_URL spark/spark-2.4.2/spark-2.4.2-bin-hadoop2.7.tgz
RUN mkdir -p /opt \
    && export APACHE_MIRROR=$(curl -s 'https://www.apache.org/dyn/closer.cgi?as_json=1' | python -c "import sys, json; print json.load(sys.stdin)['preferred']") \
    && export SPARK_FULL_URL="${APACHE_MIRROR}${SPARK_URL}" \
    && wget -q -O /opt/spark.tgz "$SPARK_FULL_URL" \
    && tar xzf /opt/spark.tgz -C /opt/ \
    && rm /opt/spark.tgz \
    && ln -s $(find /opt -maxdepth 1 -name "spark-*" -print0) /opt/spark

COPY ./ /tests/

RUN pip install --no-cache-dir tox

CMD [ "tox" ]
