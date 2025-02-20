# Use an official PHP image with Apache
FROM php:8.1-apache

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    gnupg2 \
    software-properties-common \
    apt-transport-https \
    unixodbc \
    unixodbc-dev \
    libgssapi-krb5-2 \
    ca-certificates \
    && apt-get clean

# Manually download and install Microsoft ODBC Driver
RUN curl -o /tmp/msodbcsql17.deb https://packages.microsoft.com/debian/11/prod/pool/main/m/msodbcsql17/msodbcsql17_17.10.4.1-1_amd64.deb && \
    dpkg -i /tmp/msodbcsql17.deb || apt-get -f install -y && \
    rm -f /tmp/msodbcsql17.deb

# Manually download and install Microsoft SQLCMD tools
RUN curl -o /tmp/mssql-tools.deb https://packages.microsoft.com/debian/11/prod/pool/main/m/mssql-tools/mssql-tools_17.10.4.1-1_amd64.deb && \
    dpkg -i /tmp/mssql-tools.deb || apt-get -f install -y && \
    rm -f /tmp/mssql-tools.deb

# Add SQLCMD tools to PATH
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc && \
    echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> /etc/profile && \
    apt-get clean

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
