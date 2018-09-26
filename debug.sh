#!/bin/bash 

function debug {
  [ "${debug}" = 'true' ] && echo "${@}" >&2 
  return 0
}

debug='false'

debug "Setting name to '${1}' as sent by user."
name="${1}"

debug "Attempting to run grep to find the specified name."
grep "${name}" data || debug "(Warning): Found no instances of '${name}' in the data file."

exit 0 
