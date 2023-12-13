#!/bin/bash
# Script to detect changes in a specific directory using sha256 checksums
DIRECTORY_TO_MONITOR="/var/log"
CHECKSUM_FILE="/var/log/directory_checksum.sha256"
# Check if checksum file exists, create if not
if [ ! -e "$CHECKSUM_FILE" ]; then
    find $DIRECTORY_TO_MONITOR -type f -exec sha256sum {} \; > $CHECKSUM_FILE
fi
# Compare current checksums with the stored checksums
changed_files=$(sha256sum -c $CHECKSUM_FILE 2>/dev/null | grep -E ': (OK|FAILED)' | grep 'FAILED' | cut -d':' -f1)
# Log changes
if [ -n "$changed_files" ]; then
    echo "Changes detected in the following files: $changed_files" >> /var/log/directory_changes.log
    # Update checksum file
    find $DIRECTORY_TO_MONITOR -type f -exec sha256sum {} \; > $CHECKSUM_FILE
fi
