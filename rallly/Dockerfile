ARG BUILD_FROM=alpine
FROM node:20-alpine3.20 AS builder

ENV RALLLY_VERSION=3.11.2

WORKDIR /
RUN yarn global add turbo
RUN wget "https://github.com/lukevella/rallly/archive/refs/tags/v${RALLLY_VERSION}.tar.gz" -O rallly.tar.gz
RUN tar -xvf rallly.tar.gz && mv rallly-${RALLLY_VERSION} app
WORKDIR /app
RUN sed -i 's/"native"/"native", "linux-musl-openssl-3.0.x"/' ./packages/database/prisma/schema.prisma
RUN turbo prune --scope=@rallly/web --docker

FROM node:20-alpine3.20 AS installer

WORKDIR /app
COPY --from=builder /app/.gitignore .gitignore
COPY --from=builder /app/out/json/ .
COPY --from=builder /app/out/yarn.lock ./yarn.lock
RUN yarn --network-timeout 1000000

# Build the project
COPY --from=builder /app/out/full/ .
COPY --from=builder /app/turbo.json turbo.json
RUN yarn db:generate

ENV NEXT_PUBLIC_APP_VERSION=$RALLLY_VERSION

ENV NEXT_PUBLIC_SELF_HOSTED=true

RUN SKIP_ENV_VALIDATION=1 yarn build

FROM $BUILD_FROM AS runner

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# prisma requirements
# (see https://www.prisma.io/docs/orm/reference/system-requirements)
RUN apk update && apk --no-cache add yarn openssl zlib libgcc tini bash

WORKDIR /app

RUN yarn global add prisma

# Don't run production as root
USER nextjs

COPY --from=builder --chown=nextjs:nodejs /app/scripts/docker-start.sh ./
COPY --from=builder --chown=nextjs:nodejs /app/packages/database/prisma ./prisma
 
COPY --from=installer /app/apps/web/next.config.js .
COPY --from=installer /app/apps/web/package.json .

ENV PORT=3000
EXPOSE 3000

# Automatically leverage output traces to reduce image size
# https://nextjs.org/docs/advanced-features/output-file-tracing
COPY --from=installer --chown=nextjs:nodejs /app/apps/web/.next/standalone ./
COPY --from=installer --chown=nextjs:nodejs /app/apps/web/.next/static ./apps/web/.next/static
COPY --from=installer --chown=nextjs:nodejs /app/apps/web/public ./apps/web/public

ARG SELF_HOSTED
ENV NEXT_PUBLIC_SELF_HOSTED=$SELF_HOSTED
ENV HOSTNAME=0.0.0.0

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

COPY --chown=nextjs:nodejs docker-entrypoint.sh /
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/docker-entrypoint.sh"]
