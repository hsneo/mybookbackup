#!/bin/bash
# Author: Hock Sik
# Email Add: hsneo@mindmedia.com.sg
# mybookbackup.sh -- backup from a linux server to an usb external ntfs harddisk using rsync.

## first we set variables for the file
# Source specifications
# Here is the folder that will be backup to the external hard disk. Please enter
# the value for SOURCE_DIR.
SOURCE_DIR="/home/hsneo/project/FilterScript_handphone"

# Destination specifications 
# to use readlink -e to determine the associated block device for the external hard drive.
# The external hard drive shows up in /dev/disk/by-id with unique serial number
# The associated block device is assigned to the destination device that is the external hard drive.
readlink -e /dev/disk/by-id/usb-WD_My_Book_1140_2843415A4136393937383532  > $DESTINATION_DEVICE

# The values for DESTINATION_DIR and DESTINATION_BACKUPDIR are fixed
DESTINATION_DIR="/media"
DESTINATION_BACKUPDIR=$DESTINATION_DIR/backup

# Log device specifications 
# The value for LOG_DIR is fixed but it depends on your system
LOG_DIR="/var/log"

# If your system does not support ntfs, need to include this mountpoint.
mount -t ntfs $DESTINATION_DEVICE $DESTINATION_DIR -o defaults,umask=0 

# To check if the log directory exists. Otherwise, it will be created.
if [ -d $LOG_DIR ]; then
     echo "The log dir ($LOG_DIR) exists"
else
     mkdir $LOG_DIR
fi

# to start copying files and directories from the source to the external hard drive 
rsync -avz --log-file=$LOG_DIR/mybookbackup.log --progress $SOURCE_DIR $DESTINATION_BACKUPDIR/

# script to send email
# Email subject:
SUBJECT="Backup to My Book"
# Email To:
EMAIL="hsneo@mindmedia.com.sg"
# Email text/message
EMAILMESSAGE=$LOG_DIR/emailmessage.txt
echo "This is an email message informing you that the backup has been done successfully"> $EMAILMESSAGE
# send an email using /bin/mail
mail -s "$SUBJECT" "$EMAIL" < $EMAILMESSAGE

umount $DESTINATION_DEVICE

exit 0
