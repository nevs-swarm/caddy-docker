caddy-docker
===
A Docker image for [Caddy](https://caddyserver.com/) ([github.com/mholt/caddy](https://github.com/mholt/caddy)). There already exists some almost official image: [github.com/abiosoft/caddy-docker](https://github.com/abiosoft/caddy-docker). I strongly recommend to look at these great projects first and read through the [Caddy Documentation](https://caddyserver.com/docs).

I prefer being able to easily customize the included plugins, that are built on the Docker Hub. Hence creating my own Dockerfile. Currently these plugins are included:
* realip
* tls.dns.cloudflare

Feel free to fork this repository and adjust them to your needs!

### Getting started
```sh
docker run -d -p 2015:2015 nevsnode/caddy
```

##### Relevant paths:
* `/etc/Caddyfile`

Make sure to preserve Let's Encrypt certificates and mount your own Caddyfile:
```
docker run -d \
    -v Caddyfile:/etc/Caddyfile \
    -v .caddy:/root/.caddy \
    -p 80:80 \
    -p 443:443 \
    nevsnode/caddy
```

You'll most likely need to agree to [Let's Encrypt Subscriber Agreement](https://letsencrypt.org/documents/LE-SA-v1.2-November-15-2017.pdf). This can be achieved by passing the flag `-agree`. For example:
```sh
docker run -d -p 2015:2015 nevsnode/caddy -log stdout -agree
```
Or in docker-compose.yml:
```yml
# [...]
    command: ["-log", "stdout", "-agree"]
# [...]
```

Just to have it mentioned: [Telemetry](https://caddyserver.com/docs/telemetry) is enabled by default. It can be disabled using the flag `-disabled-metrics`.
Alternatively, you can also fork this repository and adjust `caddy.go` to disable it entirely.
