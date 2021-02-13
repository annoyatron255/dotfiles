#!/usr/bin/env bash

for var in "$@"
do
	if [ -z "$(tail -c -1 "$var")" ];
	then
		echo "Truncating $var"
		truncate -s -1 "$var"
	fi
done