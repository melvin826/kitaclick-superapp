FROM php:8.3-fpm
WORKDIR /var/www/html
RUN apt-get update && apt-get install -y git zip unzip libzip-dev libpng-dev libonig-dev libxml2-dev     && docker-php-ext-install pdo_mysql mbstring zip exif pcntl || true
COPY . .
# Composer stage (if composer available in image)
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
RUN if [ -f composer.json ]; then composer install --no-dev --optimize-autoloader || true; fi
EXPOSE 8000
CMD ["php","-S","0.0.0.0:8000","-t","."]
