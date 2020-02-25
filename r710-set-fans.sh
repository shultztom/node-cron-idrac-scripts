#!/bin/bash

DATE=$(date +%Y-%m-%d-%H:%M:%S)
echo "##################################################"
echo "# Running script at $DATE for r710 #"
echo "##################################################"
echo ""

# iDrac Config
IDRACIP="192.168.1.30"
IDRACUSER="Administrator"
IDRACPASSWORD=$idracPass
# Test Config

status=$(ipmitool -H ${IDRACIP} -U ${IDRACUSER} -P ${IDRACPASSWORD} -I lan chassis power status)

if [[ $status != "Chassis Power is on" ]]
  then
    echo "Can't Connect to iDrac at this time"
    exit 1
fi

# echo "############################"
# echo "Current temps and fans rpms:"
# ipmitool -I lanplus -H $IDRACIP -U $IDRACUSER -P $IDRACPASSWORD sensor reading "Ambient Temp" "FAN 1 RPM" "FAN 2 RPM" "FAN 3 RPM"
# echo "############################"
# echo ""

# Fan config
STATICSPEEDBASE16="0x10"
SENSORNAME="Ambient"
TEMPTHRESHOLD="27"

T=$(ipmitool -I lanplus -H $IDRACIP -U $IDRACUSER -P $IDRACPASSWORD sdr type temperature | grep $SENSORNAME | cut -d"|" -f5 | cut -d" " -f2)
echo "$IDRACIP: $T °C"
#
if [[ $T > $TEMPTHRESHOLD ]]
  then
    echo "--> enable dynamic fan control for $IDRACIP"
    ipmitool -I lanplus -H $IDRACIP -U $IDRACUSER -P $IDRACPASSWORD raw 0x30 0x30 0x01 0x01
  else
    echo "--> disable dynamic fan control for $IDRACIP"
    ipmitool -I lanplus -H $IDRACIP -U $IDRACUSER -P $IDRACPASSWORD raw 0x30 0x30 0x01 0x00
    echo "--> set static fan speed for $IDRACIP"
    ipmitool -I lanplus -H $IDRACIP -U $IDRACUSER -P $IDRACPASSWORD raw 0x30 0x30 0x02 0xff $STATICSPEEDBASE16
fi