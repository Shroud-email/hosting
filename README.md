# Shroud.email hosting

Docker Compose configuration for self-hosting Shroud.email.

To self-host [Shroud.email](https://shroud.email/), follow these instructions.

1. `cp example.env .env` and enter your configuration in `.env`.
2. Enter your email in `config.env`. This is used for provisioning TLS certificates with Let's Encrypt.
3. Rename `vhosts/example.com.conf` to use your domain name instead of `example.com`.
4. Run `docker compose up`!
