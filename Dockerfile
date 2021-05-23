FROM php:8.0-fpm
RUN cd /usr/local/etc/php/conf.d/ && \
  echo 'memory_limit = -1' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini

RUN apt-get update -y && apt-get install -y libonig-dev libzip-dev zip unzip curl php7.4-xml php7.4-mbstring

RUN docker-php-ext-install pdo pdo_mysql mbstring zip curl
RUN curl -sS https://getcomposer.org/installer | php -- \ 
       --install-dir=/usr/local/bin --filename=composer

WORKDIR /app
Copy . .
RUN mkdir ("storage", 0777);
RUN mkdir ("storage/app", 0777);
RUN mkdir ("storage/app/public", 0777);
RUN mkdir ("storage/framework", 0777);
RUN mkdir ("storage/framework/cache", 0777);
RUN mkdir ("storage/framework/session", 0777);
RUN mkdir ("storage/framework/views", 0777);
RUN mkdir ("storage/logs", 0777);

RUN composer self-update --2
#RUN composer update

RUN composer install


RUN chmod -R a+w bootstrap/cache/
CMD php artisan key:generate
CMD php artisan serve --host=0.0.0.0