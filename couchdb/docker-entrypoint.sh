#!/bin/bash

set -e

if [ "$1" = '/opt/couchdb/bin/couchdb' ]; then
	touch /opt/couchdb/etc/local.d/docker.ini

	if ! grep -Pzoqr "\[couchdb\]\ndatabase_dir =" /opt/couchdb/etc/local.d/*.ini /opt/couchdb/etc/local.ini; then
		mkdir -p /data/data
		chown couchdb:couchdb /data/data
		chmod 777 /data/data
		printf "\n[couchdb]\ndatabase_dir = /data/data\n" >> /opt/couchdb/etc/local.d/docker.ini
	fi
fi

source /usr/local/bin/docker-entrypoint.sh "$1"
