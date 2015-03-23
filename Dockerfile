FROM php:5-apache
RUN \
  apt-get update && \
  apt-get install -y logrotate cron wget supervisor python python-dev python-pip python-virtualenv libpng-dev git && \
  rm -rf /var/lib/apt/lists/*
RUN \
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  apt-get install -y postfix && \
  rm -rf /var/lib/apt/lists/*

COPY 000-default.conf /etc/apache2/sites-available/
RUN pip install awscli
COPY etc /etc/
COPY s3-upload.sh /root/s3-upload.sh
RUN chmod +x /root/s3-upload.sh
COPY run.sh /run.sh
RUN chmod a+x /run.sh
EXPOSE 80
EXPOSE 443
CMD ["cron"]
CMD ["apache2-foreground"]
ENTRYPOINT ["/run.sh"]
