#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <csv_file>"
    exit 1
fi

CSV_FILE="$1"

if [ ! -f "$CSV_FILE" ]; then
    echo "Error: File '$CSV_FILE' not found!"
    exit 1
fi

echo "Host,Port,Result"

# Read the CSV file line by line, skipping the header
awk -F, 'NR>1 {print $2, $3}' "$CSV_FILE" | while read -r host port; do
    nc -z -w3 "$host" "$port" 2>/dev/null
    if [ "$?" -eq 0 ]; then
        echo "$host,$port,Ok"
    else
        echo "$host,$port,Failed"
    fi
done