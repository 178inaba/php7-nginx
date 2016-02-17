#!/bin/bash

usermod -u ${NGINX_UID:-$(id -u nginx)} nginx
groupmod -g ${NGINX_GID:-$(id -g nginx)} nginx

exec supervisord -c /etc/supervisord.conf
