#!/usr/bin/env bashio

api_key="$(bashio::config 'api_key')"
secret_key="$(bashio::config 'secret_key')"
domain="$(bashio::config 'domain')"
subdomains="$(readarray -t ARRAY <<< "$(bashio::config 'subdomains')"; IFS=','; echo "${ARRAY[*]}")"
time_update="$(bashio::config 'time_update')"

echo "{\"api_key\": \"$api_key\", \"secret_key\": \"$secret_key\"}" > secrets.json

echo "============================================================"
./porkbun_ddns --version
echo ""
echo "  Domain: $domain"
echo "  Subdomains: $subdomains"
echo "============================================================"

./porkbun_ddns "$domain" --subdomains "$subdomains" --secrets secrets.json -t "$time_update"
