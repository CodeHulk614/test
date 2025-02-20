# Use an official PHP image with Apache
FROM php:8.1-apache

# Enable required PHP extensions
RUN docker-php-ext-install pdo pdo_sqlsrv sqlsrv

# Copy project files to the Apache root directory
COPY . /var/www/html/

# Set permissions
RUN chown -R www-data:www-data /var/www/html/

# Expose port 80 for HTTP
EXPOSE 80

# Start Apache when the container runs
CMD ["apache2-foreground"]
