ARG OPENRESTY_VERSION=1.27.1.1
FROM openresty/openresty:${OPENRESTY_VERSION}-alpine

LABEL maintainer="xiaojun207 <xiaojun207@126.com>"

RUN set -ex \
    && apk upgrade --update-cache --available \
    && apk add bash openssl curl git\
    && git clone https://github.com/acmesh-official/acme.sh.git acme_src \
    && cd /acme_src && ./acme.sh --install --cert-home /acme_cert \
    && apk del git \
    && rm -rf /acme_src /var/cache/apk/* \
    && mkdir -p /usr/local/openresty/nginx/conf/ssl \
    && alias acme.sh=~/.acme.sh/acme.sh

COPY ./nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
COPY ./default.conf /usr/local/openresty/nginx/conf/conf.d/default.conf

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

WORKDIR /var/www

EXPOSE 80
EXPOSE 443

ENTRYPOINT ["/docker-entrypoint.sh"]
