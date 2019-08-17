# builder image
FROM golang:alpine AS builder

ARG version="1.0.3"

RUN apk add git

COPY caddy.go /caddy-docker/caddy.go
WORKDIR /caddy-docker

ENV GO111MODULE=on
RUN go mod init caddy
RUN go get github.com/caddyserver/caddy@v${version}

# FIXME temporary workaround
RUN echo "replace github.com/h2non/gock => gopkg.in/h2non/gock.v1 v1.0.14" >> go.mod

RUN go build -o /caddy

# final image
FROM alpine

RUN apk add --no-cache curl tini

COPY --from=builder /caddy /usr/bin/caddy
COPY /Caddyfile /etc/Caddyfile

EXPOSE 80 443 2015

ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/caddy", "-conf", "/etc/Caddyfile"]
CMD ["-log", "stdout"]
