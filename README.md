# Alpine Container Images

Alpine container images built on the official images, published daily, across two variants: `latest` (the newest stable release) and `edge` (rolling).

## Workflow

- Each variant has its own workflow (`.github/workflows/{stable,edge}.yaml`), both built from the same three Dockerfiles — the variant/base image tag is passed in as a build-arg (`VARIANT`, `BASE_TAG`, `PYTHON_TAG`) rather than hardcoded
- The daily schedule checks whether Alpine has published a new version before rebuilding — a run only republishes if the resolved version differs from what's already in GHCR. Push and manual dispatch always rebuild, since those are explicit requests a version check wouldn't catch (e.g. after editing a Dockerfile)
- The build matrix for each variant is resolved from `alpine:<variant>`'s upstream manifest at run time rather than hardcoded — see [Platforms](#platforms)
- Each image carries an `org.opencontainers.image.version` label set to the underlying Alpine version (e.g. `3.24.1`, visible via `docker inspect`)
- Version-based tags use the Alpine version itself for `latest` (e.g. `3.24.1`) and the upstream snapshot date for `edge` (e.g. `20260805`, extracted from the `_alphaYYYYMMDD` suffix in Alpine's `VERSION_ID`), matching the convention used by the official `alpine` image

## Images

Each variant produces the same three-tier image stack:

### Base

Minimal `alpine:<variant>` image, upgraded (`apk upgrade`) and with `ca-certificates` installed. Intended as a foundation for other images.

```
docker pull ghcr.io/its-me/alpine:latest       # latest
docker pull ghcr.io/its-me/alpine:edge
```

### Python

**Dockerfile:** `Dockerfile.python`
**Base:** the base image for the same variant

Extends the base image with `python3` and `py3-pip`. Built for the same platforms as the base image for that variant.

```
docker pull ghcr.io/its-me/alpine:python       # latest
docker pull ghcr.io/its-me/alpine:edge-python
```

### uv

**Dockerfile:** `Dockerfile.uv`
**Base:** the Python image for the same variant

Extends the Python image with [uv](https://github.com/astral-sh/uv), installed from the official prebuilt musl release binary — unlike glibc-based distros, uv publishes musl binaries for every platform this image builds, so no source compilation is needed anywhere.

```
docker pull ghcr.io/its-me/alpine:uv           # latest
docker pull ghcr.io/its-me/alpine:edge-uv
```

## Platforms

Each variant builds whatever platforms Docker Hub currently publishes for `alpine:<variant>`, resolved from the upstream manifest at build time rather than hardcoded. The uv image additionally always excludes `linux/ppc64le` (uv publishes no build for it at all) and `linux/s390x` (uv only publishes a glibc build, unusable on musl-based Alpine).

## Tags

| Tag pattern | Description |
|-------------|-------------|
| `latest` | `latest` base image |
| `<alpine version>` | `latest` base image, stamped with the underlying Alpine version (e.g. `3.24.1`) |
| `python` | `latest` Python image |
| `<alpine version>-python` | `latest` Python image, stamped with the underlying Alpine version |
| `uv` | `latest` uv image |
| `uv-<uv version>` | `latest` uv image, stamped with the bundled uv release (e.g. `uv-0.11.32`) |
| `edge` | `edge` base image |
| `<snapshot date>` | `edge` base image, stamped with the upstream snapshot date embedded in Alpine's edge version (e.g. `20260805`), same as the official `alpine` image |
| `edge-python` | `edge` Python image |
| `<snapshot date>-edge-python` | `edge` Python image, stamped with the upstream snapshot date |
| `edge-uv` | `edge` uv image |
| `edge-uv-<uv version>` | `edge` uv image, stamped with the bundled uv release |

## Registries

| Registry | Image |
|----------|-------|
| GitHub Container Registry | `ghcr.io/its-me/alpine` |
| Docker Hub | `1tsme/alpine` |
| Quay.io | `quay.io/itsme/alpine` |

## License

[MIT](LICENSE)
