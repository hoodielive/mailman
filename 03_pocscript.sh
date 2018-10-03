#!/bin/bash

unset verbose; 
unset APPNAME; 

verbose=false; 
APPNAME=$(basename $0)

verbose() 
{
  [ "x${verbose}" = x ] && return; 
  while [ $# -gt 0 ]; do 
    echo "${APPNAME}: info: ${1}" 1>&2 
    shift 
  done
}


while getopts :v opt; do 
  case "x${opt}" in 
    xv)
      verbose=true
      ;;
    *)
      echo "thanks"
  esac
done

if [[ "$verbose" ]]
then
  verbose "This is working or not"
else
  echo "Doesn't work"
fi
