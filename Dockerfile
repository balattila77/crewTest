FROM php:7.4-fpm
RUN cd /usr/local/etc/php/conf.d/ && \
  echo 'memory_limit = -1' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini

RUN apt-get update -y && apt-get upgrade -y
RUN apt update

RUN apt-get update -y && apt-get upgrade -y && apt-get install -y gnupg2
RUN apt-get install software-properties-common -y
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 40976EAF437D05B5
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32

RUN add-apt-repository "deb http://archive.ubuntu.com/ubuntu bionic main multiverse restricted universe"
RUN add-apt-repository "deb http://archive.ubuntu.com/ubuntu bionic-security main multiverse restricted universe"
RUN add-apt-repository "deb http://archive.ubuntu.com/ubuntu bionic-updates main multiverse restricted universe"

RUN apt-get update -y && apt-get install -y libonig-dev libzip-dev zip unzip curl  libcurl4-openssl-dev

RUN docker-php-ext-install pdo pdo_mysql mbstring zip curl
RUN curl -sS https://getcomposer.org/installer | php -- \ 
       --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www
Copy . .
RUN mkdir -v -m 777 storage
RUN mkdir -v -m 777 storage/app
RUN mkdir -v -m 777 storage/app/public
RUN mkdir -v -m 777 storage/framework
RUN mkdir -v -m 777 storage/framework/cache
RUN mkdir -v -m 777 storage/framework/session
RUN mkdir -v -m 777 storage/framework/views
RUN mkdir -v -m 777 storage/logs

RUN composer self-update --2
#RUN composer update

RUN composer install

RUN chmod -R a+w storage/
RUN chmod -R a+w bootstrap/cache/
CMD php artisan key:generate
CMD php artisan serve --host=0.0.0.0