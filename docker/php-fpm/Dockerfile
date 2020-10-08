FROM debian:buster
ARG MAGENTO_USER_ID
ARG MAGENTO_USER_GROUP_ID
ARG PHP_VER=7.4

# Base tools
RUN \
    apt update && \
    apt install -y wget curl apt-transport-https lsb-release ca-certificates

# Using Sury PHP repo to have a specific PHP version
RUN \
    wget -O /etc/apt/trusted.gpg.d/php.gpg 'https://packages.sury.org/php/apt.gpg' && \
	sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' && \
	apt update

# Install php/php-fpm and extensions
# Requirements: https://devdocs.magento.com/guides/v2.4/install-gde/system-requirements-tech.html#required-php-extensions
# Additional: xdebug
RUN \
    apt install --no-install-recommends -y \
        php${PHP_VER}-fpm \
        php${PHP_VER}-cli \
        php${PHP_VER}-bcmath \
        php${PHP_VER}-ctype \
        php${PHP_VER}-curl \
        php${PHP_VER}-dom \
        php${PHP_VER}-gd \
#        php${PHP_VER}-hash \
        php${PHP_VER}-iconv \
        php${PHP_VER}-intl \
        php${PHP_VER}-mbstring \
#        php${PHP_VER}-openssl \
        php${PHP_VER}-pdo-mysql \
        php${PHP_VER}-simplexml \
        php${PHP_VER}-soap \
        php${PHP_VER}-xsl \
        php${PHP_VER}-zip \
        php${PHP_VER}-sockets \
        php${PHP_VER}-xdebug

# Composer
RUN curl -sS 'https://getcomposer.org/installer' | php && mv composer.phar /usr/local/bin/composer

# UTF-8 locale
RUN apt install -y locales && locale-gen C.UTF-8

# Other packages (utils)
# git/unzip: for some composer dependencies
RUN \
    apt install -y \
        msmtp \
        less nano \
        unzip \
        git \
        net-tools procps


ENV MAGENTO_USER magento
ENV MAGENTO_USER_HOME /home/$MAGENTO_USER
ENV MAGENTO_BASE_DIR /var/www/magento


# Create magento user
RUN \
	# Removes any existing user/group with host ids before creating the new one (macOS cases with ids < 1000)
	existing_user_name="$(getent passwd $MAGENTO_USER_ID | cut -d: -f1)" && \
	([ -z "$existing_user_name" ] || userdel "$MAGENTO_USER") && \
	existing_group_name="$(getent group $MAGENTO_USER_GROUP_ID | cut -d: -f1)" && \
	([ -z "$existing_group_name" ] || groupdel "$MAGENTO_USER") && \
	groupadd --gid $MAGENTO_USER_GROUP_ID $MAGENTO_USER && \
	useradd --uid $MAGENTO_USER_ID --gid $MAGENTO_USER_GROUP_ID --create-home $MAGENTO_USER && \
	# Create composer home to allow using volume
	mkdir $MAGENTO_USER_HOME/.composer && chown $MAGENTO_USER: $MAGENTO_USER_HOME/.composer && \
	# Project home
	mkdir -p "$MAGENTO_BASE_DIR" && chown $MAGENTO_USER: "$MAGENTO_BASE_DIR" && \
	# User bashrc
	echo "export LC_ALL=C.UTF-8" >> $MAGENTO_USER_HOME/.bashrc && \
	echo "cd $MAGENTO_BASE_DIR" >> $MAGENTO_USER_HOME/.bashrc

# Add/overwrite files
COPY files /

# Actions after overwriting files
RUN \
    # Common php config
    ln -s /etc/php/common/*.ini /etc/php/$PHP_VER/fpm/conf.d/ && \
	ln -s /etc/php/common/*.ini /etc/php/$PHP_VER/cli/conf.d/ && \
	# Required to allow fpm to run
	mkdir -pv /run/php

CMD [ "php-fpm7.4", "--fpm-config", "/etc/php/7.4/fpm/php-fpm.conf", "--nodaemonize", "--force-stderr" ]
