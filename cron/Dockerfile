FROM alpine:3.15

RUN apk update && \
    apk add --no-cache bash

WORKDIR /workdir

COPY bundle_certs.sh /usr/local/bin/bundle_certs
RUN chmod +x /usr/local/bin/bundle_certs

VOLUME /pem

# Run bundle once at boot (populate pem_certs before Haraka's first STARTTLS),
# then keep the daily crond for renewals. Caddy's fullchain is copied verbatim.
CMD ["sh", "-c", "bundle_certs; exec crond -f -l 0"]
