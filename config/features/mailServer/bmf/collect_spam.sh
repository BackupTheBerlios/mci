#!/bin/sh

user=${1}
SITE=$(hostname | cut -d "." -f2-)
HOST=$(hostname -s)

if [ -d "/${SITE}/${HOST}/mail/$user/Maildir/.spam/cur" ] && \
   [ "$(find /${SITE}/${HOST}/mail/$user/Maildir/.spam/cur -type d -empty -print)" != "/${SITE}/${HOST}/mail/$user/Maildir/.spam/cur" ]
then
	mkdir -p /${SITE}/${HOST}/mail/$user/spam &&
	mv /${SITE}/${HOST}/mail/$user/Maildir/.spam/cur/* /${SITE}/${HOST}/mail/$user/spam/ &&
	rm -f /${SITE}/${HOST}/mail/$user/Maildir/.spam/.imap.index.tree &&
	rm -f /${SITE}/${HOST}/mail/$user/Maildir/.spam/.imap.index.data &&
	chown -R $user /${SITE}/${HOST}/mail/$user/spam
fi
