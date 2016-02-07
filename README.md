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
$ docker run -d -p 8080:80 -v $(pwd)/php:/var/www --name name-php7-nginx img/php7-nginx
```

please be run by changing `$(pwd)/php` to your php web app directory.

after access to `localhost:8080`(linux) or `$(docker-machine ip default):8080`(os x).

## licence

MIT
