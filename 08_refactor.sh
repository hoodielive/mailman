#!/usr/bin/env sh

# Unset Vars 
unset APPNAME; 
unset DEBUG; 
unset VERSION; 
unset DRY;
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

debug() 
{
  [ "${DEBUG}" = 'true' ] && echo "${@}" >&2 
  return 0 
}

verbose() 
{
  if [ "$VERBOSE" = 'true' ]; then
    sleep 1
    echo "$*." || VERBOSE=false; echo
  fi
  return 0
}

while getopts "hdvVnf:" opt; do
  case ${opt} in
     h) HELP='true'; usage ;; 
     d) DEBUG='true' ;;
     v) VERBOSE='true' ;; 
     V) verbose "Requested version of ${APPNAME}"; echo "${APPNAME}" "${VERSION}";  exit;; 
     n) DRY='true'; set -vn ;; 
     f) REFACTOR=$OPTARG ;;
     *) usage; exit ;; 
  esac 
done 

shift $((OPTIND -1))

verbose "Option Parsing" 
# parse email address args, query old
# subscriptions, bind results from queries to the new email address.
if [ ! -z "$REFACTOR" ]; then
  verbose "checking $OLD_EMAIL and $NEW_EMAIL"

  if  echo "$OLD_EMAIL" | grep -E -q "$VALID_CHARS"; then  
    verbose "$OLD_EMAIL meets the valid email requirement"
  else
    verbose "$OLD_EMAIL does NOT meet the requirement for email addresses"
    debug "$OLD_EMAIL does NOT meet validation, please check requirements"
    exit 13
  fi

  if echo "$NEW_EMAIL" | grep -E -q "$VALID_CHARS"; then 
    verbose "$NEW_EMAIL meets the valid email requirement"
  else
    verbose "$NEW_EMAIL does NOT meet the requirement for email addresses"
    debug "$NEW_EMAIL does NOT meet validation, please check requirements"
    exit 13
  fi


# Query OLD email subscriptions. 

if sudo -u list "${FIND_MEMBER}" "$OLD_EMAIL"; then
   verbose "Found ${OLD_EMAIL} subscriptions" 
else 
   DEBUG=true 
   debug "$OLD_EMAIL does NOT seem to be subscribed to any lists"
   exit 13
fi

sudo -u list "${FIND_MEMBER}" "$OLD_EMAIL" | grep -v "found" | while read -r lists; do
  verbose "Migrating ${OLD_EMAIL} lists to ${NEW_EMAIL}"
  verbose "${NEW_EMAIL} now subscribed to $lists"
  echo "$NEW_EMAIL" | sudo -u list "${ADD_MEMBER}" --regular-members-file=- --admin-notify=n "$lists"
done

 verbose "Migration complete"

else 
  DEBUG=true
  debug "Could not migrate member."
  exit 13
fi 

# Delete old email address. 
verbose "Now that $OLD_EMAIL lists have been migrated, lets purge $OLD_EMAIL" 

echo "$OLD_EMAIL" | sudo -u list "$REMOVE_MEMBER" --file=- --fromall --nouserack --noadminack

# Confirm that old email address has been deleted, let us know if it's not. 
if sudo -u list "$REMOVE_MEMBER" "$OLD_EMAIL" -a "$?" -eq 1; then
   verbose "$OLD_EMAIL is now deleted"
 else
   DEBUG=true
   debug "$OLD_EMAIL is not deleted"
fi
