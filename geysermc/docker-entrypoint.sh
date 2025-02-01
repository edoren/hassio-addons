#!/usr/bin/env bashio

BIN_FOLDER="/data/.bin"
DATA_FOLDER="/data/data"
LAST_VERSION_FILE="$BIN_FOLDER/.last_version.json"

mkdir -p $BIN_FOLDER
mkdir -p $DATA_FOLDER

config_version="$(bashio::config 'version')"
config_min_memory="$(bashio::config 'min_memory')"
config_max_memory="$(bashio::config 'max_memory')"

bashio::log.info "Checking last version"

latest_build_info=$(wget -O- --no-check-certificate --quiet --method GET --timeout=0 --header "Accept: application/json" "https://download.geysermc.org/v2/projects/geyser/versions/${config_version}/builds/latest")
if [ -z "$latest_build_info" ]; then
    bashio::log.info "Invalid Geyser version, select a proper version";
    exit 1;
fi

response_version=$(echo "$latest_build_info" | jq -r ".version")
response_build=$(echo "$latest_build_info" | jq -r ".build")

download_latest_version=0
if [ -f "$LAST_VERSION_FILE" ]; then
    file_contents=$(cat $LAST_VERSION_FILE);
    file_version=$(echo "$file_contents" | jq -r ".version");
    file_build=$(echo "$file_contents" | jq -r ".build");
    bashio::log.info "Last executed version ${file_version} build ${file_build}";
    if [[ "$file_version" != "$response_version" ]] || [[ "$file_build" != "$response_build" ]]; then
        bashio::log.info "Newer version found $response_version build $response_build";
        download_latest_version=1;
    else
        bashio::log.info "No new version found";
    fi
else
    download_latest_version=1;
fi

if [[ $download_latest_version -eq 1 ]]; then
    bashio::log.info "Downloading latest version ${response_version} build ${response_build}";
    wget -O $BIN_FOLDER/Geyser.jar --content-disposition --quiet "https://download.geysermc.org/v2/projects/geyser/versions/${config_version}/builds/latest/downloads/standalone";
    jq -n --arg version "$response_version" --arg build "$response_build" '{version: $version, build: $build}' > $LAST_VERSION_FILE;
fi

cd $DATA_FOLDER || exit
java -Xms"${config_min_memory}" -Xmx"${config_max_memory}" -jar $BIN_FOLDER/Geyser.jar
