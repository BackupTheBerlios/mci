#!/bin/sh

for i in $(cat /etc/group)
do
	id=$(echo $i | cut -d":" -f3)
	mkdir -p /etc/group.d/$id
	echo $i | cut -d":" -f1 > /etc/group.d/$id/NAME
	members=$(echo $i | cut -d":" -f4)
	if [ -n "$members" ]
	then
		echo $members > /etc/group.d/$id/MEMBERS
	fi
done
