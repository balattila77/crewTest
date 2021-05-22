FROM php:8.0-fpm

RUN apt-get update -y && apt-get install -y libonig-dev libzip-dev zip unzip

RUN docker-php-ext-install pdo pdo_mysql mbstring zip
RUN curl -sS https://getcomposer.org/installer | php -- \ 
       --install-dir=/usr/local/bin --filename=composer --1

WORKDIR /app
Copy . .
RUN composer self-update --stable
RUN php -d memory_limit=-1 /usr/local/bin/composer.phar update
RUN php -d memory_limit=-1 /usr/local/bin/composer.phar install

CMD chmod -R a+w storage/
CMD chmod -R a+w bootstrap/cache/
CMD php artisan key:generate
CMD php artisan serve --host=0.0.0.0