#!/bin/sh

SERVICE=dnscache

export PATH=$PATH:/var/qmail/bin:/usr/local/bin

site=$(cat /etc/myname | sed -e "s|$(hostname -s).||")

yesterday=$(( $(date +%s) - (60 * 60 * 24) ))

logDir=$(date -r $yesterday +/service/$SERVICE/log/main/log.%Y-%m-%d)
date=$(date -r $yesterday +%d-%m-%Y)

if [ -d "$logDir" ] && [ ! -f "/service/$SERVICE/log/main/${date}" ]
then
	cd $logDir
	lines=$(cat * | grep -v "input/output error" | grep -v "no data" | grep -v " listening on" | grep -v " stats " | grep -v "nxdomain" | grep -v " cached " | grep -v " rr " | grep -v " query " | grep -v " sent " | grep -v " tx " | grep -v " lame " | grep -v " starting" | grep -v " nodata " | wc -l)
	if [ $lines != 0 ]
	then
		(echo "Subject: $SERVICE logs for $date"; echo "" && (cat * | grep -v "input/output error" | grep -v "no data" | grep -v " listening on" | grep -v " stats " | grep -v "nxdomain" | grep -v " cached " | grep -v " rr " | grep -v " query " | grep -v " sent " | grep -v " tx " | grep -v " lame " | grep -v " nodata "| grep -v " starting")) | /usr/bin/perl -p /var/cfengine/inputs/config/features/dns/logging/dnscache-log.pl | tai64nlocal | qmail-inject root@${SITE}
	fi
   touch /service/$SERVICE/log/main/${date}
fi

