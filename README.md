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