# Use the official Ubuntu image as the base image
FROM ubuntu:20.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Update package list and install necessary packages
RUN apt-get update && apt-get install -y \
    apache2 \
    php \
    libapache2-mod-php \
    php-mysql \
    wget \
    unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Download and unzip WordPress
RUN wget -c https://wordpress.org/latest.zip -O /tmp/wordpress.zip \
    && unzip /tmp/wordpress.zip -d /var/www/html/ \
    && rm /tmp/wordpress.zip

# Set permissions for WordPress
RUN chown -R www-data:www-data /var/www/html/wordpress

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Copy Apache configuration file
COPY apache-config.conf /etc/apache2/sites-available/000-default.conf

# Expose port 80
EXPOSE 85

# Start Apache in the foreground
CMD ["apache2ctl", "-D", "FOREGROUND"]

