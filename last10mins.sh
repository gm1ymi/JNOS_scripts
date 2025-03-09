#!/bin/bash

# Get the current date in the format DDMonYY
date_str=$(date +"%d%b%y")

# Define the log file path
logfile="/jnos/logs/$date_str"

# Define the output file
output_file="winlink.log"

# Check if logfile exists
if [[ ! -f "$logfile" ]]; then
    echo "Log file $logfile not found!"
    exit 1
fi

# Get the current time and 10 minutes ago time
start_time=$(date --date='10 minutes ago' '+%H:%M')
end_time=$(date '+%H:%M')

# Extract logs between the last 10 minutes and now
awk -v start="$start_time" -v end="$end_time" '$0 ~ start, $0 ~ end' "$logfile" > "$output_file"

echo "Last 10 minutes of logs saved to $output_file"

# Email the log file contents using Postfix
subject="Winlink Log Extract $end_time"
recipient="<enter valid email address>"
echo -e "Subject: $subject\n\n$(cat $output_file)" | mail -s "$subject" "$recipient"
