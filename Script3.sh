#!/bin/bash

# Script to monitor hidden files, root executables, and changes

HIDDEN_FILES="/etc/.*"
ROOT_EXECUTABLES="/bin /sbin /usr/bin /usr/sbin"

# Log changes to hidden files
find /etc -regex $HIDDEN_FILES -exec stat -c "%n %U %y" {} \; >> /var/log/hidden_files.log

# Log changes to root executables
for dir in $ROOT_EXECUTABLES; do
    find $dir -type f -exec stat -c "%n %U %y" {} \; >> /var/log/root_executables.log
done
