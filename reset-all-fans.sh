#!/bin/bash

read -s -p "Enter Password: " idracPass
printf "\n"

IDRACUSER="Administrator"
IDRACPASSWORD=$idracPass
IPMIEK=0000000000000000000000000000000000000000

IDRACIP="192.168.1.30"
ipmitool -I lanplus -H $IDRACIP -U $IDRACUSER -P $IDRACPASSWORD raw 0x30 0x30 0x01 0x01

IDRACIP="192.168.1.35"
ipmitool -I lanplus -H $IDRACIP -U $IDRACUSER -P $IDRACPASSWORD raw 0x30 0x30 0x01 0x01

IDRACIP="192.168.1.40"
ipmitool -I lanplus -H $IDRACIP -U $IDRACUSER -P $IDRACPASSWORD raw 0x30 0x30 0x01 0x01

echo "Done"