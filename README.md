# Shroud.email hosting

Docker Compose configuration for self-hosting Shroud.email.

Please read our [deployment documentation](https://shroud.email/docs/deployment/self-host) on our website.

If you just want to get up and running with Shroud.email quickly, you can sign up for our hosted version [here](https://app.shroud.email/users/register).

Copy `haraka/haraka_config/config/me.example` to `haraka/haraka_config/config/me` and set your mail hostname.

## TLS via Bunny DNS-01 (optional)

Caddy defaults to HTTP-01 ACME (port 80), which works behind no other reverse
proxy. If your setup needs DNS-01 (e.g. you can't open port 80, or you want
wildcard certs), opt in to the Bunny.net DNS challenge:

1. Set `BUNNY_API_KEY` in `.env` to your Bunny.net account API key.
2. Set `CADDYFILE_PATH=./caddy/Caddyfile.bunny` in `.env`.
3. `docker compose up -d --build caddy`.

The Caddy binary is built locally (see `caddy/Dockerfile`) with both the
`caddy-permissive-file-storage` and `caddy-dns/bunny` modules. Self-hosters who
leave the defaults get HTTP-01 and never need a Bunny key.

## Living on the edge

The committed `docker-compose.yaml` tracks the stable `:1` image. If you'd rather
run the latest `:edge` build (rebuilt on every push to `main`) and have it
auto-update, copy the example override and bring the stack up:

```
cp docker-compose.override.example.yaml docker-compose.override.yaml
docker compose up -d
```

This points the `web` service at `:edge` and adds [Watchtower](https://containrrr.dev/watchtower/),
which polls every 5 minutes and auto-recreates `web` (and only `web`) when a new
image is published.