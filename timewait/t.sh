#!/bin/bash

tempfile=`mktemp /tmp/temp.XXXXXX`
counter=0

if [ $# != 1 ] ; then
    echo "USAGE: $0 port"
    exit 1;
fi

while true
do
    timestamp=`date "+%Y-%m-%dT%H:%M:%S" `
    result=`netstat -ant | grep "TIME_WAIT" | grep $1`
    if test $? -eq 0
    then
        echo $timestamp >> $tempfile
        if test $counter -eq 0
        then
            counter=$((counter+1))
        fi
    else
        if test $counter -eq 1
        then
            counter=$((counter+1))
        fi
    fi

    if test $counter -eq 2
    then
        echo -n "Duration:"
        echo -n `head -1 $tempfile`
        echo -n " <==> "
        echo -n `tail -1 $tempfile`
        echo
        break
    fi

    sleep 0.2
done

rm -f $tempfile
