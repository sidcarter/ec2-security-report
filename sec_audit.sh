#!/usr/bin/env bash

OLD="sieve/sec_cronlog.old"
NEW="sieve/sec_cronlog"
TMPDIR="/tmp"
TMPNEW="$TMPDIR/sec_cronlog"
LOGFILE="changelog"

function log_to_file() {
	TSTAMP=$(date +"%b %d %T")
	PTAG="$TSTAMP [$$]:"
	LOGINFO=$1
	echo "$PTAG $1" >> $LOGFILE
}

if [ ! -f $OLD ]
then
	log_to_file "Previous report not found. First run?"
	mv $NEW $OLD
else
	cp $NEW $TMPDIR
	cmp -s $OLD $TMPNEW
	result=$(echo $?)

	if [ $result -eq 1 ] 
	then
		log_to_file "The security groups have changed."
	elif [ $result -eq 0 ]
	then
		log_to_file "No changed detected in the security groups."
	else
		log_to_file "Unknown error."
		exit 1
	fi
	cp $TMPNEW $OLD
	rm $TMPNEW $NEW
fi
