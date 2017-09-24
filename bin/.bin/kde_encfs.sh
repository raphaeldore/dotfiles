#!/bin/bash

# Mounts an Encfs partition with dialogues, and a password stored in KDE Wallet.
# The first parameter is the encrypted directory and the second parameter is the mount point.
# If the password is not present in kwallet, then it is entered via a dialogue and then stored in the wallet.
#
# Original script by Taboom (version 1.2) found at http://www.kde-apps.org/content/show.php/Truecrypt+mount+and+unmount+scripts?content=53634
 
SOURCE=$1
DESTINATION=$2

# If parameters are missing
if [ -z "$SOURCE" ]; then
  echo "SOURCE parameter (full path to encrypted directory) is required."
  exit 1
fi

if [ -z "$DESTINATION" ]; then
    echo "DESTINATION parameter (mount point) is required."
    exit 1
fi
 
 
# Is this Encfs partiton mounted?
if [ "$(mount | grep $DESTINATION)" != "" ]; then
  echo "Encfs: $DESTINATION is already mounted"
else
  PASSWORD=$(kwallet-query --read-password $DESTINATION kdewallet)
  # By default assume that the password was fetched from KDE Wallet
  PASSWORD_FETCHED=0
 
  # Password does not exist - ask for it from the user
  if [[ "$PASSWORD" = "Failed to read entry"* ]]; then
    read -s -p "Please enter passphrase for $DESTINATION: " PASSWORD
    PASSWORD_FETCHED=$?
    echo "\n"
  fi
 
  # If password is fetched or given
  if [ $? != "" ];
    then
    # Try mounting the Encfs partition
    A=$(echo $PASSWORD | encfs -S $SOURCE $DESTINATION )
    # If successful mount
    if [ $? == "0" ]
      then
      # If password was asked from the user, save it to KDE Wallet
      if [ "$PASSWORD_FETCHED" = "0" ]; then
        "From the manual: The secrets are read from the standard input."
        B=$(echo $PASSWORD | kwallet-query --write-password $PASSWORD kdewallet)
      fi
      echo "Encfs partition $DESTINATION mounted successfully."
    else
      # Unsuccessful mount
      echo "Failed to mount Encfs partition $DESTINATION. Incorrect password or error."
    fi
  fi
fi
