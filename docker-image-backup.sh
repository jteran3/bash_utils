#!/bin/bash

# AUTOR: Julio Teran <teranj@daycohost.com>
# USO: Genera archivo de respaldo .tar de las imagenes locales (todas o por stack)

# ./docker-image-backup.sh <empty> <-- Respaldo de todas las imagenes
# ./docker-image-backup.sh <stack-name> <-- Respaldo de las imagenes de una stack

# Ruta de Respaldo
BACKUP_PATH="/var/lib/docker-backup/images"

# Crear directorio de Respaldo
mkdir -p $BACKUP_PATH

# Nombre de la stack
STACK_NAME=$1

function STACK_IMAGE {

# Fecha
DATE=`date +%m%d%H%M%S`

# Ruta de Stacks
STACK_PATH="/var/lib/docker-compose/$STACK_NAME"

cd $STACK_PATH

if [ $? -eq 1 ]
then
	echo ""
	echo "La stack $STACK_NAME no existe"
	echo ""
else

# Crear directorio de stack
	mkdir $BACKUP_PATH/$STACK_NAME

# Validar nombre de las imagenes
for i in `cat docker-compose.yml | grep image | sed s'/:/ /'g | awk '{print $2}'`
do IMAGE_NAME=$i

# Verificar si el nombre de la imagen contiene "/"
if [[ $IMAGE_NAME == */* ]]
then
	IMAGE_NAME2=`echo $IMAGE_NAME | sed s'/\//-/'`
	echo "$IMAGE_NAME2"
	IMAGE_ID=`docker images --format {{.ID}} $IMAGE_NAME`

# Crear archivo .TAR con la imagen del Contenedor
	SAVE_FILE=$BACKUP_PATH/$STACK_NAME/$IMAGE_NAME2-IMAGE-$DATE.tar
	docker save -o $SAVE_FILE "$IMAGE_ID"

else
	echo "$IMAGE_NAME"
	IMAGE_ID=`docker images --format {{.ID}} $IMAGE_NAME`

#Crear archivo .TAR con la imagen del Contenedor
	SAVE_FILE=$BACKUP_PATH/$STACK_NAME/$IMAGE_NAME-IMAGE.tar
	docker save -o $SAVE_FILE "$IMAGE_ID"

fi

echo "OK"

done

fi
}

function ALL_IMAGE {

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
	SAVE_FILE=$BACKUP_PATH/$IMAGE_NAME2-IMAGE.tar
	docker save -o $SAVE_FILE "$IMAGE_ID"

else
	echo "$IMAGE_NAME"
	IMAGE_ID=`docker images --format {{.ID}} $IMAGE_NAME`

#Crear archivo .TAR con la imagen del Contenedor
	SAVE_FILE=$BACKUP_PATH/$IMAGE_NAME-IMAGE.tar
	docker save -o $SAVE_FILE "$IMAGE_ID"

fi

echo "OK"

done
}

if [ -n "$1" ]; then STACK_IMAGE; fi
if [ -z "$1" ]; then ALL_IMAGE; fi
