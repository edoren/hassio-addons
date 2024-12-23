#!/usr/bin/env bashio

api_key="$(bashio::config 'api_key')"
secret_key="$(bashio::config 'secret_key')"
domain="$(bashio::config 'domain')"
subdomains="$(readarray -t ARRAY <<< "$(bashio::config 'subdomains')"; IFS=','; echo "${ARRAY[*]}")"
time_update="$(bashio::config 'time_update')"

secrets_json_fmt='{"api_key": "%s", "secret_key": "%s"}'
printf -v secrets_json "$secrets_json_fmt" $api_key $secret_key
echo "$secrets_json" > secrets.json

echo "============================================================"
echo "$(./porkbun_ddns --version)"
echo ""
echo "  Domain: $domain"
echo "  Subdomains: $subdomains"
echo "============================================================"

./porkbun_ddns "$domain" --subdomains "$subdomains" --secrets secrets.json -t "$time_update"
