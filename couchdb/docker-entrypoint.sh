#!/usr/bin/env bashio

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

couchdb_user="$(bashio::config 'couchdb_user')"
couchdb_password="$(bashio::config 'couchdb_password')"

COUCHDB_USER=$couchdb_user COUCHDB_PASSWORD=$couchdb_password source /usr/local/bin/docker-entrypoint.sh "$1"
