# Build image
ARG BUILD_FROM=alpine
FROM golang:1.23.5-alpine3.20 as build

ENV NAMECHEAT_DDNS_VERSION=1.3.0
RUN wget "https://github.com/navilg/namecheap-ddns-docker/archive/refs/tags/${NAMECHEAT_DDNS_VERSION}.tar.gz" -O namecheap-ddns-docker.tar.gz
RUN tar -xvf namecheap-ddns-docker.tar.gz && mv namecheap-ddns-docker-${NAMECHEAT_DDNS_VERSION} /build

COPY docker-entrypoint.sh /
RUN chmod 700 /build/container-entrypoint.sh
RUN chmod 700 /docker-entrypoint.sh

ARG OS
ARG ARCH
WORKDIR /build
RUN go mod download && go build -o ncddns

# Run image
ARG BUILD_FROM=$BUILD_FROM
FROM $BUILD_FROM

RUN addgroup -g 1000 ncddns && adduser -h /app -u 1000 -G ncddns -s /bin/bash -D ncddns

COPY --from=build --chown=ncddns:ncddns /build/ncddns /app/ncddns
COPY --from=build --chown=ncddns:ncddns /build/container-entrypoint.sh /app/container-entrypoint.sh
COPY --from=build --chown=ncddns:ncddns /docker-entrypoint.sh /

RUN apk update && apk --no-cache add tini bash

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

USER ncddns
WORKDIR /app
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/docker-entrypoint.sh"]
