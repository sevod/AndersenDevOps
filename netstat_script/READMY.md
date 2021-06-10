#Homework 2. Netstat script.

Not finished yet.

###Main tasks:

1.  Create a new script from this:
````
sudo netstat -tunapl | awk '/firefox/ {print $5}' | 
cut -d: -f1 | sort | uniq -c | sort | tail -n5 | 
grep -oP '(\d+\.){3}\d+' | while read IP ; do whois $IP | 
awk -F':' '/^Organization/ {print $2}' ; done
````
2. Create a READMY.md file. In this file write, what your script does.
3. The script mast take argument. PID or name of process.
4. User mast have possibility to change number of strings output. 
5. Mast be possibility to see other states of connection.
6. The script mast print messages of mistakes.
7. The script shouldn't depend on launch privileges 

###Additional tasks:
8. The script mast show numbers of connections to each organisation.
9. The script mast take other data from "whois".
10. The script can work with "ss". You use other utilities, not from step 1.

#How to use this script.
1. parameter - PID or name of process.
2. parameter - number of rows.

##Examples

`./``netstat_script.sh firefox 10`

`./netstat_script.sh 2255 5`


#How dose this script works

1. `nets=$(sudo netstat -tunapl)` - receive all connections, and put them in variable "nets".
2. `nets=$(awk '/'"$1"'/ {print $5}' <<<"$nets")'` - use the filter, name or PID of process. Also use variable $1. In this variable user mast put PID or name of process. Part `print $5` means, that only 5 column will be use. It will be IP address and ports. 
3. `nets=$(cut -d: -f1 <<<"$nets")` - cut strings. It deletes ports.
4. `nets=$(sort <<<"$nets")` - sort strings.
5. `nets=$(tail -n"$2" <<<"$nets")` - how many strings mast by shown. Variable $2 mast have numbers of strings. It's the second parameter of script.
6. `nets=$(grep -oP '(\d+\.){3}\d+' <<<"$nets")` - filter. 
7. 
````
while read IP; do
 whs=$(whois "$IP")
 nets=$(awk -F':' '/^Organization/ {print $2}' <<<"$whs")
done <<< "$nets"
````
Loop reads all IP from variable "$nets". Then read "whois" for each IP. Then use the filter `awk -F':' '/^Organization/ {print $2}' <<<"$whs"`, after this filter will be only organization name.
8. `echo "$nets"` - end of my script. Print all organization.




