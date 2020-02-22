#!/bin/bash

DATE=$(date +%Y-%m-%d-%H:%M:%S)
echo "##################################################"
echo "# Running script at $DATE for r610 #"
echo "##################################################"
echo ""

# read -s -p "Enter Password: " idracPass
# printf "\n"

# iDrac Config
IDRACIP="192.168.1.35"
IDRACUSER="Administrator"
IDRACPASSWORD=$idracPass
IPMIEK=0000000000000000000000000000000000000000
# Test Config

status=$(ipmitool -H ${IDRACIP} -U ${IDRACUSER} -P ${IDRACPASSWORD} -I lanplus chassis power status)

if [[ $status != "Chassis Power is on" ]]
  then
    echo "Can't Connect to iDrac at this time"
    exit 1
fi

# Fan config
STATICSPEEDBASE16="0x11"
TEMPTHRESHOLD="29"

T=$(ipmitool -I lanplus -H $IDRACIP -U $IDRACUSER -P $IDRACPASSWORD -y $IPMIEK sdr type temperature |grep Ambient |grep degrees |grep -Po '\d{2}' | tail -1)
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

echo "##############################"
echo "# Done setting fans for r610 #"
echo "##############################"
echo ""