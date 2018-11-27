#!/bin/bash

# AUTOR: Julio Teran <teranj@daycohost.com>
# USO: Copiar ID_RSA para hacer ssh sin solicitud de password

REMOTE_USER=<set_remote_user>
REMOTE_IP=<set_remote_ip>
FILE1=id_rsa
FILE2=id_rsa.pub

cd ~/.ssh

if [ -f $FILE1 ] && [ -f $FILE2 ]
then
	ssh $REMOTE_USER@$REMOTE_IP mkdir -p .ssh
	cat id_rsa.pub | ssh $REMOTE_USER@$REMOTE_IP 'cat >> .ssh/authorized_keys'
	ssh $REMOTE_USER@$REMOTE_IP "chmod 700 .ssh; chmod 640 .ssh/authorized_keys"
	ssh $REMOTE_USER@$REMOTE_IP
else
	ssh-keygen -t rsa
	ssh $REMOTE_USER@$REMOTE_IP mkdir -p .ssh
	cat id_rsa.pub | ssh $REMOTE_USER@$REMOTE_IP 'cat >> .ssh/authorized_keys'
	ssh $REMOTE_USER@$REMOTE_IP "chmod 700 .ssh; chmod 640 .ssh/authorized_keys"
	ssh $REMOTE_USER@$REMOTE_IP
fi
