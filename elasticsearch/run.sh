#!/bin/bash

cp /elasticsearch/config/elasticsearch.yml.template /elasticsearch/config/elasticsearch.yml

if [ -z $MASTER ]
then
  MASTER=master
fi


ES_HOSTS=$(python3 -c "import requests; print([node['metadata']['labels']['kuberdock-node-hostname'] for node in requests.get('https://$MASTER:6443/api/v1/nodes', headers={'Authorization': 'Bearer $TOKEN'}, verify=False).json()['items']])")

if [ ! -z "$ES_HOSTS" -a "$ES_HOSTS" != "[]" ]
then
  echo discovery.zen.ping.multicast.enabled: false >> /elasticsearch/config/elasticsearch.yml
  echo discovery.zen.ping.unicast.hosts: $ES_HOSTS >> /elasticsearch/config/elasticsearch.yml
fi

exec /elasticsearch/bin/elasticsearch
