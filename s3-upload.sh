#!/usr/bin/env bash
echo "upload started" > /var/www/html/index.html
LOGDIR=/var/log/apache2
BUCKET_NAME="s3://test-log-uploader/"
export AWS_ACCESS_KEY_ID="AKIAIVQBMDI27GGNJR7Q"
export AWS_SECRET_ACCESS_KEY="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"
DATE=$(date +%Y-%m-%d)
/usr/sbin/logrotate -f /etc/logrotate.conf

for gzlog in ${LOGDIR}/*.1.gz; do
        /usr/local/bin/aws s3 cp ${gzlog} ${BUCKET_NAME}/${gzlog}-${DATE} 2>&1 >> /var/www/html/index.html
done
