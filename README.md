# I have/I need platform

🚨This is **PRE-ALPHA** and not yet ready for use 🚨

This is a tool for local authorities and voluntary organisations to record and triage the needs of vulnerable people in their jurisdiction, and assign those needs to those who can meet them.

It's a rails app backed by a postgresql database.

## Running it locally

```
git clone https://github.com/wearefuturegov/i-have-i-need
bundle install

# install javascript dependencies
yarn install

# launch postgres server via docker
docker-compose up -d

# run create databases, run migrations and seeds
rails db:setup

rails server
```

It'll be on **localhost:3000**.
    
### How emails work
When running in development mode, emails are sent to [maildev](https://www.npmjs.com/package/maildev), running via `docker-compose`.

Visit **localhost:1080** to view sent emails.

## Running it on the web

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](
https://heroku.com/deploy)

Suitable for 12-factor app hosting like [Heroku](http://heroku.com).

[Sendgrid] delivers emails in production. You need to make sure the API key environment variable is set.

## Roadmap

Coming soon...

## Environment variables

| Name          | Description              |
|---------------|--------------------------|
| SMTP_DOMAIN   | HELO domain              |
| SMTP_ADDRESS  | Address for SMTP server  |
| SMTP_USERNAME | Username for SMTP server |
| SMTP_PASSWORD | Password for SMTP server |
| SMTP_PORT     | Port for SMTP server     |
|SENDGRID_API_KEY| Sendgrid API key (production only |
