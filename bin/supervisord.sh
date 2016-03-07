#!/bin/bash

usermod -u ${NGINX_UID:-$(id -u nginx)} -o nginx
groupmod -g ${NGINX_GID:-$(id -g nginx)} -o nginx

exec supervisord -n -c /etc/supervisord.conf
