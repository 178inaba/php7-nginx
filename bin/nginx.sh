#!/bin/bash

sed -i -e "s|{{NGINX_ROOT}}|${NGINX_ROOT:=/var/www}|" /etc/nginx/conf.d/default.conf

# run nginx
nginx -g "daemon off;"
