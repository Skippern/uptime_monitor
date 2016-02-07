#!/usr/bin/python
#
#
# Python solution
#

import os
import logging
import time
#import pyping

hostname = "google.com" # example
response = os.system("ping -c 1 " + hostname + " > /dev/null 2>&1")
status = response
logging.basicConfig(filename='/Users/skippern/log/linklogger.log',level=logging.DEBUG,format='%(asctime)s %(message)s',datefmt='%Y/%m/%d %H:%M:%S:')
logging.debug('monitor.py started')

if response == 0:
    logging.info('Network is up!')
else:
    logging.info('Network is down!')
    response = 1

keepalive = 1
while (keepalive == 1):
    time.sleep(55)
    response = os.system("ping -c 1 " + hostname + " > /dev/null 2>&1")
    if response == 2:
        response = 1
    if response != status:
        if resopnse == 0:
            ## Link just came back
            logging.info('Link returned')
        else:
            ## Link just fell
            logging.warning('Link just died')
