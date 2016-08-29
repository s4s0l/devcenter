FROM aexoti/lam
RUN groupadd -g 1000 external_group && usermod -a -G external_group www-data
ENV APACHE_SERVER_NAME=localhost
RUN echo "ServerName \${APACHE_SERVER_NAME}" >> /etc/apache2/apache2.conf
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT /entrypoint.sh