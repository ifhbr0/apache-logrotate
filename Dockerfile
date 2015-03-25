FROM php:5-apache
RUN \
  apt-get update && \
  apt-get install -y ssh rsyslog logrotate cron wget supervisor python python-dev python-pip python-virtualenv libpng-dev git && \
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
COPY etc /etc/
COPY run.sh /run.sh
RUN chmod a+x /run.sh
RUN sed -i 's/session    required     pam_loginuid.so/#/g' /etc/pam.d/cron
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN mkdir /root/.ssh && chmod 600 /root/.ssh
COPY authorized_keys /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys
EXPOSE 80
EXPOSE 443
CMD ["apache2-foreground"]
ENTRYPOINT ["/run.sh"]
