#!/bin/bash

echo    "[ CLEAN_ANALYZER ]  Stopping SGUIL" 		   && /etc/init.d/analyzer stop
echo -n "[ CLEAN_ANALYZER ]  Cleaning /nsm/archive/  ... " && rm -rf /nsm/archive/*	     && echo "OK" 
echo -n "[ CLEAN_ANALYZER ]  Cleaning /nsm/load      ... " && rm -rf /nsm/load/*             && echo "OK"
echo -n "[ CLEAN_ANALYZER ]  Cleaning /nsm/dailylogs ... " && rm -rf /nsm/SENSORNAME/dailylogs/* && echo "OK"
echo -n "[ CLEAN_ANALYZER ]  Cleaning /nsm/sancp     ... " && rm -rf /nsm/SENSORNAME/sancp/*     && echo "OK"
echo -n "[ CLEAN_ANALYZER ]  Cleaning /nsm/snortlog  ... " && rm -rf /nsm/SENSORNAME/snortlog/*  && echo "OK"
echo -n "[ CLEAN_ANALYZER ]  Cleaning /nsm/SENSORNAME    ... " && rm -rf /nsm/SENSORNAME/snort.stats && echo "OK"
echo    "[ CLEAN_ANALYZER ]  Cleaning DB                 " && /nsm/scripts/cleandb.sh        
echo    "[ CLEAN_ANALYZER ]  Starting SGUIL" 		   && /etc/init.d/analyzer start     && echo "OK"


