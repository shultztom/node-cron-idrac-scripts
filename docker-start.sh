#!/bin/bash

read -s -p "Enter Password: " idracPass
printf "\n"
docker run --rm -it -e IDRAC_PASS=$idracPass node-cron-idrac-scripts:latest