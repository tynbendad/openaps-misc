#!/bin/bash
#
deletefrom=`date -d "3 years ago" -Iminutes`
deleteto=`date -d "70 weeks ago" -Iminutes`
echo "deleting entries..."
echo "deletefrom=$deletefrom"
echo "deleteto=$deleteto"
curl --compressed -f -m 30 -s -X DELETE -H "API-SECRET: $API_SECRET" "$NIGHTSCOUT_HOST/api/v1/entries/sgv.json?find%5bdateString%5d%5b\$lte%5d=$deleteto&find%5bdateString%5d%5b\$gte%5d=$deletefrom"
echo "deleting treatments..."
echo "deletefrom=$deletefrom"
curl --compressed -f -m 30 -s -X DELETE -H "API-SECRET: $API_SECRET" "$NIGHTSCOUT_HOST/api/v1/treatments.json?find%5bcreated_at%5d%5b\$lte%5d=$deleteto&find%5bcreated_at%5d%5b\$gte%5d=$deletefrom"
##
deleteto=`date -d "26 weeks ago" -Iminutes`
echo "deleting all but 26 weeks of devicestatus..."
echo "deletefrom=$deletefrom"
echo "deleteto=$deleteto"
#echo 'curl --compressed -f -m 30 -s -X DELETE -H "API-SECRET: $API_SECRET" "$NIGHTSCOUT_HOST/api/v1/devicestatus.json?find%5bcreated_at%5d%5b\$lte%5d=$deleteto&find%5bcreated_at%5d%5b\$gte%5d=$deletefrom"'
curl --compressed -f -m 30 -s -X DELETE -H "API-SECRET: $API_SECRET" "$NIGHTSCOUT_HOST/api/v1/devicestatus.json?find%5bcreated_at%5d%5b\$lte%5d=$deleteto&find%5bcreated_at%5d%5b\$gte%5d=$deletefrom"
