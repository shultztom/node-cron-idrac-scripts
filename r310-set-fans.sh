#!/bin/bash

DATE=$(date +%Y-%m-%d-%H:%M:%S)
echo "##################################################"
echo "# Running script at $DATE for r310 #"
echo "##################################################"
echo ""

# read -s -p "Enter Password: " idracPass
# printf "\n"

# iDrac Config
IDRACIP="192.168.1.40"
IDRACUSER="Administrator"
IDRACPASSWORD=$idracPass
IPMIEK=0000000000000000000000000000000000000000
# Test Config

status=$(ipmitool -I lanplus -H ${IDRACIP} -U ${IDRACUSER} -P ${IDRACPASSWORD} chassis power status)

if [[ $status != "Chassis Power is on" ]]
  then
    echo "Can't Connect to iDrac at this time"
    exit 1
fi

# echo "List of Fan RPMs"
# CURR_RPMS=$(ipmitool -I lanplus -H ${IDRACIP} -U ${IDRACUSER} -P ${IDRACPASSWORD} sensor | grep FAN | grep RPM |grep -Po '\d{4}')
# echo $CURR_RPMS
# echo ""

# echo "Login Succeeded!"
# echo ""

# echo "############################"
# CURR_TEMP=$(ipmitool -I lanplus -H $IDRACIP -U $IDRACUSER -P $IDRACPASSWORD -y $IPMIEK sdr type temperature |grep Ambient |grep degrees |grep -Po '\d{2}' | tail -1)
# echo "Current temp: ${CURR_TEMP}"
# echo "############################"
# echo ""

# Fan config
STATICSPEEDBASE16="0x15"
TEMPTHRESHOLD="27"

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
