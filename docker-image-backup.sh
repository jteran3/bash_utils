#!/bin/bash

# AUTOR: Julio Teran <teranj@daycohost.com>
# USO: Genera archivo de respaldo .tar de la imagen usada
# para crear los contenedores iniciados.

#Ruta de Respaldo
BACKUP_PATH="/var/lib/docker-backup/images"

#Crear directorio de Respaldo
mkdir -p $BACKUP_PATH

#Imprimir id de la imagen
for i in `docker images --format "{{.Repository}}"`
do IMAGE_NAME=$i

# Verificar si el nombre de la imagen contiene "/"
if [[ $IMAGE_NAME == */* ]]
then
	IMAGE_NAME2=`echo $IMAGE_NAME | sed s'/\//-/'`
	echo "$IMAGE_NAME2"
	IMAGE_ID=`docker images --format {{.ID}} $IMAGE_NAME`

#Crear archivo .TAR con la imagen del Contenedor
	SAVE_FILE=$BACKUP_PATH/$IMAGE_NAME2.tar
	docker save -o $SAVE_FILE "$IMAGE_ID"

else
	echo "$IMAGE_NAME"
	IMAGE_ID=`docker images --format {{.ID}} $IMAGE_NAME`

#Crear archivo .TAR con la imagen del Contenedor
	SAVE_FILE=$BACKUP_PATH/$IMAGE_NAME.tar
	docker save -o $SAVE_FILE "$IMAGE_ID"

fi

echo "OK"

done
