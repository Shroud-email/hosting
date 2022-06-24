# Shroud.email hosting

Docker Compose configuration for self-hosting Shroud.email.

To self-host [Shroud.email](https://shroud.email/), follow these instructions.

You'll need a server running on the public Internet, with ports 25, 80, and 443 open.

# Initial setup

## Step 1: Create DNS records

Shroud.email uses two subdomains. If your domain is e.g. `example.com`, then the first subdomain (`APP_DOMAIN` in `.env`) is where the web UI will be served. The second subdomain (`EMAIL_DOMAIN`) is the domain used by email aliases.

| Type | Name              | Content             |
|------|-------------------|---------------------|
| A    | app.example.com   | your IP             |
| A    | mail.example.com  | your IP             |
| MX   | mail.example.com  | app.example.com     |

## Step 2: Configure

* `cp example.env .env` and enter your configuration in `.env`.
* Update `haraka/haraka_config/config/me` with your `EMAIL_DOMAIN`. It should be a plaintext file with only this value, e.g.

```
mail.example.com
```

## Step 3: Run it!

```
docker compose up -d
```

And if you want to view logs:

```
docker compose logs -f
```
