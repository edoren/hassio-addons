#!/usr/bin/env bashio

database_name="$(bashio::config 'database_name')"
database_host="$(bashio::config 'database_host')"
database_port="$(bashio::config 'database_port')"
database_user="$(bashio::config 'database_user')"
database_password="$(bashio::config 'database_password')"
export DATABASE_URL="postgres://$database_user:$database_password@$database_host:$database_port/$database_name"

secret_password="$(bashio::config 'secret_password')"
export SECRET_PASSWORD="$secret_password"

next_public_base_url="$(bashio::config 'next_public_base_url')"
export NEXT_PUBLIC_BASE_URL="$next_public_base_url"

allowed_emails="$(readarray -t ARRAY <<< "$(bashio::config 'allowed_emails')"; IFS=','; echo "${ARRAY[*]}")"
export ALLOWED_EMAILS="$allowed_emails"

if [ -n "$(bashio::config 'noreply_email')" ]; then
    noreply_email="$(bashio::config 'noreply_email')"
    export NOREPLY_EMAIL="$noreply_email"
fi

support_email="$(bashio::config 'support_email')"
export SUPPORT_EMAIL="$support_email"

smtp_host="$(bashio::config 'smtp_host')"
export SMTP_HOST="$smtp_host"

smtp_port="$(bashio::config 'smtp_port')"
export SMTP_PORT="$smtp_port"

smtp_secure="$(bashio::config 'smtp_secure')"
export SMTP_SECURE="$smtp_secure"

smtp_user="$(bashio::config 'smtp_user')"
export SMTP_USER="$smtp_user"

smtp_pwd="$(bashio::config 'smtp_pwd')"
export SMTP_PWD="$smtp_pwd"

/app/docker-start.sh
