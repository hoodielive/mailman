#!/usr/bin/env bash
#set -x
# Unset Vars 
unset debug; 
unset verbose; 
unset OLD_EMAIL; 
unset NEW_EMAIL;
unset VALID_CHARS; 
unset FIND_MEMBER; 
unset ADD_MEMBER; 
unset REMOVE_MEMBER; 

# Set Vars 
debug=false; 
verbose=false; 
OLD_EMAIL=$2
NEW_EMAIL=$3
VALID_CHARS="([a-zA-Z])+@(email\.lab|penguin\.lab)$"
FIND_MEMBER="/usr/lib/mailman/bin/find_member"
ADD_MEMBER="/usr/lib/mailman/bin/add_members"
REMOVE_MEMBER="/usr/lib/mailman/bin/remove_members"

# Functions 
function usage() {
cat << EOF
Usage: userid-refactor [-h help] [-d debug] [-v verbose] [-f refactor]

DESCRIPTION

-h returns usage information

-d turns on debug mode

-v turns on verbosity

-f migrate old-email-address lists to new-email-adddress lists


EOF
}

function help() 
{
  [[ "${help}" = 'true' ]] && usage
  return 0 
}

function debug() 
{
  [[ "${debug}" = 'true' ]] && echo "${@}" >&2 
  return 0 
}

function verbose()
{
  [[ "${verbose}" = 'true' ]] && set -x 
  return 0 
}

while getopts "hdvf:" opt; do
  case ${opt} in
     h) HELP=true ;; 
     d) debug=true ;;
     v) verbose=true ;; 
     f) REFACTOR=$OPTARG ;;
     *) usage; exit ;; 
  esac 
done 

shift $((OPTIND -1))

# Check that 2 args was passed to the script

# print usage to stdout 
if [[ ! -z "$HELP" ]]
then
  usage 
fi

# parse email address args, query old subscriptions, bind results from queries to the new email address
if [[ ! -z "$REFACTOR" ]] && [[ $OLD_EMAIL =~ $VALID_CHARS ]] && [[ $NEW_EMAIL =~ $VALID_CHARS ]] 
then
  verbose
   sudo -u list "${FIND_MEMBER}" "$OLD_EMAIL" | while read lists; do
   verbose debug "Find ${OLD_EMAIL} subscriptions"
     [[ $lists == *found* ]] && continue
     verbose debug "Migrate ${OLD_EMAIL} lists to ${NEW_EMAIL}"
     echo $NEW_EMAIL | sudo -u list "${ADD_MEMBER}" --regular-members-file=- --admin-notify=n "$lists"
     echo "$NEW_EMAIL now subscribed to $lists"
   done
   # now purge this email address
   verbose debug "Delete ${OLD_EMAIL}"
   echo $OLD_EMAIL | sudo -u list "${REMOVE_MEMBER}" --file=- --fromall --nouserack --noadminack
   echo "$OLD_EMAIL is now deleted"
fi
