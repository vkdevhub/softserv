#!/bin/bash

# Check if exactly three arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <source_folder> <destination_folder> <size_limit>"
    exit 1
fi

# Assign arguments to variables
SOURCE=$1
DESTINATION=$2
SIZE_LIMIT=$3
LOG_FILE="/my_files/backup.log"

# Parse the remote machine and destination folder
REMOTE_MACHINE=$(echo "$DESTINATION" | awk -F: '{print $1}')
REMOTE_FOLDER=$(echo "$DESTINATION" | awk -F: '{print $2}')

# Log the start time of the backup
echo "Backup started at $(date)" >> $LOG_FILE

# 1. Find oversized folders on the remote machine using ssh and exclude them
OVERSIZED_FOLDERS=$(ssh $REMOTE_MACHINE "find $REMOTE_FOLDER -type d -exec du -sh {} + | awk '\$1 > \"$SIZE_LIMIT\" {print \$2}'")

# Format the list of oversized folders for exclusion in rsync
EXCLUDE_OVERSIZED=""
for folder in $OVERSIZED_FOLDERS; do
    EXCLUDE_OVERSIZED+="--exclude=$folder "
done

# 2. Run the rsync command to sync files from source to destination with exclusions
RSYNC_COMMAND="rsync -av --delete \
    --exclude=\"*.log\" \
    --exclude=\"/logs\" \
    --exclude=\"/target\" \
    --exclude=\".*\" \
    $EXCLUDE_OVERSIZED \
    $SOURCE $DESTINATION"

# 3. Evaluate and run the rsync command
eval $RSYNC_COMMAND >> $LOG_FILE 2>&1

# Check if rsync command was successful and log the result
if [ $? -eq 0 ]; then
    echo "Backup completed successfully at $(date)" >> $LOG_FILE
else
    echo "Backup encountered an error at $(date)" >> $LOG_FILE
fi
