# Build image
ARG BUILD_FROM=alpine
FROM $BUILD_FROM AS build

WORKDIR /

ENV ATUIN_VERSION=18.8.0

ARG BUILD_ARCH
ENV BUILD_ARCH=$BUILD_ARCH
RUN file_name=""; \
    if [[ "$BUILD_ARCH" == "aarch64" ]]; then \
        echo "Building for aarch64"; \
        file_name="atuin-aarch64-unknown-linux-musl"; \
    elif [[ "$BUILD_ARCH" == "amd64" ]]; then \
        echo "Building for amd64"; \
        file_name="atuin-x86_64-unknown-linux-musl"; \
    else \
        echo "Architecture $BUILD_ARCH not supported" && exit 1; \
    fi; \
    wget "https://github.com/atuinsh/atuin/releases/download/v${ATUIN_VERSION}/${file_name}.tar.gz"; \
    wget "https://github.com/atuinsh/atuin/releases/download/v${ATUIN_VERSION}/${file_name}.tar.gz.sha256"; \
    sha256sum -c "${file_name}.tar.gz.sha256"; \
    tar -xvf "${file_name}.tar.gz"; \
    mv "${file_name}/atuin" "/atuin"

COPY docker-entrypoint.sh /

RUN chmod 700 /atuin /docker-entrypoint.sh
RUN chown root:root /atuin /docker-entrypoint.sh

# Run image
FROM $BUILD_FROM AS runner

COPY --from=build /atuin /
COPY --from=build /docker-entrypoint.sh /

RUN apk update && apk --no-cache add tini

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

ENV PORT=8888
EXPOSE 8888

WORKDIR /
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/docker-entrypoint.sh"]
