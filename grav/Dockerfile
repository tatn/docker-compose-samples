FROM php:7.2.3-apache-stretch

RUN apt-get update && apt-get install -y \
    git \
    libjpeg62-turbo-dev libpng-dev libfreetype6-dev \
    sass \
  && rm -rf /var/lib/apt/lists/* \
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install -j$(nproc) gd zip

ENV LC_ALL C.UTF-8

COPY etc/apache2/sites-available/grav.conf /etc/apache2/sites-available/grav.conf
RUN a2enmod rewrite && a2dissite 000-default && a2ensite grav

ARG GRAV_VERSION=1.6.15
WORKDIR /var/www/grav
RUN git clone -b ${GRAV_VERSION} https://github.com/getgrav/grav.git /var/www/grav
RUN /var/www/grav/bin/grav install
RUN /var/www/grav/bin/gpm install admin -y
RUN /var/www/grav/bin/gpm install login -y
RUN /var/www/grav/bin/gpm install form -y
RUN /var/www/grav/bin/gpm install email -y

ARG ADMIN_USER=admin
ARG ADMIN_PASSWORD=Password1234567890
ARG ADMIN_EMAIL=admin@example.com
ARG ADMIN_PERMISSIONS=b
ARG ADMIN_FULLNAME="Admin Name"
ARG ADMIN_TITLE=Administrator
RUN /var/www/grav/bin/plugin login newuser \
  --user="${ADMIN_USER}" \
  --password="${ADMIN_PASSWORD}" \
  --email="${ADMIN_EMAIL}" \
  --permissions="${ADMIN_PERMISSIONS}" \
  --fullname="${ADMIN_FULLNAME}" \
  --title="${ADMIN_TITLE}"

RUN chown -R www-data:www-data /var/www/grav
