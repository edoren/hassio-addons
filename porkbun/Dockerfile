# Build image
ARG BUILD_FROM=alpine
FROM $BUILD_FROM as build

RUN apk add --no-cache --virtual .porkbun-ddns-rs-build curl unzip pkgconfig openssl-dev rust cargo

RUN curl -sSL "https://github.com/edoren/porkbun-ddns-rs/archive/refs/tags/v0.1.4.zip" -o porkbun-ddns-rs.zip

RUN unzip "porkbun-ddns-rs.zip" 
RUN mv porkbun-ddns-rs-* /build

COPY docker-entrypoint.sh /
RUN chmod 700 /docker-entrypoint.sh

WORKDIR /build
RUN cargo build -r

# Run image
ARG BUILD_FROM=$BUILD_FROM
FROM $BUILD_FROM

COPY --from=build /build/target/release/porkbun_ddns_rs /
COPY --from=build /docker-entrypoint.sh /

RUN apk update && apk --no-cache add tini bash libstdc++

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Manuel Sabogal <mfer32@gmail.com>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Edoren's Add-ons" \
    org.opencontainers.image.authors="Manuel Sabogal <mfer32@gmail.com>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://edoren.me" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}

WORKDIR /
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/docker-entrypoint.sh"]
