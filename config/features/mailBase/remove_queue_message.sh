#!/bin/sh

message="$1"

rm /var/qmail/queue/info/$message
rm /var/qmail/queue/mess/$message

if [ -f /var/qmail/queue/remote/$message ]
then
 rm /var/qmail/queue/remote/$message
else
 rm /var/qmail/queue/local/$message
fi
