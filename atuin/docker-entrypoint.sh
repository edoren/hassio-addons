#!/usr/bin/env bashio

database_name="$(bashio::config 'database_name')"
database_host="$(bashio::config 'database_host')"
database_port="$(bashio::config 'database_port')"
database_user="$(bashio::config 'database_user')"
database_password="$(bashio::config 'database_password')"
open_registration="$(bashio::config 'open_registration')"

export ATUIN_HOST="0.0.0.0"
export ATUIN_PORT=8888
export ATUIN_OPEN_REGISTRATION=$open_registration
export ATUIN_DB_URI="postgres://$database_user:$database_password@$database_host:$database_port/$database_name"

bashio::log.info "Starting Atuin server..."

./atuin server start
