# Use the official Ubuntu image as the base image
# See hub-docker-com for Ubuntu supported tags
FROM php:7.4-fpm

# Install required dependencies
RUN apt-get update && \
    apt-get install -y \
        libzip-dev \
        zip \
        unzip \
        libpq-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libicu-dev \
        libldap2-dev \
        libxml2-dev \
        libmemcached-dev \
        libcurl4-openssl-dev \
        libonig-dev \  
        libxslt1-dev \ 
        libmagickwand-dev \
    && docker-php-ext-install -j$(nproc) \
        mysqli \
        pdo_mysql \
        curl \
        json \
        xml \
        mbstring \
        zip \
        gd \
        intl \
        bcmath \
        ldap \
        xmlrpc \
        xsl \
        soap

# Install imagick extension
RUN pecl install imagick && \
    docker-php-ext-enable imagick

# Install memcached extension
RUN pecl install memcached && \
    docker-php-ext-enable memcached

# Install ionCube loader
RUN mkdir -p /ioncube \
    && cd /ioncube \
    && curl -O http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
    && tar -zxvf ioncube_loaders_lin_x86-64.tar.gz \
    && mv ioncube/ioncube_loader_lin_7.4.so $(php -r "echo ini_get('extension_dir');") \
    && echo "zend_extension=ioncube_loader_lin_7.4.so" > /usr/local/etc/php/conf.d/00-ioncube.ini \
    && rm -rf /ioncube

# Enable opcache
RUN docker-php-ext-enable opcache

# Cleanup
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["php-fpm"]

EXPOSE 9000
