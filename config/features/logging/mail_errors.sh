#!/bin/sh

. /etc/profile

FILE="/var/log/syslog"
mkdir -p ${FILE}.d
logDir="${FILE}.d"
yesterday=$(( $(date +%s) - (60 * 60 * 24) ))
YESTERDAY=$(date -r $yesterday +%d-%m-%Y)
site=$(cat /etc/myname | sed -e "s|$(hostname -s).||")

if [ ! -f "$logDir/${YESTERDAY}" ] 
then

cp $FILE ${FILE}.d/${YESTERDAY}
rm -rf ${FILE}; touch ${FILE}; chown root:wheel ${FILE}; chmod 644 ${FILE}; kill -HUP $(cat /var/run/syslog.pid)

if [ -f "$logDir/${YESTERDAY}" ] && [ ! -f "/var/log/syslog.d/${YESTERDAY}.mailed" ]
then
	cd $logDir
	lines=$(cat ${YESTERDAY} | grep -v "was already set to" | grep -v "DHCPREQUEST" | grep -v "DHCPACK" | grep -v "bound to" | grep -v " dhcpd: " | grep -v "last message repeated " | grep -v " ftpd" | grep -v "syslogd: restart" | grep -v " cron" | grep -v "msg PRIV_OPEN_LOG received" | grep -v "/bsd" | wc -l)
	if [ $lines != 0 ]
	then
		(echo "Subject: error logs for $YESTERDAY"; echo "" && (cat ${YESTERDAY} | grep -v "was already set to" | grep -v "DHCPREQUEST" | grep -v "DHCPACK" | grep -v "bound to" | grep -v " dhcpd: " | grep -v "last message repeated " | grep -v " ftpd" | grep -v "syslogd: restart" | grep -v " cron" | grep -v "msg PRIV_OPEN_LOG received" | grep -v "/bsd" )) | qmail-inject root@${site}
	fi
   touch /var/log/syslog.d/${YESTERDAY}.mailed
fi

fi
