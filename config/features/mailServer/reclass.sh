#!/bin/sh

SITE=$(hostname | cut -d"." -f2-)
BASE="/${SITE}/me/mail"

cd ${BASE}

IFS="
"
for user in $(find * -type d -maxdepth 0 -mindepth 0)
do
	echo ${user}
	cd ${BASE}
	if [ -d "${user}/Maildir/.spam/cur" ]
	then
		cd ${user}/Maildir/.spam/cur
		for i in $(ls -1)
		do
			echo $i
			cat $i | /var/qmail/bin/qmail-inject ${user}-spam@${SITE}  &&
			rm -f $i
		done 
	fi
done
