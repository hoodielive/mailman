#!/usr/bin/env sh

# Unset Vars 
unset APPNAME; 
unset DEBUG; 
unset VERSION; 
unset DRY;
unset QUIET;
unset OLD_EMAIL; 
unset NEW_EMAIL;
unset VALID_CHARS; 
unset FIND_MEMBER; 
unset ADD_MEMBER; 
unset REMOVE_MEMBER; 

# Set Vars 
APPNAME="userid-refactor"
DEBUG=false; 
VERSION="0.1.0"
DRY=false;
QUIET=false;
OLD_EMAIL=$2
NEW_EMAIL=$3
VALID_CHARS="^([a-zA-Z0-9])+@(email\.lab|penguin\.lab)$"
FIND_MEMBER="/usr/lib/mailman/bin/find_member"
ADD_MEMBER="/usr/lib/mailman/bin/add_members"
REMOVE_MEMBER="/usr/lib/mailman/bin/remove_members"

# Functions 
usage() {
cat << EOF
Usage: userid-refactor [-h help] [-d DEBUG] [-v verbose] [-f refactor]

DESCRIPTION

-h returns usage information

-d turns on DEBUG mode

-v turns on verbosity

-V version number

-n dry-run

-f migrate old-email-address lists to new-email-adddress lEists

EOF
}

debug() {
  [ "${DEBUG}" = 'true' ] && echo "${@}" >&2 
  return 0 
}

verbose() {
  local MESSAGE="${@}"
  if [ "${VERBOSE}" = 'true' ]; then
    echo ${MESSAGE}
  fi
}

verbose "Option Parsing"
while getopts "hdvVnf:" opt; do
  case ${opt} in
     h) HELP='true'; usage ;; 
     d) DEBUG='true' ;;
     v) VERBOSE='true' ;; 
     V) echo "${APPNAME}" "${VERSION}"; exit;; 
     n) DRY='true'; set -vn && verbose "steps" ;; 
     f) REFACTOR=$OPTARG ;;
     *) usage; exit ;; 
  esac 
done 

shift $((OPTIND -1))

# parse email address args, query old subscriptions, bind results from queries to the new email address
if [ ! -z "$REFACTOR" ] && [[ $OLD_EMAIL =~ $VALID_CHARS ]] && [[ $NEW_EMAIL =~ $VALID_CHARS ]]; then
   debug "Checking if valid characters were passed to ${APPNAME}"
   sudo -u list "${FIND_MEMBER}" "$OLD_EMAIL" | while read lists; do
   verbose "Find ${OLD_EMAIL} subscriptions" 
   debug "${OLD_EMAIL} was not found"
     [[ $lists == *found* ]] && continue
     verbose "Migrating ${OLD_EMAIL} lists to ${NEW_EMAIL}"
     echo $NEW_EMAIL | sudo -u list "${ADD_MEMBER}" --regular-members-file=- --admin-notify=n "$lists"
     debug "Could not migrate ${NEW_EMAIL} to ${lists} please check ${NEW_EMAIL}"
     verbose "${NEW_EMAIL} now subscribed to ${lists}"
   done
fi
# now purge this email address
verbose "Attempting to Remove ${OLD_EMAIL}" 

#echo $OLD_EMAIL | sudo -u list "${REMOVE_MEMBER}" --file=- --fromall --nouserack --noadminack
#
#if  "sudo -u list $(${REMOVE_MEMBER} ${OLD_EMAIL})"  && [ "$?" -eq 1 ]; then
#   verbose "$OLD_EMAIL is now deleted"
#else
#   debug "${OLD_EMAIL} is not deleted"
#fi
