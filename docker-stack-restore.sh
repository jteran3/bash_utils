#!/bin/bash

# AUTOR: Julio Teran <teranj@daycohost.com>
# USO: Restaura el directorio de la stack y los archivos .tar de las imagenes
# respaldadas (snapshot) de los contenedores.

# Ruta de Respaldo
BACKUP_PATH="/var/lib/docker-backup/stack"
STACK_PATH="/var/lib/docker-compose"

# Stacks disponibles para restauracion
echo ""
echo "Stacks disponibles para restaurar:"
STACK_BK=`ls -1 "$BACKUP_PATH"`
echo ""
echo -e "$STACK_BK"
echo ""

# Introducir nombre de la stack a restaurar
echo "Introduzca el nombre de la stack a restaurar:"
read STACK_RT
echo

# Verificar si el directorio de la stack ya fue cambio de nombre
if [ -d "$STACK_PATH/$STACK_RT" ]
then
	echo ""
	echo "Debe cambiar el nombre de directorio de la stack $STACK_PATH/$STACK_RT antes de restaurarla"
	echo ""
	exit
else
	cd $STACK_PATH

# Copiar y restaurar respaldo de directorio de la stack
	cp $BACKUP_PATH/$STACK_RT/$STACK_RT-COMPOSE-DIR.tar.gz $STACK_PATH
	tar xzvf $STACK_RT-COMPOSE-DIR.tar.gz >> /dev/null
	rm $STACK_RT-COMPOSE-DIR.tar.gz

# Restaurar imagenes de los contenedores de la stack
for i in `find $BACKUP_PATH/$STACK_RT -type f -name '*-BACKUP.tar'` 
do CONT_BK=$i
	echo "$CONT_BK"
docker load -i $CONT_BK

# Imprimir ID de la imagen cargada
IMAGE_ID=`docker images -f "dangling=true" -q` 
	echo "$IMAGE_ID"

# Imprimir nombre de la imagen cargada
IMAGE_NAME=`docker image inspect $IMAGE_ID | grep ""Image"" | uniq \
| sed s'/"//'g | sed s'/:/ /'g | awk '{print $2}'`
	echo "$IMAGE_NAME"

# Establecer nombre a la nueva imagen
docker tag $IMAGE_ID $IMAGE_NAME
done

# Desplegar la stack
cd $STACK_RT
. control.sh up
fi
