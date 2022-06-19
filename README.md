
# Openresty 💖 with Auto SSL
[![Docker Image Version (latest semver)](https://img.shields.io/docker/v/xiaojun207/openresty?sort=semver)](https://hub.docker.com/r/xiaojun207/openresty)
[![Docker Image Size (latest semver)](https://img.shields.io/docker/image-size/xiaojun207/openresty?sort=semver)](https://hub.docker.com/r/xiaojun207/openresty)
[![Docker Image Size (latest semver)](https://img.shields.io/docker/pulls/xiaojun207/openresty)](https://hub.docker.com/r/xiaojun207/openresty)

arch: linux/amd64, linux/arm64

# 描述(Desc)
这是一个可以自动申请（并自动更新）免费ssl证书的Openresty镜像。证书申请和更新使用的是开源工具acme.sh。
你可以设置证书服务商：zerossl, letsencrypt，buypass，ssl等等，或是地址，如Letsencrypt测试地址：https://acme-staging-v02.api.letsencrypt.org/directory

This is a Openresty image with auto ssl，use acme.sh， you can set default-ca,like: zerossl, letsencrypt，buypass，ssl ...

当然，你也可以把它当普通的openresty镜像使用。当入参DOMAINS为空（-e DOMAINS="" 或 不填），不会启动证书acme（证书获取程序）。

# Openresty镜像github地址
https://github.com/xiaojun207/docker-openresty

# Nginx镜像github地址
https://github.com/xiaojun207/docker-nginx

# 快速启动(Quick Start)

```shell
  docker pull  xiaojun207/openresty:latest
```

使用例子，如下(eg.)：
```shell

 docker run -d -p 80:80 -p 443:443 -v "/data/web":/data/web \
      -v /data/openresty/nginx/conf/ssl:/usr/local/openresty/nginx/conf/ssl \
      -v /data/openresty/nginx/conf/conf.d:/usr/local/openresty/nginx/conf/conf.d \
      -v "/data/openresty/acme_cert":/acme_cert/ \
      -e SslDomains="example.com;www.example.com;test.example.com;test2.example.com" \
      -e SslServer="zerossl" \
      -e mail="my@example.com" \
      --name myopenresty xiaojun207/openresty:latest
```
注意：
* 1、建议把路径/usr/local/openresty/nginx/conf/ssl、/acme_cert/中的内容都持久化到宿主机保存，避免容器删除后，启动后会自动再次获取（频繁申请证书会被服务商限制）。
* 2、不要改变nginx.conf的路径，否则证书生成会失败。
* 3、测试部署时，建议使用letsencrypt的测试地址（即参数，-e SslServer="https://acme-staging-v02.api.letsencrypt.org/directory"）。

# 使用说明
默认情况下, 使用的是服务器验证，所以请确保，被申请ssl的域名可以访问到openresty容器。

# 参数说明

| 参数         | 是否必填 | 说明                                                                                                                                                                                                                                                                                                                                   |
|------------|------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| SslDomains | 必填   | 需要获取参数ssl的域名列表。多个域名间以英文分号分隔(即：;)。如果为空或不填，这就是个普通的openresty镜像，哈哈。                                                                                                                                                                                                                                                                  |
| mail       | 否    | 你的邮箱，用于获取ssl时配置，有的证书服务商有网页管理端，可以根据邮箱查看相关的证书。如果为空可能会导致注册到证书服务商失败，因此如果参数为空会使用默认邮箱。                                                                                                                                                                                                                                                     |
| SslServer  | 否    | 证书服务商（名字或地址），默认：zerossl，你还可以使用：letsencrypt，buypass，ssl等等，<br>或者letsencrypt的测试地址：https://acme-staging-v02.api.letsencrypt.org/directory                                                                                                                                                                                               |
| dns        | 否 | 域名是否采用dns验证，可选参数为：空格，dns_ali，dns_aws，dns_cf，dns_dp，，。。。<br> 更多参数请查看：https://github.com/acmesh-official/acme.sh/wiki/dnsapi <br>例如1： -e dns=" ", 空格时，请查看控制台日志中的dns记录，并手动为域名添加解析；<br>例如2： -e dns="dns_ali" -e Ali_Key="sdfsdfsdfljlbjkljlkjsdfoiwje" -e Ali_Secret="jlsdflanljkljlfdsaklkjflsa" 使用云厂商api，请添加对应的key、secret等"添加域名解析"授权参数 |

# 证书路径和openresty配置方法
容器启动，会创建一个默认证书，避免openresty启动失败。 证书获取成功后，将会被安装到固定路径：/usr/local/openresty/nginx/conf/ssl，

openresty配置方法如下：
```shell
    server {
        # 80端口必须可以正常访问，用来验证你的域名
        listen      80;
        server_name example.com;
        # ...
    }
    
    server {
        listen      443 ssl;
        server_name example.com;
        root /data/web/www;
    
        ssl_stapling off;
        ssl_certificate ssl/fullchain.pem; # ssl证书自动安装的路径：/usr/local/openresty/nginx/conf/ssl/
        ssl_certificate_key ssl/key.pem; # ssl证书自动安装的路径：/usr/local/openresty/nginx/conf/ssl/
    
        # ...
    }

```

# 证书更新
证书会定期检查是否快要过期，如果快要过期，会自动更新并安装证书，你可以高枕无忧了（理论上的，我的证书还没到期，哈哈）。

# 非常感谢，参考连接

https://github.com/xiaojun207/docker-nginx

https://github.com/neilpang/acme.sh.git

https://github.com/akeylimepie/docker-nginx-letsencrypt

https://blog.csdn.net/dancen/article/details/121044863


