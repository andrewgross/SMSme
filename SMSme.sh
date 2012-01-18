#!/bin/bash

init()
{
    
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
    -p      Cell Phone Provider
                Ex: Verizon
    -l      List Known Providers
    -t      Test Mode (No messages sent)
                
EOF
exit 1
}


check_environment()
{
    if [ -z $(compgen -c | grep -x mail) ]
    then
        echo "[ERROR] mail not found!" >&2
        echo "[ERROR] is sendmail not installed or configured?" >&2
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
    [ ! -z "${SMS_PROVIDER_ADDRESS}" ] && export SMS_PROVIDER_ADDRESS && return 0
    for provider in ${providers[@]}
    do
        # This trims all quotes, even escaped ones.
        SMS_PROVIDER_ADDRESS=$(echo "${provider}" | grep -i ${PROVIDER_NAME} | awk '{print $2}' | tr -d \" )       
        [ ! -z "${SMS_PROVIDER_ADDRESS}" ] && export SMS_PROVIDER_ADDRESS && return 0
    done
    list_providers
}

send_message()
{
    if [[ "${TEST}" != "true" ]] ; then
        echo "${MESSAGE}" |  mail -s "SMSme" ${NUMBER}@${SMS_PROVIDER_ADDRESS}   
    else
        echo "[DEBUG] Message:      ${MESSAGE}"
        echo "[DEBUG] Number:       ${NUMBER}"
        echo "[DEBUG] Provider:     ${SMS_PROVIDER_ADDRESS}"
        echo "[DEBUG] Command:      echo \"${MESSAGE}\" |  mail -s \"SMSme\" ${NUMBER}@${SMS_PROVIDER_ADDRESS}"
    fi
}




# Minimum number of arguments includes switches, like -h
MIN_ARGS=1
[ $# -lt ${MIN_ARGS} ] && usage

declare -a providers
init

while getopts “hn:n:m:p:lt” OPTION
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
    t)  # Set test mode
        TEST=true
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




