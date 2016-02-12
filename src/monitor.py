#!/usr/bin/python
#
#
# Python solution
#
import os
import logging
import time
import datetime

DEBUG = 0
if DEBUG == 1:
    logging.basicConfig(filename='/Users/skippern/log/linklogger.log',level=logging.DEBUG,format='%(asctime)s %(message)s',datefmt='%Y/%m/%d %H:%M:%S:')
    logging.debug('monitor.py started in DEBUG mode')
else:
    logging.basicConfig(filename='/Users/skippern/log/linklogger.log',level=logging.INFO,format='%(asctime)s %(message)s',datefmt='%Y/%m/%d %H:%M:%S:')

interval = 10

hostname = "google.com"
otherhost = "ikke.no"
response = os.system("ping -c 1 " + hostname + " > /dev/null 2>&1")
change = datetime.datetime.now().replace(microsecond=0)

# Ping response 0 means the link is OK, any other response means the link is down, dead, unreachable, etc.
if response == 0:
    logging.info('monitor.py started. Network is up!')
else:
    logging.info('monitor.py started. Network is down! (response code %s)', response)
    response = 1
status = response

keepalive = 1
while (keepalive == 1):
    time.sleep(interval)
    response = os.system("ping -c 1 " + hostname + " > /dev/null 2>&1")
    # If link fails, try other host to see if it really is down
    if response != 0:
        response = os.system("ping -c 1 " + otherhost + " > /dev/null 2>&1")
    if response != 0:
        response = 1
    logging.debug('Response is %s, status is %s', response, status)
    now = datetime.datetime.now().replace(microsecond=0)
    diff = now - change
    ## Code to prepare email if downtime is more than x minutes
    if response != status:
        if response == 0:
            ## Link just came back
            change = now
            status = response
            logging.info('Link returned, downtime: %s', diff)
            ## If mail prepared, send it now
        elif response == 1:
            ## Link just fell
            change = now
            status = response
            logging.warning('Link just died, uptime: %s', diff)
        else:
            logging.debug('Something went wrong')

#END
