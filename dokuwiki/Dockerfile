FROM php:7.3-apache
RUN apt-get update && apt-get install -y \
libfreetype6-dev \
libjpeg62-turbo-dev \
libpng-dev \
wget \
rsync \
vim

RUN rm -rf /var/cache/apk/*

RUN docker-php-ext-install -j$(nproc) iconv \
&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
&& docker-php-ext-install -j$(nproc) gd \
&& docker-php-ext-install mbstring

WORKDIR /usr/src
RUN wget https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz
RUN mkdir /usr/src/dokuwiki
RUN tar xvfz dokuwiki-stable.tgz -C /usr/src/dokuwiki --strip-components 1
RUN rm -f dokuwiki-stable.tgz

RUN a2enmod rewrite
RUN a2ensite 000-default
EXPOSE 80

COPY docker-entrypoint.sh /usr/local/bin/entrypoint.sh
COPY .htaccess /usr/src/dokuwiki/.htaccess
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
