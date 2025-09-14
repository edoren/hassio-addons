#!/usr/bin/env bashio

# https://support.rallly.co/self-hosting/configuration
# General
bashio::config.require "next_public_base_url"
next_public_base_url="$(bashio::config 'next_public_base_url')"
export NEXT_PUBLIC_BASE_URL="$next_public_base_url"
bashio::config.require "secret_password"
secret_password="$(bashio::config 'secret_password')"
export SECRET_PASSWORD="$secret_password"
bashio::config.require "support_email"
support_email="$(bashio::config 'support_email')"
export SUPPORT_EMAIL="$support_email"
if bashio::config.has_value "noreply_email"; then
    noreply_email="$(bashio::config 'noreply_email')"
    export NOREPLY_EMAIL="$noreply_email"
fi
if bashio::config.has_value "noreply_email_name"; then
    noreply_email_name="$(bashio::config 'noreply_email_name')"
    export NOREPLY_EMAIL_NAME="$noreply_email_name"
fi
if bashio::config.has_value "initial_admin_email"; then
    initial_admin_email="$(bashio::config 'initial_admin_email')"
    export INITIAL_ADMIN_EMAIL="$initial_admin_email"
fi

# Database
bashio::config.require "database_name"
bashio::config.require "database_host"
bashio::config.require "database_port"
bashio::config.require "database_user"
bashio::config.require "database_password"
database_name="$(bashio::config 'database_name')"
database_host="$(bashio::config 'database_host')"
database_port="$(bashio::config 'database_port')"
database_user="$(bashio::config 'database_user')"
database_password="$(bashio::config 'database_password')"
export DATABASE_URL="postgres://$database_user:$database_password@$database_host:$database_port/$database_name"

# Email (SMTP)
if bashio::config.has_value "smtp_host"; then
    smtp_host="$(bashio::config 'smtp_host')"
    export SMTP_HOST="$smtp_host"
fi
if bashio::config.has_value "smtp_port"; then
    smtp_port="$(bashio::config 'smtp_port')"
    export SMTP_PORT="$smtp_port"
fi
if bashio::config.has_value "smtp_secure"; then
    smtp_secure="$(bashio::config 'smtp_secure')"
    export SMTP_SECURE="$smtp_secure"
fi
if bashio::config.has_value "smtp_user"; then
    smtp_user="$(bashio::config 'smtp_user')"
    export SMTP_USER="$smtp_user"
fi
if bashio::config.has_value "smtp_pwd"; then
    smtp_pwd="$(bashio::config 'smtp_pwd')"
    export SMTP_PWD="$smtp_pwd"
fi
if bashio::config.has_value "smtp_pwd"; then
    smtp_pwd="$(bashio::config 'smtp_pwd')"
    export EMAIL_LOGIN_ENABLED="$smtp_pwd"
fi
if bashio::config.has_value "smtp_pwd"; then
    smtp_pwd="$(bashio::config 'smtp_pwd')"
    export REGISTRATION_ENABLED="$smtp_pwd"
fi

# Auth
if bashio::config.has_value "email_login_enabled"; then
    email_login_enabled="$(bashio::config 'email_login_enabled')"
    export EMAIL_LOGIN_ENABLED="$email_login_enabled"
fi
if bashio::config.has_value "registration_enabled"; then
    registration_enabled="$(bashio::config 'registration_enabled')"
    export REGISTRATION_ENABLED="$registration_enabled"
fi
if bashio::config.has_value "allowed_emails"; then
    allowed_emails="$(readarray -t ARRAY <<< "$(bashio::config 'allowed_emails')"; IFS=','; echo "${ARRAY[*]}")"
    export ALLOWED_EMAILS="$allowed_emails"
fi

## Google
if bashio::config.has_value "google_client_id"; then
    google_client_id="$(bashio::config 'google_client_id')"
    export GOOGLE_CLIENT_ID="$google_client_id"
fi
if bashio::config.has_value "google_client_secret"; then
    google_client_secret="$(bashio::config 'google_client_secret')"
    export GOOGLE_CLIENT_SECRET="$google_client_secret"
fi

## Microsoft
if bashio::config.has_value "microsoft_tenant_id"; then
    microsoft_tenant_id="$(bashio::config 'microsoft_tenant_id')"
    export MICROSOFT_TENANT_ID="$microsoft_tenant_id"
fi
if bashio::config.has_value "microsoft_client_id"; then
    microsoft_client_id="$(bashio::config 'microsoft_client_id')"
    export MICROSOFT_CLIENT_ID="$microsoft_client_id"
fi
if bashio::config.has_value "microsoft_client_secret"; then
    microsoft_client_secret="$(bashio::config 'microsoft_client_secret')"
    export MICROSOFT_CLIENT_SECRET="$microsoft_client_secret"
fi

## Custom SSO (OIDC)
if bashio::config.has_value "oidc_discovery_url"; then
    oidc_discovery_url="$(bashio::config 'oidc_discovery_url')"
    export OIDC_DISCOVERY_URL="$oidc_discovery_url"
fi
if bashio::config.has_value "oidc_client_id"; then
    oidc_client_id="$(bashio::config 'oidc_client_id')"
    export OIDC_CLIENT_ID="$oidc_client_id"
fi
if bashio::config.has_value "oidc_client_secret"; then
    oidc_client_secret="$(bashio::config 'oidc_client_secret')"
    export OIDC_CLIENT_SECRET="$oidc_client_secret"
fi
if bashio::config.has_value "oidc_issuer_url"; then
    oidc_issuer_url="$(bashio::config 'oidc_issuer_url')"
    export OIDC_ISSUER_URL="$oidc_issuer_url"
fi
if bashio::config.has_value "oidc_name"; then
    oidc_name="$(bashio::config 'oidc_name')"
    export OIDC_NAME="$oidc_name"
fi
if bashio::config.has_value "oidc_discovery_url"; then
    oidc_discovery_url="$(bashio::config 'oidc_discovery_url')"
    export OIDC_DISCOVERY_URL="$oidc_discovery_url"
fi
if bashio::config.has_value "oidc_issuer_url"; then
    oidc_issuer_url="$(bashio::config 'oidc_issuer_url')"
    export OIDC_ISSUER_URL="$oidc_issuer_url"
fi
if bashio::config.has_value "oidc_client_id"; then
    oidc_client_id="$(bashio::config 'oidc_client_id')"
    export OIDC_CLIENT_ID="$oidc_client_id"
fi
if bashio::config.has_value "oidc_client_secret"; then
    oidc_client_secret="$(bashio::config 'oidc_client_secret')"
    export OIDC_CLIENT_SECRET="$oidc_client_secret"
fi
if bashio::config.has_value "oidc_name_claim_path"; then
    oidc_name_claim_path="$(bashio::config 'oidc_name_claim_path')"
    export OIDC_NAME_CLAIM_PATH="$oidc_name_claim_path"
fi
if bashio::config.has_value "oidc_email_claim_path"; then
    oidc_email_claim_path="$(bashio::config 'oidc_email_claim_path')"
    export OIDC_EMAIL_CLAIM_PATH="$oidc_email_claim_path"
fi
if bashio::config.has_value "oidc_picture_claim_path"; then
    oidc_picture_claim_path="$(bashio::config 'oidc_picture_claim_path')"
    export OIDC_PICTURE_CLAIM_PATH="$oidc_picture_claim_path"
fi

# Storage (S3)
if bashio::config.has_value "s3_bucket_name"; then
    s3_bucket_name="$(bashio::config 's3_bucket_name')"
    export S3_BUCKET_NAME="$s3_bucket_name"
fi
if bashio::config.has_value "s3_access_key_id"; then
    s3_access_key_id="$(bashio::config 's3_access_key_id')"
    export S3_ACCESS_KEY_ID="$s3_access_key_id"
fi
if bashio::config.has_value "s3_secret_access_key"; then
    s3_secret_access_key="$(bashio::config 's3_secret_access_key')"
    export S3_SECRET_ACCESS_KEY="$s3_secret_access_key"
fi
if bashio::config.has_value "s3_endpoint"; then
    s3_endpoint="$(bashio::config 's3_endpoint')"
    export S3_ENDPOINT="$s3_endpoint"
fi
if bashio::config.has_value "s3_region"; then
    s3_region="$(bashio::config 's3_region')"
    export S3_REGION="$s3_region"
fi

/app/docker-start.sh
