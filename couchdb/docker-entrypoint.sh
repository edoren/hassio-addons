#!/bin/bash

echo "" > /opt/couchdb/etc/local.d/docker.ini
mkdir -p /data/data
chown couchdb:couchdb /data/data
chmod 777 /data/data
printf "\n[couchdb]\ndatabase_dir = /data/data\n" >> /opt/couchdb/etc/local.d/docker.ini

source /usr/local/bin/docker-entrypoint.sh "$1"
