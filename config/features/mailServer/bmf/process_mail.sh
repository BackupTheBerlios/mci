#!/bin/sh

SITE=$(hostname | cut -d"." -f2-)
user=${1}

(find /${SITE}/me/mail/$user/Maildir -type f -mtime 1 | grep cur | grep -v spam | grep -v uidvalidity | grep -v bincimap | grep -v courierimap | grep -v dovecot | grep -v .subscriptions | grep -v .imap | grep -v .customflags) | while read i
do
     #echo "$i"
     cat "$i" | bmf -n -f text -d /${SITE}/me/mail/$user/.bmf &&
	chown -R $user /${SITE}/me/mail/$user/.bmf
done

exit 0
