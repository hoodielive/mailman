#!/bin/sh 

sudo -u list /usr/lib/mailman/bin/find_member $1 | grep -v "found" | while read lists; do 
    echo $lists
done
