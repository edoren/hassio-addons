#!/usr/bin/env bashio

database_name="$(bashio::config 'database_name')"
database_host="$(bashio::config 'database_host')"
database_port="$(bashio::config 'database_port')"
database_user="$(bashio::config 'database_user')"
database_password="$(bashio::config 'database_password')"

export DATABASE_URL="postgres://$database_user:$database_password@$database_host:$database_port/$database_name"
export SECRET_PASSWORD="$(bashio::config 'secret_password')"
export NEXT_PUBLIC_BASE_URL="$(bashio::config 'next_public_base_url')"
export ALLOWED_EMAILS="$(readarray -t ARRAY <<< "$(bashio::config 'allowed_emails')"; IFS=','; echo "${ARRAY[*]}")"
if [ ! -z "$(bashio::config 'noreply_email')" ]; then
    export NOREPLY_EMAIL="$(bashio::config 'noreply_email')"
fi
export SUPPORT_EMAIL="$(bashio::config 'support_email')"
export SMTP_HOST="$(bashio::config 'smtp_host')"
export SMTP_PORT="$(bashio::config 'smtp_port')"
export SMTP_SECURE="$(bashio::config 'smtp_secure')"
export SMTP_USER="$(bashio::config 'smtp_user')"
export SMTP_PWD="$(bashio::config 'smtp_pwd')"

/app/docker-start.sh
