#!/usr/bin/env bashio

LAST_VERSION_FILE="/data/.last_version.json"

config_version="$(bashio::config 'version')"
config_min_memory="$(bashio::config 'min_memory')"
config_max_memory="$(bashio::config 'max_memory')"

latest_build_info=$(wget -O- --no-check-certificate --quiet --method GET --timeout=0 --header "Accept: application/json" "https://download.geysermc.org/v2/projects/geyser/versions/${config_version}/builds/latest")
if [ -z "$latest_build_info" ]; then
    echo "Invalid Geyser version, select a proper version";
    exit 1;
fi

response_version=$(echo "$latest_build_info" | jq ".version")
response_build=$(echo "$latest_build_info" | jq ".build")

download_latest_version=0
if [ -f "$LAST_VERSION_FILE" ]; then
    file_contents=$(cat "$LAST_VERSION_FILE");
    file_version=$(echo "$file_contents" | jq ".version");
    file_build=$(echo "$file_contents" | jq ".build");

    if [[ $file_version != $response_version ]] || [[ $file_build != $response_build ]]; then
        download_latest_version=1;
    fi
else
    download_latest_version=1;
fi

if [[ $download_latest_version -eq 1 ]]; then
    echo "Downloading latest version $response_version build $response_build";
    mkdir -p /opt/geyser;
    wget -O /opt/geyser/Geyser.jar --content-disposition "https://download.geysermc.org/v2/projects/geyser/versions/${config_version}/builds/latest/downloads/standalone";
    jq -n --arg version "$response_version" --arg build "$response_build" '{version: $version, build: $build}' > $LAST_VERSION_FILE;
fi

cd /data
java -Xms${config_min_memory} -Xmx${config_max_memory} -jar /opt/geyser/Geyser.jar
