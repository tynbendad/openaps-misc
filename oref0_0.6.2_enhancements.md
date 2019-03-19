oref0 0.6.2 (also known as oref1 or OpenAPS "master" branch) on an Explorer-Edison rig is nearly perfect. However, these enhancements will help you keep a BT connection more consistently (1), keep the rig active (vs hung) more often (2), and keep your mlab database from ever filling up (3).

1. oref0-online is a script that OpenAPS executes regularly to keep your WiFi and BT connections alive and updated. My version of this script updates it to keep the BT connection open more often and consistently. These changes were submitted to dev branch and are part of 0.7 release, but 0.6.2 needs them as well.
   1. Enter these commands on your rig (it helps to copy and paste each one so you don't make any typos):
       ```
       cd ~
       exefile=`which oref0-online`
       cp -p $exefile ${exefile}.backup1
       wget https://raw.githubusercontent.com/tynbendad/openaps-misc/master/oref0-online -O oref0-online
       
       ```
   1. Edit /root/myopenaps/preferences.json (using either vi or nano, as you prefer), and add these two new preferences to the end, but before the final "}":
       ```
       "bt_with_wifi": true,
       "bt_offline": true
       
       ```
       These will help keep your rig connected to your phone via BT even if the rig is already connected to the internet via WiFi (turn "bt_with_wifi" to false, or remove it, if you don't want that), and keep your rig connected to BT even if it can't get to the internet (useful for accessing the rig's internal web page via its BT IP address).

1. By default jubilinux will hang after a system or driver fault (also known as a "kernel panic"), and unfortunately the jubilinux BT driver (bnep0) often causes these panics. Fortunately, you can change jubilinux's behavior to instead reboot the system whenever a fault occurs, with just a small change (this is likely going to be a part of the 0.7 install script, but isn't part of 0.6.2 so you must manually do it):
   * Edit /etc/sysctl.conf with either vi or nano, and add a line anywhere after the top block of comments (comment lines start with a "#"):
       ```
       kernel.panic = 3
       
       ```
 1. Nightscout databases fill up quickly with a running loop. Instead of being confused why your site isn't updating (after first wondering if your loop has stopped), you can proactively remove old data from mlab through the recent Nightscout release updates to the delete REST APIs, right on your rig, daily with a simple script and crontab entry:
    1. Fetch the script to your rig with these commands:
        ```
        cd ~
        wget https://raw.githubusercontent.com/tynbendad/openaps-misc/master/delete_old_ns.sh -O delete_old_ns.sh
        perl -pi -e 's/\r\n/\n/g' delete_old_ns.sh
        chmod +x ./delete_old_ns.sh
        
        ```
    1. Look the script over with your favorite editor (e.g., `vi delete_old_ns.sh`) and make sure you agree with the time ranges it is going to delete - change them if you want to save more or less data... By default the script is saving 52 weeks (1 year) of BG data (entries) and treatments (insulin/carbs/sensors and cannula changes/etc), and only 3 weeks of devicestatus (loop status and CGM status). This is what worked for me, but my CGM uploader is logger/xdrip-js which may store more or less devicestatus than yours... Also check out the OpenAPS data commons and consider contributing your data before deleting it - https://openaps.org/outcomes/data-commons/ .
    1. Add a crontab entry to run the script daily, by using `crontab -e` which should open your favorite editor (if it doesn't choose your preferred editor you can exit without saving and use `select-editor` to change the editor). The line you should add to the end of the file is:
        ```
        25 18 * * * /root/delete_old_ns.sh 2>&1 >> /var/log/openaps/delete_old_ns.log
        
        ```
        (You can change the first two values to start at a different time, this example has it running daily at 6:25PM. You might want to change it if you have multiple rigs so they don't all bombard your Nightscout site at the same time).
    1. The next day (or right now if you choose to manually run it right away with `/root/delete_old_ns.sh 2>&1 >> /var/log/openaps/delete_old_ns.log`) you should check the log to make sure the commands worked, e.g., `cat /var/log/openaps/delete_old_ns.log`. You should see something like this (the "n" number is how many database records were deleted):
        ```
        deleting entries before 2018-03-19T18:25-0600...
        {"n":0,"opTime":{"ts":"6669891353771507713","t":12},"electionId":"7fffffff000000000000000c","ok":1,"operationTime":"6669891353771507713","$clusterTime":{"clusterTime":"6669891353771507713","signature":{"hash":"cEfu+aHX6lrrFC0SM9FuuxwfcxI=","keyId":"6628743123239436289"}}}
        deleting treatments before 2018-03-19T18:25-0600...
        {"n":9,"opTime":{"ts":"6669891392426213385","t":12},"electionId":"7fffffff000000000000000c","ok":1,"operationTime":"6669891392426213385","$clusterTime":{"clusterTime":"6669891392426213385","signature":{"hash":"P+hgrT3pNB9+t46Mo2eSrSkXlQY=","keyId":"6628743123239436289"}}}
        deleting devicestatus before 2019-02-25T17:25-0700...
        {"n":1032,"opTime":{"ts":"6669891405311116296","t":12},"electionId":"7fffffff000000000000000c","ok":1,"operationTime":"6669891405311116296","$clusterTime":{"clusterTime":"6669891405311116296","signature":{"hash":"B1buy+elxguRJCXtGdBvl/XKQxw=","keyId":"6628743123239436289"}}}
        ```
