FROM php:7.2.3-apache-stretch

RUN apt-get update
RUN apt-get install -y git wget curl cron vim \
    libjpeg62-turbo-dev libpng-dev libfreetype6-dev \
    openssl libssl-dev  libxml2-dev libcurl4-openssl-dev libyaml-dev \
    sass

RUN rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install -j$(nproc) gd zip curl ctype dom  json mbstring session simplexml xml zip opcache

ENV LC_ALL C.UTF-8

COPY ./grav.conf /etc/apache2/sites-available/grav.conf
RUN a2enmod rewrite ssl  && a2dissite 000-default && a2ensite grav

RUN pecl channel-update pecl.php.net \
    && pecl install apcu && docker-php-ext-enable apcu \
    && pecl install yaml-2.0.4  && docker-php-ext-enable yaml \
    && pecl install xdebug  && docker-php-ext-enable xdebug 

COPY ./opcache.ini /usr/local/etc/php/conf.d/opcache.ini

WORKDIR /usr/src
RUN wget https://getgrav.org/download/skeletons/blog-site/2.0.0
RUN unzip 2.0.0

WORKDIR /usr/src/grav-skeleton-blog-site
RUN /usr/src/grav-skeleton-blog-site/bin/gpm selfupgrade
RUN /usr/src/grav-skeleton-blog-site/bin/gpm install admin -y

ARG ADMIN_USER=admin
ARG ADMIN_PASSWORD=Password1234567890
ARG ADMIN_EMAIL=admin@example.com
ARG ADMIN_PERMISSIONS=b
ARG ADMIN_FULLNAME="Admin Name"
ARG ADMIN_TITLE=Administrator
RUN /usr/src/grav-skeleton-blog-site/bin/plugin login newuser \
  --user="${ADMIN_USER}" \
  --password="${ADMIN_PASSWORD}" \
  --email="${ADMIN_EMAIL}" \
  --permissions="${ADMIN_PERMISSIONS}" \
  --fullname="${ADMIN_FULLNAME}" \
  --title="${ADMIN_TITLE}"

WORKDIR /usr/src/grav-skeleton-blog-site
RUN chown -R www-data:www-data /usr/src/grav-skeleton-blog-site \
    && chgrp -R www-data . \
    && find . -type f | xargs chmod 664 \
    && find ./bin -type f | xargs chmod 775 \
    && find . -type d | xargs chmod 775 \
    && find . -type d | xargs chmod +s \
    && umask 0002

RUN (crontab -u www-data -l; echo "* * * * * cd /var/www/grav;/usr/local/bin/php bin/grav scheduler 1>> /dev/null 2>&1") | crontab -u www-data -
RUN service cron start
RUN update-rc.d cron enable

COPY docker-entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

VOLUME /var/www/grav
RUN chown -R www-data:www-data /var/www/grav

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]