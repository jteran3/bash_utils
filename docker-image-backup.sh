#!/bin/bash

# AUTOR: Julio Teran <teranj@daycohost.com>
# USO: Genera archivo de respaldo .tar de la imagen usada
# para crear los contenedores iniciados.

#Ruta de Respaldo
BACKUP_PATH="/var/lib/docker-backup/images"

#Crear directorio de Respaldo
mkdir -p $BACKUP_PATH

#Imprimir nombre de Contenedor
for i in `docker inspect --format='{{.Name}}' $(docker ps -q) | cut -f2 -d\/`
do CONTAINER_NAME=$i
echo -n "$CONTAINER_NAME - "

#Imprimir nombre de la imagen del Contenedor
CONTAINER_IMAGE=`docker inspect --format='{{.Config.Image}}' $CONTAINER_NAME`

#Crear directorio con nombre de Contenedor en ruta de Respaldo
mkdir -p $BACKUP_PATH/$CONTAINER_NAME

#Crear archivo .TAR con la imagen del Contenedor
SAVE_FILE="$BACKUP_PATH/$CONTAINER_NAME/$CONTAINER_NAME-IMAGE.tar"
docker save -o $SAVE_FILE $CONTAINER_IMAGE

echo "OK"

done
