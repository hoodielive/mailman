#!/bin/bash 

usage() {
  script.sh [options] arg1 arg2 

}

while getopts "h:u:p:d:" flag; do
  case "$flag" in
    h) HOSTNAME=$OPTARG;; 
    u) USERNAME=$OPTARG;; 
    p) PASSWORD=$OPTARG;; 
    d) DATABASE=$OPTARG;; 
  esac
done

ARG1=${@:$OPTIND:1}
ARG2=${@:$OPTIND+1:1}

if [[ "$HOSTNAME" ]]
then
  echo "Hostname is $(hostnamectl)"
else
  echo "something went wrong"
  usage
fi


