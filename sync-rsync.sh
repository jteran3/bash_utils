#!/bin/bash

# Variables Globales
DATE=`date +%m%d%H%M%S`
LOG_DIR=/var/log/rsync
LOG_FILE=/var/log/rsync/$DATE.log

# Variables source
PATH_SOURCE=<DIR_SOURCE>

#Variables destination
SYNC_DEST=<IP_DEST>
PATH_DEST=<DIR_DEST>
USER_DEST=<USER_DEST>

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
