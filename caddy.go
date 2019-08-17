package main

import (
	"github.com/caddyserver/caddy/caddy/caddymain"

	_ "github.com/caddyserver/dnsproviders/cloudflare"
	_ "github.com/captncraig/caddy-realip"
)

func main() {
	// optional: disable telemetry
	// caddymain.EnableTelemetry = false
	caddymain.Run()
}
