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
USER_DEST=accdayco2
PATH_DEST=/tmp/rsync-dest

mkdir $LOG_DIR
touch $LOG_FILE

rsync --delete -av --stats $PATH_SOURCE $USER_DEST@$SYNC_DEST:$PATH_DEST | tee -a $LOG_FILE

CHECK_SYNC=`cat $LOG_FILE | egrep "Number of created files|Number of deleted files|Number of regular files" \
	| grep -o "0" | wc -l`
	echo "$CHECK_SYNC"
	
if [ "$CHECK_SYNC" -eq 3 ]
then
	rm $LOG_FILE
else
	echo "Se sincronizaron los cambios"
fi

