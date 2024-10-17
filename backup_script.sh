#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <source_folder> <destination_folder>"
    exit 1
fi

SOURCE=$1
DESTINATION=$2
rsync -av --delete --exclude="*.log" "$SOURCE" "$DESTINATION"
