FROM centos:7
MAINTAINER 178inaba <178inaba@users.noreply.github.com>

# add nginx repo
RUN echo -e '[nginx]\n\
name=nginx repo\n\
baseurl=http://nginx.org/packages/mainline/centos/7/$basearch/\n\
gpgcheck=1\n\
gpgkey=http://nginx.org/keys/nginx_signing.key\n\
enabled=1' > /etc/yum.repos.d/nginx.repo

# add epel and remi
RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
    yum-config-manager --enable remi-php70

# install php, nginx, supervisor
RUN yum -y update && \
    yum -y install php php-mbstring php-pdo php-fpm nginx supervisor && \
    yum clean all

# add conf of supervisor
COPY etc/supervisor/ /etc/supervisord.d/

# copy conf of nginx
COPY etc/nginx/php.conf /etc/nginx/conf.d/default.conf

# copy bin and give permission to execute *.sh
COPY bin/ /usr/local/bin
RUN chmod u+x /usr/local/bin/*.sh

# use unix socket of fpm
RUN sed -i -e "s/apache$/nginx/" \
           -e "s|listen = 127.0.0.1:9000|listen = /var/run/php-fpm/php-fpm.sock|" \
           -e "s/;listen.owner = nobody/listen.owner = nginx/" \
           -e "s/;listen.group = nobody/listen.group = nginx/" \
           -e "s/listen.allowed_clients/;listen.allowed_clients/" \
           /etc/php-fpm.d/www.conf

# port open
EXPOSE 80

CMD ["supervisord.sh"]
