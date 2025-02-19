#!/bin/bash

# Define base directory
BASE_DIR="/xrr_records"

echo "XRR Cleanup Service Started. Monitoring $BASE_DIR..."

while true; do
    current_time=$(date +%s)

    for dir in "$BASE_DIR"/xrr-*; do
        if [[ -d "$dir" ]]; then
            exp_file="$dir/expiration_time.json"

            if [[ -f "$exp_file" ]]; then
                expire_time=$(jq -r '.timestamp' "$exp_file")

                # If expiration time is more than 10 minutes old, delete the directory
                if [[ $((current_time - expire_time)) -gt 600 ]]; then
                    echo "$(date): Removing expired directory $dir" | tee -a "$BASE_DIR/cleanup.log"
                    rm -rf "$dir"
                fi
            fi
        fi
    done

    sleep 60  # Wait 1 minute before checking again
done
