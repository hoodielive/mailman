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
#MESSAGE=${@}

debug()
{
  [ "${DEBUG}" = 'true' ] && echo "${@}" >&2 
  return 0 
}

#verbose() 
#{
#  #local MESSAGE="${@}"
#  [ "x${VERBOSE}" = x ] && return; 
#  while [ $# -gt 0 ]; do 
#    echo "script : info: ${1}" 1>&2
#    shift
#  done
#}

verbose() { 
  [ "$VERBOSE" = 'true' ] && log_action_msg "$@"; 
  return 0 
}

log_action_msg () {
    log_action_msg_pre "$@"
    echo "$@." || true
    log_action_msg_post "$@"
}

log_action_msg_pre () { :; }

log_action_msg_post () { :; }

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
  #if [[ "$old_email" =~ $valid_chars  ]]; then #| grep -Eq "$valid_chars"; then 
  #if expr "x$old_email" : "x$valid_chars" > /dev/null; then
  #  verbose "confirming that the old email address meets valid character check"
  #else
  #  debug "test failed"
  #fi
  echo $old_email | egrep -q "^([a-zA-Z0-9])+@(email\.lab)$"
    verbose "confirming that the old email address meets valid character check"
  #if [[ "$new_email" =~ $valid_chars ]]; then 
  if expr "x$new_email" : "x$valid_chars" > /dev/null; then 
    verbose "confirming that the new email address meets valid character check"
  else
    debug "test failed"
  fi
else 
  debug "You have not selected the factor option, so it is skipped over"
fi
