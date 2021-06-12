#!/bin/bash

#Check $1
if [ -z "$1" ]; then
  echo "The first parameter is incorrect"
  exit
fi

#Star checkin $2
if [[ "$2" =~ [^0-9]+ ]]; then
  echo "The second parameter is incorrect"
  exit
fi

if [[ "$2" -eq 0 ]]; then
  num=5
else
  num="$2"
fi
#End checkin $2

#check root
if [[ "$EUID" -ne 0 ]]; then
  echo "Please run as root to see all information."
fi

#Start module State
if [ "$3" = "ls" ]; then
  state="LISTEN"
elif [ "$3" = "cd" ]; then
  state="CLOSED"
elif [ "$3" = "ss" ]; then
  state="SYN_SENT"
elif [ "$3" = "sr" ]; then
  state="SYN_RECEIVED"
elif [ "$3" = "es" ]; then
  state="ESTABLISHED"
elif [ "$3" = "cw" ]; then
  state="CLOSE_WAIT"
elif [ "$3" = "fw1" ]; then
  state="FIN_WAIT_1"
elif [ "$3" = "cg" ]; then
  state="CLOSING"
elif [ "$3" = "la" ]; then
  state="LAST_ACK"
elif [ "$3" = "fw2" ]; then
  state="FIN_WAIT_2"
elif [ "$3" = "tw" ]; then
  state="TIME_WAIT"
elif [ "$3" != "" ]; then
  echo The therd parameter is incorrect. Will be shoun all states.
fi
#End module State

#Start Main module
nets=$(netstat -tunapl 2>/dev/null)
nets=$(grep "$state" <<<"$nets")
nets=$(awk '/'"$1"'/ {print $5}' <<<"$nets")
nets=$(cut -d: -f1 <<<"$nets")
nets=$(sort <<<"$nets")
nets=$(uniq -c <<<"$nets")
nets=$(sort <<<"$nets")
nets=$(tail -n"$num" <<<"$nets")
nets=$(grep -oP '(\d+\.){3}\d+' <<<"$nets")
while read IP; do
  whs=$(whois "$IP")
  org=$(awk -F':' '/^Organization/ {print $2}' <<<"$whs")
  if [ -n "$org" ]; then
    echo "$org"
  fi
done <<<"$nets"
#End Main module
