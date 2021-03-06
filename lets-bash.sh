#!/bin/sh

unset REFACTOR; 
unset DEBUG; 
unset VERBOSE;

old_email="$2"
new_email="$3"
valid_chars="^([a-zA-Z0-9])+@(email\.lab)$"
REFACTOR=""
DEBUG=false
VERBOSE=false

debug()
{
  [ "${DEBUG}" = 'true' ] && echo "${@}" >&2 
  return 0 
}

verbose() 
{
  local MESSAGE="${@}"
  if [ "${VERBOSE}" = 'true' ]; then 
    echo "${MESSAGE}"
  fi
}

while getopts "hdvf:" opt; do 
  case $opt in 
    h) 
      echo "usage"
      ;; 
    d)
      DEBUG='true'
      ;;
    v)
      VERBOSE='true'
      ;;
    f)
      REFACTOR=$OPTARG
      ;;
    *)
      echo "Follow the rules yo!"
      ;;
  esac
done

shift $((OPTIND - 1))

if [ ! -z "$REFACTOR" ]; then 
  if [[ "$old_email" =~ $valid_chars  ]]; then 
    verbose "confirming that the old email address meets valid character check"
  else
    debug "test failed"
  fi

  if [[ "$new_email" =~ $valid_chars ]]; then 
    verbose "confirming that the new email address meets valid character check"
  else
    debug "test failed"
  fi
else 
  debug "You have not selected the factor option, so it is skipped over"
fi
