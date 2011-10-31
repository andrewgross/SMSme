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
exit 1
}


check_environment()
{
    if ! which sendmail > /dev/null 2>&1
    then
        echo "[ERROR] sendmail not found!" >&2
        exit 1
    fi
}

send_message()
{
    echo "${MESSAGE}" |  mail -s "SMSme" ${NUMBER}@vtext.com    
}


check_environment

# Minimum number of arguments includes switches, like -h
MIN_ARGS=2
[ $# -lt ${MIN_ARGS} ] && usage

while getopts “hn:m:” OPTION
do
    case ${OPTION} in
    h)
        # Show help information
        usage
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
        ;;
    esac
done

send_message



