# Use the official PHP image with Apache
FROM php:8.1-apache

# Update and install required system dependencies
RUN apt-get update && apt-get install -y \
    gnupg2 \
    unixodbc \
    unixodbc-dev \
    apt-transport-https \
    curl \
    libcurl4-openssl-dev \
    libssl-dev

# Add Microsoft ODBC Driver Repository
RUN curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl -fsSL https://packages.microsoft.com/config/debian/$(lsb_release -rs)/prod.list | tee /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update

# Install Microsoft ODBC Driver & Dependencies
RUN ACCEPT_EULA=Y apt-get install -y \
    msodbcsql18 \
    mssql-tools \
    unixodbc-dev

# Install PHP SQLSRV and PDO_SQLSRV extensions
RUN docker-php-ext-configure pdo_sqlsrv --with-pdo-odbc=unixODBC,/usr \
    && docker-php-ext-install pdo pdo_sqlsrv sqlsrv

# Copy project files to the Apache root directory
COPY . /var/www/html/

# Set permissions
RUN chown -R www-data:www-data /var/www/html/

# Expose port 80 for HTTP
EXPOSE 80

# Start Apache when the container runs
CMD ["apache2-foreground"]
