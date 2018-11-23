#!/bin/bash

# AUTOR: Julio Teran <teranj@daycohost.com>
# USO: Restaura contenedor desde el archivo .tar de la
# imagen respaldada (snapshot) del contenedor.

# Ruta de Respaldo
BACKUP_PATH="/var/lib/docker-backup/containers"

# Contenedores disponibles para restauracion
echo ""
echo "Contenedores disponibles para restaurar:"
CONT_BK=`ls -1 "$BACKUP_PATH"`
echo -e "$CONT_BK"

#
# Introducir nombre del contenedor a restaurar
echo "Introduzca el nombre del contenedor a restaurar:"
read CONT_RT
echo

# Verificar si imagen de contenedor ya existe
docker images --format "{{.Repository}}" | grep $CONT_RT$

if [ $? -eq 0  ]
then
echo "¿Desea eliminar la imagen actual? si - no"
read ANSW
	if [ "$ANSW" == "si" ]
		then
		docker rmi -f $CONT_RT #Eliminar imagen anterior del contenedor a restaurar
	fi
	if [ "$ANSW" == "no" ]
		then
		echo ""
	fi
fi

# Crear imagen desde el archivo .tar del contenedor
docker load -i $BACKUP_PATH/$CONT_RT/$CONT_RT-BACKUP.tar 

# Mostrar el ID de la nueva imagen
IMAG_ID=`docker images -f "dangling=true" -q`

# Establecer nombre a la nueva imagen con el nombre del contenedor
docker tag $IMAG_ID $CONT_RT

# Crear el contenedor con la imagen creada
docker run -it -d --name $CONT_RT $IMAG_ID
