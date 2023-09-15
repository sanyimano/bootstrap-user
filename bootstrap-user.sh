#!/bin/sh
# input parameters jailname username password
# first run bootstrap-sshd.ssh!
# this user will be added to sftponly group
# test Nr of parameters
if [ ! $# -eq 3 ] ; then
  echo " usage bootstrap-user.sh jailname userwebname userwebpasswd"
  exit
fi
JAIL="$1"
echo $JAIL
JAILPATH="/usr/local/bastille/jails/${JAIL}/root"
if [ ! -e ${JAILPATH} ] ; then
  echo "Bad jailname ${JAIL}"
  exit
fi
# add user
USER="$2"
PASSWORD="$3"
# add to stfponly group
GROUP="sftponly"
# test wheather user already added
JAILPATH="/usr/local/bastille/jails/$JAIL/root"
LOCALPATH="/etc/"
FNAME="passwd"
HOMEROOT="/home"
if ! OUTPUT=$(grep  ${USER} ${JAILPATH}${LOCALPATH}${FNAME})
then
 jexec ${JAIL} pw useradd -n ${USER} -m -d ${HOMEROOT}/${USER} -s /bin/sh
 echo ${PASSWORD} | jexec ${JAIL} pw usermod -n ${USER} -h 0
 jexec ${JAIL} pw groupadd -n ${USER}
 jexec -l -U ${USER} ${JAIL} mkdir public_html
 jexec -l -U ${USER} ${JAIL} ssh-keygen -t ecdsa
# these line are for sftpoly access
 jexec ${JAIL} chown  root:wheel ${HOMEROOT}/${USER}
 jexec ${JAIL} pw groupmod -n ${GROUP} -m ${USER}
# comment the next line if you want the user to have shall access
 jexec ${JAIL} pw usermod -n ${USER} -s /usr/sbin/nologin

fi

