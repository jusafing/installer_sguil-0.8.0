#!/bin/sh
SENSOR=agente1
SNORTLOG="/nsm/$SENSOR/snortlog"
cd /nsm/etc/
# As a daemon
barnyard -D -c barnyard.conf -g gen-msg.map -s sid-msg.map -f snort.log -w $SNORTLOG/waldo.file -p classification.config -X /var/run/sguil/barnyard-$SENSOR.pid -L $SNORTLOG -a $SNORTLOG -d $SNORTLOG

####################################################################################
#barnyard -D -c barnyard.conf -d /var/log/snort-sensoruno -g gen-msg.map -s sid-msg.map -f snort.log -w /nsm/$SENSOR/snort-sensoruno/waldo.file
# In foreground
#barnyard -c barnyard.conf -d /var/log/snort-sensoruno -g gen-msg.map -s sid-msg.map -f snort.log -w /nsm/$SENSOR/waldo.file

