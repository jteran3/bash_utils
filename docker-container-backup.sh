#!/bin/bash

# AUTOR: Julio Teran <teranj@daycohost.com>
# USO: Genera archivo .tar de imagen (snapshot) del estado actual
# de todos los contenedores iniciados o de un contenedor en particular.
#
# ./docker-container-backup.sh <empty> <-- Respaldo de todos los contenedores
# ./docker-container-backup.sh <container-name> <-- Respaldo de un contenedor

# Ruta de Respaldo
BACKUP_PATH="/var/lib/docker-backup/containers"

# Crear directorio de Respaldo
mkdir -p $BACKUP_PATH

# Nombre de contenedor
CONT_NAME=$1

function ALL_CONTAINERS {
# Imprimir nombre de Contenedor
for i in `docker inspect --format='{{.Name}}' $(docker ps -q) | cut -f2 -d\/`
do CONTAINER_NAME=$i
echo -n "$CONTAINER_NAME - "

# Crear imagen (snapshot) del contenedor:
CONTAINER_BACKUP=`docker commit -p $CONTAINER_NAME $CONTAINER_NAME-bk`

# Crear directorio con nombre de Contenedor en ruta de Respaldo
mkdir -p $BACKUP_PATH/$CONTAINER_NAME

# Crear archivo .TAR de la imagen (commit) creada del Contenedor:
SAVE_FILE="$BACKUP_PATH/$CONTAINER_NAME/$CONTAINER_NAME-BACKUP.tar"
docker save -o $SAVE_FILE $CONTAINER_BACKUP
echo "$CONTAINER_NAME-BACKUP.tar"

# Borrar imagen -bk del respaldo anterior
docker rmi --force $(docker images --format "{{.Repository}}" $CONTAINER_NAME-bk)

echo "OK"
done
}

function ONE_CONTAINER {
# Fecha
DATE=`date +%m%d%H%M%S`

# Validar nombre de contenedor
CHECK_NAME=`docker ps --format {{.Names}} | grep "$CONT_NAME$"`
if [ $? -eq 1 ]
then
	echo ""
	echo "El contenedor $CONT_NAME no existe o esta apagado"
	echo ""
else

# Mostrar nombre de contenedor a respaldar
echo "$CONT_NAME - "

# Crear imagen (snapshot) del contenedor:
CONT_BACKUP=`docker commit -p $CONT_NAME $CONT_NAME-bk`

# Crear directorio con nombre de Contenedor en ruta de Respaldo
mkdir -p $BACKUP_PATH/$CONT_NAME

# Crear archivo .TAR de la imagen (commit) creada del Contenedor:
SAVE_FILE="$BACKUP_PATH/$CONT_NAME/$CONT_NAME-BACKUP-$DATE.tar"
docker save -o $SAVE_FILE $CONT_BACKUP
echo "$CONT_NAME-BACKUP.tar"

# Borrar imagen -bk del respaldo anterior
docker rmi --force $(docker images --format "{{.Repository}}" $CONT_NAME-bk)

echo "OK"
fi
}

if [ -z "$1" ]; then ALL_CONTAINERS; fi
if [ -n "$1" ]; then ONE_CONTAINER; fi
