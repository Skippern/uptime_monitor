#!/bin/sh

ping comcast.net | while read pong; do echo "$(date): $pong"; done > ~/pings_superuser.log
