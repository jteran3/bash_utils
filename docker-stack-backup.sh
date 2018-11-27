#!/bin/bash

# AUTOR: Julio Teran <teranj@daycohost.com>
# USO: Genera archivo .tar de imagen (snapshot) del estado actual
# de todos los contenedores de una stack.
#
# ./docker-container-backup.sh <stack-name> <-- Respaldo de todos los contenedores de la stack

# Ruta de Respaldo
BACKUP_PATH="/var/lib/docker-backup/stack"

# Ruta de Stacks
STACK_PATH="/var/lib/docker-compose/"

# Fecha
#DATE=`date +%m%d%H%M%S`

# Crear directorio de Respaldo
mkdir -p $BACKUP_PATH

# Nombre de la stack
ST_NAME=$1

# Stacks disponibles para respaldar
echo ""
echo "Stacks disponibles para respaldar:"
STACK_BK=`ls -1 "$STACK_PATH" | grep -v _devops_`
echo ""
echo -e "$STACK_BK"
echo ""

# Introducir nombre de la stack a restaurar
echo "Introduzca el nombre de la stack a respaldar:"
read STACK_BACKUP
echo

# Validar nombre de ls stack
CHECK_NAME=`ls -1 $STACK_PATH | grep -v "_devops_" | grep "$STACK_BACKUP$"` 
if [ $? -eq 1 ]
then
	echo ""
	echo "La stack $STACK_BACKUP no existe o no está desplegada"
	echo ""
else

# Respaldar directorio de la stack $STACK_PATH/<stack>
cd $STACK_PATH
echo "Respaldando directorio docker-compose/$STACK_BACKUP"
tar czvf $BACKUP_PATH/$STACK_BACKUP/$STACK_BACKUP-COMPOSE-DIR.tar.gz  $STACK_BACKUP >> /dev/null

# Mostrar nombre de contenedores a respaldar
echo "Ejecutando Backup de los contenedores de la stack $STACK_BACKUP - "

# Imprimir nombre de Contenedor
cd $STACK_PATH/$STACK_BACKUP
for i in `docker inspect --format='{{.Name}}' $(docker-compose ps -q) | cut -f2 -d\/`
do CONTAINER_NAME=$i
echo -n "$CONTAINER_NAME - "

# Crear imagen (snapshot) del contenedor:
CONTAINER_BACKUP=`docker commit -p $CONTAINER_NAME $CONTAINER_NAME-bk`

# Crear directorio con nombre de Contenedor en ruta de Respaldo
mkdir -p $BACKUP_PATH/$STACK_BACKUP/

# Crear archivo .TAR de la imagen (commit) creada del Contenedor:
#SAVE_FILE="$BACKUP_PATH/$ST_NAME/$CONTAINER_NAME-BACKUP-$DATE.tar"
SAVE_FILE="$BACKUP_PATH/$STACK_BACKUP/$CONTAINER_NAME-BACKUP.tar"
docker save -o $SAVE_FILE $CONTAINER_BACKUP
echo "$CONTAINER_NAME-BACKUP.tar"

# Borrar imagen -bk del respaldo anterior
docker rmi --force $(docker images --format "{{.Repository}}" $CONTAINER_NAME-bk)

echo "OK"
done
fi
