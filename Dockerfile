FROM php:7.4-fpm
RUN cd /usr/local/etc/php/conf.d/ && \
  echo 'memory_limit = -1' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini

RUN apt-get update -y && apt-get upgrade -y
RUN apt update
#RUN apt install php php-cli php-fpm php-json php-common php-mysql php-zip php-gd php-mbstring  php-xml php-pear php-bcmath



RUN apt-get update -y && apt-get upgrade -y && apt-get install -y gnupg2
RUN apt-get install software-properties-common -y
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 40976EAF437D05B5
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32

RUN add-apt-repository "deb http://archive.ubuntu.com/ubuntu bionic main multiverse restricted universe"
RUN add-apt-repository "deb http://archive.ubuntu.com/ubuntu bionic-security main multiverse restricted universe"
RUN add-apt-repository "deb http://archive.ubuntu.com/ubuntu bionic-updates main multiverse restricted universe"


#RUN apt-get update -y && apt-get upgrade -y
RUN apt-get update -y && apt-get install -y libonig-dev libzip-dev zip unzip curl 
RUN apt install -y php-mbstring php-xml

#RUN apt-get purge php7.* -y
#RUN apt update -y && apt upgrade -y
#RUN apt-get install php7.2-mbstring
#RUN apt install php7.2-mbstring php7.2-xml -y


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