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

## Step 2: Configuration

* `cp example.env .env` and enter your configuration in `.env`.
* Rename `vhosts/example.com.conf` to use your domain name instead of `example.com`.

## Step 3: Create Docker volumes

```
docker volume create --name=nginx_conf
docker volume create --name=letsencrypt_certs
```

## Step 4: Test your TLS configuration

Run `docker compose up`. This will automatically fetch a new TLS certificate from Let's Encrypt. First, it will use the Let's Encrypt staging environment. If this works (and you see `Successfully received certificate`) in the logs, you can proceed. 

## Step 4: Switch to production Let's Encrypt server

Set `CERTBOT_TEST_CERT=0` in your `.env`. Then, re-create the Docker volume that holds the certificates:

```
docker volume rm letsencrypt_certs
docker volume create --name=letsencrypt_certs
```

Finally, re-run `docker compose up`.

## Step 5: Verify HTTPS

Try visiting your domain in your browser. It should show the Shroud.email app using HTTPS!

## Step 6: Run as a daemon

```
docker compose up -d
```
