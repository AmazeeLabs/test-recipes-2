FROM amazeeio/php:7.4-cli-drupal as builder

RUN apk add --no-cache git imagemagick && \
  docker-php-ext-install intl && \
  docker-php-ext-enable intl && \
  composer selfupdate --2 && \
  composer config --global github-protocols https && \
  composer global remove hirak/prestissimo

# Initiate the whole monorepo for the case if Drupal will need something from
# other yarn workspaces (e.g. CSS files for the editor).
COPY package.json yarn.lock /app/

COPY apps/cms/package.json /app/apps/cms/package.json
# You might need to copy package.json files from all workspaces.

# Yarn's postinstall scripts can be tricky, so we use --ignore-scripts flag. For
# the case if something required is missing, it can be built with `npm rebuild`
# after `yarn install`.
# Example:
# RUN yarn install --pure-lockfile --ignore-scripts --ignore-engines
# RUN npm rebuild node-sass
# RUN yarn lerna run prepare
RUN yarn install --pure-lockfile --ignore-scripts --ignore-engines
COPY . /app

WORKDIR /app/apps/cms
RUN composer install --prefer-dist --no-interaction

ENV WEBROOT=/app/apps/cms/web
