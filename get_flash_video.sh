#!/bin/bash

args=("$@")

args=`echo $args | sed 's/[/]$//'`

pids=`eval pgrep -f flashplayer`
for pid in $pids
do
lsoutput=$(lsof -p $pid | grep '/tmp/Flash[^ ]*')

IFS=$'\n'
for line in $lsoutput; do
lsout1=`echo $line | awk '{print "/proc/" $2 "/fd/" $4}' | sed 's/[rwu]$//'`
lsout2=`echo $line | awk '{print $9}' | awk -F '/' '{print $3}'`

if [ -n "$args" ];then
if [ -d $args ]; then
echo "Copying $lsout2 to $args/"
eval "cp $lsout1 $args/$lsout2.flv"
else
echo "The directory \"$args\" doesn't exist"
break
fi
else
echo "Copying $lsout2"
eval "cp $lsout1 $lsout2.flv"
echo "Copied $lsout2.flv from $lsout1"
fi

done
done
