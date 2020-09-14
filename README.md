# docker-gemstash

This repo contains files to deploy Gemstash as a docker container.
Gemstash is both a cache and a private gem source (more info here
https://github.com/rubygems/gemstash)

## How it works

Open the file `override.env` and set the following variables:

```
DOCKER_HOST=ssh://root@example.com
HOST=example.com
APP_FQDN=gems.example.com
```

Then run

```
make generate-env deploy
```
