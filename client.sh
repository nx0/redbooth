#!/bin/bash

case $1 in
	query)
		curl -s http://$HTTP_HOST:9999/employees.xml | grep -Eo --color "<name>.*</name>"
	queryall)
		curl -s http://$HTTP_HOST:9999/employees/$2.xml | grep -Eo --color "<name>.*</name>"
	;;
	create)

	;;
	update)

	;;
	delete)

	;;
	*)
		echo "usage: query | queryall | create | update | delete"
esac
