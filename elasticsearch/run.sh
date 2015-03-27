#!/bin/bash

cp /elasticsearch/config/elasticsearch.yml.template /elasticsearch/config/elasticsearch.yml

if [ -z $ETCD_HOST ]
then
  ETCD_HOST=etcd
fi


ES_HOSTS=$(python3 -c "import json, requests; print([ str(x['key'].rpartition('/')[2]) for x in json.loads(requests.get('http://$ETCD_HOST:4001/v2/keys/registry/nodes').text)['node']['nodes'] ])")

if [ ! -z "$ES_HOSTS" -a "$ES_HOSTS" != "[]" ]
then
  echo discovery.zen.ping.multicast.enabled: false >> /elasticsearch/config/elasticsearch.yml
  echo discovery.zen.ping.unicast.hosts: $ES_HOSTS >> /elasticsearch/config/elasticsearch.yml
fi

exec /elasticsearch/bin/elasticsearch
