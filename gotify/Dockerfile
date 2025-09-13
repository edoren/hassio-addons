ARG BUILD_FROM=alpine

# Build image
FROM golang:1.25.1-alpine3.22 AS builder

ENV GOTIFY_VERSION=2.7.2

WORKDIR /

RUN apk --no-cache add git
RUN git clone --depth 1 --branch v${GOTIFY_VERSION} https://github.com/gotify/server.git server

WORKDIR /server

RUN apk --no-cache add bash build-base binutils-gold musl-dev
RUN make download-tools

# Build UI
ARG BUILD_ARCH
ENV BUILD_ARCH=$BUILD_ARCH
RUN apk --no-cache add yarn
RUN cd ui; \
    if [[ "$BUILD_ARCH" == "i386" ]]; then \
        apk --no-cache add jq; \
        jq '. + { "resolutions": { "rollup": "npm:@rollup/wasm-node" } }' package.json > tmp.json && mv tmp.json package.json; \
    fi; \
    yarn install; \
    yarn build

# Build server
RUN export CGO_ENABLED=1; \
    export CGO_CFLAGS="-D_LARGEFILE64_SOURCE"; \
    export LD_FLAGS="-w -s -X main.Version=$(git describe --tags | cut -c 2-) -X main.BuildDate=$(date "+%F-%T") -X main.Commit=$(git rev-parse --verify HEAD) -X main.Mode=prod"; \
    go build -ldflags="$LD_FLAGS" -o gotify-server

COPY docker-entrypoint.sh /

RUN chmod 755 /server/gotify-server /docker-entrypoint.sh
RUN chown root:root /server/gotify-server /docker-entrypoint.sh

# Run image
FROM $BUILD_FROM AS runner

COPY --from=builder /server/gotify-server /
COPY --from=builder /docker-entrypoint.sh /

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

EXPOSE 80

WORKDIR /
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/docker-entrypoint.sh"]
