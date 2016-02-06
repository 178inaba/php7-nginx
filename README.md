# php7-nginx

php7-nginx is php-fpm and nginx of docker

## spec

| os | language | web server | fast cgi |
|:--:|:--:|:--:|:--:|
| centos7 | php7 | nginx(mainline) | php-fpm |

## docker command

### build

```bash
$ docker build --force-rm --no-cache -t img/php7-nginx .
```

### run

```bash
$ docker run -d -p 80:80 -v $(pwd)/php:/var/www --name name-php7-nginx img/php7-nginx
```

please be run by changing `$(pwd)/php` to your PHP web app directory.

## licence

MIT
