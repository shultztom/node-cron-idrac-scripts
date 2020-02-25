#!/bin/bash

read -s -p "Enter Password: " idracPass
printf "\n"

IDRACUSER="Administrator"
IDRACPASSWORD=$idracPass
IPMIEK=0000000000000000000000000000000000000000

while true; do
    IDRACIP="192.168.1.30"
    T=$(ipmitool -I lanplus -H $IDRACIP -U $IDRACUSER -P $IDRACPASSWORD -y $IPMIEK sdr type temperature |grep Ambient |grep degrees |grep -Po '\d{2}' | tail -1)
    echo "$IDRACIP: $T °C"

    IDRACIP="192.168.1.35"
    T=$(ipmitool -I lanplus -H $IDRACIP -U $IDRACUSER -P $IDRACPASSWORD -y $IPMIEK sdr type temperature |grep Ambient |grep degrees |grep -Po '\d{2}' | tail -1)
    echo "$IDRACIP: $T °C"

    IDRACIP="192.168.1.40"
    T=$(ipmitool -I lanplus -H $IDRACIP -U $IDRACUSER -P $IDRACPASSWORD -y $IPMIEK sdr type temperature |grep Ambient |grep degrees |grep -Po '\d{2}' | tail -1)
    echo "$IDRACIP: $T °C"

    echo "Sleeping 15 Seconds, press q to exit loop"
    sleep 15
    read -t 0.25 -N 1 input
    if [[ $input = "q" ]] || [[ $input = "Q" ]]; then
        echo
        break 
    fi
done