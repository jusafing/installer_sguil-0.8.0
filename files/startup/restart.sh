#!/bin/bash

# Sguild daemon
/etc/init.d/sguild              restart

# Agent daemons
/etc/init.d/sancp_agent-sensor  restart
/etc/init.d/pads_agent-sensor   restart
/etc/init.d/pcap_agent-sensor   restart
/etc/init.d/snort_agent-sensor  restart
/etc/init.d/sguil_logger-sensor restart

# Sensor daemons
/etc/init.d/snort-sensor        restart
/etc/init.d/pads-sensor         restart
/etc/init.d/barnyard-sensor     restart
/etc/init.d/sancp-sensor        restart

