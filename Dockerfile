FROM centos:7
MAINTAINER 178inaba <178inaba@users.noreply.github.com>

# add nginx repo
COPY nginx.repo /etc/yum.repos.d/

# set nginx key
ENV NGINX_KEY nginx_signing.key
RUN curl -fSL http://nginx.org/keys/$NGINX_KEY -o $NGINX_KEY && \
    rpm --import $NGINX_KEY && \
    rm $NGINX_KEY

# add epel and remi
RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
    yum-config-manager --enable remi-php70

# install nginx, php, supervisor
RUN yum -y update && \
    yum -y install nginx php php-fpm supervisor && \
    yum clean all

# add conf of supervisor
COPY supervisord.d/ /etc/supervisord.d/

# remove default conf of nginx
RUN rm /etc/nginx/conf.d/default.conf

# copy conf of nginx
COPY php-nginx.conf /etc/nginx/conf.d/

# use unix socket of fpm
RUN sed -i -e "s/apache$/nginx/" \
           -e "s|listen = 127.0.0.1:9000|listen = /var/run/php-fpm/php-fpm.sock|" \
           -e "s/;listen.owner = nobody/listen.owner = nginx/" \
           -e "s/;listen.group = nobody/listen.group = nginx/" \
           -e "s/listen.allowed_clients/;listen.allowed_clients/" \
           /etc/php-fpm.d/www.conf

# port open
EXPOSE 80

CMD ["supervisord", "-c", "/etc/supervisord.conf"]
