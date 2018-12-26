## update openaps install - see https://openaps.readthedocs.io/en/latest/docs/Customize-Iterate/update-your-rig.html
## update Logger install - see https://github.com/xdrip-js/Logger/blob/dev/README.md
## reboot in case of kernel panics (vs rig just hangs by default):
```
vi /etc/sysctl.conf
```
add a line immediately after the top block of comments:
```
kernel.panic = 3
```

## non-pulled openaps updates:
### oref0-online updates for "bt_with_wifi" and "bt_offline" (an earlier version of these changes are in dev 0.7 but not 0.6.2):
```
 cd /usr/local/bin
 cp -p oref0-online oref0-online.sh.backup1
 scp root@192.168.1.110:/usr/local/bin/oref0-online .
```

## non-pulled logger updates (changes are already in Logger's master branch as of 12/24/2018 - this is just here for reference, ignore for now):
```
 cp -p xdrip-get-entries.sh  xdrip-get-entries.sh.orig
 scp root@192.168.1.110:/root/src/Logger/xdrip-get-entries.sh ./xdrip-get-entries.sh.110
```

## copy latest preferences and xdrip settings:
```
 cd ~/myopenaps
 cp -p preferences.json preferences.json.backup1
 scp root@192.168.1.110:/root/myopenaps/preferences.json .
 cp -p xdripjs.json xdripjs.json.backup1
 scp root@192.168.1.110:/root/myopenaps/xdripjs.json .
 <also check that pump.ini has latest pump serial #>
 cd ~/myopenaps/monitor/xdripjs
 cp -p calibrations.csv calibrations.csv.backup1
 scp root@192.168.1.110:/root/myopenaps/monitor/xdripjs/calibrations.csv .
 cp -p calibration-linear.json calibration-linear.json.backup1
 scp root@192.168.1.110:/root/myopenaps/monitor/xdripjs/calibration-linear.json .
```

## get latest autotune settings:
```
 cd ~/myopenaps/settings
 cp -p autotune.json autotune.json.backup1
 scp root@192.168.1.110:/root/myopenaps/settings/autotune.json .
 cd ~/myopenaps/autotune
 cp -p profile.json profile.json.backup1
 scp root@192.168.1.110:/root/myopenaps/autotune/profile.json .
 cp -p profile.pump.json profile.pump.json.backup1
 scp root@192.168.1.110:/root/myopenaps/autotune/profile.pump.json .
```

## get latest versions of my local scripts:
### for sending a daily summary of autotune via pushover:
```
 scp root@192.168.1.110:/root/sendautotunepushover.sh .
 scp root@192.168.1.110:/root/summarize_autotune.sh .
 scp root@192.168.1.110:/root/sendmypushover.sh .
```
### for sending a pushover when inet addresses change:
```
 scp root@192.168.1.110:/root/sendinetpushover.sh .
```
### for rebooting rig if no bg for 15 minutes, since xdrip-js can get stuck:
```
 scp root@192.168.1.110:/root/xdrip-js-monitor.sh .
```
### for deleting old NS entries, treatments, devicedata, so mlab doesn't fill up - requires NS v11 dev branch:
```
 scp root@192.168.1.110:/root/delete_old_ns.sh .
```
### for adding fake entry to NS in case no CGM data has been in use for >2 days, otherwise NS will stop displaying properly:
```
 scp root@192.168.1.110:/root/send-fake-entry.sh .
 scp root@192.168.1.110:/root/fake-entry.json .
```

## update crontab:
```
 select-editor
 <choose your favorite editor>
 crontab -e
```
add lines:
```
0 10 * * * /root/sendautotunepushover.sh
*/15 * * * * /root/sendinetpushover.sh 2>&1 >> /var/log/openaps/inetpushover.log
*/5 * * * * /root/xdrip-js-monitor.sh 2>&1 >> /dev/null
0 22 * * * /root/delete_old_ns.sh 2>&1 >> /var/log/openaps/delete_old_ns.log
```
also check there are uptodate crontab lines for Logger, flask...
