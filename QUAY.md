# Alpine Container Images

Alpine container images built on the official images, published daily, across two variants: `latest` (the newest stable release) and `edge` (rolling).

## Images

Each variant produces the same three-tier image stack:

### Base

Minimal `alpine:<variant>` image, upgraded (`apk upgrade`) and with `ca-certificates` installed. Intended as a foundation for other images.

```
docker pull quay.io/itsme/alpine:latest       # latest
docker pull quay.io/itsme/alpine:edge
```

### Python

Extends the base image with `python3` and `py3-pip`. Built for the same platforms as the base image for that variant.

```
docker pull quay.io/itsme/alpine:python       # latest
docker pull quay.io/itsme/alpine:edge-python
```

### uv

Extends the Python image with [uv](https://github.com/astral-sh/uv), installed from the official prebuilt musl release binary — unlike glibc-based distros, uv publishes musl binaries for every platform this image builds, so no source compilation is needed anywhere.

```
docker pull quay.io/itsme/alpine:uv           # latest
docker pull quay.io/itsme/alpine:edge-uv
```

## Platforms

Each variant builds whatever platforms Docker Hub currently publishes for `alpine:<variant>`, resolved from the upstream manifest at build time rather than hardcoded. The uv image additionally always excludes `linux/ppc64le` (uv publishes no build for it at all) and `linux/s390x` (uv only publishes a glibc build, unusable on musl-based Alpine).

## Tags

| Tag pattern | Description |
|-------------|-------------|
| `latest` | `latest` base image |
| `python` | `latest` Python image |
| `uv` | `latest` uv image |
| `uv-<uv version>` | `latest` uv image, stamped with the bundled uv release (e.g. `uv-0.11.32`) |
| `edge` | `edge` base image |
| `edge-python` | `edge` Python image |
| `edge-uv` | `edge` uv image |
| `edge-uv-<uv version>` | `edge` uv image, stamped with the bundled uv release |

Source: https://github.com/its-me/image.alpine
