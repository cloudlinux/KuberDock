#!/bin/bash

cp /elasticsearch/config/elasticsearch.yml.template /elasticsearch/config/elasticsearch.yml

if [ -z $MASTER ]
then
  MASTER=master
fi


ES_HOSTS=$(python3 -c "import json, requests; print([x['labels']['kuberdock-node-hostname'] for x in json.loads(requests.get('http://$MASTER:7080/api/v1beta2/nodes').text)['items']])")

if [ ! -z "$ES_HOSTS" -a "$ES_HOSTS" != "[]" ]
then
  echo discovery.zen.ping.multicast.enabled: false >> /elasticsearch/config/elasticsearch.yml
  echo discovery.zen.ping.unicast.hosts: $ES_HOSTS >> /elasticsearch/config/elasticsearch.yml
fi

exec /elasticsearch/bin/elasticsearch
