#!/usr/bin/env bashio

host="$(bashio::config 'host')"
domain="$(bashio::config 'domain')"
password="$(bashio::config 'password')"

NC_HOST=$host NC_DOMAIN=$domain NC_PASS=$password /app/container-entrypoint.sh
