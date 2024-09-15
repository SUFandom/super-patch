#!/bin/bash
#

if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then 
    echo "Super-patch"
    echo "v. 0.9.3 - devel_git"
    echo ""
    echo "Usage:"
    echo "     When on Linux Desktop ENV, even WSL:"
    echo "            sudo ./builder.sh [arg1]"
    echo ""
    echo "     When on Termux Android:"
    echo "            ./builder.sh [arg1]"
    echo ""
    echo "Usage:"
    echo "--help -h          Shows Help Page"
    echo "--clear            Clear any cached files generated"
    echo "                   by this script."
    echo "                   Note that you need to run this on"
    echo "                   Root if you are using a desktop"
    echo "                   Environment"
    echo "--inst_archlinux   Install dependencies for archlinux"  
    echo "                   Dont run it alongside with sudo, as"
    echo "                   paru requires the user to not run itself"
    echo "                   as sudo"
    echo ""
    echo "If you have issues, visit https://t.me/a12schat"
    exit 
fi

if [ "$1" == "--inst_archlinux" ]; then 
    if [ $EUID != 0 ]; then 
        chmod +x libs/archlinux/init
        bash libs/archlinux/init
        echo "OK"
        exit
    else 
        echo "Dont run as root for this argument"
        exit 1
    fi
fi

if [ "$1" == "--clear" ] ; then 
    case $(uname -m) in
        x86_64)
            if [ $EUID != 0 ]; then 
                echo "[ERROR] You need root to run this"
                exit 1
            else 
                echo "Wiping cache"
                TMP="$HOME/cached_sp"
                rm -rf "$TMP"
                echo ""Done
                exit 
            fi
            ;;
        aarch64)
            echo "Wiping cache"
            TMP="$HOME/cached_sp"
            rm -rf "$TMP"
            echo ""Done
            exit 
            ;;
        *)
            echo "Could not determine your cpu"
            exit 1
            ;;
    esac
fi

# GLOBAL VARIABLES (FOR INFO AND EYECANDY)
VERSION_ID="0.9.3-hfx"
STATUS="devel_git_release_candidate"

if [ "$(pwd)" == "$(pwd | grep -a super-patch)" ]; then 
    echo "Init Good!"
else 
    echo "Please run this script inside super-patch directory"
    exit 1
fi 
case $(uname -m) in 
    aarch64)
        echo "[OK!] CPU is: aarch64"
        ;;
    x86_64)
        if [ $EUID != 0 ]; then 
            echo "[ERROR] Please Run this as root"
            exit 1
        fi
        echo "[OK!] CPU is: x86_64"
        ;;
    *)
        echo "[ERROR] Unsupported CPU: $(uname -m)"
        exit 1
        ;;
esac 

function debian() {

    dialog --backtitle "Debian/Ubuntu Env Confirmation" --title "[?] Are you sure?" \
            --yes-label "I am sure" --no-label "Back" \
            --yesno "Are you sure that you are running on Debian/Ubuntu Environment?\n\nWe will look for these packages: \n- APT\n- dpkg \n\nIf you don't have these in your system, then this session will crash and then you would have to relaunch again to continue" 0 0 
    flag=$?
    case $flag in 
        0)
            aptc=$(command -v apt 2>/dev/null)
            dpkgc=$(command -v dpkg 2>/dev/null)
            if [ -n "$aptc" ] && [ -n "$dpkgc" ]; then 
                echo "Apt and Dpkg is OK"
                echo "Installing necessary packages..."
                sudo apt update 
                sudo apt install --fix-missing -y
                sudo apt install android-sdk-libsparse-utils p7zip-full lz4 -y
                sudo apt update --fix-missing -y
                sudo apt install --fix-missing -y
                extbin --generic
                touch "$TMP/pass"
            else 
                echo "APT and Dpkg failed to see, not a Debian/Ubuntu Distro"
                exit 1
            fi 
            ;;
        1)
            distro_select
            ;;
    esac 
}

function arch_linux() {
    # This strictly requires paru to be installed
    # NOTE: I realized that paru hates root
    clear
    echo "Check the --help option as this option is now no longer available"
    echo "due to paru hating to start as root and the installation would fail..."
    echo "Otherwise, ignore the message"
    extbin --generic
    touch "$TMP/pass"
    # dialog --backtitle "Arch Linux Env Confirmation" --title "[?] Are you sure?" \
    #         --yes-label "I am sure" --no-label "Back" \
    #         --yesno "Are you sure that you are running on Arch Linux Environment?\n\nWe will look for these packages: \n- pacman \n- paru\n\nIf you don't have these in your system, then this session will crash and then you would have to relaunch again to continue\n\nyay is no longer needed as if it breaks, it would spam to the server and causing you to be in blacklist temporarily, 24 hours..." 0 0 
    # flag=$?
    # case $flag in 
    #     0)
    #         pacmanc=$(command -v pacman 2>/dev/null)
    #         paruc=$(command -v paru 2>/dev/null)
    #         if [ -n "$pacmanc" ] && [ -n "$paruc" ]; then 
    #             echo "Pacman and paru is OK"
    #             echo "Installing necessary packages..."
    #             sudo pacman -Syu
    #             sudo pacman -Sy lz4 p7zip
    #             paru -Syu
    #             paru -Sy android-sdk-platform-tools
    #             paru -Sy android-sdk
    #             extbin --generic
    #             touch "$TMP/pass"
    #         else 
    #             echo "Pacman and Paru failed to spot, not an Arch Linux Distro"
    #             exit 1
    #         fi 
    #         ;;
    #     1)
    #         distro_select
    #         ;;
    # esac 
}

function android() {
    dialog --backtitle "Termux Android Env Confirmation" --title "[?] Are you sure?" \
            --yes-label "I am sure" --no-label "Back" \
            --yesno "Are you sure that you are running on Termux Android Environment?\n\nWe will look for these packages: \n- APT\n- dpkg \n\nIf you don't have these in your system, then this session will crash and then you would have to relaunch again to continue" 0 0
    flag=$?
    case $flag in 
        0)
            aptc=$(command -v apt 2>/dev/null)
            dpkgc=$(command -v dpkg 2>/dev/null)
            if [ -n "$aptc" ] && [ -n "$dpkgc" ]; then 
                echo "Apt and Dpkg is OK"
                echo "Installing necessary packages..."
                apt update 
                apt install --fix-missing -y
                apt install lz4 -y
                apt update --fix-missing -y
                apt install --fix-missing -y
                extbin --android
                touch "$TMP/pass"
            else 
                echo "APT and Dpkg failed to see, not running Termux on Android..."
                exit 1
            fi 
            ;;
        1)
            distro_select
            ;;
    esac 
}

function wsa() {
    if [[ ! "$(wsainfo >/dev/null)" ]]; then
    dialog --backtitle "Debian WSA Env Confirmation" --title "[?] Are you sure?" \
            --yes-label "I am sure" --no-label "Back" \
            --yesno "Are you sure that you are running on Debian on a Windows Subsystem for Android Environment?\n\nWe will look for these packages: \n- APT\n- dpkg \n\nIf you don't have these in your system, then this session will crash and then you would have to relaunch again to continue" 0 0 
    flag=$?
    case $flag in 
        0)
            aptc=$(command -v apt 2>/dev/null)
            dpkgc=$(command -v dpkg 2>/dev/null)
            if [ -n "$aptc" ] && [ -n "$dpkgc" ]; then 
                echo "Apt and Dpkg is OK"
                echo "Installing necessary packages..."
                sudo apt update 
                sudo apt install --fix-missing -y
                sudo apt install android-sdk-libsparse-utils p7zip-full lz4 -y
                sudo apt update --fix-missing -y
                sudo apt install --fix-missing -y
                touch "$TMP/pass"
                extbin --generic
            else 
                echo "APT and Dpkg failed to see, not running Debian WSA"
                exit 1
            fi 
            ;;
        1)
            distro_select
            ;;
    esac 
    else 
        distro_select
    fi
}

function none_e() {
    clear
    echo "Sorry, you cant use this script on an unsupported script"
    exit 1
}

function distro_select() {
    distromenu=$(dialog --backtitle "I want to know this environment" \
                --title "What linux this is?" \
                --menu "This script wants to know what linux this is, so it can try calling out the package manager of the current env" 0 0 0 \
                "Debian/Ubuntu" "Debian & Ubuntu Latest, NOT WSA" \
                "Arch Linux" "Arch Linux Latest, NOT WSA" \
                "Termux Android" "Android has linux so that counts??" \
                "WSA Debian" "Windows subsystem for Linux (Debian ONLY)" \
                "None" "None of the above" \
                2>&1 > /dev/tty)
    fetch=$?
    case $fetch in
        1)
            clear
            exit 1
            ;;
        255)
            exit 255
            ;;
        9)
            exit 9
            ;;
    esac
    case "$distromenu" in 
        "Debian/Ubuntu")
            debian
            ;;
        "Arch Linux")
            arch_linux
            ;;
        "Termux Android")
            android 
            ;;
        "WSA Debian")
            wsa 
            ;;
        "None")
            none_e
            ;;
    esac 
}

function extbin() {
    case $1 in 
        "--android")
            if [ ! -f "$TMP/pass" ]; then
                apt install ./packages/termux-arm64/*
                # distro_select
            else 
                echo "No need to set up"
            fi
            ;;
        "--generic")
            if [ ! -f "$TMP/pass" ]; then
                sudo cp -rf packages/amd64/* /usr/bin/
                add_tools=("lpadd" "lpdump" "lpmake" "lpunpack")
                for util in "${add_tools[@]}" ; do 
                    chmod +x /usr/bin/$util
                done 
                # distro_select
            else 
                echo "No need to set up"
            fi
            ;;
        *)
            echo "[ERROR] Can't Understand: $1"
            echo "Abruptly exiting..."
            exit 1 # Literally exit for failsafes
            ;;
    esac
}

function linux () {
    if [ "$(uname -m)" == "x86_64" ]; then 
        if [ $EUID != 0 ]; then 
            echo "You need root to proceed..."
        fi
    fi
    clear
    echo "Linux Confirmed"
    echo "Setting variables..."
    LAB="$(pwd)/image_build"
    TMP="$HOME/cached_sp"
    if [ $EUID != 0 ]; then 
        IS_SUDO="0"
    else 
        IS_SUDO="1"
    fi
    CLEAR_UP="0"
    mkdir "$LAB"
    mkdir "$TMP"
    # Realized this line of code will not work on android, check policy
    # This will be implemented separately
    # if [ ! -f "$TMP/pass" ]; then
    #     sudo cp -rf packages/amd64/* /bin
    #     add_tools=("lpadd" "lpdump" "lpmake" "lpunpack")
    #     for util in "${add_tools[@]}" ; do 
    #         chmod +x /usr/bin/$util
    #     done 
    #     distro_select
    # else 
    #     echo "No need to set up"
    # fi
    if [ ! -e $TMP/pass ]; then 
        distro_select
    fi
    echo "Variables set, and components are ready to go..."
    echo "Starting on 5 seconds"
    sleep 5 
}






# This area is in rework

# # ANOTHER GLOBAL VARIABLES (THAT ARE MUTABLE IF CONFIGED, NEXT VERSION)
# case $(uname -m) in
#     "x86_64") 
#         if [ $EUID != 0 ]; then 
#             echo "Please Run this as root"
#             exit 1
#         fi
#         if [[ "$(wsainfo > /dev/null)" ]]; then 
#             echo "WSL detected"
#             LAB="$(pwd)/image_build"
#             TMP="$HOME/cached_sp"
#             IS_SUDO="1"
#             CLEAR_UP="0"
#             mkdir "$TMP"
#             mkdir "$LAB"
#             if [ ! -f "$TMP/pass" ]; then
#                 sudo cp -rf packages/amd64/* /bin
#                 addmod=("lpadd" "lpdump" "lpmake" "lpunpack")
#                 for elevate in "${addmod[@]}"; do 
#                     chmod +x /usr/bin/$elevate
#                 done
#                 sudo apt install android-sdk-libsparse-utils -y
#                 sudo apt update --fix-missing -y
#                 sudo apt install --fix-missing -y
#                 sudo apt install android-sdk-libsparse-utils -y
#                 sudo apt install p7zip-full lz4  -y 
#                 touch "$TMP/pass"
#             fi 
#             echo "Since you are running this in desktop, the process will be happening inside the super-patch folder"
#             echo "Dir: $LAB"
#             echo "So please move the files there"
#             echo "If you are using WSA, you can check it on File Explorer, but we recommend you to run the Environment at WSL 2 for the tools to get working properly"
#             echo ""
#             echo ""
#             echo "Starting in 5 seconds..."
#             sleep 5
#         else 
#             echo "Real Debian Confirmed"
#             LAB="$(pwd)/image_build"
#             TMP="$HOME/cached_sp"
#             IS_SUDO="1"
#             CLEAR_UP="0"
#             mkdir "$TMP"
#             mkdir "$LAB"
#             if [ ! -f "$TMP/pass" ]; then
#                 sudo cp -rf packages/amd64/* /bin
#                 addmod=("lpadd" "lpdump" "lpmake" "lpunpack")
#                 for elevate in "${addmod[@]}"; do 
#                     chmod +x /usr/bin/$elevate
#                 done
#                 sudo apt install android-sdk-libsparse-utils -y
#                 sudo apt update --fix-missing -y
#                 sudo apt install --fix-missing -y
#                 sudo apt install android-sdk-libsparse-utils -y
#                 sudo apt install p7zip-full lz4  -y 
#                 touch "$TMP/pass"
#             fi 
#                 clear
#                 echo "Real Debian Moment Here!"
#                 echo "The Environment the building will take place at:"
#                 echo "$LAB"
#                 echo "And the TMP will be at:"
#                 echo "$TMP"
#                 echo -ne "\n\nRemeber that..."
#                 echo -ne "\nStarting in 5 seconds\n"
#                 sleep 5
#         fi
#         ;;
#     "aarch64")
#         if [ "$EUID" == 0 ]; then
#             echo "Dont use Root Please"
#             exit 1
#         fi
#         termux-setup-storage
#         ed=$?
#         if [ "$ed" == 0 ]; then 
#             dpkg -i packages/termux-arm64/*
#             LAB="$HOME/storage/shared/image_build"
#             TMP="$HOME/cached_sp"
#             CLEAR_UP="0"
#             IS_SUDO="0"
#             mkdir "$LAB"
#             mkdir "$TMP"
#         else 
#             echo "Setup can't continue if termux-setup-storage isnt working, also if youre running this other than termux, please download termux."
#             echo "If you're running this on WSA Arm, uhhh sorry, script dont support that"
#             echo "https://github.com/termux/termux-app"
#             exit 1
#         fi 
#         dpkg -i packages/termux-arm64/*
#         ;;
#     *)
#         echo "Your Device isnt supported: $(uname -m)"
#         echo "This script only supports ARM64, and x86_64/AMD64"
#         exit 1
#         ;;
# esac

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
    if [ -e $LAB/AP_*.tar.md5 ]; then # Shellcheck Linter tryna telling me wrong for wildcarding if -e rn, i wish i wanna fking bit that sht
        msg "$(datetime) - AP File Found... Extracting"
        if [ "$IS_SUDO" == "0" ]; then
            7z e  $LAB/AP_*.tar.md5 -o$LAB/
        else 
            sudo 7z e  $LAB/AP_*.tar.md5 -o$LAB/
        fi 
        #E1
        msg "$(datetime) - Looking for the Super"
        if [ -e "$LAB/super.img.lz4" ]; then 
            msg "$(datetime) Super.img.lz4 Found"
            #mv -f $LAB/AP/super.img.lz4" "$LAB/super.img.lz4
            mdt "CLEANUP!"
            TARGET_RM=("recovery.img.lz4" "boot.img.lz4" "dtbo.img.lz4" "userdata.img.lz4" "misc.bin.lz4" "vbmeta.img.lz4" "vbmeta_system.img.lz4" "meta-data" "metadata.img.lz4" "fota.zip")
            for KILL in "${TARGET_RM[@]}"; do 
                if [ "$IS_SUDO" == "0" ]; then 
                    rm -rf $LAB/$KILL
                    mdt "$KILL removed as it's useless"
                else 
                    sudo rm -rf $LAB/$KILL 
                    mdt "$KILL removed as it's useless"
                fi
            done 
            mdt "Useless Files Removed"
            sleep 1
            menu_ap_super
        else 
            mdt "No LZ4 Version of Super.img was found after extraction, checking if theres super.img"
            if [ -e "$LAB/super.img" ]; then 
                mdt "Super.img found, moving"
               mdt "CLEANUP!"
                TARGET_RM=("recovery.img" "boot.img" "dtbo.img" "userdata.img" "misc.bin" "vbmeta.img" "vbmeta_system.img" "meta-data" "metadata.img" "fota.zip")
                for KILL in "${TARGET_RM[@]}"; do 
                    if [ "$IS_SUDO" == "0" ]; then 
                        rm -rf "${LAB/$KILL:?}"
                        mdt "$KILL removed as it's useless"
                    else 
                        sudo rm -rf $LAB/$KILL 
                        mdt "$KILL removed as it's useless"
                    fi
                done 
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

function wipe_cache_tmp_clut {
    rm -rf $TMP/* 
    msgbox "Done" "Files Cleaned"
    menu_man
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
                    cp -r $PCX $LAB/MAP/magisked.tar
                    if [ -e "$LAB/MAP/magisked.tar" ]; then 
                        mdt "File Done Copied"
                        mdt "Extracting..."
                        7z e $LAB/MAP/magisked.tar -o$LAB/MAP/
                        mdt "p7zip reports that the process is done"
                        mdt "Looking for super"
                        if [ -e "$LAB/MAP/super.img.lz4" ]; then 
                            mdt "File found"
                            mdt "Removing waste"
                            TARGET_RM=("recovery.img.lz4" "boot.img.lz4" "dtbo.img.lz4" "userdata.img.lz4" "misc.bin.lz4" "vbmeta.img.lz4" "vbmeta_system.img.lz4" "meta-data" "metadata.img.lz4" "fota.zip")
                            for KILL in "${TARGET_RM[@]}"; do 
                                if [ "$IS_SUDO" == "0" ]; then 
                                    rm -rf $LAB/MAP/$KILL
                                    mdt "$KILL removed as it's useless"
                                else 
                                    sudo rm -rf $LAB/MAP/$KILL 
                                    mdt "$KILL removed as it's useless"
                                fi
                            done
                            mdt "Done"
                            mv $LAB/MAP/super.img.lz4 $LAB/
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
    clear
    if [ "$(find $LAB/system.img -type f ! -size 0 -printf '%S\n' | sed 's/.\.[0-9]*//')" == 1 ]; then 
        mdt "Processing..."
    else 
        mdt "Something needs to be taken care of... Please Wait..."
        simg2img $LAB/system.img $LAB/system.raw.img
    fi
    if [ -e "$LAB/odm.img" ]; then
        if [ -e "$LAB/product.img" ]; then
            mdt "Product already present"
            #mdt "Warning: If the patching didn't work, you can ask the group for help"
            if [ "$(ls -nl $LAB/product.img | awk '{print $5}')" -gt 6000 ]; then 
                mdt "Replacing Product.img as it identifies to be a potential stock Product, with universal product.img"
                cp -rf fake-props/product.img $LAB/product.img
            else 
                mdt "Confirmed to be a potential universal product.img detected..."
            fi 
        else 
            mdt "Product does not exist, probably external interference or old AP device..."
            mdt "Replacing it with Universal Product.img"
            cp -rf fake-props/product.img $LAB/product.img
            mdt "Done"
        fi 
        mdt "Starting Building"
        mdt "You may see header errors, but that just mean that its doing something right..."
        lpmake --metadata-size 65536 --super-name super --metadata-slots 2 --device super:$(<$TMP/super_size.txt) --group main:$(<$TMP/super_main.txt) --partition system:readonly:$(ls -nl $LAB/system.img | awk '{print $5}'):main --image system=$LAB/system.img --partition vendor:readonly:$(ls -nl $LAB/vendor.img | awk '{print $5}'):main --image vendor=$LAB/vendor.img --partition product:readonly:$(ls -nl $LAB/product.img | awk '{print $5}'):main --image product=$LAB/product.img --partition odm:readonly:$(ls -nl $LAB/odm.img | awk '{print $5}'):main --image odm=$LAB/odm.img --sparse --output $LAB/super.img
        mdt "OK!"
    else 
        if [ -e "$LAB/product.img" ]; then 
            mdt "Product already Present"
            #mdt "If patching didn't work, then you can ask the group for help"
            if [ "$(ls -nl $LAB/product.img | awk '{print $5}')" -gt 6000 ]; then 
                mdt "Replacing Product.img as it identifies to be a potential stock Product, with universal product.img"
                cp -rf fake-props/product.img $LAB/product.img
            else 
                mdt "Confirmed to be a potential universal product.img detected..."
            fi 
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
        lpmake --metadata-size 65536 --super-name super --metadata-slots 2 --device super:$(<$TMP/super_size.txt) --group main:$(<$TMP/super_main.txt) --partition system:readonly:$(ls -nl $LAB/system.img | awk '{print $5}'):main --image system=$LAB/system.img --partition vendor:readonly:$(ls -nl $LAB/vendor.img | awk '{print $5}'):main --image vendor=$LAB/vendor.img --partition product:readonly:$(ls -nl $LAB/product.img | awk '{print $5}'):main --image product=$LAB/product.img --partition system_ext:readonly:$(ls -nl $LAB/system_ext.img | awk '{print $5}'):main --image system_ext=$LAB/system_ext.img --sparse --output $LAB/super.img
        fi 
}

function build_normal_cmp {
    mdt "Starting process..."
    mdt "Starting : build_file"
    build_file
    mdt "It seems process : build_file has completed the task"
    mdt "Proceeding..."
    sleep 5
    file_name=$(dialog --backtitle "SAMSUNG GSI TO SUPER - $VERSION_ID - $STATUS" --title "Name-a-file" --inputbox "Enter what you want to name this file: \n\nREMEBER: NO SPACES, FILE EXTENSIONS AND SLASHES AND IF IT BREAKS ITS YOUR FAULT! \nGoing back resets to default name\n\nDefault:" 0 0 "exported_super" 2>&1 >/dev/tty)
    if [ -z "$file_name" ]; then
        mdt "No value detected, using default name"
        file_name="exported_super"
    else 
        mdt "Name: $file_name"
    fi
    recovery_insert_main
    
    if [[ $REC_RESPONSE == 1 ]]; then
        mdt "Continuing this"
        mdt "Calling tar to pack"
        #mdt "BTW renaming package feature is coming soon"
        tar -cvf $LAB/$file_name.tar $LAB/super.img
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
            menu_man "Error: B_NT_25 - Invalid expected size or you put spaces which you shouldn't in the first place"
        else 
            mdt "YES! IT IS DONE"
            mdt "File is completed"
            mdt "File was located in : $LAB/$file_name.tar, now ready to flash..."
            mdt "Going back to menu in 5 seconds"
            menu_man
        fi
    fi
    if [[ $REC_RESPONSE == 0 ]]; then
        case $RECOVERY_FILE in 
            "twrp_a12s")
                mdt "Continuing this"
                mdt "Calling tar to pack"
                #mdt "BTW renaming package feature is coming soon"
                tar -cvf $LAB/$file_name.tar super.img $LOCATION_RECOVERY
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
                    menu_man "Error: B_NT_25 - Invalid expected size or you put spaces which you shouldn't in the first place"
                else 
                    mdt "YES! IT IS DONE"
                    mdt "File is completed"
                    mdt "File was located in : $LAB/$file_name.tar, now ready to flash..."
                    mdt "Going back to menu in 5 seconds"
                    menu_man
                fi
                ;;
        esac
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
                "Wipe Cache NOW" "Wipes Cache Now. Only use this if you are done" \
                "Wipe Inside LAB dir" "Wipes inside LAB variable: $LAB" \
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
                    "Wipe Cache NOW")
                        wipe_cache_tmp_clut
                        ;;
                    "Wipe Inside LAB dir")
                        image_build_wipe
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
    msgbox "About" "SAMSUNG GSI TO SUPER BUILDER \n\nVERSION: $VERSION_ID\nFLAGS: $STATUS\n\nIf you struggled using this script, try to use Rou, same thing:\nhttps://github.com/Takumi123x/rou\n\nJoin Telegram: https://t.me/a12schat\n\n\nFlags while running:\nIS_SUDO=$IS_SUDO\nCLEAR_UP=$CLEAR_UP"
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

function image_build_wipe {
    rm -rf $LAB/*
    msgbox "Done" "Clean Done"
    menu_man
}

function recovery_insert_main () {
    recovery_menu=$(dialog \
                    --backtitle "SAMSUNG GSI TO SUPER - $VERSION_ID - $STATUS" \
                    --title "Recovery Option" \
                    --menu "THIS FEATURE WAS WORKING IN 0.9.2, BUT WAS REMOVED DUE TO SAVING TIME TO CLONE + LESS ISSUE, SUGGEST TO CANCEL THE PROCESS\n\n\n\nInject Recovery to the archive\n\nInsert Recoveries at your disposal\n\n\nOthers will be added soon\n\nExiting this menu will not insert custom recovery either" 0 0 0\
                    "No Custom Recovery" "No Custom Recovery" \
                    "TWRP - Galaxy A12s Exynos" "TWRP Galaxy A12s for Exynos 850 Handsets" \
                    2>&1 >/dev/tty)
    ervar=$?
    case $ervar in
        1)
            clear
            mdt "No recovery will be injected"
            REC_RESPONSE=1
            ;;
    esac 
    case $recovery_menu in 
        "No Custom Recovery")
            clear
            mdt "No recovery will be injected"
            REC_RESPONSE=1
            ;;
        "TWRP - Galaxy A12s Exynos")
            clear 
            twrp_galaxy_a12s
            ;;
    esac
}

function twrp_galaxy_a12s() {
    yesno "Are you sure you want:\n\nTWRP for Galaxy A12s for your device?\n\nWARNING:\nTHIS RECOVERY ONLY SUPPORTS GALAXY A12s U9 and UA, THIS CAN CAUSE NEAR IRREVERSIBLE DAMAGE IF YOU WANT THIS RECOVERY ON A DEVICE THAT DOESN'T SUPPORT IT!, ALTHO MORE ITERATIONS ARE COMING SOON..."
    local ervar=$?
    case $ervar in 
        0)
            REC_RESPONSE=0
            RECOVERY_FILE="twrp_a12s"
            LOCATION_RECOVERY="recoveries/twrp/a12s_exynos/recovery.img"
            ;;
        1)
            recovery_insert_main
            ;;
    esac
}



linux
disclaimer

