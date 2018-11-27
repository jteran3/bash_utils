#!/bin/bash

# AUTOR: Julio Teran <teranj@daycohost.com>
# USO: RSYNC de directorio local a host remoto
# con salida solo si existen cambios

# Variables Globales
DATE=`date +%m%d%H%M%S`
LOG_DIR=/var/log/rsync
LOG_FILE=/var/log/rsync/$DATE.log

# Variables source
PATH_SOURCE=<set_source_path>

#Variables destination
SYNC_DEST=<set_ip_dest>
PATH_DEST=<set_path_dest>
USER_DEST=<set_user_dest>

mkdir $LOG_DIR
touch $LOG_FILE

CHECK_SYNC=`rsync --delete -ai $PATH_SOURCE $USER_DEST@$SYNC_DEST:$PATH_DEST`

if [ -n "$CHECK_SYNC" ]
then
	echo "$CHECK_SYNC" | tee -a $LOG_FILE
else
	rm $LOG_FILE
fi

