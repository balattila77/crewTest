FROM php:8.0-fpm
RUN cd /usr/local/etc/php/conf.d/ && \
  echo 'memory_limit = -1' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini

RUN apt-get update -y && apt-get install -y libonig-dev libzip-dev zip unzip

RUN docker-php-ext-install pdo pdo_mysql mbstring zip
RUN curl -sS https://getcomposer.org/installer | php -- \ 
       --install-dir=/usr/local/bin --filename=composer

WORKDIR /app
Copy . .
RUN mkdir storage
RUN mkdir storage/app
RUN mkdir storage/app/public
RUN mkdir storage/framework
RUN mkdir storage/framework/cache
RUN mkdir storage/framework/session
RUN mkdir storage/framework/views
RUN mkdir storage/logs

RUN chmod -R 777 storage/

RUN composer self-update 
#RUN composer update
RUN composer install


RUN chmod -R a+w bootstrap/cache/
CMD php artisan key:generate
CMD php artisan serve --host=0.0.0.0