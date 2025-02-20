# Use the official PHP image with Apache
FROM php:8.1-apache

# Install dependencies
RUN apt-get update && apt-get install -y \
    gnupg2 \
    curl \
    apt-transport-https \
    unixodbc \
    unixodbc-dev \
    libgssapi-krb5-2

# Add Microsoft repository for ODBC Driver
RUN curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl -fsSL https://packages.microsoft.com/config/debian/11/prod.list | tee /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update

# Install Microsoft ODBC Driver & SQLCMD tools
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql18 mssql-tools && \
    echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc && \
    source ~/.bashrc

# Install PHP SQL Server extensions
RUN docker-php-ext-configure pdo_sqlsrv --with-pdo-odbc=unixODBC,/usr && \
    docker-php-ext-install pdo pdo_sqlsrv sqlsrv

# Copy project files to the Apache root directory
COPY . /var/www/html/

# Set permissions
RUN chown -R www-data:www-data /var/www/html/

# Expose port 80 for HTTP
EXPOSE 80

# Start Apache when the container runs
CMD ["apache2-foreground"]
