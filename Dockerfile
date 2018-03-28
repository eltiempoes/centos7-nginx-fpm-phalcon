FROM eltiempoes/centos7-nginx-fpm:latest
ENV REFRESHED_AT 2018-03-28
LABEL maintainer "it@eltiempo.es"
LABEL version "1.0"
LABEL description "Image with NGINX, PHP-FPM and Phalcon Framework"
ENV container docker

RUN yum -y --setopt=tsflags=nodocs install gcc libtool pcre-devel git php71w-devel re2c file make

RUN git clone --depth=1 "git://github.com/phalcon/cphalcon.git" && \
    cd cphalcon/build && \
    ./install

COPY phalcon.ini /etc/php.d

COPY startup.sh /usr/local/bin/startup.sh
RUN chmod -v +x /usr/local/bin/startup.sh

EXPOSE 80 443 8080

CMD ["/usr/local/bin/startup.sh"]