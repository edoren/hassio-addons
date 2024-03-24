#!/usr/bin/env bashio

api_key="$(bashio::config 'api_key')"
secret_key="$(bashio::config 'secret_key')"
domain="$(bashio::config 'domain')"
subdomains="$(bashio::config 'subdomains')"

secrets_json_fmt='{"api_key": "%s", "secret_key": "%s"}'
printf -v secrets_json "$secrets_json_fmt" $api_key $secret_key
echo "$secrets_json" > secrets.json

/app/porkbun_ddns_rs $domain --subdomains $subdomains --secrets secrets.json