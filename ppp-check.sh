#!/bin/bash
#
# This script will check if you 
# have access to internet
#
# original by desgua
# edited by northway
#
#######################################

# Location of log files
LOGCHECK='/var/log/ppp/ppp-check.log'
LOGERROR='/var/log/ppp/ppp-error.log'

# Addresses for checking
HOST1='80.80.80.80'
HOST2='8.8.8.8'

# Checking HOST1 if it's reachable
pingtime=$(ping -w 1 $HOST1 | grep ttl)
if [ "$pingtime" = "" ] 
then
	echo [$(date +"%Y.%m.%d. %H:%M:%S")] "$HOST1 is unreachable. Trying next server.">> $LOGERROR

	# Checking HOST2 if it's reachable
	pingtimetwo=$(ping -w 1 $HOST2 | grep ttl) 
	if [ "$pingtimetwo" = "" ] 
	then
		echo [$(date +"%Y.%m.%d. %H:%M:%S")] "$HOST2 is unreachable. PPP connection is down.">> $LOGERROR	
		echo [$(date +"%Y.%m.%d. %H:%M:%S")] "PPPoE restating.">> $LOGERROR
		
		# Restarting PPPoE connection
		poff;pon dsl-provider
	else
		echo [$(date +"%Y.%m.%d. %H:%M:%S")] "$HOST2 is reachable. PPP connection is up.">> $LOGCHECK	
		echo [$(date +"%Y.%m.%d. %H:%M:%S")] "$HOST2 is reachable. PPP connection is up.">> $LOGERROR	
	fi 
else
	echo [$(date +"%Y.%m.%d. %H:%M:%S")] "$HOST1 is reachable. PPP connection is up.">> $LOGCHECK
fi
