#!/bin/bash

read -s -p "Enter Password: " idracPass
printf "\n"
docker run --rm -it -e IDRAC_PASS=$idracPass tks23/node-cron-idrac-scripts:stable