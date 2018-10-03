#!/usr/bin/env bash 

set -x 

OLD_EMAIL=$1
NEW_EMAIL=$2 
VALID_CHARS="([a-zA-Z])+@(email\.lab|penguin\.lab)$"

if [[ $OLD_EMAIL =~ $VALID_CHARS ]] && [[ $NEW_EMAIL =~ $VALID_CHARS ]]; then 
  sudo -u mailman /usr/lib/mailman/bin/find_member "$OLD_EMAIL" 2>/dev/null | while read lists; do
    lists=$lists
    [[ $lists == *found* ]] && continue 
    echo $NEW_EMAIL | sudo -u mailman /usr/lib/mailman/bin/add_members --regular-members-file=-  --admin-notify=n "$lists"
    echo "$NEW_EMAIL now subscribed to $lists"
  done
  # now purge this email address
  echo $OLD_EMAIL | sudo -u mailman /usr/lib/mailman/bin/remove_members --file=- --fromall --nouserack --noadminack
  echo "$OLD_EMAIL is now deleted"
else 
  exit 200
fi 
