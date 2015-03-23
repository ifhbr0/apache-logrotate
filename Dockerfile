FROM php:5-apache
RUN \
  apt-get update && \
  apt-get install -y rsyslog logrotate cron wget supervisor python python-dev python-pip python-virtualenv libpng-dev git && \
  rm -rf /var/lib/apt/lists/*
RUN \
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  apt-get install -y postfix && \
  rm -rf /var/lib/apt/lists/*
RUN \
  cd /tmp && \
  wget http://nodejs.org/dist/node-latest.tar.gz && \
  tar xvzf node-latest.tar.gz && \
  rm -f node-latest.tar.gz && \
  cd node-v* && \
  ./configure && \
  CXX="g++ -Wno-unused-local-typedefs" make && \
  CXX="g++ -Wno-unused-local-typedefs" make install && \
  cd /tmp && \
  rm -rf /tmp/node-v* && \
  npm install -g npm && \
  echo -e '\n# Node.js\nexport PATH="node_modules/.bin:$PATH"' >> /root/.bashrc
RUN npm install -g bower grunt-cli
RUN echo "Include sites-available/*" >> /etc/apache2/apache2.conf
COPY 000-default.conf /etc/apache2/sites-available/
RUN pip install awscli
COPY etc /etc/
COPY s3-upload.sh /root/s3-upload.sh
RUN chmod +x /root/s3-upload.sh
COPY run.sh /run.sh
#COPY apache2.conf /etc/apache2/apache2.conf
RUN chmod a+x /run.sh
RUN sed -i 's/session    required     pam_loginuid.so/#/g' /etc/pam.d/cron
EXPOSE 80
EXPOSE 443
CMD ["apache2-foreground"]
ENTRYPOINT ["/run.sh"]
