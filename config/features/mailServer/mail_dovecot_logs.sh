#!/bin/ksh

SERVICE=dovecot

export PATH=$PATH:/var/qmail/bin:/usr/local/bin

site=$(cat /etc/myname | sed -e "s|$(hostname -s).||")

yesterday=$(( $(date +%s) - (60 * 60 * 24) ))

logDir=$(date -r $yesterday +/service/$SERVICE/log/main/log.%Y-%m-%d)
date=$(date -r $yesterday +%d-%m-%Y)

if [ -d "$logDir" ] && [ ! -f "/service/$SERVICE/log/main/${date}" ]
then
	cd $logDir
	lines=$(cat * | grep -v "login: Info:" | grep -v "dovecot: Info: Dovecot starting up" | wc -l)
	if [ $lines != 0 ]
	then
		(echo "Subject: $SERVICE logs for $date"; echo "" && (cat *| grep -v "login: Info:" | grep -v "dovecot: Info: Dovecot starting up")) | tai64nlocal | qmail-inject root@${site}
	fi
   touch /service/$SERVICE/log/main/${date}
fi


