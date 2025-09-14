ARG BUILD_FROM=alpine
FROM node:22-alpine3.22 AS base

ENV RALLLY_VERSION=4.4.1

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable

# --- Builder Stage ---
FROM base AS builder

WORKDIR /
RUN wget "https://github.com/lukevella/rallly/archive/refs/tags/v${RALLLY_VERSION}.tar.gz" -O rallly.tar.gz
RUN tar -xvf rallly.tar.gz && mv rallly-${RALLLY_VERSION} app
WORKDIR /app
RUN pnpm add -g turbo
RUN sed -i 's/"native"/"native", "linux-musl-openssl-3.0.x"/' ./packages/database/prisma/schema.prisma
RUN turbo prune --scope=@rallly/web --docker

# --- Installer Stage ---
FROM base AS installer

WORKDIR /app
COPY --from=builder /app/package.json .
COPY --from=builder /app/out/json/ .
COPY --from=builder /app/out/pnpm-lock.yaml ./
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --frozen-lockfile

# Build the project
COPY --from=builder /app/out/full/ .
COPY --from=builder /app/turbo.json turbo.json
RUN pnpm db:generate

ENV NEXT_PUBLIC_APP_VERSION=$RALLLY_VERSION

ENV NEXT_PUBLIC_SELF_HOSTED=true

RUN SKIP_ENV_VALIDATION=1 pnpm build

# --- Runner Stage ---
FROM $BUILD_FROM AS runner

# Disable Next.js telemetry for self-hosted instances
ENV NEXT_TELEMETRY_DISABLED=1

RUN addgroup --system nodejs \
  && adduser --system --ingroup nodejs --home /app --shell /bin/bash nextjs

# prisma requirements
# (see https://www.prisma.io/docs/orm/reference/system-requirements)
RUN apk update && apk --no-cache add npm openssl zlib libgcc tini bash pnpm

RUN npm install --global corepack@latest

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable

WORKDIR /app

# Install prisma globally needed for runtime operations like migrations
RUN pnpm add -g prisma

# Copy Corepack cache from installer stage to avoid runtime download
COPY --from=installer /root/.cache/node/corepack/ /app/.cache/node/corepack/

COPY --from=builder --chown=nextjs:nodejs /app/scripts/docker-start.sh ./
COPY --from=builder --chown=nextjs:nodejs /app/packages/database/prisma ./prisma

COPY --from=installer /app/apps/web/next.config.js .
COPY --from=installer /app/apps/web/package.json .

# Automatically leverage output traces to reduce image size
# https://nextjs.org/docs/advanced-features/output-file-tracing

COPY --from=installer --chown=nextjs:nodejs /app/apps/web/.next/standalone ./
COPY --from=installer --chown=nextjs:nodejs /app/apps/web/.next/static ./apps/web/.next/static
COPY --from=installer --chown=nextjs:nodejs /app/apps/web/public ./apps/web/public

COPY --chown=nextjs:nodejs --from=installer /app/apps/web/.next/standalone ./
COPY --chown=nextjs:nodejs --from=installer /app/apps/web/.next/static ./apps/web/.next/static
COPY --chown=nextjs:nodejs --from=installer /app/apps/web/public ./apps/web/public

# Fix ownership of global pnpm dir - Prisma needs write access to its engines
# and cache directories within the pnpm global store at runtime
RUN chown -R nextjs:nodejs /pnpm
ENV HOME=/app
USER nextjs

EXPOSE 3000
ENV PORT=3000

ARG SELF_HOSTED
ENV NEXT_PUBLIC_SELF_HOSTED=$SELF_HOSTED
ENV HOSTNAME=0.0.0.0

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

# HEALTHCHECK CMD curl --fail http://localhost:${PORT}/api/status || exit 1

COPY --chown=nextjs:nodejs docker-entrypoint.sh /
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/docker-entrypoint.sh"]
