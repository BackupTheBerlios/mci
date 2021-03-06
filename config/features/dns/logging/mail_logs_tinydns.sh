#!/bin/sh

export PATH=$PATH:/var/qmail/bin:/usr/local/bin

SERVICE="tinydns"

site=$(cat /etc/myname | sed -e "s|$(hostname -s).||")

yesterday=$(( $(date +%s) - (60 * 60 * 24) ))

logDir=$(date -r $yesterday +/service/$SERVICE/log/main/log.%Y-%m-%d)
date=$(date -r $yesterday +%d-%m-%Y)

if [ -d "$logDir" ] && [ ! -f "/service/$SERVICE/log/main/${date}" ]
then
	cd $logDir
	lines=$(cat * | grep -v ' + ' | grep -v ' I ' | grep -v 'starting tinydns' | wc -l)
	if [ $lines != 0 ]
	then
		(echo "Subject: $SERVICE logs for $date"; echo "" && (cat * | grep -v ' + ' | grep -v ' I ' | grep -v 'starting tinydns' )) | /usr/bin/perl -p /var/cfengine/inputs/config/features/dns/logging/tinydns-log.pl | tai64nlocal | qmail-inject root@${SITE}
	fi
   touch /service/$SERVICE/log/main/${date}
fi
