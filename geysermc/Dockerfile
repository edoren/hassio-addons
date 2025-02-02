ARG BUILD_FROM=alpine
FROM $BUILD_FROM

ENV GEYSER_PORT=19132/udp

EXPOSE ${GEYSER_PORT}

WORKDIR /var/lib/geyser

RUN apk update && apk upgrade
RUN apk add --no-cache tini wget
RUN apk add openjdk17-jre-headless jq

RUN mkdir /data

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

# Build arguments
ARG BUILD_ARCH
ARG BUILD_VERSION
ARG BUILD_NAME
ARG BUILD_DESCRIPTION
ARG BUILD_REPOSITORY
ARG BUILD_REF
ARG BUILD_DATE

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Manuel Sabogal <personal@edoren.me>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Edoren's Add-ons" \
    org.opencontainers.image.authors="Manuel Sabogal <personal@edoren.me>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://edoren.me" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/master/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/docker-entrypoint.sh"]
