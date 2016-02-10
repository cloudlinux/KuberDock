#!/bin/bash
set -e

BASE='/elasticsearch'

chown -R elasticsearch "$BASE" 2> /dev/null || true

cp $BASE/config/elasticsearch.yml.template $BASE/config/elasticsearch.yml

python3 $BASE/data/make_elastic_config.py >> $BASE/config/elasticsearch.yml


if [ "$1" = 'elasticsearch' ]; then

    shift
    exec gosu elasticsearch $BASE/bin/elasticsearch "$@"

fi

exec "$@"

