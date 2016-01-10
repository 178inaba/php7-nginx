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

# nginx log to docker logs
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
	ln -sf /dev/stderr /var/log/nginx/error.log

# php dir
ENV PHP_INI_DIR /usr/local/etc/php
RUN mkdir -p $PHP_INI_DIR/conf.d

RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 1A4E8B7277C42E53DBA9C7B9BCAA30EA9C0D5763

ENV PHP_DIR /usr/src/php
ENV PHP_FILENAME php-7.0.2.tar.xz
ENV PHP_SHA256 556121271a34c442b48e3d7fa3d3bbb4413d91897abbb92aaeced4a7df5f2ab2

# install php7
RUN curl -fSL http://php.net/get/$PHP_FILENAME/from/this/mirror -o $PHP_FILENAME && \
	echo "$PHP_SHA256 *$PHP_FILENAME" | sha256sum -c - && \
	curl -fSL http://php.net/get/$PHP_FILENAME.asc/from/this/mirror -o $PHP_FILENAME.asc && \
	gpg --verify $PHP_FILENAME.asc && \
	mkdir -p $PHP_DIR && \
	tar -xf $PHP_FILENAME -C $PHP_DIR --strip-components=1 && \
	rm $PHP_FILENAME* && \
	cd $PHP_DIR && \
	./configure \
		--with-config-file-path=$PHP_INI_DIR \
		--with-config-file-scan-dir=$PHP_INI_DIR/conf.d \
		--enable-fpm \
		--disable-cgi \
		--enable-mysqlnd \
		--with-curl \
		--with-openssl \
		--with-readline \
		--with-zlib && \
	make && \
	make install && \
	make clean

CMD ["nginx", "-g", "daemon off;"]
