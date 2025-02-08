#!/bin/bash

# Switch Timezone Script

# Get the current month
current_month=$(date +%m)

# Switch to CEST on March 31st
if [ "$current_month" -eq 03 ]; then
    if [ "$(date +%d)" -eq 31 ]; then
        timedatectl set-timezone Europe/Copenhagen
        echo "Timezone switched to CEST (Central European Summer Time)."
    fi
fi

# Switch to CET on October 31st
if [ "$current_month" -eq 10 ]; then
    if [ "$(date +%d)" -eq 31 ]; then
        timedatectl set-timezone Europe/Copenhagen
        echo "Timezone switched to CET (Central European Time)."
    fi
fi
