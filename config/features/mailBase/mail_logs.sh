#!/bin/sh

service="qmail-send"
SERVICE=$service
yesterday=$(( $(date +%s) - (60 * 60 * 24) ))
logDir=$(date -r $yesterday +/service/$service/log/main/log.%Y-%m-%d)
date=$(date -r $yesterday +%d-%m-%Y)
site=$(cat /etc/myname | sed -e "s|$(hostname -s).||")
export PATH=$PATH:/var/qmail/bin

if [ -d "$logDir" ] && [ ! -f "/service/$SERVICE/log/main/${date}" ]
then

umask 077
TMP_FILE="/service/qmail-send/log/main/qmailanalog.tmp"
EXT_FILE="/service/qmail-send/log/main/qmailanalog.ext"
OUT_FILE="/service/qmail-send/log/main/qmailanalog.out"
LOG_FILE="$logDir/*"
rm -f $TMP_FILE $OUT_FILE

cat << MAIL_HEADER > $OUT_FILE
From: root@${site}
To: root@${site}
Subject: `hostname` qmail statistics

MAIL_HEADER

touch $EXT_FILE
cat $EXT_FILE $LOG_FILE | /usr/local/bin/matchup > $TMP_FILE 5>$EXT_FILE.new
mv $EXT_FILE.new $EXT_FILE

/var/cfengine/inputs/config/features/mailBase/zoverall < $TMP_FILE >> $OUT_FILE
echo "------------------------------------------" >> $OUT_FILE
/usr/local/bin/zfailures   < $TMP_FILE >> $OUT_FILE
echo "------------------------------------------" >> $OUT_FILE
/usr/local/bin/zdeferrals   < $TMP_FILE >> $OUT_FILE

/var/qmail/bin/qmail-inject < $OUT_FILE
rm -f $TMP_FILE $OUT_FILE

touch /service/$SERVICE/log/main/${date}

fi
