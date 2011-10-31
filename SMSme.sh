#!/bin/bash

usage()
{
cat << EOF
usage: $0 [options]

This script is a simple interface to send SMS messages via email.

OPTIONS:
    -h      Show this message
    -m      Message
                Ex: -m "The job has finished!"
    -n      Phone Number, no delimiters         
                Ex: -n "5551234567"

EOF
}


check_environment()
{
    if ! which sendmail > /dev/null 2>&1
    then
        echo "[ERROR] sendmail not found!" > &2
        exit 1
    fi
}

send_message()
{
    echo "${MESSAGE}’" |  mail -s "SMSme" ${NUMBER}@vtext.com    
}


check_environment

# Minimum number of arguments includes switches, like -h
MIN_ARGS=2
if [ $# -lt ${MIN_ARGS} ]
then
    usage
    exit 1
fi

while getopts “hn:m:” OPTION
do
    case ${OPTION} in
    h)
        # Show help information
        usage
        exit 1
        ;;
    n)
        # Set number passed in
        NUMBER="${OPTARG}"
        ;;
    m)
        # Set Message
        MESSAGE="${OPTARG}"
        ;;
    ?)
        # Handle uncaught parameters
        usage
        exit 1
        ;;
    esac
done





