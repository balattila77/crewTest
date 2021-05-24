FROM php:7.4-fpm
RUN cd /usr/local/etc/php/conf.d/ && \
  echo 'memory_limit = -1' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini


RUN apt-get update -y && apt-get upgrade -y && apt-get install -y zip unzip
RUN docker-php-ext-install pdo pdo_mysql
RUN curl -sS https://getcomposer.org/installer | php -- \ 
       --install-dir=/usr/local/bin --filename=composer

WORKDIR /app
Copy . .

RUN composer update

CMD php artisan serve --host=0.0.0.0