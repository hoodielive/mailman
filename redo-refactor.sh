#!/usr/bin/env bash 

OLD_EMAIL=$1
NEW_EMAIL=$2 
VALID_CHARS="([a-zA-Z])+@(email\.lab|penguin\.lab)$"

usage() { 
cat << EOF 
usage: $0 options [old_email] [new_email]

Description of Requirements: 
  1. The first argument must be the old email address 
  2. The second argument must be the new email address

The script will query mailing lists that the current user email address is subscribed to, then it will migrate
those subscriptions to the new user email address.

EOF
}

# parse email address args, query old subscriptions, bind results from queries to the new email address 
if [[ $OLD_EMAIL =~ $VALID_CHARS ]] && [[ $NEW_EMAIL =~ $VALID_CHARS ]]; then 
  sudo -u mailman /usr/lib/mailman/bin/find_member "$OLD_EMAIL" | while read lists; do
    lists=$lists
    [[ $lists == *found* ]] && continue 
    echo $NEW_EMAIL | sudo -u mailman /usr/lib/mailman/bin/add_members --regular-members-file=- --admin-notify=n "$lists"
    echo "$NEW_EMAIL now subscribed to $lists"
  done
  # now purge this email address
  echo $OLD_EMAIL | sudo -u mailman /usr/lib/mailman/bin/remove_members --file=- --fromall --nouserack --noadminack
  echo "$OLD_EMAIL is now deleted"
else 
  usage
  exit 200
fi 
