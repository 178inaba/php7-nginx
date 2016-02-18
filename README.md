# php7-nginx

php7-nginx is php-fpm and nginx of docker

## spec

| os | language | web server | fast cgi |
|:--:|:--:|:--:|:--:|
| centos7 | php7 | nginx(mainline) | php-fpm |

## environment variable

- `NGINX_ROOT`
    - set the location where there is index.php.
    - default:`/var/www`

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

## how to use in framework

### [lumen](https://lumen.laravel.com/)

``` bash
$ docker run -d -p 8080:80 -v /path/to/lumen_app:/var/www -e NGINX_ROOT=/var/www/public --name lumen_app img/php7-nginx
```

### [laravel](https://laravel.com/)

``` bash
$ docker run -d -p 8080:80 -v /path/to/laravel_app:/var/www -e NGINX_ROOT=/var/www/public -e NGINX_UID=$(id -u) -e NGINX_GID=$(id -g) --name laravel_app img/php7-nginx
```

## licence

MIT
