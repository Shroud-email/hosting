# Shroud.email hosting

Docker Compose configuration for self-hosting Shroud.email.

To self-host [Shroud.email](https://shroud.email/), follow these instructions.

You'll need a server running on the public Internet, with ports 25, 80, and 443 open.

# Configure SPF/DKIM

## Step 1: Create DNS records

Shroud.email uses two domains. If your domain is e.g. `example.com`, then the first domain (`APP_DOMAIN` in `.env`) is where the web UI will be served (e.g. `app.example.com`). The second domain (`EMAIL_DOMAIN`) is the domain used by email aliases. For this, you can use your top domain, so that email aliases will end in `@example.com`.

Note that your `APP_DOMAIN` cannot be the same as your `EMAIL_DOMAIN`.

| Type | Name              | Content             | Notes                                                     |
|------|-------------------|---------------------|-----------------------------------------------------------|
| A    | app.example.com   | your IP             |                                                           |
| A    | example.com       | your IP             | Needed to get SSL certificate for example.com             |
| MX   | example.com       | app.example.com     |                                                           |
| TXT  | example.com       | v=spf1 mx -all      | Don't allow other servers to send emails from your domain |

## Step 2: Setup SPF

[SPF (Sender Policy Framework)](https://en.wikipedia.org/wiki/Sender_Policy_Framework) prevents others from forging
emails from your domain.

If you added the SPF TXT record above, this should already be done. You can check your SPF configuration using free online
tools like [this one](https://www.spf-record.com/).

## Step 3: Setup DKIM

[DKIM (DomainKeys Identified Mail)](https://en.wikipedia.org/wiki/DomainKeys_Identified_Mail) uses public-key cryptography to
sign messages from your domain, so recipients can be sure that emails were not forged.

First, generate your keypair:

```bash
# cd to the dkim directory so keys are created in the right place
$ cd haraka/haraka_config/config/dkim
$ ./dkim_key_gen.sh example.com # use your domain
```

Now, look in the directory `./example.com/dns`. This file shows the TXT DNS record you need to add.

## Step 3: Set up DMARC

We're getting there! [DMARC](https://en.wikipedia.org/wiki/DMARC) builds on top of SPF and DKIM to tell recipients how to verify that emails really came from you.

Add the following TXT record for `_dmarc.example.com`, replace `admin@example.com` with your own email address:

```
v=DMARC1; p=none; ruf=mailto:admin@example.com
```

This tells recipients to send a message to you if there are any DMARC errors.

# Run the app

## Step 1: Configure

* `cp example.env .env` and enter your configuration in `.env`.
* Update `haraka/haraka_config/config/me` with your `EMAIL_DOMAIN`. It should be a plaintext file with only this value, e.g.

```
example.com
```

## Step 2: Run it

```
docker compose up -d
```

And if you want to view logs:

```
docker compose logs -f
```

## Step 3: Bundle SSL certificates

Once you see in the logs that Caddy has setup certificates for your domains, you can continue.
Now that we have the certificates, we need to convert them to a format that the SMTP relay can understand.
Run the following command:

```
docker compose exec cron /etc/periodic/daily/bundle_certs
docker compose restart haraka
```

You only need to run this manually once; going forward it will run automatically once per day.

## Step 4: Harden DMARC

Now you're up and running, see if you receive any DMARC reports on the email you specified earlier.
If not, you can tighten your configuration by updating your DMARC TXT record to the following (again, replacing `admin@example.com` with your own email address):

```
v=DMARC1; p=quarantine; aspf=s; adkim=s; ruf=mailto:admin@example.com
```

# Test your setup

Running your own mailserver isn't trivial. Now, you should run some checks against it to ensure
that you're not running an open relay, that your SPF/DKIM/DMARC are configured properly, and that
you're not on any blocklists. Even then, it's not uncommon for emails from small mailservers to end
up in spam.

Here's a non-exhaustive list of useful websites that can help check your configuration:

* [Mail tester](https://www.mail-tester.com/)
* [SMTP server test](https://mxtoolbox.com/diagnostic.aspx)
* [Email deliverability test](https://mxtoolbox.com/deliverability)
* [Open relay test](https://tools.appriver.com/OpenRelay.aspx)
