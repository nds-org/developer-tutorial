FROM php:apache

RUN apt-get -qq update && apt-get -qq install cowsay fortunes

COPY index.php /var/www/html/

EXPOSE 80
CMD ["apache2-foreground"]
