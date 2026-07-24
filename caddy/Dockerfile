# Compile Caddy with custom modules.
#   - caddy-permissive-file-storage: world-readable certs so the cron
#     sidecar can bundle them for Haraka (the whole reason this fork exists).
#   - caddy-dns/bunny: DNS-01 ACME via Bunny.net, opt-in via Caddyfile.bunny.
#
# Built locally by docker compose (see `caddy` service `build: ./caddy`).
# Pins: Caddy v2.10.0, bunny v1.2.0. caddy-permissive-file-storage tracks
# main (the PR #1 "Update for current Caddy" fix lives there; the latest tag
# v0.1.4 still has the pre-context Store() signature that fails to compile
# against Caddy v2.10.0+).
FROM caddy:2.10-builder AS builder

RUN xcaddy build v2.10.0 \
    --with github.com/Shroud-email/caddy-permissive-file-storage@main \
    --with github.com/caddy-dns/bunny@v1.2.0

# Production image
FROM caddy:2.10-alpine

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
