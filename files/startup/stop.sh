#!/bin/bash

/etc/init.d/sguild              stop

/etc/init.d/barnyard-sensor     stop
/etc/init.d/sancp-sensor        stop
/etc/init.d/sancp_agent-sensor  stop
/etc/init.d/pads_agent-sensor   stop
/etc/init.d/pcap_agent-sensor   stop
/etc/init.d/snort_agent-sensor  stop
/etc/init.d/sguil_logger-sensor stop
/etc/init.d/snort-sensor        stop
/etc/init.d/pads-sensor         stop

