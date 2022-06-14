
container_name="openresty"
WORK_DIR="$(pwd)"

docker run -p 80:80 -p 443:443  -v $WORK_DIR/web:/data/web \
 -v $WORK_DIR/nginx/conf/ssl:/usr/local/openresty/nginx/conf/ssl \
 -v $WORK_DIR/nginx/conf/conf.d:/usr/local/openresty/nginx/conf/conf.d \
  -v $WORK_DIR/acme_cert:/acme_cert \
  -v $WORK_DIR/docker-entrypoint.sh:/docker-entrypoint.sh \
  -e DOMAINS="litizhili.com www.litizhili.com test.litizhili.com jenkins.litizhili.com" \
  -e SslServer="https://acme-staging-v02.api.letsencrypt.org/directory" \
  -e mail="xiaojun@126.com" \
 --name $container_name xiaojun207/openresty:latest
