logfiledir=/var/log/openaps
logfilename=xdrip-reset-log.txt
minutes=14
xdrip_errors=`find ~/myopenaps/monitor/xdripjs -mmin -$minutes -type f -name "*entry.json" | grep entry.json; find $logfiledir -mmin -$minutes -type f -name $logfilename`
#can we also check for ns bg?: find ~/myopenaps/cgm -mmin -$minutes -type f -name ns-glucose.json
if [ -z "$xdrip_errors" ]
then
  logfile=$logfiledir/$logfilename
  date >> $logfile
  echo "no entry.json for $minutes minutes - rebooting" | tee -a $logfile
  wall "Rebooting to fix xdrip-js!"
  cd ~/myopenaps && /etc/init.d/cron stop && killall -g openaps ; killall -g oref0-pump-loop | tee -a $logfile
  sleep 5
  reboot
fi
