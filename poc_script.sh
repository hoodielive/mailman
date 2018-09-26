#!/bin/bash 

usage() {
  echo "script.sh [options] arg1 arg2"
}

while getopts "hupd:" flag; do
  case "$flag" in
    h) 
      hostname=$OPTARG;; 
    u) 
      username=$OPTARG;; 
    p) 
      password=$OPTARG;; 
    d) 
      database=$OPTARG;; 
  esac
done

#ARG1=${@:$OPTIND:1}
#ARG2=${@:$OPTIND+1:1}
#shift $(($OPTIND -1));

for i in $(seq 2 $OPTIND)
do
  shift 
done

