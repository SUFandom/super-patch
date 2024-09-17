#!/bin/bash

# Extractor
# realpath .
# sleep 100

case $1 in
    "--extract")
        case $2 in
            "--ap")
                if [ -e "$3" ]; then 
                    echo "File found"
                    echo "Exec Extract"
                    mv "$3" "$(realpath .)/imgbuild/$(basename "$3")"
                    echo "Extracting $(basename $3)"
                    tar -xvf "$(realpath .)/imgbuild/$(basename "$3")"  -C "$(realpath .)/imgbuild/" super.img.lz4
                    if [ "$?" -ne "0" ]; then
                        # Oops, wrong file, probably file was older variant
                        tar -xvf "$(realpath .)/imgbuild/$(basename "$3")"  -C "$(realpath .)/imgbuild/" super.img
                    fi
                    for remove in "$(realpath .)/imgbuild/"*; do
                        case "$(basename $remove)" in
                            super.img.lz4/super.img)
                                ;;
                            *)
                                rm -rfv $remove
                                ;;
                        esac
                    done
                    if [ -e "$(realpath .)/imgbuild/super.img.lz4" ]; then
                        lz4 -c -d "$(realpath .)/imgbuild/super.img.lz4" > "$(realpath .)/imgbuild/super.img"
                    fi
                    echo "Done extracting $(basename $3)"
                    echo "Preparing to raw the simg"
                    simg2img $(realpath imgbuild)/super.img $(realpath imgbuild)/super_raw.img
                    if [ "$(ls -nl "$(realpath imgbuild)/super_raw.img" | awk '{print $5}')" -lt 100000 ]; then
                        echo "Super_raw is unreasonably tiny..."
                        echo "Removing Super_raw since it may be obsolete"
                        echo "Instead using super instead"
                        lpunpack $(realpath imgbuild)/super.img $(realpath imgbuild)/
                        echo "Done"
                        echo "End extract.sh"
                        exit 0
                    else
                        echo "Super raw, OK"
                        lpunpack $(realpath imgbuild)/super_raw.img $(realpath imgbuild)/
                        echo "Done"
                        echo "End extract.sh"
                        exit 0
                    fi
                else
                    echo "File not found"
                    echo "Are you sure its: $?"
                    exit 1
                fi
                    ;;
            "--super")
                if [ -e "$3" ]; then
                    echo "File found"
                    echo "Exec Extract"
                    mv "$3" "$(realpath .)/imgbuild/$(basename "$3")"
                    if [ -e "$(realpath .)/imgbuild/super.img.lz4" ]; then
                        lz4 -c -d "$(realpath .)/imgbuild/super.img.lz4" > "$(realpath .)/imgbuild/super.img"
                    elif [ -e "$(realpath .)/imgbuild/super.img" ]; then
                        echo "Is not lz4"
                    fi
                    echo "super.img to raw"
                    simg2img $(realpath imgbuild)/super.img $(realpath imgbuild)/super_raw.img
                    if [ "$(ls -nl "$(realpath imgbuild)/super_raw.img" | awk '{print $5}')" -lt 100000 ]; then
                        echo "Super_raw is unreasonably tiny..."
                        echo "Removing Super_raw since it may be obsolete"
                        echo "Instead using super instead"
                        rm -rf "$(realpath imgbuild)/super_raw.img"
                        lpunpack $(realpath imgbuild)/super.img $(realpath imgbuild)/
                        echo "Done"
                        echo "End extract.sh"
                        exit 0
                    else
                        echo "Super raw, OK"
                        lpunpack $(realpath imgbuild)/super_raw.img $(realpath imgbuild)/
                        echo "Done"
                        echo "End extract.sh"
                        exit 0
                    fi
                else 
                    echo "File not found"
                    echo "Are you sure its: $?"
                    exit 1
                fi
                ;;
        esac
        ;;
    "--help")
        echo ""
        echo "Extractor for super-patch"
        echo "v1"
        echo ""
        echo "Usage:"
        echo "  ./extract.sh --[extract/help] --[ap/super] <file location>"
        echo ""
        exit
        ;;
    *)
        $0 --help
        ;;
esac
                    
