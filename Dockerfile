FROM alpine:3

LABEL org.opencontainers.image.source="https://github.com/ScottBrenner/generate-changelog-action"

RUN apk --no-cache add git npm
RUN npm install -g generate-changelog

COPY LICENSE README.md /

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
