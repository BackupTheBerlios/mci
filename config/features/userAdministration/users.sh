#!/bin/sh

function check {
	var=$(echo $i | cut -d":" -f${1})
	if [ -n "$var" ]
	then
		echo $var > /etc/master.passwd.d/$id/$2
	fi
}
IFS="
"

for i in $(cat /etc/master.passwd)
do
	id=$(echo $i | cut -d":" -f3)
	mkdir -p /etc/master.passwd.d/$id
	check 1 NAME
	check 2 PASSWORD
	check 4 GID
	check 5 CLASS
	check 6 PASSWORD_CHANGE
	check 7 EXPIRATION
	check 8 GECOS
	check 9 HOME
	check 10 SHELL
done
