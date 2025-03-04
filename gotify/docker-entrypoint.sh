#!/usr/bin/env bashio

if [[ "$(bashio::config 'database_dialect')" == "sqlite3" ]]; then
    database_dialect=$(bashio::config 'database_dialect');
    database_connection=data/gotify.db;
else
    database_dialect=$(bashio::config 'database_dialect');
    database_connection=$(bashio::config 'database_connection');
fi
password_strength=$(bashio::config 'password_strength')
registration=$(bashio::config 'registration')

if [[ "$database_connection" == "" ]]; then
    bashio::log.error "Database connection configuration is required for $database_dialect database. Exiting...";
    exit 1;
fi

bashio::log.info "Using $database_dialect as database.";

export GOTIFY_SERVER_PORT=80
export GOTIFY_SERVER_KEEPALIVEPERIODSECONDS=0
export GOTIFY_SERVER_LISTENADDR=
export GOTIFY_SERVER_SSL_ENABLED=false
export GOTIFY_SERVER_SSL_REDIRECTTOHTTPS=true
export GOTIFY_SERVER_SSL_LISTENADDR=
export GOTIFY_SERVER_SSL_PORT=443
export GOTIFY_SERVER_SSL_CERTFILE=
export GOTIFY_SERVER_SSL_CERTKEY=
export GOTIFY_SERVER_SSL_LETSENCRYPT_ENABLED=false
export GOTIFY_SERVER_SSL_LETSENCRYPT_ACCEPTTOS=false
export GOTIFY_SERVER_SSL_LETSENCRYPT_CACHE=certs
# export GOTIFY_SERVER_SSL_LETSENCRYPT_HOSTS=[mydomain.tld, myotherdomain.tld]
# export GOTIFY_SERVER_RESPONSEHEADERS={X-Custom-Header: "custom value", x-other: value}
# export GOTIFY_SERVER_TRUSTEDPROXIES=[127.0.0.1,192.168.178.2/24]
# export GOTIFY_SERVER_CORS_ALLOWORIGINS=[.+\.example\.com, otherdomain\.com]
# export GOTIFY_SERVER_CORS_ALLOWMETHODS=[GET, POST]
# export GOTIFY_SERVER_CORS_ALLOWHEADERS=[X-Gotify-Key, Authorization]
# export GOTIFY_SERVER_STREAM_ALLOWEDORIGINS=[.+.example\.com, otherdomain\.com]
export GOTIFY_SERVER_STREAM_PINGPERIODSECONDS=45
export GOTIFY_DATABASE_DIALECT=$database_dialect;
export GOTIFY_DATABASE_CONNECTION=$database_connection;
export GOTIFY_DEFAULTUSER_NAME=admin
export GOTIFY_DEFAULTUSER_PASS=admin
export GOTIFY_PASSSTRENGTH=$password_strength
export GOTIFY_UPLOADEDIMAGESDIR=data/images
export GOTIFY_PLUGINSDIR=data/plugins
export GOTIFY_REGISTRATION=$registration

./gotify-server
