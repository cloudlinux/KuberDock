FROM dockerfile/java:oracle-java8

ENV ES_PKG_NAME elasticsearch-1.4.4

RUN apt-get update && apt-get -y install python3-requests

RUN \
  cd / && \
  wget https://download.elasticsearch.org/elasticsearch/elasticsearch/$ES_PKG_NAME.tar.gz && \
  tar xvzf $ES_PKG_NAME.tar.gz && \
  rm -f $ES_PKG_NAME.tar.gz && \
  mv /$ES_PKG_NAME /elasticsearch

ADD elasticsearch.yml.template /elasticsearch/config/elasticsearch.yml.template
ADD run.sh /elasticsearch/run.sh

CMD /elasticsearch/run.sh

EXPOSE 9200
EXPOSE 9300
