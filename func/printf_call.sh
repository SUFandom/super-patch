#!/bin/bash

TMP=$(realpath cached_proc) # Compatibility with snippet code

case $1 in
    "--measure")
        if [ -e "$2" ]; then # this is meant ensure it is there :D
            if [ "$(ls -nl "$(realpath imgbuild)/super_raw.img" | awk '{print $5}')" -lt 100000 ]; then
                lpdump $(realpath imgbuild)/super.img > $(realpath cached_proc)/super_map.txt
                printf "$(<$TMP$/super_map.txt)" | grep -e "Size:" | awk '{print $2}' > $TMP/super_size.txt
                printf "$(<$TMP/super_map.txt)" | grep -e "Maximum size:" | awk '{print $3}' | sed '2!d' > $TMP/super_main.txt
            else 
                lpdump $(realpath imgbuild)/super_raw.img > $(realpath cached_proc)/super_map.txt
                printf "$(<$TMP/super_map.txt)" | grep -e "Size:" | awk '{print $2}' > $TMP/super_size.txt
                printf "$(<$TMP/super_map.txt)" | grep -e "Maximum size:" | awk '{print $3}' | sed '2!d' > $TMP/super_main.txt
            fi
        else 
            echo "$2 not found"
        fi
        rm -rf $(realpath imgbuild)/super.img
        rm -rf $(realpath imgbuild)/super_raw.img
        ;;
    "--help")
        echo ""
        echo "Sparse image dump and measure"
        echo "v1"
        echo ""
        echo "Usage:"
        echo "./printf_call.sh --measure <file>"
        echo ""
        echo "Note, at the end of the process, super.img and/or super_raw.img will be removed"
        exit
        ;;
    *)
        $0 --help
        ;;
esac
