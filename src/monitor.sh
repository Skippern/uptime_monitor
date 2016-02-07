#!/bin/bash
#
# Monitor shell script - shell attempt to solve the problem
#
export status=-1
test_link () {
    ping -c 5 www.google.com >/dev/null 2>&1
#    echo "Status is $?"
    return $?
}
up2down() {
    # Host turned not reachable
    echo "$(date) Host unreachable ($timedown), up since $timeup" >> ~/log/linklogger.log
}
up2dead() {
    # Host completely dead
    echo "$(date) No route to nameserver ($timedead), up since $timeup" >> ~/log/linklogger.log
}
down2up() {
    # Host returned
    echo "$(date) Host returned ($timeup), down since $timedown" >> ~/log/linklogger.log
}
dead2up() {
    # Host returned
    echo "$(date) Host returned ($timeup), down since $timedead" >> ~/log/linklogger.log
}
set_status () {
    if [ "$1" -eq "$status" ]
    then
        # Nothing to do here
#        echo "No change"
        sleep 0.1
    elif [ "$1" -eq 0 ]
    then
        # Link up
        export timeup=$(date)
        if [ "$status" -eq 1 ]
        then
            down2up
        elif [ "$status" -eq 2 ]
        then
            dead2up
        fi
        export status=$1
#        echo "Link up"
    elif [ "$1" -eq 1 ]
    then
        # host not responding
        export timedown=$(date)
        if [ "$status" -eq 0 ]
        then
            up2down
        fi
        export status=$1
#        echo "Link down"
    elif [ "$1" -eq 2 ]
    then
        # host name not resolved
        export timedead=$(date)
        if [ "$status" -eq 0 ]
        then
            up2dead
        fi
        export status=$1
#        echo "Host not resolved"
    fi
}

test_link
export arg=$?
if [ "$arg" -eq 0 ]
then
    echo "$(date) Log started with link up." >> ~/log/linklogger.log
elif [ "$arg" -eq 1 ]
then
    echo "$(date) Log started with link down." >> ~/log/linklogger.log
elig [ "$arg" -eq 2 ]
then
    echo "$(date) Log started with no route to nameserver." >> ~/log/linklogger.log
fi
set_status $arg
sleep 10

while [ 1 ]
do
    test_link
    export arg=$?
    set_status $arg

    sleep 55
done
