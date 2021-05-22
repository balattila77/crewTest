FROM php:8.0-fpm
RUN cd /usr/local/etc/php/conf.d/ && \
  echo 'memory_limit = -1' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini

RUN apt-get update -y && apt-get install -y libonig-dev libzip-dev zip unzip

RUN docker-php-ext-install pdo pdo_mysql mbstring zip
RUN curl -sS https://getcomposer.org/installer | php -- \ 
       --install-dir=/usr/local/bin --filename=composer --version=1.10.22

WORKDIR /app
Copy . .
CMD mkdir storage/app/public
CMD mkdir storage/framework/cache
CMD mkdir storage/logs
CMD mkdir storage/framework/session
CMD mkdir storage/framework/views
CMD chmod -R 777 storage/

RUN composer self-update 1.10.22
#RUN composer update
RUN composer install


CMD chmod -R a+w bootstrap/cache/
CMD php artisan key:generate
CMD php artisan serve --host=0.0.0.0