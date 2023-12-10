#!/bin/bash

# Script to detect suspicious login attempts

LOG_FILE="/var/log/auth.log"
SUSPICIOUS_LOG="/var/log/suspicious.log"
RED_FLAG_THRESHOLD=5

# Create log files 
touch "$LOG_FILE" "$SUSPICIOUS_LOG"

# Get IP addresses with multiple login attempts between midnight and 6 AM
suspicious_ips=$(awk '/Failed password/ && /from [0-9]/{print $(NF-3)}' "$LOG_FILE" | grep -E "$(date -d 'yesterday' +'%b %e (00|01|02|03|04|05):[0-5][0-9]')" | sort | uniq -c | awk -v threshold=$RED_FLAG_THRESHOLD '$1 >= threshold {print $2}')

# Log suspicious IPs
if [ -n "$suspicious_ips" ]; then
    echo "Suspicious login attempts detected from the following IPs: $suspicious_ips" >> "$SUSPICIOUS_LOG"
fi
