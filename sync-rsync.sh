#!/bin/bash

# Variables Globales
DATE=`date +%m%d%H%M%S`
LOG_DIR=/var/log/rsync
LOG_FILE=/var/log/rsync/$DATE.log

# Variables source
SYNC_SOURCE=10.0.0.192
PATH_SOURCE=/root/scripts

#Variables destination
SYNC_DEST=10.0.1.235
PATH_DEST=/tmp/rsync-dest/
USER_DEST=accdayco2

if [ ! -d "$LOG_DIR" ]
then
	mkdir $LOG_DIR
fi

touch $LOG_FILE

CHECK_SYNC=`rsync --delete -ai $PATH_SOURCE $USER_DEST@$SYNC_DEST:$PATH_DEST`

if [ -n "$CHECK_SYNC" ]
then
	echo "$CHECK_SYNC" | tee -a $LOG_FILE
else
	rm $LOG_FILE
fi
