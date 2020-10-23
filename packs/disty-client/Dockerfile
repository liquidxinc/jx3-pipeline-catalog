FROM nginx:alpine

RUN apk add --update nodejs npm gettext libintl

# This is needed to get the packages and appConfig builder
COPY appConfigCreator .
COPY .npmrc ./
RUN apk add --update nodejs-npm && npm ci
COPY src src

COPY dist/REPLACE_ME_APP_NAME /usr/share/nginx/html
COPY src/assets /usr/share/nginx/html/assets
COPY scripts scripts

# Copy lqx-react library
COPY lqx-react lqx-react
COPY docs/storybook-static /usr/share/nginx/html/storybook

# Avoids a Docker bug with consecutive COPY commands in Azure Container Registry.
RUN true
COPY nginx/nginx.conf.template /etc/nginx/nginx.conf.template

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    && mkdir /run/nginx

EXPOSE 80
WORKDIR /

CMD ["/bin/sh", "/scripts/runwithenvironment.sh", "/usr/share/nginx/html/assets/data", "nginx"]
