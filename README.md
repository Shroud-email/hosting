# Shroud.email hosting

Docker Compose configuration for self-hosting Shroud.email.

Please read our [deployment documentation](https://shroud.email/docs/deployment/self-host) on our website.

If you just want to get up and running with Shroud.email quickly, you can sign up for our hosted version [here](https://app.shroud.email/users/register).

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

## Cap CAPTCHA

The compose file includes a [Cap](https://trycap.dev) self-hosted CAPTCHA
instance (the `cap` + `valkey` services). Cap protects the signup, login,
and password-reset forms. It is **opt-in at the application level**: the
services run by default, but the widget is not rendered and verification
is not performed until you set all three `CAP_*` variables on the `web`
service.

### Setup

1. Generate an admin key and set `CAP_ADMIN_KEY` in `.env`:
   ```bash
   openssl rand -hex 32
   ```

2. Start the services:
   ```bash
   docker compose up -d cap valkey
   ```

3. Create a site key with the strongest challenge combination
   (RSW time-lock + JS instrumentation). Cap authenticates with a
   session token issued by logging in with the `ADMIN_KEY` — the `Bot`
   scheme is for Valkey-stored API keys, not the admin key:
   ```bash
   # Log in with ADMIN_KEY → get a session token + hash
   RESP=$(curl -s -X POST http://<cap-host>:3000/auth/login \
     -H "Content-Type: application/json" \
     -d "{\"admin_key\":\"$CAP_ADMIN_KEY\"}")
   TOKEN=$(echo "$RESP" | jq -r .session_token)
   HASH=$(echo "$RESP" | jq -r .hashed_token)
   BEARER=$(printf '{"token":"%s","hash":"%s"}' "$TOKEN" "$HASH" | base64)

   # Create the site key with the Bearer session
   curl -X POST http://<cap-host>:3000/server/keys \
     -H "Authorization: Bearer $BEARER" \
     -H "Content-Type: application/json" \
     -d '{"name":"shroud-email","instrumentation":true,"rsw":true}'
   ```
   The response returns `siteKey` and `secretKey` (shown only once — save it).
   (`<cap-host>:3000` must be reachable — the `cap` service has no host port
   mapping in the production compose, so run this from the host with a
   temporary `ports:` override, or `docker compose exec` into another service
   on the compose network and use `http://cap:3000`.)

4. Set `CAP_SITE_KEY` and `CAP_SECRET_KEY` in `.env` and restart `web`:
   ```bash
   docker compose restart web
   ```

Cap verifies tokens are single-use. The secret key never reaches the
browser; only the site key is public.