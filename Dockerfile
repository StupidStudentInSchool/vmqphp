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

# 复制项目文件（包括已安装的 vendor）
COPY . .

# PHP 8.3 ThinkPHP 5.1 兼容性修复
# 修复 Container.php ArrayAccess 方法返回类型
RUN sed -i 's/#\[\ReturnTypeWillChange\]//' /var/www/html/thinkphp/library/think/Container.php \
    && sed -i 's/public function offsetExists(\$key)/public function offsetExists(mixed \$key): bool/' /var/www/html/thinkphp/library/think/Container.php \
    && sed -i 's/public function offsetGet(\$key)/public function offsetGet(mixed \$key): mixed/' /var/www/html/thinkphp/library/think/Container.php \
    && sed -i 's/public function offsetSet(\$key, \$value)/public function offsetSet(mixed \$key, mixed \$value): void/' /var/www/html/thinkphp/library/think/Container.php \
    && sed -i 's/public function offsetUnset(\$key)/public function offsetUnset(mixed \$key): void/' /var/www/html/thinkphp/library/think/Container.php

# 修复 Config.php ArrayAccess 方法返回类型
RUN sed -i 's/public function offsetSet(\$name, \$value)/public function offsetSet(mixed \$name, mixed \$value): void/' /var/www/html/thinkphp/library/think/Config.php \
    && sed -i 's/public function offsetExists(\$name)/public function offsetExists(mixed \$name): bool/' /var/www/html/thinkphp/library/think/Config.php \
    && sed -i 's/public function offsetUnset(\$name)/public function offsetUnset(mixed \$name): void/' /var/www/html/thinkphp/library/think/Config.php \
    && sed -i 's/public function offsetGet(\$name)/public function offsetGet(mixed \$name): mixed/' /var/www/html/thinkphp/library/think/Config.php

# 设置PHP配置，忽略E_DEPRECATED警告
RUN echo 'error_reporting = E_ALL & ~E_DEPRECATED' >> /usr/local/etc/php/php.ini

# 设置Apache配置
RUN sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf \
    && a2enmod rewrite

# 复制Apache虚拟主机配置
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

# 设置文件权限
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# 暴露端口
EXPOSE 80

# 启动Apache
CMD ["apache2-foreground"]