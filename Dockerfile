FROM centos:7

# update yum
RUN yum -y update

# set nginx key
ENV NGINX_KEY nginx_signing.key
RUN curl -fSL http://nginx.org/keys/$NGINX_KEY -o $NGINX_KEY && \
	rpm --import $NGINX_KEY && \
	rm $NGINX_KEY

# add nginx repo
COPY nginx.repo /etc/yum.repos.d/

# install nginx
RUN yum -y install nginx

# port open
EXPOSE 80 443

# nginx log to stdout and stderr
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
	ln -sf /dev/stderr /var/log/nginx/error.log

# php7

CMD ["nginx", "-g", "daemon off;"]
