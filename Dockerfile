FROM php:8.0-fpm

RUN docker-php-ext-install pdo pdo_mysql
RUN curl -sS https://getcomposer.org/installer | php -- \ 
       --install-dir=/usr/local/bin --filename=composer

WORKDIR /app
Copy . .
RUN composer install

CMD chmod -R a+w storage/
CMD chmod -R a+w bootstrap/cache/
CMD php artisan key:generate
CMD php artisan serve --host=0.0.0.0