#!/bin/bash 

usage() {
  echo "script.sh [options] arg1 arg2"
}

while getopts "h:u:p:d:" flag; do
  case "$flag" in
    h) HOSTNAME=$OPTARG;; 
    u) USERNAME=$OPTARG;; 
    p) PASSWORD=$OPTARG;; 
    d) DATABASE=$OPTARG;; 
  esac
done

#ARG1=${@:$OPTIND:1}
#ARG2=${@:$OPTIND+1:1}

shift $(($OPTIND -1));

if [[ "$#" -ne 2 ]]
then
  usage
  exit 220 
fi

if [[ "$HOSTNAME" ]]
then
  echo "Hostname is: HOSTNAME" 
else
  usage 
  exit 221 
fi

if [[ "$USERNAME" ]]
then
  echo "You are user $(echo $USER)"
else 
  usage 
  exit 222 
fi

if [[ "$PASSWORD" ]]
then
  echo "Your password is: doodle"
else
  usage 
  exit 223 
fi

if [[ "$DATABASE" ]]
then
  echo "This is a database called: mongodb"
else
  echo "Something went wrong"
  usage
  exit 224
fi


