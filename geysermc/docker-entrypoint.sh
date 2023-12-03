#!/bin/sh

set -e

GEYSER_MIN_MEM=1G
GEYSER_MAX_MEM=2G

cd /data
java -Xms${GEYSER_MIN_MEM} -Xmx${GEYSER_MAX_MEM} -jar /opt/geyser/Geyser.jar
