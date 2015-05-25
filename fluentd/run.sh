#!/bin/bash

if [ -z $NODENAME ]
then
  NODENAME=$HOSTNAME
fi

if [ -z $ES_HOST ]
then
  ES_HOST=elasticsearch
fi

sed -e s/@NODENAME@/$NODENAME/g -e s/@ES_HOST@/$ES_HOST/g fluentd.conf.template > fluentd.conf

exec /usr/sbin/td-agent -c fluentd.conf
