#!/bin/bash

test "$1" ||  { echo "Usage: `basename $0` HOST" >&2 ; exit 1; }

host=$1     # new host entry

# inventory file
inventory=$( awk -F= '/^ *inventory/ {print $2}' \
                `ansible --version 2>/dev/null | awk -F= '/config file/ {print $2}'` )

declare -a groups=( `sed -n '/\[\([^:]\+\)\]/ s//\1/p' $inventory` )
select group in ${groups[@]}
do
  if [ -n "$group" ];
  then break
  else echo "Wrong selection, try again...." 
  fi
done
echo "Adding to the '$group'"

echo -e \
"/\[$group
?\w
a
$host
.
w
q" | ed -s $inventory 1>/dev/null

#echo -e "
#/\[$group
#?\w
#a
#$host
#.
#w
#q" | ed -s $inventory
