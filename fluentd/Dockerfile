FROM ubuntu:14.04

MAINTAINER Aleksandr Tishin "atishin@cloudlinux.com"

RUN ulimit -n 65536

RUN apt-get update && \
    apt-get install -y curl && \
    apt-get install -y -q libcurl4-openssl-dev make && \
    apt-get clean

RUN /usr/bin/curl -L http://toolbelt.treasuredata.com/sh/install-ubuntu-trusty-td-agent2.sh | sh

RUN sed -i -e "s/USER=td-agent/USER=root/" -e "s/GROUP=td-agent/GROUP=root/" /etc/init.d/td-agent

RUN /usr/sbin/td-agent-gem install fluent-plugin-elasticsearch fluent-plugin-record-reformer

WORKDIR /root

EXPOSE 5140/udp

ADD run.sh /root/
ADD fluentd.conf.template /root/

CMD ./run.sh
