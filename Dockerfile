FROM centos:7

# add nginx repo
COPY nginx.repo /etc/yum.repos.d/

# set nginx key
ENV NGINX_KEY nginx_signing.key
RUN curl -fSL http://nginx.org/keys/$NGINX_KEY -o $NGINX_KEY && \
	rpm --import $NGINX_KEY && \
	rm $NGINX_KEY

# add epel and remi
RUN yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
	yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
	yum-config-manager --enable remi-php70

# install nginx and php
RUN yum -y update && \
	yum -y install nginx php php-fpm

# nginx log to docker logs
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
	ln -sf /dev/stderr /var/log/nginx/error.log

# port open
EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
