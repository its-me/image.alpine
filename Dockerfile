ARG VARIANT=latest
FROM alpine:${VARIANT}

ARG VARIANT
ARG VERSION
LABEL org.opencontainers.image.version=$VERSION
LABEL org.opencontainers.image.source=https://github.com/its-me/image.alpine
LABEL org.opencontainers.image.title="alpine"
LABEL org.opencontainers.image.description="Minimal alpine:${VARIANT} image with ca-certificates installed"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.authors="Sergey Kanafyev <sergeykanafyev@gmail.com>"

RUN apk update && apk upgrade && apk add --no-cache ca-certificates
