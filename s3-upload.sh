#!/usr/bin/env bash
LOGDIR=/var/log/apache2
BUCKET_NAME="s3://test-log-uploader"
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
DATE=$(date +%Y-%m-%d)
/usr/sbin/logrotate -f /etc/logrotate.conf

for gzlog in ${LOGDIR}/*.1.gz; do
	log_name=$(basename $gzlog)
        /usr/local/bin/aws s3 cp ${gzlog} ${BUCKET_NAME}/${DATE}-$log_name
done
rm -f ${LOGDIR}/*.1.gz
