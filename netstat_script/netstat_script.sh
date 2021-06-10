#!/bin/bash

#made check for arguments. especially for 2

nets=$(sudo netstat -tunapl)
nets=$(awk '/'"$1"'/ {print $5}' <<<"$nets")
nets=$(cut -d: -f1 <<<"$nets")
nets=$(sort <<<"$nets")
nets=$(uniq -c <<<"$nets")
nets=$(sort <<<"$nets")
nets=$(tail -n"$2" <<<"$nets") #need check 2 argument
nets=$(grep -oP '(\d+\.){3}\d+' <<<"$nets")
while read IP; do
  whs=$(whois "$IP")
  nets=$(awk -F':' '/^Organization/ {print $2}' <<<"$whs")
done <<< "$nets"
echo "$nets"
