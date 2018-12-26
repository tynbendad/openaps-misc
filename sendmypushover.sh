#!/bin/bash
title=$1
shift
message="$HOSTNAME: $*"
#echo title=$title, message=$message
token=`grep pushover /root/myopenaps/oref0-runagain.sh | perl -p -e "s/.*pushover_token=\'//; s/\'.*//;"`
user=`grep pushover /root/myopenaps/oref0-runagain.sh | perl -p -e "s/.*pushover_user=\'//; s/\'.*//;"`
#echo token=$token, user=$user
curl -s --form-string "token=$token" --form-string "user=$user" --form-string "title=$title" --form-string "message=$message" https://api.pushover.net/1/messages.json
