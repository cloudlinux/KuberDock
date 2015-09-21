#!/bin/bash

BASE='/elasticsearch'

cp $BASE/config/elasticsearch.yml.template $BASE/config/elasticsearch.yml

python3 $BASE/make_elastic_config.py >> $BASE/config/elasticsearch.yml

exec $BASE/bin/elasticsearch
