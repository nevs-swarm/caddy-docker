# builder image
FROM golang:alpine AS builder

ARG version="0.11.5"
ARG plugins="\
github.com/caddyserver/dnsproviders/cloudflare \
github.com/captncraig/caddy-realip \
"

RUN apk add --no-cache git

# get caddy source
RUN git clone https://github.com/mholt/caddy -b "v${version}" $GOPATH/src/github.com/mholt/caddy
WORKDIR $GOPATH/src/github.com/mholt/caddy
RUN git checkout -b "v${version}"

# add plugins
WORKDIR $GOPATH/src/github.com/mholt/caddy/caddy/caddymain
RUN for plugin in $(echo "${plugins}"); do \
      go get -v $plugin; \
      awk "{sub(/^import \\(/, \"import \\(\n\t_ \\\"$plugin\\\"\"); print \$0}" run.go > run.go.tmp; \
      rm -f run.go; \
      mv run.go.tmp run.go; \
    done

# get build helper
RUN git clone https://github.com/caddyserver/builds $GOPATH/src/github.com/caddyserver/builds

# finally build caddy
WORKDIR $GOPATH/src/github.com/mholt/caddy/caddy
RUN go run build.go
RUN mv caddy /


# final image
FROM alpine

RUN apk add --no-cache curl tini

COPY --from=builder /caddy /usr/bin/caddy
COPY /Caddyfile /etc/Caddyfile

ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/caddy", "-conf", "/etc/Caddyfile"]
CMD ["-log", "stdout"]
