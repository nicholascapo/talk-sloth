.PHONY: all lint clean
all: slides.html slides.pdf slo/prometheus.yaml

lint: slides.md
	docker run --rm --entrypoint=/bin/sh --workdir=/src --volume="${CURDIR}:/src/" davidanson/markdownlint-cli2:v0.18.1 -c 'markdownlint-cli2 --fix slides.md'

slides.html: lint slides.md images
	docker run --rm --entrypoint=/bin/bash --workdir=/src --volume="${CURDIR}:/src/" marpteam/marp-cli:v4.2.1 -c 'marp-cli.js --allow-local-files slides.md'

slides.pdf: lint slides.md images
	docker run --rm --entrypoint=/bin/bash --workdir=/src --volume="${CURDIR}:/src/" marpteam/marp-cli:v4.2.1 -c 'marp-cli.js --allow-local-files --pdf slides.md'

images: images/qr-slides.png images/qr-sloth.png images/qr-sloth-github.png images/sloth-logo.svg

images/qr-slides.png:
	qrencode --output=images/qr-slides.png https://github.com/nicholascapo/talk-sloth

images/qr-sloth.png:
	qrencode --output=images/qr-sloth.png https://sloth.dev/

images/qr-sloth-github.png:
	qrencode --output=images/qr-sloth-github.png https://github.com/slok/sloth

images/sloth-logo.svg:
	curl -o images/sloth-logo.svg https://sloth.dev/static/media/sloth-logo-white.svg

slo/prometheus.yaml: slo/slo.yaml
	go run github.com/slok/sloth/cmd/sloth@v0.12.0 generate --input=slo/slo.yaml --out=slo/prometheus.yaml

clean:
	rm -f slides.html slides.pdf
	rm -f images/qr-slides.png images/qr-sloth.png images/qr-sloth-github.png images/sloth-logo.svg
	rm -f slo/prometheus.yaml
