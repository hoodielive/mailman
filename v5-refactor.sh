
    #!/usr/bin/env bash
    set -x

    # Unset Vars 
    unset DEBUG; 
    unset OLD_EMAIL; 
    unset NEW_EMAIL;
    unset VALID_CHARS; 
    unset FIND_MEMBER; 
    unset ADD_MEMBER; 
    unset REMOVE_MEMBER; 
    
    # Set Vars 
    DEBUG=
    OLD_EMAIL=$2
    NEW_EMAIL=$3
    VALID_CHARS="^([a-zA-Z0-9])+@(sei\.cmu\.edu|cert\.org)$"
    FIND_MEMBER="/usr/lib/mailman/bin/find_member"
    ADD_MEMBER="/usr/lib/mailman/bin/add_members"
    REMOVE_MEMBER="/usr/lib/mailman/bin/remove_members"
    
    # Functions 
    function usage() {
    cat << EOF
    Usage: userid-refactor [-f refactor] [-h help] [-d debug] [-v verbose] 
    
    DESCRIPTION
    
    -f refactor old-email-address lists to new-email-adddress lists
    
    -h returns usage information
    
    -d turns on debug 
    
    -v turns on verbosity
    
    
    EOF
    }
    
    function DEBUG() 
    {
        [ "$_DEBUG" == "on" ] && $@
    }
    
    
    while getopts "f:hdv" opt; do
      case ${opt} in
         f) REFACTOR=$OPTARG ;;
         h) HELP=true ;; 
         d) DEBUG=on ;;
         v) VERBOSE=true ;; 
         *) usage; exit ;; 
      esac 
    done 
    
    shift $((OPTIND -1))
    
    # Check that 2 args was passed to the script
    
    
    # parse email address args, query old subscriptions, bind results from queries to the new email address
    if [[ ! -z "$REFACTOR" ]] && [[ $OLD_EMAIL =~ $VALID_CHARS ]] && [[ $NEW_EMAIL =~ $VALID_CHARS ]] 
    then
       sudo -u mailman "${FIND_MEMBER}" "$OLD_EMAIL" | while read lists; do
       DEBUG "did user pass in the right stuff?"
         [[ $lists == *found* ]] && continue
         echo $NEW_EMAIL | sudo -u mailman "${ADD_MEMBER}" --regular-members-file=- --admin-notify=n "$lists"
         echo "$NEW_EMAIL now subscribed to $lists"
       done
       # now purge this email address
       echo $OLD_EMAIL | sudo -u mailman "${REMOVE_MEMBER}" --file=- --fromall --nouserack --noadminack
       echo "$OLD_EMAIL is now deleted"
    fi
    
    # print usage to stdout 
    if [[ ! -z "$HELP" ]]
    then
      usage 
    fi
    
    if [[ ! -z "$DEBUG" ]] 
    then
        DEBUG
    fi

