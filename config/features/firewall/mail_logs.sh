#!/bin/sh

. /etc/profile

FILE="/var/log/pflog"
mkdir -p ${FILE}.d; chmod 700 ${FILE}.d
logDir="${FILE}.d"
yesterday=$(( $(date +%s) - (60 * 60 * 24) ))
YESTERDAY=$(date -r $yesterday +%d-%m-%Y)
site=$(cat /etc/myname | sed -e "s|$(hostname -s).||")

kill -ALRM $(cat /var/run/pflogd.pid)

cp $FILE ${FILE}.d/${YESTERDAY}; chmod 600 ${FILE}.d/${YESTERDAY}
rm -rf ${FILE}; touch ${FILE}; chown root:wheel ${FILE}; chmod 600 ${FILE}

kill -HUP $(cat /var/run/pflogd.pid)

if [ -f "$logDir/${YESTERDAY}" ] && [ ! -f "/var/log/pflog.d/${YESTERDAY}.mailed" ]
then
	cd $logDir
	lines=$(tcpdump -n -e -ttt -r ${YESTERDAY} | wc -l)
	if [ $lines != 0 ]
	then
		(echo "Subject: firewall logs for $YESTERDAY"; echo "" && (tcpdump -n -e -ttt -r ${YESTERDAY} )) | qmail-inject root@${site}
	fi
   touch /var/log/pflog.d/${YESTERDAY}.mailed
fi
