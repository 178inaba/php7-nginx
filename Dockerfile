FROM centos:7

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
	yum -y install nginx php php-fpm supervisor

COPY supervisord.d/ /etc/supervisord.d/

# port open
EXPOSE 80 443

CMD ["supervisord"]
