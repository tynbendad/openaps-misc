oref0 0.6.2 (also known as oref1 or OpenAPS "master" branch) on an Explorer-Edison rig is nearly perfect. However, these two enhancements will help you keep a BT connection more consistently, and keep the rig active (vs hung) more often.

1. oref0-online is a script that OpenAPS executes regularly to keep your WiFi and BT connections alive and updated. My version of this script updates it to keep the BT connection open more often and consistently. These changes were submitted to dev branch and are part of 0.7 release, but 0.6.2 needs them as well.
   1. Enter these commands on your rig (it helps to copy and paste each one so you don't make any typos):
       ```
       exefile=`which oref0-online`
       cp -p $exefile ${exefile}.backup1
       wget https://raw.githubusercontent.com/tynbendad/openaps-misc/master/oref0-online $exefile
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
       
