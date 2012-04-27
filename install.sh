##################################################################################
## This file is free software; as a special exception the author gives		##
## unlimited permission to copy and/or distribute it, with or without		##
## modifications, as long as this notice is preserved.				##
##										##
## This program is distributed in the hope that it will be useful, but		##
## WITHOUT ANY WARRANTY, to the extent permitted by law; without even the	##
## implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	##
##										##
##################################################################################
## Honeynet Project UNAM-Chapter						##
## SSI/UNAM-CERT								##
## honeynet@seguridad.unam.mx							##
## www.seguridad.unam.mx/www.cert.org.mx/www.honeynet.unam.mx			##
##										##
##################################################################################
## Installation script Sguil 0.8.0 on Debian GNU/Linux 6.0 Base  V0.2.0 	##
## By [Javier Santillan] [jsantillan@seguridad.unam.mx, jusafing@gmail.com]	##
## Date [2012-04-18]								##
## ---------------------------------------------------------------------------- ##
## Requirements:								##
##	- Debian GNU/Linux 6.0.x						##
## Abstract:                                                                    ##
## 	This script is an installer of Sguil 0.8.0 server/sensor.               ##
##	Compiles source code tools and install some debian packages in order to ##
##	prepare a Debian base installation as a network traffic analyzer.       ##
##################################################################################

#!/bin/bash

#####################################################################################################
##################################  VERSION CONFIGURATION      ######################################
#######  WARNING: Changes in versions may need changes in functions of the script as well   #########
#####################################################################################################

	ARGS=$#
	DIRECTORY=`pwd` 
	LOG=$DIRECTORY/INSTALL_LOG
	SENSORNAME=$1
	USER="sguil"
	INSTALLER=`whoami`
	TCL="8.4.19"
	TCLx="8.4"
	TCLLIB="1.9"
	TCPFLOW="0.21"
	TCPDUMP="4.1.1"
	OPENSSL="1.0.1"
	TLS="1.6"
	LIBPCAP="1.1.1"
	LIBNET="1.0.2a"
	LIBDNET="1.12"
	SGUILVER="0.8.0"
	MYSQLTCL="3.05"
	SNORT="2.9.2.2"
	RULES="2922"
	DAQ="0.6.2"
	BARNYARD="0.2.0"
	SANCP="1.6.1"
	PADS="pads-1.2-sguil-mods"
	IFACE="eth0"
#####################################################################################################
#####################################################################################################

#####################################################################################################
delete_dirs()
{
	echo "[DELETE_DIRS    ]   Deleting directories" >> $LOG
	echo -n "   > Deleting directory [ /nsm/ ] ... " ;          rm -rf /nsm/archive    && echo "[DELETE_DIRS   ]   Directory [/nsm] has been deleted"            >> $LOG
	echo -n "   > Deleting directory [ /nsm/etc ] ... " ;       rm -rf /nsm/etc        && echo "[DELETE_DIRS   ]   Directory [/nsm/etc] has been deleted"        >> $LOG
	echo -n "   > Deleting directory [ /var/run/sguil ] ... " ; rm -rf /nsm/etc        && echo "[DELETE_DIRS   ]   Directory [/evar/run/sguil] has been deleted" >> $LOG
}
#####################################################################################################
exit_install()
{
	echo
	echo
	echo "[EXIT_INSTALL   ]   The installation script has been terminated with errors" >> $LOG
	echo "[EXIT_INSTALL   ]   The installation script has been terminated with errors"
	echo
	echo
	exit 1
}
#####################################################################################################
exec_install()
{
	if [ $1 -ne 0 ]; then
		echo "[EXEC_INSTALL   ]   ERROR - Installation of $2"            >> $LOG
		exit_install
	else
		echo "[EXEC_INSTALL   ]   The package $2 has been installed OK"  >> $LOG	
	fi
}
#####################################################################################################
banner_log()
{
	echo "######################################" >  $LOG
	echo "###      SGUIL INSTALLATION       ####" >> $LOG
	echo "######################################" >> $LOG
	echo "______________________________________" >> $LOG
	echo "Started @ [`date`]"                     >> $LOG
	echo                                          >> $LOG
	echo                                          >> $LOG
}
#####################################################################################################
make_dirs()
{
	echo "[MAKE_DIRS      ]   Making directories on $SENSORNAME" >> $LOG
	echo "[MAKE_DIRS      ]   > Making directory [ /nsm/archive ] ... " ;               mkdir -p /nsm/archive               &&  echo "[MAKE_DIRS      ]   Directory [/nsm/archive] created OK"               >> $LOG
	echo "[MAKE_DIRS      ]   > Making directory [ /nsm/$SENSORNAME/dailylogs ] ... " ; mkdir -p /nsm/$SENSORNAME/dailylogs &&  echo "[MAKE_DIRS      ]   Directory [/nsm/$SENSORNAME/dailylogs] created OK" >> $LOG
	echo "[MAKE_DIRS      ]   > Making directory [ /nsm/$SENSORNAME/sancp ] ... " ;     mkdir -p /nsm/$SENSORNAME/sancp     &&  echo "[MAKE_DIRS      ]   Directory [/nsm/$SENSORNAME/sancp] created OK"     >> $LOG
	echo "[MAKE_DIRS      ]   > Making directory [ /nsm/$SENSORNAME/snortlog ] ... " ;  mkdir -p /nsm/$SENSORNAME/snortlog  &&  echo "[MAKE_DIRS      ]   Directory [/nsm/$SENSORNAME/snortlog] created OK"  >> $LOG
	echo "[MAKE_DIRS      ]   > Making directory [ /nsm/rules/$SENSORNAME ] ... " ;     mkdir -p /nsm/rules/$SENSORNAME     &&  echo "[MAKE_DIRS      ]   Directory [/nsm/rules/$SENSORNAME] created OK"     >> $LOG
	echo "[MAKE_DIRS      ]   > Making directory [ /nsm/load ] ... " ;                  mkdir -p /nsm/load                  &&  echo "[MAKE_DIRS      ]   Directory [/nsm/load] created OK"                  >> $LOG
	echo "[MAKE_DIRS      ]   > Making directory [ /nsm/mysql ] ... " ;                 mkdir -p /nsm/mysql                 &&  echo "[MAKE_DIRS      ]   Directory [/nsm/mysql] created OK"                 >> $LOG
	echo "[MAKE_DIRS      ]   > Making directory [ /nsm/scripts ] ... " ;               mkdir -p /nsm/scripts               &&  echo "[MAKE_DIRS      ]   Directory [/nsm/scripts] created OK"               >> $LOG
	echo "[MAKE_DIRS      ]   > Making directory [ /nsm/etc ] ... " ;                   mkdir -p /nsm/etc                   &&  echo "[MAKE_DIRS      ]   Directory [/nsm/etc] created OK"                   >> $LOG
	echo "[MAKE_DIRS      ]   > Making directory [ /nsm/etc/certs ] ... " ;             mkdir -p /nsm/etc/certs             &&  echo "[MAKE_DIRS      ]   Directory [/nsm/etc/certs] created OK"             >> $LOG
	echo "[MAKE_DIRS      ]   > Making directory [ /var/run/sguil ] ... " ;             mkdir -p /var/run/sguil             &&  echo "[MAKE_DIRS      ]   Directory [/var/run/sguil] created OK"             >> $LOG
	echo "[MAKE_DIRS      ]   > Making directory [ /var/log/sguild ] ... " ;            mkdir -p /var/log/sguild            &&  echo "[MAKE_DIRS      ]   Directory [/var/log/sguild] created OK"            >> $LOG
}
#####################################################################################################
name_sensor()
{
	echo
	echo "[NAME_SENSOR    ]   Verifying name of sensor" >> $LOG
	echo "[NAME_SENSOR    ]   Verifying name of sensor"
	if [ $ARGS -eq 1 ]
	then
		echo -n " Name of sensor: [$SENSORNAME]  [Y/N]:  "
		read me
		if [ $me != "Y" ]
		then
			echo -n " New name :  "
			read nametmp
			echo "[NAME_SENSOR    ]   The new name of sensor is [$nametmp] "
			SENSORNAME=$nametmp
			echo "[NAME_SENSOR    ]   The name of sensor has been defined: [$SENSORNAME]"	
			echo "[NAME_SENSOR    ]   The name of sensor has been defined: [$SENSORNAME]" >> $LOG	
		fi
	else
		echo "SYNTAX ERROR. You must define the name of sensor ->  ./install.sh SENSORNAME"
		echo "SYNTAX ERROR. You must define the name of sensor ->  ./install.sh SENSORNAME" >> $LOG
		echo 
		exit_install
	fi
}
#####################################################################################################
user_install()
{
	if [ $INSTALLER != "root" ]; then
		echo ""
		echo ""
		echo "#####################################################"
		echo "# You must be root to exec this installation script #"
		echo "#####################################################"
		echo ""
		echo ""
		echo ""
		echo ""
		exit_install
	fi
}

#####################################################################################################
create_user()
{
	su - $USER -c id 2>/dev/null 1>/dev/null

	if [ "$?" -ne "0" ]; then
		echo ""
		echo "[CREATE_USER    ]   Adding user account [$USER]" >> $LOG
		echo "[CREATE_USER    ]   Adding user account [$USER]"

		usermod -G root $USER
		if [ "$?" -ne "0" ]; then
			echo "[CREATE_USER    ]   ERROR -- Adding user account [$USER]" >> $LOG
			echo "[CREATE_USER    ]   ERROR -- Adding user account [$USER]"
			echo ""
			exit_install
		else
			echo "[CREATE_USER    ]   User account [$USER] has been created" >> $LOG
			echo "[CREATE_USER    ]   User account [$USER] has been created"
			echo ""
		fi
	else
		echo "[CREATE_USER    ]   User $USER exists" >> $LOG
	fi
}
##############################################################################
install_aptpkg()
{
	echo "[INSTALL_APTPKG ]   Installing debian packages build-essential libncurses5-dev automake autoconf flex byacc libpcre3 libpcre3-dev " >> $LOG
	cmd="apt-get install build-essential libncurses5-dev automake autoconf flex bison byacc libpcre3 libpcre3-dev zlib1g-dev -y -qq"
	$cmd
    	exec_install $? "APT PACKAGES $cmd"

}
##############################################################################
install_tcl()
{
	cd $DIRECTORY
	echo "[INSTALL_TCL    ]   Installing TCL $TCL..." >> $LOG
	tar -zxvf tcl$TCL-src.tar.gz
	cd tcl$TCL/unix
	./configure --disable-threads
	cmd="make"
	$cmd
	exec_install $? "TCL $cmd"
	cmd="make install"
	$cmd
	exec_install $? "TCL $cmd"
}
##############################################################################
install_tcllib()
{
	cd $DIRECTORY 
	echo "[INSTALL_TCLLIB ]   Installing TCLLIB $TCLLIB..." >> $LOG
	tar -zxvf tcllib-$TCLLIB.tar.gz
	cd tcllib-$TCLLIB
	./configure --prefix=/usr/local/tcllib
	cmd="make"
	$cmd
	exec_install $? "TCLIB $cmd"
	cmd="make install"
	$cmd
	exec_install $? "TCLIB $cmd"
}
##############################################################################
install_tclx()
{
	cd $DIRECTORY 
	echo "[INSTALL_TCLX   ]   Installing TCLx $TCLx..." >> $LOG
	tar -jxvf tclx$TCLx.tar.bz2
	cd tclx$TCLx
	#http://wiki.linuxfromscratch.org/blfs/ticket/1720
	cp configure{,.orig} && sed "s/relid'/relid/" configure.orig > configure
	./configure --with-tcl=/usr/local/lib/ --disable-threads
	cmd="make"
	$cmd
	exec_install $? "TCLx $cmd"
	cmd="make install"
	$cmd
	exec_install $? "TCLx $cmd"
}
##############################################################################
install_openssl()
{
	cd $DIRECTORY
	echo "[INSTALL_OPENSSL]   Installing OPENSSL $OPENSSL..." >> $LOG
	tar -zxvf openssl-$OPENSSL.tar.gz
	cd openssl-$OPENSSL
	./config
	cmd="make"
	$cmd
	exec_install $? "OPENSSL $cmd"
	cmd="make install"
	$cmd
	exec_install $? "OPENSSL $cmd"
}
##############################################################################
install_libpcap()
{
	cd $DIRECTORY
	echo "[INSTALL_LIBPCAP]   Installing LIBPCAP $LIBPCAP..." >> $LOG
	tar -zxvf libpcap-$LIBPCAP.tar.gz
	cd libpcap-$LIBPCAP
	./configure 
	cmd="make"
	$cmd
	exec_install $? "LIBPCAP $cmd"
	make shared
	cmd="make install"
	$cmd
	exec_install $? "LIBPCAP $cmd"
	ldconfig
}
##############################################################################
install_libnet()
{
	cd $DIRECTORY
	echo "[INSTALL_LIBNET ]   Installing LIBNET $LIBNET..." >>  $LOG
	tar -zxvf libnet-$LIBNET.tar.gz 
	cd Libnet-$LIBNET
	./configure --prefix=/usr/local/libnet
	cmd="make"
	$cmd
	exec_install $? "LIBNET $cmd"
	cmd="make install"
	$cmd
	exec_install $? "LIBNET $cmd"
}
##############################################################################
install_tls()
{
	cd $DIRECTORY
	echo "[INSTALL_TLS    ]   Installing TLS $TLS..." >> $LOG
	tar -zxvf tls$TLS-src.tar.gz
	cd tls$TLS
	./configure --with-tcl=/usr/local/lib/ --with-ssl-dir=/usr/local/ssl/
	cmd="make"
	$cmd
	exec_install $? "TLS $cmd"
	cmd="make install"
	$cmd
	exec_install $? "TLS $cmd"
}
##############################################################################
install_libdnet()
{
        cd $DIRECTORY
        echo "[INSTALL_LIBDNET]   Installing LIBDNET $LIBDNET..." >> $LOG
        tar -zxvf libdnet-$LIBDNET.tar.gz
        cd libdnet-$LIBDNET
	./configure
	cmd="make"
	$cmd
	exec_install $? "LIBDNET $cmd"
	cmd="make install"
	$cmd
	exec_install $? "LIBDNET $cmd"
	ldconfig
}	
##############################################################################
install_daq()
{
        cd $DIRECTORY
        echo "[INSTALL_DAQ    ]   Installing DAQ $DAQ..." >> $LOG
        tar -zxvf daq-$DAQ.tar.gz
	cd daq-$DAQ
	./configure 
	cmd="make"
	$cmd
	exec_install $? "DAQ $cmd"
	cmd="make install"
	$cmd
	exec_install $? "DAQ $cmd"
	ldconfig
}
##############################################################################
install_snort()
{
	echo "[INSTALL_SNORT  ]   Installing Snort $SNORT" >> $LOG
	cd $DIRECTORY
	tar -zxvf snort-$SNORT.tar.gz
	cd snort-$SNORT
	export PATH=$PATH:/usr/local/libnet/bin
	./configure  --prefix=/usr/local/snort/
	cmd="make"
	$cmd
	exec_install $? "SNORT $cmd"
	cmd="make install"
	$cmd
	exec_install $? "SNORT $cmd"
#	echo -n "Changing name of i486-linux-gnu to i486-linux-gnu.old ... " >> $LOG && mv /usr/lib/i486-linux-gnu /usr/lib/i486-linux-gnu.old  && echo "OK" >> $LOG

}
##############################################################################
install_pads()
{
	echo "[INSTALL_PADS   ]   Installing PADS $PADS" >> $LOG
	cd $DIRECTORY
	tar -zxvf $PADS.tar.gz
	cd $PADS
	patch -p0 < $DIRECTORY/files/patch/pads.patch
	export LDFLAGS="-L/usr/local/libpcap/lib -Xlinker -rpath -Xlinker /usr/local/libpcap/lib"
 	export CFLAGS="-I/usr/local/libpcap/include"
 	./configure --prefix=/usr/local/pads
 	cmd="make"
	$cmd
	exec_install $? "PADS $cmd" 
 	cmd="make install"
	$cmd
	exec_install $? "PADS $cmd" 
}
##############################################################################
install_sancp()
{
	echo "[INSTALL_SANCP  ]   Installing SANCP $SANCP..." >> $LOG
	cd $DIRECTORY
	tar -zxvf sancp-$SANCP.tar.gz
	cd sancp-$SANCP
	sed -i 's/CFLAGS.*\=.*O3.*/CFLAGS  =  -O3 -s -I\/usr\/local\/libpcap\/include -L\/usr\/local\/libpcap\/lib -Xlinker -rpath -Xlinker \/usr\/local\/libpcap\/lib/' Makefile
	patch < $DIRECTORY/files/patch/sancp-1.6.1.fix200511.a.patch
	patch < $DIRECTORY/files/patch/sancp-1.6.1.fix200511.b.patch
	cmd="make"
	$cmd
	exec_install $? "SANCP $cmd"
	mkdir -p /usr/local/sancp/bin
	cp sancp /usr/local/sancp/bin/
}
##############################################################################
unpack_sguil()
{
	echo "[UNPACK_SGUIL   ]   Unpacking Sguil $SGUILVER files " >> $LOG
	cd $DIRECTORY
	cmd="tar -zxvf sguil-$SGUILVER.tar.gz -C /usr/local/"
	$cmd
	exec_install $? "Unpacking SGUIL $cmd"
}
##############################################################################
install_barnyard()
{
	echo "[INSTALL_BARNYARD]   Installing BARNYARD $BARNYARD..." >> $LOG
	cd $DIRECTORY
	tar -zxvf barnyard-$BARNYARD.tar.gz 
	cd barnyard-$BARNYARD
	cp /usr/local/sguil-$SGUILVER/sensor/barnyard_mods/configure.in .
	cp /usr/local/sguil-$SGUILVER/sensor/barnyard_mods/op_*         src/output-plugins/
	cd src/output-plugins/
	patch -p0 < op_plugbase.c.patch
	cd $DIRECTORY/barnyard-$BARNYARD
	autoconf
	./configure --prefix=/usr/local/barnyard --enable-tcl --with-tcl=/usr/local/lib
	cmd="make"
	$cmd
	exec_install $? "Barnyard   $cmd"
	cmd="make install"
	$cmd
	exec_install $? "Barnyard   $cmd"
	cp etc/barnyard.conf /nsm/etc
}
##############################################################################
install_otherpkg()
{
	echo "[INSTALL_OTHERPKG]   Installing with APT: mysql-server-5.0 p0f libmysqlclient15-dev" >> $LOG
	cmd="apt-get install mysql-server-5.1 p0f libmysqlclient15-dev -y -qq"
	$cmd
	exec_install $? "APT  mysql-server-5.0 p0f libmysqlclient15-dev   $cmd"
}
##############################################################################
install_mysqltcl()
{
	echo "[INSTALL_MYSQLTCL]   Installing MysqlTCL $MYSQLTCL ..." >> $LOG
	cd $DIRECTORY
	tar -zxvf mysqltcl-$MYSQLTCL.tar.gz
	cd mysqltcl-$MYSQLTCL
	cp configure{,.orig} && sed "s/relid'/relid/" configure.orig > configure
	./configure --prefix=/usr/local/mysqltcl --exec-prefix=/usr/local/mysqltcl
	cmd="make"
	$cmd
	exec_install $? "MySQLTCL $cmd"
	cmd="make install"
	$cmd
	exec_install $? "MySQLTCL $cmd"
}
##############################################################################
install_tcpflow()
{
	echo "[INSTALL_TCPFLOW]   Installing Tcpflow $TCPFLOW..." >> $LOG
        cd $DIRECTORY
        tar -zxvf tcpflow-$TCPFLOW.tar.gz
        cd tcpflow-$TCPFLOW
        ./configure --prefix=/usr/local/tcpflow 
        cmd="make"
        $cmd
        exec_install $? "Tcpflow $cmd"
        cmd="make install"
        $cmd
        exec_install $? "Tcpflow $cmd"
}
##############################################################################
install_tcpdump()
{
	echo "[INSTALL_TCPDUMP]   Installing Tcpdump by ATP-GET ..." >> $LOG
	cmd="apt-get install tcpdump"
	$cmd
	exec_install $? "Tcpdump-APT $cmd"
}
##############################################################################
make_links()
{
	echo "[MAKE_LINKS     ]   Generating links to binaries" >> $LOG
  	ln -s /usr/bin/mysql                         /usr/local/bin/  && echo "[MAKE_LINKS     ]   Link: mysql to /usr/local/bin .. OK"            >> $LOG
  	ln -s /usr/bin/mysqladmin                    /usr/local/bin/  && echo "[MAKE_LINKS     ]   Link: mysqladmin to /usr/local/bin .. OK"       >> $LOG
	ln -s /usr/bin/mysqlcheck                    /usr/local/bin/  && echo "[MAKE_LINKS     ]   Link: mysqlcheck to /usr/local/bin .. OK"       >> $LOG
 	ln -s /usr/bin/mysqld_safe                   /usr/local/bin/  && echo "[MAKE_LINKS     ]   Link: mysqld_safe to /usr/local/bin .. OK"      >> $LOG
  	ln -s /usr/bin/mysqldump                     /usr/local/bin/  && echo "[MAKE_LINKS     ]   Link: mysqldump to /usr/local/bin .. OK"        >> $LOG
  	ln -s /usr/bin/mysql_install_db              /usr/local/bin/  && echo "[MAKE_LINKS     ]   Link: mysql_install_db to /usr/local/bin .. OK" >> $LOG
  	ln -s /usr/local/tcpflow/bin/tcpflow         /usr/local/bin/  && echo "[MAKE_LINKS     ]   Link: tcpflow to /usr/local/bin .. OK"          >> $LOG
  	ln -s /usr/local/tcpflow/bin/tcpflow         /usr/bin/        && echo "[MAKE_LINKS     ]   Link: tcpflow to /usr/bin .. OK"                >> $LOG
	ln -s /usr/sbin/p0f                          /usr/local/bin/  && echo "[MAKE_LINKS     ]   Link: p0f to /usr/local/bin .. OK"              >> $LOG
  	ln -s /usr/sbin/p0f                          /usr/bin/        && echo "[MAKE_LINKS     ]   Link: p0f to /usr/bin .. OK"                    >> $LOG
  	ln -s /usr/local/sancp/bin/sancp             /usr/local/bin/  && echo "[MAKE_LINKS     ]   Link: sancp to /usr/local/bin .. OK"            >> $LOG
  	ln -s /usr/local/sancp/bin/sancp             /usr/bin/        && echo "[MAKE_LINKS     ]   Link: sancp to /usr/bin .. OK"                  >> $LOG
  	ln -s /usr/local/barnyard/bin/barnyard       /usr/local/bin/  && echo "[MAKE_LINKS     ]   Link: barnyard to /usr/local/bin .. OK"         >> $LOG
  	ln -s /usr/local/barnyard/bin/barnyard       /usr/bin/        && echo "[MAKE_LINKS     ]   Link: barnyard to /usr/bin .. OK"               >> $LOG
        ln -s /usr/local/pads/bin/pads               /usr/local/bin/  && echo "[MAKE_LINKS     ]   Link: pads to /usr/local/bin .. OK"             >> $LOG
        ln -s /usr/local/pads/bin/pads               /usr/bin/        && echo "[MAKE_LINKS     ]   Link: pads to /usr/bin .. OK"                   >> $LOG
	ln -s /usr/local/snort/bin/snort             /usr/local/bin/  && echo "[MAKE_LINKS     ]   Link: snort to /usr/local/bin .. OK"            >> $LOG
        ln -s /usr/local/snort/bin/snort             /usr/bin/        && echo "[MAKE_LINKS     ]   Link: snort to /usr/bin .. OK"                  >> $LOG
	ln -s /usr/local/lib                         /usr/lib/i486-linux-gnu  && echo "[MAKE_LINKS     ]   Link: /usr/local/lib to i486-linux-gnu" >> $LOG
	ln -s /usr/local/bin/tclsh8.4		     /usr/bin/tclsh           && echo "[MAKE_LINKS     ]   Link: tclsh8.4 to /usr/bin/tclsh .. OK" >> $LOG
  	ln -s /usr/local/mysqltcl/lib/mysqltcl-3.05/ /usr/lib/                && echo "[MAKE_LINKS     ]   Link: Libs mysqltcl ... OK"             >> $LOG
  	ln -s /usr/local/tcllib/lib/tcllib1.9/       /usr/lib/                && echo "[MAKE_LINKS     ]   Link: Libs tcllib  ... OK"              >> $LOG
        ln -s /usr/local/sguil-0.8.0/                /usr/local/sguil-0.7.0   && echo "[MAKE_LINKS     ]   Link: Sguil0.8.0 -> Sguil0.7.0  ... OK" >> $LOG

}
##############################################################################
rules_snort()
{
	echo "[RULES_SNORT     ]   Installing SNORT Rules..." >> $LOG
	cd $DIRECTORY
	echo "[RULES_SNORT     ]   Unpacking VRT SNORT Rules..." >> $LOG
	cd rulepack/vrt
	tar -zxvf snortrules-snapshot-$RULES.tar.gz
	cp rules/*    /nsm/rules/$SENSORNAME/ && echo "[RULE_SNORT     ]   VRT Files *.rules to /nsm/rules/$SENSORNAME"  >> $LOG
	cp etc/*      /nsm/rules/$SENSORNAME/ && echo "[RULE_SNORT     ]   VRT Files etc/*   to /nsm/rules/$SENSORNAME"  >> $LOG
	echo "[RULES_SNORT     ]   Generating links for VRT..." >> $LOG
	ln -s /nsm/rules/$SENSORNAME/classification.config   /nsm/etc
	ln -s /nsm/rules/$SENSORNAME/reference.config        /nsm/etc
	ln -s /nsm/rules/$SENSORNAME/sid-msg.map             /nsm/etc
	ln -s /nsm/rules/$SENSORNAME/threshold.conf          /nsm/etc
	ln -s /nsm/rules/$SENSORNAME/unicode.map             /nsm/etc
	ln -s /nsm/rules/$SENSORNAME/gen-msg.map             /nsm/etc
	cd ../..
	
	echo "[RULES_SNORT     ]   Unpacking EMERGING Rules..." >> $LOG
	cd rulepack/emerging
	tar -zxvf emerging.rules.tar.gz
	cp rules/*.rules  /nsm/rules/$SENSORNAME               && echo "[RULE_SNORT     ]   EMERGING Files *.rules to /nsm/rules/$SENSORNAME" >> $LOG
	grep '|| ET' rules/sid-msg.map >> /nsm/etc/sid-msg.map && echo "[RULE_SNORT     ]   Updating Emerging sid-msg" >> $LOG
	cd ../..
}
##############################################################################
create_account()
{
	useradd -u 400 -d /home/sguil -c "SGUIL User" sguil  && echo "[CREATE_ACCOUNT ]   User account sguil has been created ... OK" >> $LOG
	chown -R sguil.sguil /nsm                            && echo "[CREATE_ACCOUNT ]   Setting /nsm privileges [own:sguil] ... OK" >> $LOG
	usermod -G root sguil                                && echo "[CREATE_ACCOUNT ]   Changing sguil group [root]         ... OK" >> $LOG
}
##############################################################################
copy_files()
{
	chown -R sguil.sguil /var/run/sguil                          && echo "[COPY_FILES     ]   Setting privileges [own sguil /var/run/sguil]         ... OK" >> $LOG
	cp /usr/local/sguil-$SGUILVER/server/sguild.*      /nsm/etc  && echo "[COPY_FILES     ]   Copying sguild* from Sguil directory to /nsm/etc/     ... OK" >> $LOG
	cp /usr/local/sguil-$SGUILVER/server/autocat.conf  /nsm/etc  && echo "[COPY_FILES     ]   Copying autocat.conf from Sguil directory to /nsm/etc ... OK" >> $LOG
	cp $DIRECTORY/files/startup/*  /nsm/scripts                  && echo "[COPY_FILES     ]   Startup scripts have been copied to /nsm/scripts      ... OK" >> $LOG
	cp $DIRECTORY/files/conf/*     /nsm/etc                      && echo "[COPY_FILES     ]   Configuration files have been copied to /nsm/etc      ... OK" >> $LOG
	cp $DIRECTORY/files/crt/*      /nsm/etc/certs                && echo "[COPY_FILES     ]   SSL Certs files have been copied to /nsm/etc/certs    ... OK" >> $LOG
	cp $DIRECTORY/files/mysql/*    /nsm/etc/                     && echo "[COPY_FILES     ]   SQL scripts have been copied to /nsm/etc/             ... OK" >> $LOG
	chown -R sguil.sguil /nsm/etc                                && echo "[COPY_FILES     ]   Setting privileges [own sguil /nsm/etc]               ... OK" >> $LOG
	ln -s /nsm/etc /etc/sguild                                   && echo "[COPY_FILES     ]   Generating link [/etc/sguild > /nsm/etc]              ... OK" >> $LOG
	mkfifo /nsm/$SENSORNAME/pads.fifo                            && echo "[COPY_FILES     ]   Generating file [/nsm/$SENSORNAME/pads.fifo]          ... OK" >> $LOG
}
##############################################################################
config_mysql()
{
	echo "#####################################################"
	echo "Starting MYSQL Configuration"
	chown -R mysql.mysql /nsm/mysql   && echo "[CONFIG_MYSQL   ]   Setting /nsm/mysql privileges [own:mysql]... OK"          >> $LOG
	chmod 755 /nsm/mysql/             && echo "[CONFIG_MYSQL   ]   Setting /nsm/mysql privileges [chmod 755]... OK"          >> $LOG
	rm -rf /var/lib/mysql             && echo "[CONFIG_MYSQL   ]   Deleting /var/lib/mysql ... OK"                           >> $LOG
	ln -s /nsm/mysql/ /var/lib/mysql  && echo "[CONFIG_MYSQL   ]   Creating link /nsm/mysql > /var/lib/mysql ... OK"         >> $LOG
	mysql_install_db --user=mysql     && echo "[CONFIG_MYSQL   ]   Creating DATABASE [CMD: mysql_install_db --user=mysql ] " >> $LOG
	/etc/init.d/mysql restart         && echo "[CONFIG_MYSQL   ]   Restarting Mysql  [CMD: /etc/init.d/mysql restart ] "     >> $LOG
	echo "[CONFIG_MYSQL   ]   Changing Mysql root password"
	mysql -u root mysql    < $DIRECTORY/files/mysql/passwdroot.sql   && echo "[CONFIG_MYSQL   ]   Changing mysql root password ... OK" >> $LOG
	echo "[CONFIG_MYSQL   ]   Setting mysql sguil user password." >> $LOG
	mysql -u root -pdbroot mysql < $DIRECTORY/files/mysql/passwdsguil.sql  && echo "[CONFIG_MYSQL   ]   Setting mysql sguil password ... OK" >> $LOG
	echo "[CONFIG_MYSQL   ]   Creating Sguil database." >> $LOG
	mysql -u sguil -pdbsguil -e "CREATE DATABASE sguildb" && echo "[CONFIG_MYSQL   ]   Creating Sguil database ... OK" >> $LOG
	echo "[CONFIG_MYSQL   ]   Loading script. Enter mysql SGUIL password." >> $LOG
	mysql -u sguil -D sguildb -pdbsguil < /usr/local/sguil-$SGUILVER/server/sql_scripts/create_sguildb.sql && echo "[CONFIG_MYSQL   ]   Loading script ... OK" >> $LOG
}
##############################################################################
link_initd()
{
	echo "[LINK_INIT_D     ]   Generating link to /etc/init.d " >> $LOG
	ln -s /nsm/scripts/barnyard-sensor     /etc/init.d   && echo "[LINK_INITD     ]   barnyard-sensor     link created ... OK" >> $LOG
	ln -s /nsm/scripts/log_packets.sh      /etc/init.d   && echo "[LINK_INITD     ]   log_packets         link created ... OK" >> $LOG
	ln -s /nsm/scripts/pads_agent-sensor   /etc/init.d   && echo "[LINK_INITD     ]   pads_agent-sensor   link created ... OK" >> $LOG
	ln -s /nsm/scripts/pads-sensor         /etc/init.d   && echo "[LINK_INITD     ]   pads-sensor         link created ... OK" >> $LOG
	ln -s /nsm/scripts/pcap_agent-sensor   /etc/init.d   && echo "[LINK_INITD     ]   pcap_agent-sensor   link created ... OK" >> $LOG
	ln -s /nsm/scripts/sancp_agent-sensor  /etc/init.d   && echo "[LINK_INITD     ]   sancp_agent-sensor  link created ... OK" >> $LOG
	ln -s /nsm/scripts/sancp-sensor        /etc/init.d   && echo "[LINK_INITD     ]   sancp-sensor        link created ... OK" >> $LOG
	ln -s /nsm/scripts/sguild              /etc/init.d   && echo "[LINK_INITD     ]   sguild              link created ... OK" >> $LOG
	ln -s /nsm/scripts/sguil_logger-sensor /etc/init.d   && echo "[LINK_INITD     ]   sguil_logger-sensor link created ... OK" >> $LOG
	ln -s /nsm/scripts/snort_agent-sensor  /etc/init.d   && echo "[LINK_INITD     ]   snort_agent-sensor  link created ... OK" >> $LOG
	ln -s /nsm/scripts/snort-sensor        /etc/init.d   && echo "[LINK_INITD     ]   snort-sensor        link created ... OK" >> $LOG
	ln -s /nsm/scripts/analyzer            /etc/init.d   && echo "[LINK_INITD     ]   analyzer            link created ... OK" >> $LOG
	ln -s /nsm/scripts/iface.sh     /etc/rc2.d/S17iface  && echo "[LINK_INITD     ]   START > RC2 S17iface link created ... OK" >> $LOG

}
##############################################################################
add_sguil_user()
{
	echo "#####################################################"
	echo "Adding new user for sguil server"
	echo
	echo "[ADD_SGUIL_USER ]   Adding new user for sguil server ... OK" >> $LOG
	/usr/local/sguil-$SGUILVER/server/sguild -adduser sguil
}
#####################################################################################################
define_iface()
{
	echo
	echo "[DEFINE_IFACE   ]   Verifying monitoring interface" >> $LOG
	echo "[DEFINE_IFACE   ]   Verifying monitoring"
	echo -n " Monitoring interface: [$IFACE]  [Y/N]"
	read me
	if [ $me != "Y" ]
	then
		echo -n " New iface :"
		read nametmp
		echo "[DEFINE_IFACE   ]   The monitoring interface is [$nametmp] "
		IFACE=$nametmp
		echo "[DEFINE_IFACE   ]   The monitoring interface has been defined: [$IFACE]"	
		echo "[DEFINE_IFACE   ]   The monitoring interface has been defined: [$IFACE]" >> $LOG
		sed -i "s/config interface\: eth0/config interface\: $IFACE/g" /nsm/etc/barnyard.conf 
		sed -i "s/interface eth0/interface $IFACE/g"                   /nsm/etc/pads_agente1.conf 
		sed -i "s/INTERFACE=\"eth0\"/INTERFACE=\"$IFACE\"/g"           /nsm/scripts/log_packets.sh 
		sed -i "s/IFACE=eth0/IFACE=$IFACE/g"                           /nsm/scripts/sancp-sensor 
		sed -i "s/IFACE=eth0/IFACE=$IFACE/g"                           /nsm/scripts/snort-sensor 
		sed -i "s/IFACE/$IFACE/g"                                      /nsm/scripts/iface.sh 
	fi
}
##############################################################################
update_files()
{
	sed -i "s/config hostname\: agente1/config hostname\: $SENSORNAME/g"                     /nsm/etc/barnyard.conf     && echo "[UPDATE_FILES   ]   Setting [config hostname: $SENSORNAME] in /nsm/etc/barnyard.conf"          >> $LOG
	sed -i "s/output sguil\: sensor_name agente1/output sguil\: sensor_name $SENSORNAME/g"   /nsm/etc/barnyard.conf     && echo "[UPDATE_FILES   ]   Setting [output sguil: sensor_name $SENSORNAME] in /nsm/etc/barnyard.conf" >> $LOG
	sed -i "s/set HOSTNAME agente1/set HOSTNAME $SENSORNAME/g"                               /nsm/etc/pads_agent.conf   && echo "[UPDATE_FILES   ]   Setting [set HOSTNAME $SENSORNAME] in /nsm/etc/pads_agent.conf"            >> $LOG
	sed -i "s/set NET_GROUP agente1/set NET_GROUP $SENSORNAME/g"                             /nsm/etc/pads_agent.conf   && echo "[UPDATE_FILES   ]   Setting [set NET_GROUP $SENSORNAME] in /nsm/etc/pads_agent.conf"           >> $LOG
	sed -i "s/set HOSTNAME agente1/set HOSTNAME $SENSORNAME/g"                               /nsm/etc/pcap_agent.conf   && echo "[UPDATE_FILES   ]   Setting [set HOSTNAME $SENSORNAME] in /nsm/etc/pcap_agent.conf"            >> $LOG
	sed -i "s/set NET_GROUP agente1/set NET_GROUP $SENSORNAME/g"                             /nsm/etc/pcap_agent.conf   && echo "[UPDATE_FILES   ]   Setting [set NET_GROUP $SENSORNAME] in /nsm/etc/pcap_agent.conf "          >> $LOG
	sed -i "s/set HOSTNAME agente1/set HOSTNAME $SENSORNAME/g"                               /nsm/etc/sancp_agent.conf  && echo "[UPDATE_FILES   ]   Setting [set HOSTNAME $SENSORNAME] in /nsm/etc/sancp_agent.conf"           >> $LOG
	sed -i "s/set NET_GROUP agente1/set NET_GROUP $SENSORNAME/g"                             /nsm/etc/sancp_agent.conf  && echo "[UPDATE_FILES   ]   Setting [set NET_GROUP $SENSORNAME] in /nsm/etc/sancp_agent.conf"          >> $LOG
	sed -i "s/set HOSTNAME agente1/set HOSTNAME $SENSORNAME/g"                               /nsm/etc/snort_agent.conf  && echo "[UPDATE_FILES   ]   Setting [set HOSTNAME $SENSORNAME] in /nsm/etc/snort_agent.conf"           >> $LOG
	sed -i "s/set NET_GROUP agente1/set NET_GROUP $SENSORNAME/g"                             /nsm/etc/snort_agent.conf  && echo "[UPDATE_FILES   ]   Setting [set NET_GROUP $SENSORNAME] in /nsm/etc/snort_agent.conf"          >> $LOG
	sed -i "s/SENSORNAME/$SENSORNAME/g" 							 /nsm/etc/snort.conf        && echo "[UPDATE_FILES   ]   Setting [$SENSORNAME] values on /nsm/etc/snort.conf"                       >> $LOG
	sed -i "s/SENSORNAME/$SENSORNAME/g"                                                      /nsm/etc/pads_agente1.conf && echo "[UPDATE_FILES   ]   Setting [SENSORNAME > $SENSORNAME] in /nsm/etc/pads_agente1.conf"          >> $LOG
	sed -i "s/SENSORNAME/$SENSORNAME/g"                                                      /nsm/scripts/cleananalyzer.sh    && echo "[UPDATE_FILES   ]   Setting [SENSORNAME > $SENSORNAME] in /nsm/scripts/cleananalyzer.sh" >> $LOG
	sed -i "s/SENSOR=agente1/SENSOR=$SENSORNAME/g"                                           /nsm/scripts/barnyard-sensor     && echo "[UPDATE_FILES   ]   Setting [SENSOR=$SENSORNAME] in /nsm/scripts/barnyard-sensor"        >> $LOG
	sed -i "s/HOSTNAME=\"agente1\"/HOSTNAME=\"$SENSORNAME\"/g"                               /nsm/scripts/log_packets.sh      && echo "[UPDATE_FILES   ]   Setting [HOSTNAME=$SENSORNAME] in /nsm/scripts/log_packets.sh"       >> $LOG
	sed -i "s/SENSOR=agente1/SENSOR=$SENSORNAME/g"                                           /nsm/scripts/pads_agent-sensor   && echo "[UPDATE_FILES   ]   Setting [SENSOR=$SENSORNAME] in /nsm/scripts/pads_agent-sensor"      >> $LOG
	sed -i "s/SENSOR=agente1/SENSOR=$SENSORNAME/g"                                           /nsm/scripts/pads-sensor         && echo "[UPDATE_FILES   ]   Setting [SENSOR=$SENSORNAME] in /nsm/scripts/pads-sensor"            >> $LOG
	sed -i "s/SENSOR=agente1/SENSOR=$SENSORNAME/g"                                           /nsm/scripts/pcap_agent-sensor   && echo "[UPDATE_FILES   ]   Setting [SENSOR=$SENSORNAME] in /nsm/scripts/pcap_agent-sensor"      >> $LOG
	sed -i "s/SENSOR=agente1/SENSOR=$SENSORNAME/g"                                           /nsm/scripts/sancp_agent-sensor  && echo "[UPDATE_FILES   ]   Setting [SENSOR=$SENSORNAME] in /nsm/scripts/sancp_agent-sensor"     >> $LOG
	sed -i "s/SENSOR=agente1/SENSOR=$SENSORNAME/g"                                           /nsm/scripts/sancp-sensor        && echo "[UPDATE_FILES   ]   Setting [SENSOR=$SENSORNAME] in /nsm/scripts/sancp-sensor"           >> $LOG
	sed -i "s/SENSOR=agente1/SENSOR=$SENSORNAME/g"                                           /nsm/scripts/sguil_logger-sensor && echo "[UPDATE_FILES   ]   Setting [SENSOR=$SENSORNAME] in /nsm/scripts/sguil_logger-sensor"    >> $LOG
	sed -i "s/SENSOR=agente1/SENSOR=$SENSORNAME/g"                                           /nsm/scripts/snort_agent-sensor  && echo "[UPDATE_FILES   ]   Setting [SENSOR=$SENSORNAME] in /nsm/scripts/snort_agent-sensor"     >> $LOG
	sed -i "s/SENSOR=agente1/SENSOR=$SENSORNAME/g"                                           /nsm/scripts/snort-sensor        && echo "[UPDATE_FILES   ]   Setting [SENSOR=$SENSORNAME] in /nsm/scripts/snort-sensor"           >> $LOG
	sed -i "s/SENSOR=agente1/SENSOR=$SENSORNAME/g"                                           /nsm/scripts/barnyard_start.sh   && echo "[UPDATE_FILES   ]   Setting [SENSOR=$SENSORNAME] in /nsm/scripts/barnyard_start.sh"      >> $LOG
	sed -i "s/exit 0//g"                  /etc/rc.local	   	&& echo "[UPDATE_FILES   ]   Deleting exit 0 on rc.local"                    >> $LOG
	echo "/nsm/scripts/iface.sh"       >> /etc/rc.local           	&& echo "[UPDATE_FILES   ]   Setting /nsm/scripts/iface.sh on rc.local"      >> $LOG
	echo "/etc/init.d/analyzer start"  >> /etc/rc.local           	&& echo "[UPDATE_FILES   ]   Setting /etc/init.d/analyzer start on rc.local" >> $LOG
	echo "exit 0"                      >> /etc/rc.local           	&& echo "[UPDATE_FILES   ]   Adding exit 0 on rc.local"                      >> $LOG
	mv /nsm/etc/pads_agente1.conf /nsm/etc/pads_$SENSORNAME.conf  	&& echo "[UPDATE_FILES   ]   Changing name of /nsm/etc/pads_agente1.conf > /nsm/etc/pads_$SENSORNAME.conf" >> $LOG
	chmod 775 /var/run                                            	&& echo "[UPDATE_FILES   ]   Setting privileges 775 /var/run" 		>> $LOG
	touch /var/log/sguild/user.log       				&& echo "[UPDATE_FILES   ]   Creating /var/log/sguild/user.log"        	>> $LOG
	touch /var/log/sguild/agent.log      				&& echo "[UPDATE_FILES   ]   Creating /var/log/sguild/agent.log"       	>> $LOG
	chown -R sguil:sguil /var/log/sguild 				&& echo "[UPDATE_FILES   ]   Changing owner sguil for /var/log/sguild" 	>> $LOG
}
##############################################################################
end_install()
{
	echo "#####################################################"
	echo "The installation proccess of sguil has been completed"
	echo "The installation proccess of sguil has been completed" >> $LOG
	echo
	echo >> $LOG
	echo >> $LOG
	echo "For more detail, see INSTALL_LOG file"
	echo 
	echo "____________________________________"
	echo "By Javier S.A."
	echo "jsantillan@seguridad.unam.mx"
	echo "jusafing@gmail.com"
	echo
	echo
	echo "____________________________________" >> $LOG
	echo "By Javier S.A." 			    >> $LOG
	echo "jsantillan@seguridad.unam.mx"         >> $LOG
	echo "jusafing@gmail.com"                   >> $LOG
}
##############################################################################
##############################################################################

	banner_log
	user_install
	name_sensor
	make_dirs
	install_aptpkg
	install_tcl
	install_tcllib
	install_openssl
	install_tls
	install_libpcap
	install_libnet
	install_libdnet
	install_daq
	install_snort
	install_pads
	install_sancp
	unpack_sguil
	install_barnyard
	install_otherpkg
	install_mysqltcl
	install_tcpflow
	install_tclx
	install_tcpdump
	make_links
	rules_snort
	create_account
	copy_files
	config_mysql
	link_initd
	add_sguil_user
	define_iface
	update_files
	end_install

