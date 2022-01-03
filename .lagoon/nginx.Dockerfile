ARG CLI_IMAGE
FROM ${CLI_IMAGE} as cli

FROM amazeeio/nginx-drupal

COPY --from=cli /app/apps/cms /app/apps/cms
ENV WEBROOT=apps/cms/web
