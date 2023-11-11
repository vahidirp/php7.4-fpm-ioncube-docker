# Use the official Ubuntu image as the base image
# See hub-docker-com for Ubuntu supported tags
FROM ubuntu:22.04

# Set non-interactive mode during the build
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and install necessary packages
RUN apt-get update && \
    apt-get install -y \
        software-properties-common \
        && \
    add-apt-repository ppa:ondrej/php && \
    apt-get update && \
    apt-get install -y \
        php7.4-fpm \
        php7.4-common \
        php7.4-cli \
        php7.4-mysql \
        php7.4-curl \
        php7.4-json \
        php7.4-xml \
        php7.4-mbstring \
        php7.4-zip \
        php7.4-gd \
        php7.4-imagick \
        php7.4-intl \
        php7.4-bcmath \
        php7.4-ldap \
        php7.4-xmlrpc \
        php7.4-xsl \
        php7.4-soap \
        php7.4-memcached \
        php7.4-opcache \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Download and install ionCube Loader
WORKDIR /tmp
RUN apt-get update && \
    apt-get install -y wget && \
    wget https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz && \
    tar -xvzf ioncube_loaders_lin_x86-64.tar.gz && \
    cp ioncube/ioncube_loader_lin_7.4.so $(php -r "echo ini_get('extension_dir');") && \
    echo "zend_extension = $(php -r "echo ini_get('extension_dir');")/ioncube_loader_lin_7.4.so" > /etc/php/7.4/fpm/conf.d/00-ioncube.ini && \
    rm -rf ioncube*

# Configure PHP-FPM
COPY php-fpm-pool.conf /etc/php/7.4/fpm/pool.d/www.conf

# Expose the port that PHP-FPM will listen on
EXPOSE 9000

# Start PHP-FPM
CMD ["php-fpm7.4", "-F"]
