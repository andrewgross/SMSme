#!/bin/bash

init(){
    
    providers[1]='"Verizon": "vtext.com"'
    providers[2]='"ATT": "txt.att.net"'
    providers[3]='"T-Mobile": "tmomail.net"'
    providers[4]='"Sprint": "messaging.sprintpcs.com"' 
    
}

usage()
{
cat << EOF
usage: $0 [options]

This script is a simple interface to send SMS messages via email.

OPTIONS:
    -h      Show this message
    -m      Message
                Ex: -m "The job has finished!"
    -n      Phone Number (No delimiters)         
                Ex: -n "5551234567"
    -p      Cell Phone Provider (Leave empty for a list)
                Ex: Verizon
                
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

list_providers()
{
    IFS=$','
    for provider in ${providers[@]}
    do
       echo "${provider}"
    done    
    exit 1    
}

get_provider()
{    
    IFS=$','
    [ ! -z "$SMS_PROVIDER_ADDRESS" ] && export SMS_PROVIDER_ADDRESS && return 0
    for provider in ${providers[@]}
    do
        # Check for a preset variable before looping     
        SMS_PROVIDER_ADDRESS=$(echo "${provider}" | grep -i ${PROVIDER_NAME} | awk '{print $2}' | tr -d \" )       
        [ ! -z "$SMS_PROVIDER_ADDRESS" ] && export SMS_PROVIDER_ADDRESS && return 0
    done
    list_providers
}

send_message()
{
    echo "${MESSAGE}" |  mail -s "SMSme" ${NUMBER}@${SMS_PROVIDER_ADDRESS}   
}

# Minimum number of arguments includes switches, like -h
MIN_ARGS=1
[ $# -lt ${MIN_ARGS} ] && usage

declare -a providers
init

while getopts “hn:n:m:p:l” OPTION
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
    p)  # Set provider
        PROVIDER_NAME="${OPTARG}"
        ;;
    l)  # List providers
        list_providers
        ;;
    ?)
        # Handle uncaught parameters
        usage
        ;;
    esac
done

check_environment
get_provider
send_message




