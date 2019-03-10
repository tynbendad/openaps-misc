#!/bin/bash
#
deletefrom=`date -d "3 years ago" -Iminutes`
deleteto=`date -d "52 weeks ago" -Iminutes`
echo "deleting entries before $deleteto..."
curl --compressed -f -m 30 -s -X DELETE -H "API-SECRET: $API_SECRET" "$NIGHTSCOUT_HOST/api/v1/entries/sgv.json?find%5bdateString%5d%5b\$lte%5d=$deleteto&find%5bdateString%5d%5b\$gte%5d=$deletefrom"
echo
echo "deleting treatments before $deleteto..."
curl --compressed -f -m 30 -s -X DELETE -H "API-SECRET: $API_SECRET" "$NIGHTSCOUT_HOST/api/v1/treatments.json?find%5bcreated_at%5d%5b\$lte%5d=$deleteto&find%5bcreated_at%5d%5b\$gte%5d=$deletefrom"
echo
##
deleteto=`date -d "3 weeks ago" -Iminutes`
echo "deleting devicestatus before $deleteto..."
curl --compressed -f -m 30 -s -X DELETE -H "API-SECRET: $API_SECRET" "$NIGHTSCOUT_HOST/api/v1/devicestatus.json?find%5bcreated_at%5d%5b\$lte%5d=$deleteto&find%5bcreated_at%5d%5b\$gte%5d=$deletefrom"
echo
