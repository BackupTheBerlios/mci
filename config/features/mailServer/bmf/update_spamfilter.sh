#!/bin/sh

SITE=$(hostname | cut -d"." -f2-)

cd /${SITE}/$(hostname -s)/mail

users=$(find * -type d -maxdepth 0 -mindepth 0)

cd /

for user in $users
do
	echo "$user"
	if [ -d "/${SITE}/$(hostname -s)/mail/$user/spam" ]
	then
		echo "collect spam"
		/bin/ksh /var/cfengine/inputs/config/features/mailServer/bmf/collect_spam.sh $user
		echo "process spam"
		/bin/ksh /var/cfengine/inputs/config/features/mailServer/bmf/process_spam.sh $user
		echo "process mail"
		/bin/ksh /var/cfengine/inputs/config/features/mailServer/bmf/process_mail.sh $user
	fi
done
