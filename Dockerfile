FROM php:8.3-apache

# 设置工作目录
WORKDIR /var/www/html

# 安装系统依赖和PHP扩展
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    unzip \
    git \
    ca-certificates \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install zip \
    && docker-php-ext-install pdo_mysql \
    && rm -rf /var/lib/apt/lists/*

# 安装Composer（使用更可靠的方法）
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');" \
    && chmod +x /usr/local/bin/composer

# 复制项目文件
COPY . .

# 配置Composer忽略安全警告
RUN composer config --global audit.block-insecure false

# 安装依赖
RUN composer install --no-dev --optimize-autoloader --no-interaction

# 设置Apache配置
RUN sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf \
    && a2enmod rewrite

# 设置文件权限
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# 暴露端口
EXPOSE 80

# 启动Apache
CMD ["apache2-foreground"]