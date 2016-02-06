#!/bin/sh

echo —————————– >> ~/pinglog_google.log
date >> ~/pinglog_google.log
ping -D -c 2 http://www.google.com >> ~/pinglog_google.log
