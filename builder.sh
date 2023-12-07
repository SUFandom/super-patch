#!/bin/bash



# GLOBAL VARIABLES (FOR INFO AND EYECANDY)
VERSION_ID="0.7"
STATUS="devel_git"

if [ "$(pwd)" == "$(pwd | grep -a super-patch)" ]; then 
    echo "1st phse gd"
else 
    echo "Please run this script inside super-patch directory"
    exit 1
fi 

# ANOTHER GLOBAL VARIABLES (THAT ARE MUTABLE IF CONFIGED, NEXT VERSION)
case $(uname -m) in
    "x86_64") 
        if [ $EUID != 0 ]; then 
            echo "Please Run this as root"
            exit 1
        fi
        if [[ "$(wsainfo > /dev/null)" ]]; then 
            echo "WSL detected"
            LAB="$(pwd)/image_build"
            TMP="$HOME/cached_sp"
            CLEAR_UP="0"
            mkdir "$TMP"
            mkdir "$LAB"
            if [ ! -f "$TMP/pass" ]; then
                sudo cp -rf packages/amd64/* /bin
                sudo apt install android-sdk-libsparse-utils -y
                sudo apt update --fix-missing -y
                sudo apt install --fix-missing -y
                sudo apt install android-sdk-libsparse-utils -y
                sudo apt install p7zip-full lz4  -y 
                touch "$TMP/pass"
            fi 
            echo "Since you are running this in desktop, the process will be happening inside the super-patch folder"
            echo "Dir: $LAB"
            echo "So please move the files there"
            echo "If you are using WSA, you can check it on File Explorer, but we recommend you to run the Environment at WSL 2 for the tools to get working properly"
            echo ""
            echo ""
            echo "Starting in 10 seconds..."
            sleep 10
        else 
            echo "Real Debian Confirmed"
            LAB="$(pwd)/image_build"
            TMP="$HOME/cached_sp"
            CLEAR_UP="0"
            mkdir "$TMP"
            mkdir "$LAB"
            if [ ! -f "$TMP/pass" ]; then
                sudo cp -rf packages/amd64/* /bin
                sudo apt install android-sdk-libsparse-utils -y
                sudo apt update --fix-missing -y
                sudo apt install --fix-missing -y
                sudo apt install android-sdk-libsparse-utils -y
                sudo apt install p7zip-full lz4  -y 
                touch "$TMP/pass"
            fi 
                clear
                echo "Real Debian Moment Here!"
                echo "The Environment the building will take place at:"
                echo "$LAB"
                echo "And the TMP will be at:"
                echo "$TMP"
                echo -ne "\n\nRemeber that..."
                echo "Starting in 10 seconds"
                #sleep 10
                
        fi
        ;;
    "aarch64")
        termux-setup-storage
        ed=$?
        if [ "$ed" == 0 ]; then 
            dpkg -i packages/termux-arm64/*
            LAB="$HOME/storage/shared/image_build"
            TMP="$HOME/cached_sp"
            CLEAR_UP="0"
            mkdir "$LAB"
            mkdir "$TMP"
        else 
            echo "Setup can't continue if termux-setup-storage isnt working, also if youre running this other than termux, please download termux."
            echo "If you're running this on WSA Arm, uhhh sorry, script dont support that"
            echo "https://github.com/termux/termux-app"
            exit 1
        fi 
        dpkg -i packages/termux-arm64/*
        ;;
    *)
        echo "Your Device isnt supported: $(uname -m)"
        echo "This script only supports ARM64, and x86_64/AMD64"
        exit 1
        ;;
esac

#TMP="$HOME/cached_sp"

# Trap Functions

function cleanup_waste {
    if [[ "$CLEAR_UP" == 1 ]]; then 
        bar
        msg "Cleaning Up TMP Directories.."
        rm -rf "${TMP/*}"
        msg "Done"
        bar 
        exit
    else 
        msg "cleanup_waste: FLAG CLEAR_UP was set to 0, will not clean the tmpfiles"
        exit
    fi
}

trap 'cleanup_waste' 0 1


# CORE FUNCTIONS

function msg {
    echo "$1"
}

function bar {
    msg ""
    msg "==============================================="
    msg ""
}

function datetime {
    M_D_Y=$(date +%m-%d-%y)
    SECOND_TMER=$(date +%T)
    msg "$M_D_Y - $SECOND_TMER<s>"
}

function check_files {
    #obsolete
    bar
    msg "Analyzing Files"
    msg "The files will also be installed"
    bar 

}

function msgbox {
    dialog --backtitle "SAMSUNG GSI TO SUPER - $VERSION_ID - $STATUS" --title "$1" --msgbox "$2" 0 0 
}


# function linkerer {
#     # OBSOLETE
#     ln -s "~/builder.sh" "$PREFIX/bin"
# }

function mdt {
    #MSG with Datetime
    msg "$(datetime) - $1"
}

function yesno () {
    clear
    dialog --backtitle "SAMSUNG GSI TO SUPER - $VERSION_ID - $STATUS" --title "Confirm" --yes-label "Sure" --no-label "Cancel" --yesno "$1" 0 0  
}



# Inner workings


function extract_ap {
    # Extracts AP, and super
    msg "$(datetime) - Checking if files are present"
    if [ -e "$LAB/AP_*.tar.md5" ]; then
        msg "$(datetime) - AP File Found... Extracting"
        mkdir $LAB/AP
        7z e $LAB/AP_*.tar.md5 -o $LAB/AP
        #E1
        msg "$(datetime) - Looking for the Super"
        if [ -e "$LAB/AP/super.img.lz4" ]; then 
            msg "$(datetime) Super.img.lz4 Found"
            mv -f $LAB/AP/super.img.lz4" "$LAB/super.img.lz4
            mdt "File Moved and Cleaning Useless leftovers..."
            rm -rf $LAB/AP
            mdt "Useless Files Removed"
            sleep 1
            menu_ap_super
        else 
            mdt "No LZ4 Version of Super.img was found after extraction, checking if theres super.img"
            if [ -e "$LAb/AP/super.img" ]; then 
                mdt "Super.img found, moving"
                mv -f $LAB/AP/super.img $LAB/super.img
                mdt "File moved, and cleaning useless leftovers"
                rm -rf $LAB/AP
                mdt "Useless Files Removed"
                mdt "Going back"
                sleep 5
                menu_ap_super
            else 
                mdt "Cannot find super.img or super.img.lz4, make sure thats the right AP that you selected or make sure the device is treble supported"
                sleep 5
                menu_man "Error: super.img not found - AP_no_super"
            fi 
        fi
        else 
            mdt "Cannot Find AP Image, if you have already extracted it, then try to go to Extract Super instead"
            sleep 5
            menu_man "Error: Can't locate AP"
    fi
}

function extract_super_img {
    mdt "Extracting Super IMG File"
    mdt "Checking if super was compressed"
    if [ -e "$LAB/super.img.lz4" ] ; then 
        mdt "Super was compressed, decompressing"
        unlz4 --rm $LAB/super.img.lz4
        mdt "Super was reported to be uncompressed now by unlz4, confirming"
        if [ -e "$LAB/super.img" ]; then 
            mdt "Super was indeed Uncompressed"
            if [ -e "$LAB/super.img" ]; then 
                mdt "Now, converting it"
                simg2img $LAB/super.img $LAB/super_raw.img
                mdt "Simg2img process stopped, checking if super_raw exists..."
                if [ -e "$LAB/super_raw.img" ]; then 
                    mdt "super_raw.img exists, checking the file"
                        if [ "$(ls -nl "$LAB/super_raw.img" | awk '{print $5}')" -lt 100000 ]; then
                            mdt "Super raw seems abnormally tiny (below 100MB)"
                            mdt "Removing Super_raw since it may be obsolete"
                            mdt "Instead using super instead"
                            rm -rf $LAB/super_raw.img
                            mdt "Dumping super.img"
                            lpdump $LAB/super.img > $TMP/super_map.txt
                            mdt "Dumping Done"
                            mdt "Calling printf to do something..."
                            printf "$(<$TMP/super_map.txt)" | grep -e "Size:" | awk '{print $2}' > $TMP/super_size.txt
                            printf "$(<$TMP/super_map.txt)" | grep -e "Maximum size:" | awk '{print $3}' | sed '2!d' > $TMP/super_main.txt
                            mdt "printf process done"
                            mdt "Packing"
                            lpunpack $LAB/super.img $LAB/
                            mdt "Done"
                            gsi_select
                        else 
                            mdt "Removing Super.img since we have super_raw"
                            rm -rf $LAB/super.img
                            mdt "Super.img removed"
                            mdt "Dumping super_raw.img"
                            lpdump $LAB/super_raw.img > $TMP/super_map.txt
                            mdt "Dumping Done"
                            mdt "Calling printf to do something..."
                            printf "$(<$TMP/super_map.txt)" | grep -e "Size:" | awk '{print $2}' > $TMP/super_size.txt
                            printf "$(<$TMP/super_map.txt)" | grep -e "Maximum size:" | awk '{print $3}' | sed '2!d' > $TMP/super_main.txt
                            mdt "printf process done"
                            mdt "Packing"
                            lpunpack $LAB/super_raw.img $LAB/
                            gsi_picker
                        fi
                    else 
                        mdt "Cannot proceed because super_raw is not present, it also proves the fact that super.img could be corrupted"
                        sleep 3
                        menu_man "Error: super_img_corrupt"
                    fi
                else
                    mdt "Could not find super.img"
                    mdt "Try checking Terminal permissions"
                    sleep 3
                    menu_man "Error: cant locate super.img?"
                fi 
        else 
            mdt "Super was not uncompressed"
            mdt "It seems theres an internal error."
            mdt "Report this: extract_super_lz4_error_8"
            sleep 5
            menu_man "Error: Special: extract_super_lz4_error_8"
        fi 
    else 
        mdt "It seems that super.img.lz4 is not present, could it be the user had already extracted it?"
        mdt "Checking for the super.img in the directory build"
        if [ -e "$LAB/super.img" ]; then 
            mdt "Yes, confirmed super.img was extracted already by external interference..."
            mdt "Now, converting it"
            simg2img $LAB/super.img $LAB/super_raw.img
            mdt "Simg2img process stopped, checking if super_raw exists..."
            if [ -e "$LAB/super_raw.img" ]; then 
                mdt "super_raw.img exists, checking the file"
                if [ "$(ls -nl "$LAB/super_raw.img" | awk '{print $5}')" -lt 100000 ]; then
                    mdt "Super raw seems abnormally tiny (below 100MB)"
                    mdt "Removing Super_raw since it may be obsolete"
                    mdt "Instead using super instead"
                    rm -rf $LAB/super_raw.img
                    mdt "Dumping super.img"
                    lpdump $LAB/super.img > $TMP/super_map.txt
                    mdt "Dumping Done"
                    mdt "Calling printf to do something..."
                    printf "$(<$TMP/super_map.txt)" | grep -e "Size:" | awk '{print $2}' > $TMP/super_size.txt
                    printf "$(<$TMP/super_map.txt)" | grep -e "Maximum size:" | awk '{print $3}' | sed '2!d' > $TMP/super_main.txt
                    mdt "printf process done"
                    mdt "Packing"
                    lpunpack $LAB/super.img $LAB/
                    mdt "Done"
                    gsi_select
                else 
                    mdt "Removing Super.img since we have super_raw"
                    rm -rf $LAB/super.img
                    mdt "Super.img removed"
                    mdt "Dumping super_raw.img"
                    lpdump $LAB/super_raw.img > $TMP/super_map.txt
                    mdt "Dumping Done"
                    mdt "Calling printf to do something..."
                    printf "$(<$TMP/super_map.txt)" | grep -e "Size:" | awk '{print $2}' > $TMP/super_size.txt
                    printf "$(<$TMP/super_map.txt)" | grep -e "Maximum size:" | awk '{print $3}' | sed '2!d' > $TMP/super_main.txt
                    mdt "printf process done"
                    mdt "Packing"
                    lpunpack $LAB/super_raw.img $LAB/
                    gsi_picker
                fi
            else 
                mdt "Cannot proceed because super_raw is not present, it also proves the fact that super.img could be corrupted"
                sleep 3
                menu_man "Error: super_img_corrupt"
            fi
        else
            mdt "Could not find super.img"
            mdt "Try checking Terminal permissions"
            sleep 3
            menu_man "Error: cant locate super.img?"
        fi 
    fi
}

function super_info {
    #This is a descriptor
    # Only Intended for dialog env
    msg "\n\nSuper Image Size: $(ls -nl "$LAB/super.img" | awk '{print $5}')"
    msg "\nSystem Image Size: $(ls -nl "$LAB/system.img" | awk '{print $5}')"
    msg "\nVendor Image Size: $(ls -nl "$LAB/vendor.img" | awk '{print $5}')"
    msg "\nProduct Image Size: $(ls -nl "$LAB/product.img" | awk '{print $5}')"
    msg "\nSystem EXT Image Size: $(ls -nl "$LAB/system-ext.img" | awk '{print $5}')"
    msg "\nODM Image Size: $(ls -nl "$LAB/odm.img" | awk '{print $5}')"
}


function menu_ap_super {
    menu_page=$(dialog \
                --backtitle "SAMSUNG GSI TO SUPER - $VERSION_ID - $STATUS" \
                --title "Extract AP/Super" \
                --menu "Select what you want to do in the menu\n\nReports by super_info:$(super_info)\n\nIf these values are empty, it means you didnt do the process or something.\nAsk us at the Telegram Group" 0 0 0 \
                "Extract AP" "Extract AP File (Stock AP)" \
                "Extract Magisked AP" "Extract Magisked AP" \
                "Extract Super" "Extract Super File instead" \
                "Pick GSI" "Pick GSI" \
                2>&1 >/dev/tty)
                local ervar=$?
                case $ervar in 
                    1)
                        clear
                        menu_man
                        ;;
                esac 
                case $menu_page in 
                    "Extract AP")
                        yesno "Are you sure that you want to extract the AP? Make sure it is present in your dir: $LAB"
                        fetch=$?
                        case $fetch in
                            0)
                                clear 
                                mdt "Process now in verbose mode for stable processing"
                                mdt "Starting in 5 seconds"
                                sleep 5
                                extract_ap
                                ;;
                            1)
                                menu_ap_super
                                ;;
                        esac 
                        ;;
                    "Extract Super")
                        yesno "Are you sure you want to extract the Super? Make sure that you already extracted it in this Dir: $LAB\n\nAlready extracted super.img works too."
                        fetch=$?
                        case $fetch in 
                            0)
                                clear 
                                mdt "Process now in verbose mode for stable processing"
                                mdt "Starting in 5 seconds"
                                sleep 5 
                                extract_super_img
                                ;;
                            1)
                                menu_ap_super
                                ;;
                        esac
                        ;;
                    "Pick GSI")
                        gsi_picker
                        ;;
                    "Extract Magisked AP")
                        yesno "Are you sure you want to pick 'Extract Magisked AP'?"
                        fetch=$?
                        case $fetch in 
                            0)
                                magisk_pick_ap
                                ;;
                            1)
                                menu_ap_super
                                ;;
                        esac
                        ;;
                    *)
                       clear
                       mdt "Something went wrong and the process needed to end abruptly"
                       mdt "Please report this: E-mapsu-cl=$menu_page"
                       exit 9
                       ;;
                    esac
}

function magisk_pick_ap {
    # This is painful to implement
    PCX=$(dialog \
            --backtitle "SAMSUNG GSI TO SUPER - $VERSION_ID - $STATUS" \
            --title "Pick Patched AP by Magisk" \
            --ok-label "Pick the AP File" \
            --cancel-label "Back" \
            --fselect "$LAB" 0 0 \
            2>&1 >/dev/tty)
    local exvar=$?
    case $exvar in 
        1)
            menu_ap_super
            ;;
        0)
            if [ -z $PCX ]; then 
                mdt "Checking if the file is present..."
                export DIALOGRC="libs/dialog-rc/error.thm"
                msgbox "ERROR" "The variable is null!"
                unset DIALOGRC
                menu_man "Empty Entry from: magisk_pick_ap"
            else 
                mdt "Checking if $PCX is present and has the right size"
                if [ -e $PCX ] && [ $(ls -nl $PCX | awk '{print $5}') -gt 2000000000 ]; then 
                    mdt "Correct file"
                    mdt "Moving file: $PCX to $LAB/MAP"
                    mkdir $LAB/MAP
                    mv -r $PCX $LAB/MAP/magisked.tar
                    if [ -e "$LAB/MAP/magisked.tar" ]; then 
                        mdt "File Done Copied"
                        mdt "Extracting..."
                        7z e $LAB/MAP/magisked.tar -o $LAB/MAP/
                        mdt "p7zip reports that the process is done"
                        mdt "Looking for super"
                        if [ -e "$LAB/MAP/super.img.lz4" ]; then 
                            mdt "File found"
                            mdt "Removing waste"
                            mdt "Done"
                            mdt "Revert back to Extract AP/Super then try to extract super to continue"
                            msg ""
                            read -n 1 -t 100 -p "PRESS ANY KEY TO END" fdk
                            if [[ -n $FDK ]]; then
                                menu_man 
                            else 
                                menu_man 
                            fi 
                        else 
                            export DIALOGRC="libs/dialog-rc/error.thm"
                            msgbox "ERROR, CANNOT FIND SUPER!" "The script cant find the super.img.lz4 from selected $PCX!"
                            unset DIALOGRC
                            menu_man "Empty file loc: magisked_ap_file"
                        fi 
                    else 
                        export DIALOGRC="libs/dialog-rc/error.thm"
                        msgbox "ERROR! CANNOT FIND magisked.tar!" "Uh oh, it seems that the script can't find where the magisked tar is? please check the build location please!"
                        unset DIALOGRC
                        menu_man "magisk_pick_ap: No such file found after transfer"
                    fi
                else 
                    export DIALOGRC="libs/dialog-rc/error.thm"
                    msgbox "ERROR, NOT ENOUGH SIZE" "Are you sure thats the correct size for a Patched AP? it may be smaller than that or you used official magisk to patch.\n\nWe recommend you to use Magisk Delta or Magisk Kitsune instead since it only works on Samsung\n\nDebug:\nFile Size Reported: $(ls -nl "$PCX" | awk '{print $5}') \n Which it violates the 2GB limit"
                    unset DIALOGRC
                    menu_man "Error:\nEstimation file wasnt exact"
                fi 
            fi 
        ;;
    esac
}

function build_super {
        menu_page=$(dialog \
                    --backtitle "SAMSUNG GSI TO SUPER - $VERSION_ID - $STATUS" \
                    --title "Build Super" \
                    --menu "$(datetime) <s> Super Info Report: $(super_info) \n\nIf all values are empty then you didn't extract the files properly, go back on Extract option\n\n\nSelection:\n Build (.tar) - Build the Super with tar format" 0 0 0 \
                    "Build" "Build with Tar Only Compression" \
                    "Build with xz" "Build with tar.xz compression" \
                    "Build with 7z" "Build with 7z Compression" \
                    2>&1 >/dev/tty)
                    local ervar=$?
                    case $ervar in 
                        1)
                            menu_man
                            ;;
                    esac 
                    case $menu_page in 
                        "Build")
                            yesno "Are you sure to start building? with tar only compression?"
                            local ercon=$?
                            case $ercon in 
                                0)
                                    build_normal_cmp
                                    ;;
                                1)
                                    build_super
                                    ;;
                            esac 
                            ;;
                        "Build with xz")
                            yesno "Are you sure to start building with xz compression?"
                            local ercon=$?
                            case $ercon in 
                                0)
                                    build_xz_cmp
                                    ;;
                                1)
                                    build_super
                                    ;;
                            esac 
                            ;;
                        "Build with 7z")
                            yesno "Are you sure to start building with 7z compression?"
                            local ercon=$?
                            case $ercon in 
                                0)
                                    build_7z_cmp
                                    ;;
                                1)
                                    build_super
                                    ;;
                            esac 
                            ;;
                    esac
}

function build_file {
    if [ "$(find $LAB/system.img -type f ! -size 0 -printf '%S\n' | sed 's/.\.[0-9]*//')" == 1 ]; then 
        mdt "Processing..."
    else 
        mdt "Something needs to be taken care of... Please Wait..."
        simg2img $LAB/system.img $LAB/system.raw.img
    fi
    if [ -e "$LAB/odm.img" ]; then
        if [ -e "$LAB/product.img" ]; then
            mdt "Product already present"
            mdt "Warning: If the patching didn't work, you can ask the group for help"
        else 
            mdt "Product does not exist, probably external interference or old AP device..."
            mdt "Replacing it with Universal Product.img"
            cp -rf fake-props/product.img $LAB/product.img
            mdt "Done"
        fi 
        mdt "Starting Building"
        mdt "You may see header errors, but that just mean that its doing something right..."
        lpmake --metadata-size 65536 --super-name super --metadata-slots 2 --device super:$(<$TMP/super_size.txt) --group main:$(<$TMP/super_main.txt) --partition system:readonly:$(ls -nl $LAB/system.img | awk '{print $5}'):main --image system=$LAB/system.img --partition vendor:readonly:$(ls -nl $LAB/vendor.img | awk '{print $5}'):main --image vendor=$LAB/vendor.img --partition product:readonly:$(ls -nl $LAB/product.img | awk '{print $5}'):main --image product=$LAB/product.img --partition odm:readonly:$(ls -nl $LAB/odm.img | awk '{print $5}'):main --image odm=$LAB/odm.img --sparse --output super.img
        mdt "OK!"
    else 
        if [ -e "$LAB/product.img" ]; then 
            mdt "Product already Present"
            mdt "If patching didn't work, then you can ask the group for help"
        else 
            mdt "Product does not exist, probably external interference or old AP device..."
            mdt "Replacing it with Universal Product.img"
            cp -rf fake-props/product.img $LAB/product.img
            mdt "Done"
        fi 
        if [ -e "$LAB/system_ext.img" ]; then 
            mdt "System_ext already present, so fake system_ext is no longer needed."
        else 
            mdt "System_ext is not present, it could be an external interference"
            mdt "Trying to add Universal System_ext"
            cp -rf fake-props/system_ext.img $LAB/product.img
            mdt "Done"
        fi 
        mdt "Starting Building"
        mdt "You may see header errors, but that's just mean that its doing something right"
        lpmake --metadata-size 65536 --super-name super --metadata-slots 2 --device super:$(<$TMP/super_size.txt) --group main:$(<$TMP/super_main.txt) --partition system:readonly:$(ls -nl $LAB/system.img | awk '{print $5}'):main --image system=$LAB/system.img --partition vendor:readonly:$(ls -nl $LAB/vendor.img | awk '{print $5}'):main --image vendor=$LAB/vendor.img --partition product:readonly:$(ls -nl $LAB/product.img | awk '{print $5}'):main --image product=$LAB/product.img --partition system_ext:readonly:$(ls -nl $LAB/system_ext.img | awk '{print $5}'):main --image system_ext=$LAB/system_ext.img --sparse --output super.img
        fi 
}

function build_normal_cmp {
    mdt "Starting process..."
    mdt "Starting : build_file"
    build_file
    mdt "It seems process : build_file has completed the task"
    file_name=$(dialog --backtitle "SAMSUNG GSI TO SUPER - $VERSION_ID - $STATUS" --title "Name-a-file" --inputbox "Enter what you want to name this file: \n\nREMEBER: NO SPACES, FILE EXTENSIONS AND SLASHES AND IF IT BREAKS ITS YOUR FAULT! \nGoing back resets to default name\n\nDefault:" 0 0 "exported_super" 2>&1 >/dev/tty)
    if [ -z "$file_name" ]; then
        mdt "No value detected, using default name"
        file_name="exported_super"
    else 
        mdt "Name: $file_name"
    fi
    mdt "Calling tar to pack"
    #mdt "BTW renaming package feature is coming soon"
    tar -cvf $LAB/$file_name.tar super.img
    mdt "Done"
    mdt "Cleaning..."
    rm -rf $LAB/super.img
    mdt "Checking the tar file"
    if [ "$(ls -nl $LAB/$file_name.tar | awk '{print $5}')" -lt 100000 ]; then 
        mdt "ONO!"
        mdt "The tar file size is not right!"
        mdt "Error: B_NT_25"
        mdt "Returning in 5 seconds"
        sleep 5
        menu_man "Error: B_NT_25"
    else 
        mdt "YES! IT IS DONE"
        mdt "File is completed"
        mdt "File was located in : $LAB/$file_name.tar, now ready to flash..."
        mdt "Going back to menu in 5 seconds"
        menu_man
    fi
}

function build_xz_cmp {
    mdt "Starting process..."
    mdt "Starting : build_file"
    build_file
    mdt "It seems process : build_file has completed the task"
    sleep 2
    file_name=$(dialog --backtitle "SAMSUNG GSI TO SUPER - $VERSION_ID - $STATUS" --title "Name-a-file" --inputbox "Enter what you want to name this file: \n\nREMEBER: NO SPACES, FILE EXTENSIONS AND SLASHES AND IF IT BREAKS ITS YOUR FAULT! \n\nDefault:" 0 0 "exported_super" 2>&1 >/dev/tty)
    if [ -z "$file_name" ]; then
        mdt "No value detected, using default name"
        file_name="exported_super"
    else 
        mdt "Name: $file_name"
    fi
    mdt "Calling tar to pack alongside with the name"
    #mdt "BTW renaming package feature is coming soon"
    tar --xz -cvf $LAB/$file_name.tar.xz super.img
    mdt "Done"
    mdt "Cleaning..."
    rm -rf $LAB/super.img
    mdt "Checking the tar.xz file"
    if [ "$(ls -nl $LAB/$file_name.tar.xz | awk '{print $5}')" -lt 100000 ]; then 
        mdt "ONO!"
        mdt "The tar file size is not right!"
        mdt "Error: B_XZ_25"
        mdt "Returning in 5 seconds"
        sleep 5
        menu_man "Error: B_XZ_25"
    else 
        mdt "YES! IT IS DONE"
        mdt "File is completed"
        mdt "File was located in : $LAB/$file_name.tar.xz, now ready to flash..."
        mdt "Going back to menu in 5 seconds"
        menu_man
    fi
}

function build_7z_cmp {
    mdt "Starting process..."
    mdt "Starting : build_file"
    build_file
    mdt "It seems process : build_file has completed the task"
    mdt "Calling 7z to pack"
    file_name=$(dialog --backtitle "SAMSUNG GSI TO SUPER - $VERSION_ID - $STATUS" --title "Name-a-file" --inputbox "Enter what you want to name this file: \n\nREMEBER: NO SPACES, FILE EXTENSIONS AND SLASHES AND IF IT BREAKS ITS YOUR FAULT! \nGoing back resets to default name\n\nDefault:" 0 0 "exported_super" 2>&1 >/dev/tty)
    if [ -z "$file_name" ]; then
        mdt "No value detected, using default name"
        file_name="exported_super"
    else 
        mdt "Name: $file_name"
    fi
    #mdt "BTW renaming package feature is coming soon"
    7z a $LAB/$file_name.7z $LAB/super.img
    mdt "Done"
    mdt "Cleaning..."
    rm -rf $LAB/super.img
    mdt "Checking the 7z file"
    if [ "$(ls -nl $LAB/$file_name.7z | awk '{print $5}')" -lt 100000 ]; then 
        mdt "ONO!"
        mdt "The 7z file size is not right!"
        mdt "Error: B_7Z_25"
        mdt "Returning in 5 seconds"
        sleep 5
        menu_man "Error: B_7Z_25"
    else 
        mdt "YES! IT IS DONE"
        mdt "File is completed"
        mdt "File was located in : $LAB/$file_name.7z, now ready to flash..."
        mdt "Going back to menu in 5 seconds"
        menu_man
    fi
}

function gsi_picker {
    gsi_input=$(dialog \
                --backtitle "SAMSUNG GSI TO SUPER - $VERSION_ID - $STATUS" \
                --title "GSI Picker" \
                --inputbox "Enter the FULL directory where the GSI img was located\nPlease Extract the GSI if it were in 7z or zip, basically anything other than img, if its an iso, what GSI is that?\n\nExample: \n/sdcard/Downloads/PixelExperiencePlus.img\n\nIf the image is already located in : $LAB and renamed/replaced to system.img (Basically deleting stock system.img then replacing it with renamed gsi then this is useless and you should skip this), then skip this part" 0 0 2>&1 >/dev/tty)
            local ervar=$?
            case $ervar in
                1)
                    menu_ap_super
                    ;;
            esac 
            if [ -z "${gsi_input}" ]; then 
                clear
                mdt "ERROR, FAILSAFE REPORTS A MISSING VARIABLE"
                mdt "Going back to Main Menu"
                mdt "Error: eap_gsi_null"
                sleep 3
                menu_man "Error: eap_gsi_null"
            else 
                if [ -e "${gsi_input}" ]; then 
                    clear
                    mdt "Image: $gsi_input found, checking file size..."
                    if [ "$(ls -nl "$gsi_input" | awk '{print $5}')" -lt 100000 ]; then 
                        mdt "Invalid size for a GSI detected"
                        mdt "Reverting back"
                        sleep 3
                        menu_ap_super
                    else 
                        mdt "File size valid, inspectioning the file"
                        if [ -e "${gsi_input}" ]; then # Sadly this cannot be modified
                            mdt "File Inspection complete and is an image file."
                            mdt "Moving the file"
                            rm -rf $LAB/system.img
                            cp -rf "$gsi_input" $LAB/system.img
                            if [ -e "$LAB/system.img" ]; then 
                                mdt "You can now go to Build Super for this configuration"
                                sleep 5
                                menu_man
                            else 
                                mdt "Tried Copying the GSI Image to $LAB as system.img and Failed"
                                mdt "try doing that manually if error persists"
                                sleep 5
                                gsi_picker
                            fi 
                        else
                            mdt "File is not img format, please try to check if its a typo"
                            sleep 5
                            gsi_picker
                        fi 
                    fi 
                else 
                    clear
                    mdt "Cannot find $gsi_input"
                    mdt "Are you sure its correct?"
                    sleep 5
                    menu_man "Error: gsi_nf"
                fi
            fi
}

function menu_man  {
    ERROR_CONTAINER="$1"
    if [ -z "${ERROR_CONTAINER}" ]; then 
        local VAR="No error was sent"
    else
        local VAR="$ERROR_CONTAINER"
    fi
    greet="User"
    menu_page=$(dialog \
                --backtitle "SAMSUNG GSI TO SUPER - $VERSION_ID - $STATUS" \
                --title "Main Menu" \
                --menu "Error Message:\n$VAR\n\nTime and date: \n$(datetime)\n\nWelcome $greet , to Samsung GSI to Super Builder, this tool can make your GSI a 100% fully compatible on some of your samsung Devices (Check wiki, or Telegram Group around the About part of the menu), that is of course its not a fake, it can work with ODIN or HEIMDALL, but sadly those tools are not bundled and i WOULD RECOMMEND YOU to use ODIN instead\n\nTarget Dir: $LAB"  0 0 0 \
                "Extract AP/Super" "Extract Super/AP Files" \
                "Build Super" "Build the Super" \
                "How to" "How-to-wiki" \
                "Configure" "Configure Settings" \
                "About" "About" \
                2>&1 >/dev/tty)
                local ervar=$?
                case $ervar in
                    1)
                        clear
                        mdt "See you next time - Super Builder"
                        exit 0
                        ;;
                esac
                case $menu_page in 
                    "Extract AP/Super")
                        menu_ap_super
                        ;;
                    "Build Super")
                        build_super
                        ;;
                    "How to")
                        wikiflash
                        ;;
                    "About")
                        about 
                        ;;
                    "Configure")
                        conf_man
                        ;;
                    *)
                        clear 
                        mdt "Invalid Call in menu_page, says: $menu_page"
                        mdt "Abruptly stopping the process to ensure maximum safety"
                        mdt "Also if you annoyingly resize the session, this could happen, unless Android kills dialog for some unknown reason?"
                        exit 9 
                        ;;
                esac
}

function wikiflash {
    wikimenu=$(dialog \
                --backtitle "SAMSUNG GSI TO SUPER - $VERSION_ID - $STATUS" \
                --title "Wiki" \
                --menu "Here are the wiki pages that could help solve your problem\n\nThis is incomplete as of this release" 0 0 0 \
                "AP" "How to put the AP to the target dir?" \
                "Super" "After Extracting AP or have already Extracted AP and Super is already at the $LAB" \
                "GSI How" "How to put GSI in the $LIB directory" \
                "GSI Where" "Where to grab those GSI Images?" \
                "Build Super" "How to Build Super" \
                2>&1 >/dev/tty )
                local erval=$?
                case $erval in 
                    1)
                        menu_man
                        ;;
                esac 
                case $wikimenu in
                    "AP")
                        msgbox "AP" "$(cat docs/ap/main.txt)"
                        wikiflash
                        ;;
                    "Build Super")
                        msgbox "Super" "$(cat docs/how_2_build/main.txt)"
                        wikiflash
                        ;;
                    "GSI How")
                        msgbox "GSI How" "$(cat docs/gsi/main.txt)"
                        wikiflash
                        ;;
                    "GSI Where")
                        msgbox "GSI Where" "$(cat docs/gsi/link.txt)"
                        wikiflash
                        ;;
                    "Super")
                        msgbox "Super" "$(cat docs/super/main.txt)"
                        wikiflash
                        ;;
                esac
}

function conf_man {
    menu_png=$(dialog \
                --backtitle "SAMSUNG GSI TO SUPER - $VERSION_ID - $STATUS" \
                --title "Configure" \
                --menu "Change Settings here\n\nWARNING, CHANGING THINGS HERE CAN BREAK THE OPERATION OF THE SCRIPT UNLESS YOU KNOW WHAT YOU ARE DOING!" 0 0 0 \
                "Change the Testing folder" "Current: $LAB" \
                "Toggle Wipe Cache on EXIT" "Current: $CLEAR_UP" \
                2>&1 >/dev/tty)
                local ervar=$?
                case $ervar in 
                    1)
                        menu_man
                        ;;
                esac 
                case $menu_png in 
                    "Change the Testing folder")
                        changeLAB
                        ;;
                    "Toggle Wipe Cache on EXIT")
                        wipe_cache_diag
                        ;;
                    esac

}

function changeLAB {
                        case $(uname -m) in 
                            "x86_64")
                                cfr=$(dialog --backtitle "SAMSUNG GSI TO SUPER - $VERSION_ID - $STATUS" --title "Change the Testing Folder" --inputbox "Input the Directory that you want to use\n\nAt the end of the line, do not add / to ensure that it wont break.\n\nDo not use folders/subdirectories that has spaces in them\nDefault is here:" 0 0 "$(pwd)/image_build" 2>&1 >/dev/tty)
                                if [ $? == 1 ]; then 
                                    conf_man
                                fi
                                if [ -z $cfr ]; then 
                                    clear
                                    mdt "Variable empty"
                                    sleep 3
                                    conf_man 
                                else 
                                    LAB="$cfr" 
                                    if [ "$cfr" == "$LAB" ]; then
                                        mkdir "$cfr" 
                                        mdt "Sucess!"
                                        mdt "THE DIR IS NOW: $LAB"
                                        sleep 3
                                        menu_man
                                    else 
                                        mdt "FAIL!"
                                        mdt "Could not bind the variable"
                                        mdt "Exiting for safety purposes"
                                        exit 1
                                    fi
                                fi
                                ;;
                            "aarch64")
                                cfr=$(dialog --backtitle "SAMSUNG GSI TO SUPER - $VERSION_ID - $STATUS" --title "Change the Testing Folder" --inputbox "Input the Directory that you want to use\n\nAt the end of the line, do not add / to ensure that it wont break.\n\nDo not use folders/subdirectories that has spaces in them.\n\nDefault is here:" 0 0 "/storage/emulated/0/image_build"  2>&1 >/dev/tty)
                                if [ $? == 1 ]; then 
                                    conf_man
                                fi
                                if [ -z $cfr ]; then 
                                    clear
                                    mdt "Variable empty"
                                    sleep 3
                                    conf_man 
                                else 
                                    LAB="$cfr"
                                    if [ "$cfr" == "$LAB" ]; then 
                                        mkdir "$cfr"
                                        mdt "Sucess!"
                                        mdt "THE DIR IS NOW: $LAB"
                                        sleep 3
                                        menu_man
                                    else 
                                        mdt "FAIL!"
                                        mdt "Could not bind the variable"
                                        mdt "Exiting for safety purposes"
                                        exit 1
                                    fi
                                fi
                            ;;
                        esac
}

function wipe_cache_diag {
    if [ "$CLEAR_UP" == 0 ]; then 
        yesno "Are you sure you want to Enable the Auto TMP Wipe?\n\nThis is not recommended to be enabled in a session because your terminal session could get killed out of nowhere and then tmpfiles could get deleted, thus you need to redo the whole process again!"
        local extvar=$?
        case $extvar in
            0)
                CLEAR_UP="1"
                msgbox "Done"
                menu_man
                ;;
            1)
                conf_man
                ;;
        esac 
    else 
        yesno "Are you sure you want to Disable the Auto TMP Wipe?"
        local extvar=$?
        case $extvar in
            0)
                CLEAR_UP="0"
                msgbox "Done"
                menu_man
                ;;
            1)
                conf_man
                ;;
        esac
    fi 

}


function about {
    msgbox "About" "SAMSUNG GSI TO SUPER BUILDER \n\nVERSION: $VERSION_ID\nFLAGS: $STATUS\n\nIf you struggled using this script, try to use Rou, same thing:\nhttps://github.com/Takumi123x/rou\n\nJoin Telegram: https://t.me/a12schat"
    menu_man
}

function disclaimer {
    export DIALOGRC="libs/dialog-rc/disclaimer.thm"
    yesno "$(cat docs/disclaimer)"
    local ervar=$?
    unset DIALOGRC
    case $ervar in 
        1)
            clear 
            mdt "See you next Time"
            exit 1
            ;;
        0)
            menu_man
            ;;
    esac
}

disclaimer

