#!/bin/bash

# Variables Globales
DATE=`date +%m%d%H%M%S`
LOG_DIR=/var/log/rsync
LOG_FILE=/var/log/rsync/$DATE.log

# Variables source
SYNC_SOURCE=<set_ip_source>
PATH_SOURCE=<set_path_source>

#Variables destination
SYNC_DEST=<set_ip_dest>
PATH_DEST=<set_path_dest>
USER_DEST=<set_user_dest>

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
