ARG CLI_IMAGE
FROM ${CLI_IMAGE} as cli

FROM amazeeio/php:7.4-fpm
RUN apk add --no-cache git imagemagick && \
  docker-php-ext-install intl && \
  docker-php-ext-enable intl

COPY --from=cli /app/apps/cms /app/apps/cms
WORKDIR /app/apps/cms
ENV WEBROOT=apps/cms/web
