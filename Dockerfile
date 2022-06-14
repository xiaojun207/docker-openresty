ARG OPENRESTY_VERSION
FROM openresty/openresty:${OPENRESTY_VERSION}-alpine

LABEL maintainer="xiaojun207 <xiaojun207@126.com>"

RUN set -ex \
    && apk upgrade --update-cache --available \
    && apk add bash openssl curl \
    && rm -rf /var/cache/apk/* \
    && mkdir -p /usr/local/openresty/nginx/conf/ssl

COPY ./nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
COPY ./default.conf /usr/local/openresty/nginx/conf/conf.d/default.conf

COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY acme.sh /acme.sh
RUN chmod +x /docker-entrypoint.sh
RUN chmod +x /acme.sh && /acme.sh --install

WORKDIR /var/www

EXPOSE 80
EXPOSE 443

ENTRYPOINT ["/docker-entrypoint.sh"]
