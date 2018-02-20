FROM wpinit

COPY ./html /var/www/html

RUN chown -R www-data:www-data /var/www/html \
    && chmod -R g+w /var/www/html

EXPOSE 80

CMD /usr/sbin/apache2ctl -D FOREGROUND