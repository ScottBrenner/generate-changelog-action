FROM alpine:3

RUN apk --no-cache add nodejs nodejs-npm
RUN npm install -g generate-changelog

COPY LICENSE README.md /

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
