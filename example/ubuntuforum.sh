#!/bin/sh

ping -c 5 www.google.com ; echo $? $(date) >> ~/pings.log
