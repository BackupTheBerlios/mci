#!/bin/sh

user=${1}
SITE=$(hostname | cut -d"." -f2-)

(find /${SITE}/me/mail/$user/spam -type f -mtime 1) | while read i
do
     #echo "$i"
     cat "$i" | bmf -s -f text -d /${SITE}/me/mail/$user/.bmf &&
     chown -R $user /${SITE}/me/mail/$user/.bmf
done
