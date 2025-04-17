#!/bin/sh

if [ -z "$FTP_USER" ]; then
    echo "Missing \$FTP_USER variable."
    exit 1
fi

if [ -z "$FTP_HOST" ]; then
    echo "Missing \$FTP_HOST variable."
    exit 1
fi

if [ -z "$FTP_PASSWORD" ]; then
    echo "Missing \$FTP_PASSWORD variable."
    exit 1
fi

if [ -z "$BUILD_DIR" ]; then
    echo "Missing \$BUILD_DIR variable."
    exit 1
fi


lftp "$FTP_HOST" -u "$FTP_USER,$FTP_PASSWORD" -e "
    set net:timeout 60;
    set net:max-retries 20;
    set net:reconnect-interval-multiplier 2;
    set net:reconnect-interval-base 5;
    set ftp:ssl-force false; 
    set sftp:auto-confirm yes;
    set ssl:verify-certificate false;
    mirror -v -P 5 -R -n -L -p $BUILD_DIR /;
    quit
"
