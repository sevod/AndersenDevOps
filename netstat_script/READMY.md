# Homework 2. Netstat script.

### Main tasks:

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
8. Delete all pipes. (As I understood task, maybe incorrect).

### Additional tasks:

9. The script mast show numbers of connections to each organisation.
10. The script mast take other data from "whois".
11. The script can work with "ss". You use other utilities, not from step 1.

# How to use this script.
1. parameter - PID or name of process.
2. parameter - number of rows (default 5).
3. parameter - connection state. Not necessarily.
   - ls - LISTEN
   - cd - CLOSED
   - ss - SYN_SENT
   - sr - SYN_RECEIVED
   - es - ESTABLISHED
   - cw - CLOSE_WAIT
   - fw - FIN_WAIT_1
   - cg - CLOSING
   - la - LAST_ACK
   - fw2 - FIN_WAIT_2
   - tw - TIME_WAIT

### Examples

`./netstat_script.sh firefox 10 es`

`./netstat_script.sh 2255 5 ls`

`./netstat_script.sh firefox`

# How dose the script work

1. ````
      if [ -z "$1" ]; then
      echo "The first parameter is incorrect"
      exit
      fi
   ````
   Check the first parameter.
   
2. ````
      if [[ "$2" =~ [^0-9]+ ]]; then
      echo "The second parameter is incorrect"
      exit
      fi
   ````
   Check, that the second is only number.
   
3. ````
      if [[ "$2" -eq 0 ]]; then
         num=5
      else
         num="$2"
      fi
   ````   
   If the second parameter equals 0, we use 5, else we use the parameter.

4. ````
      if [[ "$EUID" -ne 0 ]]; then
      echo "Please run as root to see all information."
      fi
   ````
   If not a root user, we use notification.

5. ````
      if [ "$3" = "ls" ]; then
         state="LISTEN"
      ...
   ````
   Here we initialise variable state.
   
6. `nets=$(sudo netstat -tunapl)` - receive all connections, and put them in variable "nets".
7. `nets=$(grep "$state" <<<"$nets")` -  filter for connection state.
8. `nets=$(awk '/'"$1"'/ {print $5}' <<<"$nets")'` - use the filter, name or PID of process. Also use variable $1. In this variable user mast put PID or name of process. Part `print $5` means, that only 5 strings will be use. It will be IP address and port. 
9. `nets=$(cut -d: -f1 <<<"$nets")` - cut strings. It deletes ports.
10. `nets=$(sort <<<"$nets")` - sort strings.
11. `nets=$(tail -n"$num" <<<"$nets")` - how many strings mast by shown. Variable $num is the second parameter of the script.
12. `nets=$(grep -oP '(\d+\.){3}\d+' <<<"$nets")` - filter. 
13.   ````
        while read IP; do
            whs=$(whois "$IP")
            org=$(awk -F':' '/^Organization/ {print $2}' <<<"$whs")
            if [ -n "$org" ]; then
               echo "$org"
            fi
        done <<< "$nets"
      ````
      Loop reads all IP from variable "$nets". Then read "whois" for each IP. Then use the filter `awk -F':' '/^Organization/ {print $2}' <<<"$whs"`, after this filter will be only name of organization. And print if it has string.




