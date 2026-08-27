FROM php:8.4-cli AS composer_builder
RUN apt-get update && apt-get install -y git curl zip unzip libzip-dev libpng-dev libgd-dev libonig-dev libxml2-dev libssl-dev \
    && docker-php-ext-install pdo_mysql mbstring zip bcmath gd pcntl opcache
RUN pecl install redis && docker-php-ext-enable redis
RUN pecl install swoole && docker-php-ext-enable swoole
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
WORKDIR /app
COPY composer.json composer.lock ./
COPY packages ./packages
RUN composer install --optimize-autoloader --no-scripts --no-interaction --ignore-platform-reqs

FROM node:20-slim AS node_builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY --from=composer_builder /app/vendor ./vendor
COPY . .
RUN npm run build

FROM php:8.4-cli

RUN apt-get update && apt-get install -y     git curl zip unzip libzip-dev libpng-dev libgd-dev     libonig-dev libxml2-dev libssl-dev supervisor     && docker-php-ext-install pdo_mysql mbstring zip bcmath gd pcntl opcache

RUN pecl install redis && docker-php-ext-enable redis
RUN pecl install swoole && docker-php-ext-enable swoole

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app
COPY . .
COPY --from=composer_builder /app/vendor ./vendor
COPY --from=node_builder /app/public/build ./public/build

# Process manager: runs Octane (web) + a queue worker in one container.
COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY docker/start-queue.sh /usr/local/bin/start-queue.sh
RUN chmod +x /usr/local/bin/start-queue.sh

RUN mkdir -p storage/framework/cache/data     storage/framework/sessions     storage/framework/views     storage/logs     bootstrap/cache     && chmod -R 775 storage bootstrap/cache

EXPOSE 8000
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
