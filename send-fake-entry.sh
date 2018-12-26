#!/bin/bash
sed -e "s/DATESTRINGHERE/`date "+%Y-%m-%dT%H:%M:%S%Z"`/; s/DATEHERE/`date +%s%3N`/;" ~/fake-entry.json > /tmp/fake-entry-tmp.json
/usr/local/bin/g5-post-ns /tmp/fake-entry-tmp.json
