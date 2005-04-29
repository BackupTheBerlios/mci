#!/bin/sh

. /etc/profile

FILE="/var/www/logs/access_log"
mkdir -p ${FILE}.d
logDir="${FILE}.d"
yesterday=$(( $(date +%s) - (60 * 60 * 24) ))
YESTERDAY=$(date -r $yesterday +%d-%m-%Y)
site=$(cat /etc/myname | sed -e "s|$(hostname -s).||")

if [ ! -f "$logDir/${YESTERDAY}" ] 
then

cp $FILE ${FILE}.d/${YESTERDAY}
rm -rf ${FILE}; touch ${FILE}; chown root:daemon ${FILE}; chmod 644 ${FILE}; apachectl stop; httpd -u 

fi
