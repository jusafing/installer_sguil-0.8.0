#!/bin/bash

# Sguild daemon
/etc/init.d/sguild              start

# Agent daemons
/etc/init.d/sancp_agent-sensor  start
/etc/init.d/pads_agent-sensor   start
/etc/init.d/pcap_agent-sensor   start
/etc/init.d/snort_agent-sensor  start
/etc/init.d/sguil_logger-sensor start

# Sensor daemons
/etc/init.d/snort-sensor        start
/etc/init.d/pads-sensor         start
/etc/init.d/barnyard-sensor     start
/etc/init.d/sancp-sensor        start

