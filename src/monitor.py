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
interval = 15

hostname = "google.com"
otherhost = "ikke.no"
response = os.system("ping -c 1 " + hostname + " > /dev/null 2>&1")
status = response
change = datetime.datetime.now().replace(microsecond=0)
if DEBUG == 1:
    logging.basicConfig(filename='/Users/skippern/log/linklogger.log',level=logging.DEBUG,format='%(asctime)s %(message)s',datefmt='%Y/%m/%d %H:%M:%S:')
else:
    logging.basicConfig(filename='/Users/skippern/log/linklogger.log',level=logging.INFO,format='%(asctime)s %(message)s',datefmt='%Y/%m/%d %H:%M:%S:')

logging.debug('monitor.py started in DEBUG mode')
if response == 0:
    logging.info('monitor.py started. Network is up!')
else:
    logging.info('monitor.py started. Network is down!')
    response = 1

keepalive = 1
while (keepalive == 1):
    time.sleep(interval)
    response = os.system("ping -c 1 " + hostname + " > /dev/null 2>&1")
    # If link fails, try other host to see if it really is down
    if response != 0:
        response = os.system("ping -c 1 " + otherhost + " > /dev/null 2>&1")
    if response == 2:
        response = 1
    logging.debug('Response is %s, status is %s', response, status)
    if response != status:
        if response == 0:
            ## Link just came back
            now = datetime.datetime.now().replace(microsecond=0)
            diff = now - change
            change = now
            logging.info('Link returned, downtime: %s', diff)
            status = response
        else:
            ## Link just fell
            now = datetime.datetime.now().replace(microsecond=0)
            diff = now - change
            change = now
            logging.warning('Link just died, uptime: %s', diff)
            status = response
