# php7-nginx

php7-nginx is php-fpm and nginx of docker

## spec

| os | language | web server | fast cgi |
|:--:|:--:|:--:|:--:|
| centos | php7 | nginx | php-fpm |

## docker command

### build

```bash
$ docker build --force-rm --no-cache -t img/php7-nginx .
```

### run

```bash
$ docker run -d --name name-php7-nginx img/php7-nginx
```

## licence

MIT
