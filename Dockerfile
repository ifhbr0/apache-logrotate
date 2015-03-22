FROM php:5-apache

# Install nodejs, bower and grunt
RUN \
  apt-get update && \
  apt-get install -y logrotate cron wget supervisor python python-dev python-pip python-virtualenv libpng-dev git && \
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

# Start postfix on starup
RUN \
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  apt-get install -y postfix && \
  rm -rf /var/lib/apt/lists/*
COPY run.sh /run.sh
RUN chmod a+x /run.sh

# Extend apache configuration
#RUN echo "Include conf.d/*" >> /etc/apache2/apache2.conf
#RUN a2enmod ssl
# Configure website
COPY website /var/www/html
COPY ssl /etc/ssl/
COPY 000-default.conf /etc/apache2/sites-available/
RUN pip install awscli
COPY etc /etc/
COPY s3-upload.sh /root/s3-upload.sh
RUN chmod +x /root/s3-upload.sh
EXPOSE 80
EXPOSE 443
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
