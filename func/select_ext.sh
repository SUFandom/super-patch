#!/bin/bash

# Selector for AP
# ill try to merge-case this later on

CACHE=$(realpath cached_proc)/ext_cache.txt # i just found out that open in python works like ninkapoop

if [ -e "$CACHE" ]; then 
    rm -rf $CACHE
fi


if [ -e "/usr/bin/ranger" ] || [ -e "/data/data/com.termux/files/usr/bin/ranger" ]; then
    ranger --choosefile=$CACHE $1
else
    echo "Ranger Command not found"
    exit 1
fi

