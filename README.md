# php7-nginx

php7-nginx is php-fpm and nginx of Docker.

## Spec

| os | language | web server | fast cgi |
|:--:|:--:|:--:|:--:|
| centos7 | php7 | nginx(mainline) | php-fpm |

## Environment Variables

- `NGINX_ROOT`
    - set the location where there is index.php.
    - default:`/var/www`
- `NGINX_UID`/`NGINX_GID`
    - id to be set to the container inside of nginx user/group (for permission).
    - default:`$ docker exec 178inaba-php7-nginx id -u/g nginx`

## Docker Commands

### Build

```console
$ docker build --force-rm --no-cache -t 178inaba/php7-nginx .
```

### Run

```console
$ docker run -d -p 8080:80 -v $(pwd)/php:/var/www --name 178inaba-php7-nginx 178inaba/php7-nginx
```

please be run by changing `$(pwd)/php` to your php web app directory.

after access to `localhost:8080`(linux) or `$(docker-machine ip default):8080`(os x).

## How To Use In Framework

### [CodeIgniter](https://codeigniter.com/)

```console
$ docker run -d -p 8080:80 -v /path/to/ci_app:/var/www --name ci_app 178inaba/php7-nginx
```

### [Lumen](https://lumen.laravel.com/)

```console
$ docker run -d -p 8080:80 -v /path/to/lumen_app:/var/www -e NGINX_ROOT=/var/www/public --name lumen_app 178inaba/php7-nginx
```

### [Laravel](https://laravel.com/)

laravel need write permission.

```console
$ docker run -d -p 8080:80 -v /path/to/laravel_app:/var/www -e NGINX_ROOT=/var/www/public -e NGINX_UID=$(id -u) -e NGINX_GID=$(id -g) --name laravel_app 178inaba/php7-nginx
```

please use by replacing the `id -u/g` to `docker-machine ssh default id -u/g` if you are using a docker-machine.

### [CakePHP](http://cakephp.org/)

```console
# run db container
$ docker run -d -p 3366:3306 -e MYSQL_ALLOW_EMPTY_PASSWORD=yes --name maria mariadb:10

# create db user and db
# dockerhost is localhost or $(docker-machine ip default)
$ mysql -h dockerhost -P 3366 -u root -e "CREATE USER my_app IDENTIFIED BY 'secret'"
$ mysql -h dockerhost -P 3366 -u root -e "GRANT ALL ON *.* TO my_app"
$ mysql -h dockerhost -P 3366 -u my_app -p -e "CREATE DATABASE my_app"
$ mysql -h dockerhost -P 3366 -u my_app -p -e "CREATE DATABASE test_myapp"

# change the db host configuration of cakephp from localhost to maria
$ cd /path/to/cakephp_app
$ sed -i -e "$(grep -n "'Datasources' => \[" config/app.php | sed -e "s/\(.*\):.*/\1/"),$(grep -n "'Log' => \[" config/app.php | sed -e "s/\(.*\):.*/\1/")s/localhost/maria/" config/app.php

# run container
$ cd /path/to/php7-nginx
$ docker run -d -p 8080:80 -v /path/to/cakephp_app:/var/www -e NGINX_ROOT=/var/www/webroot -e NGINX_UID=$(id -u) -e NGINX_GID=$(id -g) --link maria --name cakephp_app 178inaba/php7-nginx
```

## License

[MIT](LICENSE)

## Author

[178inaba](https://github.com/178inaba)
