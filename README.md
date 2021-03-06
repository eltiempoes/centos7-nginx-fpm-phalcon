# Docker CentOS 7.1 image with NGINX, PHP-FPM, and Phalcon Framework

This Docker image is intended to be used as a general NGINX web server with PHP-FPM supporting Phalcon Framework.

## How to use it to serve static files

The default server is configured to serve static files from `/usr/share/nginx/html` so the easiest way of using the image is, for example:

`docker run -d -v /home/user/samples/html:/usr/share/nginx/html -p 8080:80 eltiempoes/centos7-nginx-fpm-phalcon`

## How to use it to serve php files

Instead of using the default nginx configuration you can pass your own configuration. The image nginx configuration is prepared to load all configuration files from `/etc/nginx/conf.d`.

So, imagine you have a config file called `local.conf` into `/home/user/samples` and the php application you want to use is installed in `/home/user/webapp`:

```
server {
    listen       80;
    server_name  local.localdomain;

    charset utf-8;


    location / {
        root   /webapp/public;
        index  index.php index.html index.htm;
        try_files $uri $uri/ /index.php?$query_string;
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    #
    location ~ \.php$ {
        fastcgi_split_path_info ^(.+?\.php)(/.*)$;
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  /webapp/public$fastcgi_script_name;
        include        fastcgi_params;
    }

}
```
the way to start the PHP application is:

```
docker run -d -v /home/user/samples/webapp:/webapp -v /home/user/samples/local.conf:/etc/nginx/conf.d/local.conf -p 8080:80 eltiempoes/centos7-nginx-fpm-phalcon
```
## Debugging PHP
The image has the xdebug extension enabled. In order to inject your own configuration, for example to set your host IP addres to remote debugging, you have to set a new volume with the route of your local xdebug file pointing to `/etc/php.d/xdebug.ini`:

```
[xdebug]
zend_extension = xdebug.so
xdebug.remote_enable = 1
xdebug.remote_autostart = 1
xdebug.remote_connect_back = 0
xdebug.remote_handler = dbgp
xdebug.remote_port = 9000
xdebug.remote_host = 192.168.1.0
xdebug.profiler_enable = 0
xdebug.profiler_enable_trigger = 1
xdebug.profiler_enable_trigger_value = "yes"
xdebug.profiler_output_dir = /xdebug/profiling
xdebug.profiler_output_name = xdebug.profile.%s.%t
xdebug.max_nesting_level = 200
xdebug.trace_enable_trigger = 1
xdebug.trace_enable_trigger_value = "yes"
xdebug.trace_output_dir = /xdebug/tracing
xdebug.trace_output_name = xdebug.trace.%s.%t
xdebug.remote_log = /xdebug/log/xdebug_remote.log
```
So that, you have to start the container providing the new volume:

```
docker run -d -v /home/user/samples/xdebug.ini:/etc/php.d/xdebug.ini -v /home/user/samples/webapp:/webapp -v /home/user/samples/local.conf:/etc/nginx/conf.d/local.conf -p 8080:80 eltiempoes/centos7-nginx-fpm
```
