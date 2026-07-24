# Compile Caddy with custom modules.
#   - caddy-permissive-file-storage: world-readable certs so the cron
#     sidecar can bundle them for Haraka (the whole reason this fork exists).
#   - caddy-dns/bunny: DNS-01 ACME via Bunny.net, opt-in via Caddyfile.bunny.
#
# Built locally by docker compose (see `caddy` service `build: ./caddy`).
# Pins: Caddy v2.10.0, bunny v1.2.0. caddy-permissive-file-storage is pinned to
# commit 4059a60 (PR #1, "Update for current Caddy") because the latest tag
# v0.1.4 still has the pre-context Store() signature that fails to compile
# against Caddy v2.10.0+. Replace with @v0.1.5 once a release is cut.
FROM caddy:2.10-builder AS builder

RUN xcaddy build v2.10.0 \
    --with github.com/Shroud-email/caddy-permissive-file-storage@4059a602db55a1762de165dac7f1204c823ebbd4 \
    --with github.com/caddy-dns/bunny@v1.2.0

# Production image
FROM caddy:2.10-alpine

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
