#!/bin/bash

read -s -p "Enter Password: " idracPass
printf "\n"

IDRACUSER="Administrator"
IDRACPASSWORD=$idracPass
IPMIEK=0000000000000000000000000000000000000000

while true; do
    IDRACIP="192.168.1.30"
    CURR_RPMS=$(ipmitool -I lanplus -H ${IDRACIP} -U ${IDRACUSER} -P ${IDRACPASSWORD} sensor | grep FAN | grep RPM |grep -Po '\d{4}')
    echo $IDRACIP": "$CURR_RPMS
    echo ""

    IDRACIP="192.168.1.35"
    CURR_RPMS=$(ipmitool -I lanplus -H ${IDRACIP} -U ${IDRACUSER} -P ${IDRACPASSWORD} sensor | grep FAN | grep RPM |grep -Po '\d{4}')
    echo $IDRACIP": "$CURR_RPMS
    echo ""

    IDRACIP="192.168.1.40"
    CURR_RPMS=$(ipmitool -I lanplus -H ${IDRACIP} -U ${IDRACUSER} -P ${IDRACPASSWORD} sensor | grep FAN | grep RPM |grep -Po '\d{4}')
    echo $IDRACIP": "$CURR_RPMS
    echo ""

    echo "Sleeping 15 Seconds, press q to exit loop"
    sleep 15
    read -t 0.25 -N 1 input
    if [[ $input = "q" ]] || [[ $input = "Q" ]]; then
        echo
        break 
    fi
done