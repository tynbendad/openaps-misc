cd ~/myopenaps/autotune
ls -1tr autotune.*.log | tail -1 | xargs -i -r ~/summarize_autotune.sh {} | xargs -r ~/sendmypushover.sh
