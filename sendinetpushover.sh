#!/bin/bash
# usage, in crontab: */15 * * * * /root/sendinetpushover.sh
#
ifconfig bnep0 | awk '/inet addr:/ {print $2} ' > /var/tmp/inetaddrs.bnep0.txt.new
ifconfig wlan0 | awk '/inet addr:/ {print $2} ' > /var/tmp/inetaddrs.wlan0.txt.new
grep "addr:" /var/tmp/inetaddrs.bnep0.txt.new
if [ $? == 0 ]
then
    diff /var/tmp/inetaddrs.bnep0.txt.new /var/tmp/inetaddrs.bnep0.txt
    if [ $? != 0 ]
    then
        echo "change detected in bnep0 addr"
        echo "old:"
        cat /var/tmp/inetaddrs.bnep0.txt
        echo "new:"
        cat /var/tmp/inetaddrs.bnep0.txt.new
        echo "ifconfig bnep0:"
        ifconfig bnep0
        cat /var/tmp/inetaddrs.bnep0.txt.new | xargs -r ~/sendmypushover.sh "bt inet addr change"
        if [ $? == 0 ]
        then
            mv /var/tmp/inetaddrs.bnep0.txt.new /var/tmp/inetaddrs.bnep0.txt
        fi
    fi
fi
grep "addr:" /var/tmp/inetaddrs.wlan0.txt.new
if [ $? == 0 ]
then
    diff /var/tmp/inetaddrs.wlan0.txt.new /var/tmp/inetaddrs.wlan0.txt
    if [ $? != 0 ]
    then
        echo "change detected in wlan0 addr"
        echo "old:"
        cat /var/tmp/inetaddrs.wlan0.txt
        echo "new:"
        cat /var/tmp/inetaddrs.wlan0.txt.new
        echo "ifconfig wlan0:"
        ifconfig wlan0
        cat /var/tmp/inetaddrs.wlan0.txt.new | xargs -r ~/sendmypushover.sh "wifi inet addr change"
        if [ $? == 0 ]
        then
            mv /var/tmp/inetaddrs.wlan0.txt.new /var/tmp/inetaddrs.wlan0.txt
        fi
    fi
fi
if [ $(bc <<< "$(date +'%M') % 30") -eq 0 ]
then
    tail -300 /var/log/openaps/pump-loop.log| grep -B30 Completed | egrep "enacted|bolused|No .* needed|Completed" | egrep -A1 "enacted|bolused|No .* needed"|tail -2 > /var/tmp/lastloopcheck.txt.new
    diff /var/tmp/lastloopcheck.txt.new /var/tmp/lastloopcheck.txt
    if [ $? == 0 ]
    then
        tail -10 /var/log/openaps/pump-loop.log | xargs -r ~/sendmypushover.sh "no openaps enacts or boluses detected"
        echo "no openaps enacts or boluses detected"
    fi
    mv /var/tmp/lastloopcheck.txt.new /var/tmp/lastloopcheck.txt
fi
echo "done $0"

