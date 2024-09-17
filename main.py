#!/usr/bin/env python3

import sys
import subprocess
import shutil
import os
import time
from simple_term_menu import TerminalMenu
import lzma

# STRINGS
DIR = sys.path[0]
VENV = f"{DIR}/venv"
VERSION = "rolling-python"
BUILD = ""
TARGET_DIR = f"{DIR}/imgbuild"
CACHE = f"{DIR}/cached_proc"
# try:
#     SUPER_MAP = open(f"{CACHE}/super_map.txt").read
# except:
#     print() # idk what to say, this is necessary to make the py script not crash
try:
    SUPER_SIZE_RAW = open(f"{CACHE}/super_size.txt", "r")
    SS_TAG = SUPER_SIZE_RAW.read()
    SUPER_SIZE = SS_TAG # IM FRUSTRATED
    SUPER_SIZE_RAW.close()
except:
    SUPER_SIZE = "Not present"
try:
    SUPER_MAIN_RAW = open(f"{CACHE}/super_main.txt", "r")
    SM_TAG = SUPER_MAIN_RAW.read()
    SUPER_MAIN = SM_TAG
    SUPER_MAIN_RAW.close()
except:
    SUPER_MAIN = "Not present"
try:
    SYSIMG_SELECT_RAW = open(f"{CACHE}/loc_cache.txt", "r")
    SY_TAG = SYSIMG_SELECT_RAW.read()
    SYSIMG_SELECT = SY_TAG 
    SYSIMG_SELECT_RAW.close()
except:
    SYSIMG_SELECT = "Not present"
try:
    EXT_SELECT_RAW = open(f"{CACHE}/ap_cache.txt", "r")
    EXT_TAG = EXT_SELECT_RAW.read()
    EXT_SELECT = EXT_TAG
    EXT_SELECT_RAW.close()
except:
    EXT_SELECT = "Not present"
    
# IMG SIZES
try:
    SYSTEM_IMG = os.path.getsize(f"{TARGET_DIR}/system.img")
except OSError:
    SYSTEM_IMG = "Not present"
try:
    ODM_IMG = os.path.getsize(f"{TARGET_DIR}/odm.img")
except OSError:
    ODM_IMG = "Not present"
try:
    PRODUCT_IMG = os.path.getsize(f"{TARGET_DIR}/product.img")
except OSError:
    PRODUCT_IMG = "Not present"
try:
    VENDOR_IMG = os.path.getsize(f"{TARGET_DIR}/vendor.img")
except OSError:
    VENDOR_IMG = "Not present"
try:
    SUPER_IMG = os.path.getsize(f"{TARGET_DIR}/super.img")
except OSError:
    SUPER_IMG = "Not present"
try:
    SYSTEM_EXT_IMG = os.path.getsize(f"{TARGET_DIR}/system_ext.img")
except OSError:
    SYSTEM_EXT_IMG = "Not present"


# Checkpoint
ANDROID_TARGET_VARIABLE = "ANDROID_ROOT"
if ANDROID_TARGET_VARIABLE in os.environ:
    IS_ANDROID_SYSTEM = True
    LANDING = "/data/data/com.termux/files/home"
else:
    IS_ANDROID_SYSTEM = False
    LANDING = "/"




# FUNCTIONS 

# ALWAYS INVOKE THIS WHEN DONE EXTRACTING IMAGES
def refresh_variable():
    global SUPER_SIZE
    global SUPER_IMG
    global SUPER_MAIN
    global SYSTEM_IMG
    global ODM_IMG
    global PRODUCT_IMG
    global VENDOR_IMG
    global SYSTEM_EXT_IMG
    global SYSIMG_SELECT
    global EXT_SELECT
    try:
        SUPER_SIZE_RAW = open(f"{CACHE}/super_size.txt", "r")
        SS_TAG = SUPER_SIZE_RAW.read()
        SUPER_SIZE = SS_TAG
        SUPER_SIZE_RAW.close()
    except:
        SUPER_SIZE = "Not present"
    try:
        SUPER_MAIN_RAW = open(f"{CACHE}/super_main.txt", "r")
        SM_TAG = SUPER_MAIN_RAW.read()
        SUPER_MAIN = SM_TAG
        SUPER_MAIN_RAW.close()
    except:
        SUPER_MAIN = "Not present"
    try:
        SYSIMG_SELECT_RAW = open(f"{CACHE}/loc_cache.txt", "r")
        SY_TAG = SYSIMG_SELECT_RAW.read()
        SYSIMG_SELECT = SY_TAG
        SYSIMG_SELECT_RAW.close()
    except:
        SYSIMG_SELECT = "Not present"
    try:
        EXT_SELECT_RAW = open(f"{CACHE}/ext_cache.txt", "r")
        EXT_TAG = EXT_SELECT_RAW.read()
        EXT_SELECT = EXT_TAG
        EXT_SELECT_RAW.close()
    except:
        EXT_SELECT = "Not present"
    try:
        SYSTEM_IMG = os.path.getsize(f"{TARGET_DIR}/system.img")
    except OSError:
        SYSTEM_IMG = "FILE NOT FOUND"
    try:
        ODM_IMG = os.path.getsize(f"{TARGET_DIR}/odm.img")
    except OSError:
        ODM_IMG = "FILE NOT FOUND"
    try:
        PRODUCT_IMG = os.path.getsize(f"{TARGET_DIR}/product.img")
    except OSError:
        PRODUCT_IMG = "FILE NOT FOUND"
    try:
        VENDOR_IMG = os.path.getsize(f"{TARGET_DIR}/vendor.img")
    except OSError:
        VENDOR_IMG = "FILE NOT FOUND"
    try:
        SUPER_IMG = os.path.getsize(f"{TARGET_DIR}/super.img")
    except OSError:
        SUPER_IMG = "FILE NOT FOUND"
    try:
        SYSTEM_EXT_IMG = os.path.getsize(f"{TARGET_DIR}/system_ext.img")
    except OSError:
        SYSTEM_EXT_IMG = "FILE NOT FOUND"
    

    
    # return SUPER_SIZE, SUPER_IMG, SUPER_MAIN, SYSTEM_IMG, ODM_IMG, PRODUCT_IMG, VENDOR_IMG, SYSTEM_EXT_IMG


    # time.sleep(3)


if os.path.isdir(CACHE):
    print("CACHE DIR ALREADY EXISTS")
else:
    print("Directory does not exist...")
    os.mkdir(CACHE)
    print("There we go...")
    
if os.path.isdir(TARGET_DIR):
    print("TARGET EXISTS")
else:
    print("Directory does not exist...")
    os.mkdir(TARGET_DIR)
    print("There we go")

os.system('clear')

# diagnose
# print(f"""
# Verbose Debug:

# DIR =  {DIR}
# VENV = {VENV}
# VERSION = {VERSION}
# BUILD =  {BUILD}
# TARGET_DIR = {TARGET_DIR}
# CACHE = {CACHE}


# do comment this side when on release, including the sleep
# """)

# time.sleep(5)
os.system('clear')


def disclaimer():
    print("""
Disclaimer Notice

WARNING: This software tool is currently in the development testing phase. 
          Expect unexpected issues or errors to occur during its usage.

IMPORTANT: Before proceeding, ensure you have a stock AP backup readily 
          available in case the flashing process fails.

MANDATORY: Perform a NAND wipe prior to flashing the Super Image file.

RECOMMENDATION: To guarantee a smooth and seamless experience, 
          we strongly advise utilizing the alternative tool 
          developed by Takumi123x: https://github.com/Takumi123x/rou: 
          https://github.com/Takumi123x/rou

ESSENTIAL: Ensure you possess adequate reading comprehension and mental 
          preparedness to handle any unforeseen circumstances that may 
          arise during the process.

CRUCIAL DISCLAIMER: Flashing the Super Image file generated by this 
          script has been confirmed to cause potentially irreversible 
          damage to MediaTek and Spreadtrum/UNISOC devices. Currently, 
          only Qualcomm and Exynos devices have been verified to 
          function properly with this tool.

Proceed with extreme caution and at your own discretion. The author of 
          this software tool assumes no responsibility for any damage 
          caused to your device as a result of its usage. By utilizing 
          this tool, you acknowledge and accept the potential risks 
          involved, particularly for MediaTek and Spreadtrum/UNISOC 
          devices.
""")
    vbresponse = input("Do you agree (Y/N): ")
    if vbresponse == "y" or vbresponse == "Y":
        mainmenu()
        # print("T")
    elif vbresponse == "n" or vbresponse == "N":
        exit()
    else:
        os.system('clear')
        print(f"Wrong response: {vbresponse}")
        print("It should be Y or y or n or N")
        time.sleep(5)
        disclaimer()

def mainmenu():
    os.system('clear')
    menutitle = f"   Super Patch\n  Version: {VERSION} - {BUILD}\n\n Press ESC or Q to quit immediately\n\nThis script modifies super.img file\nfrom samsung to add your own\nGSI of your choice\n\n\nDebug:\nDirectory Core: {DIR}\nImage Dir: {TARGET_DIR}\nCache: {CACHE}\n\n\n"
    items = [ "Extract" ,"Inject" , "Build", "Wiki" , "About", "Leave/Exit" ]
    menu_exit = False

    main_menu = TerminalMenu(
        menu_entries = items,
        menu_cursor= " [H]> ",
        title = menutitle,
        cycle_cursor = True,
    )

    while not menu_exit:
        menu_selection = main_menu.show()

        if menu_selection == 0:
            menu_exit = True
            os.system('clear')
            extract_menupage()
        elif menu_selection == 1:
            menu_exit = True
            os.system('clear')
            inject_menupage()
        elif menu_selection == 2:
            build_menupage()
        elif menu_selection == 3:
            os.system('clear')
            print("Wiki is still in construction so come back later")
        elif menu_selection == 4:
            menu_exit = True
            os.system('clear')
            about()
        elif menu_selection == 5 or menu_selection == None:
            menu_exit = True
            os.system('clear')
            quit()


def extract_menupage():
    os.system('clear')
    extract_title = f"    Super-patch\n   EXTRACTION MENU\n\n(Press ESC or Q to abruptly quit, all progress wont be saved (probably))\n\nDebug:\nSuper Image Size: {SUPER_SIZE}\nSuper Image Main Size: {SUPER_MAIN}\nSYSTEM IMG size: {SYSTEM_IMG}\nODM IMG size: {ODM_IMG}\nPRODUCT IMG size: {PRODUCT_IMG}\nVENDOR IMG size: {VENDOR_IMG}\nSYSTEM EXT IMG size: {SYSTEM_EXT_IMG}\n\n\n\n"
    items = [ "< Back", "Extract AP", "Extract super.img.lz4", "Extract super.img only", "Refresh variables" ]
    menu_exit = False

    main_menu = TerminalMenu(
        menu_entries=items,
        menu_cursor=" [E]> ",
        title = extract_title,
        cycle_cursor= False
    )

    while not menu_exit:
        menu_selection = main_menu.show()

        if menu_selection == 0:
            menu_exit = True
            os.system('clear')
            mainmenu()
        elif menu_selection == 1:
            menu_exit = True
            os.system('clear')
            print("Starting Ranger")
            print("Note that ranger is a vi based file picker so only use arrows, esc and enter for navigation")
            time.sleep(3)
            if IS_ANDROID_SYSTEM == True and ANDROID_TARGET_VARIABLE in os.environ:
                if os.path.isfile("/data/data/com.termux/files/usr/bin/ranger"):
                    try:
                        os.system(f"func/select_ext.sh {LANDING}")
                    except:
                        os.system('clear')
                        print("Can't see the ranger command in your system... Selection aborted")
                        time.sleep(5)
                    refresh_variable()
            else:
                if os.path.isfile("/usr/bin/ranger"):
                    try:
                        os.system(f"func/select_ext.sh {LANDING}")
                    except:
                        os.system('clear')
                        print("Can't see the ranger command in your system... Selection aborted")
                        time.sleep(5)
                    refresh_variable()
            if EXT_SELECT != "Not Present":
                os.system(f"func/extract.sh --extract --ap {EXT_SELECT}")
            else:
                print(f"File select says: {EXT_SELECT}")
                print("ERROR")
                time.sleep(5)
            refresh_variable()
            extract_menupage()
        elif menu_selection == 2:
            menu_exit = True
            os.system('clear')
            print("Starting Ranger")
            print("Note that ranger is a vi based file picker so only use arrows, esc and enter for navigation")
            time.sleep(3)
            if IS_ANDROID_SYSTEM == True and ANDROID_TARGET_VARIABLE in os.environ:
                if os.path.isfile("/data/data/com.termux/files/usr/bin/ranger"):
                    try:
                        os.system(f"func/select_ext.sh {LANDING}")
                    except:
                        os.system('clear')
                        print("Can't see the ranger command in your system... Selection aborted")
                        time.sleep(5)
                    refresh_variable()
            else:
                if os.path.isfile("/usr/bin/ranger"):
                    try:
                        os.system(f"func/select_ext.sh {LANDING}")
                    except:
                        os.system('clear')
                        print("Can't see the ranger command in your system... Selection aborted")
                        time.sleep(5)
                    refresh_variable()
            if EXT_SELECT != "Not Present":
                os.system(f"func/extract.sh --extract --super {EXT_SELECT}")
            else:
                print(f"File select says: {EXT_SELECT}")
                print("ERROR")
                time.sleep(5)
            refresh_variable()
            extract_menupage()
        elif menu_selection == 3:
            menu_exit = True
            os.system('clear')
            print("Starting Ranger")
            print("Note that ranger is a vi based file picker so only use arrows, esc and enter for navigation")
            time.sleep(3)
            if IS_ANDROID_SYSTEM == True and ANDROID_TARGET_VARIABLE in os.environ:
                if os.path.isfile("/data/data/com.termux/files/usr/bin/ranger"):
                    try:
                        os.system(f"func/select_ext.sh {LANDING}")
                    except:
                        os.system('clear')
                        print("Can't see the ranger command in your system... Selection aborted")
                        time.sleep(5)
                    refresh_variable()
            else:
                if os.path.isfile("/usr/bin/ranger"):
                    try:
                        os.system(f"func/select_ext.sh {LANDING}")
                    except:
                        os.system('clear')
                        print("Can't see the ranger command in your system... Selection aborted")
                        time.sleep(5)
                    refresh_variable()
            if EXT_SELECT != "Not Present":
                os.system(f"func/extract.sh --extract --super {EXT_SELECT}")
            else:
                print(f"File select says: {EXT_SELECT}")
                print("ERROR")
                time.sleep(5)
            refresh_variable()
            extract_menupage()
        elif menu_selection == 4:
            menu_exit = True
            refresh_variable()
            os.system('clear')
            extract_menupage()
        elif menu_selection == None: 
            os.system('clear')
            menu_exit = True
            mainmenu()

def inject_menupage():
    os.system('clear')
    inject_title = f"     Super-patch\n   Inject Menupage\n\nPress ESC or Q to Quit\n Here, you can select and let the script handle it... :D\n\nDebug:\n\nSelected Image: {SYSIMG_SELECT}\nSuper Image Size: {SUPER_SIZE}\nSuper Image Main Size: {SUPER_MAIN}\nSYSTEM IMG size: {SYSTEM_IMG}\nODM IMG size: {ODM_IMG}\nPRODUCT IMG size: {PRODUCT_IMG}\nVENDOR IMG size: {VENDOR_IMG}\nSYSTEM EXT IMG size: {SYSTEM_EXT_IMG}\n\n"
    items = [ "< Back" , "Select GSI" , "Select GSI (compressed)", "Refresh Variables" ]
    menu_exit = False

    main_menu = TerminalMenu(
        menu_entries=items,
        menu_cursor=" [I]> ",
        title = inject_title,
        cycle_cursor= False
    )
    
    while not menu_exit:
        menu_selection = main_menu.show()
        if menu_selection == 0:
            menu_exit = True
            os.system('clear')
            mainmenu()
        elif menu_selection == 1:
            menu_exit = True
            os.system('clear')
            print("Starting Ranger")
            print("Note that ranger is a vi based file picker so only use arrows, esc and enter for navigation")
            time.sleep(3)
            if IS_ANDROID_SYSTEM == True and ANDROID_TARGET_VARIABLE in os.environ:
                if os.path.isfile("/data/data/com.termux/files/usr/bin/ranger"):
                    try:
                        os.system(f"func/select.sh {LANDING}")
                        os.remove(f"{TARGET_DIR}/system.img")
                    except:
                        os.system('clear')
                        print("Can't see the ranger command in your system... Selection aborted")
                        time.sleep(5)
            else:
                if os.path.isfile("/usr/bin/ranger"):
                    try:
                        os.system(f"func/select.sh {LANDING}")
                        os.remove(f"{TARGET_DIR}/system.img")
                    except:
                        os.system('clear')
                        print("Can't see the ranger command in your system... Selection aborted")
                        time.sleep(5)
            if SYSIMG_SELECT != "Not Present":
                try:
                    shutil.copy2({SYSIMG_SELECT}, f"{TARGET_DIR}/system.img")
                except FileNotFoundError:
                    print(f"File {SYSIMG_SELECT} not found")
                except PermissionError:
                    if IS_ANDROID_SYSTEM == True and ANDROID_TARGET_VARIABLE in os.environ:
                        print("Your termux doesn't have permissions to access user data directories")
                        print("Please run termux-setup-storage")
                        time.sleep(5)
                    else:
                        print("The directory that shutil tried to access and move the files cannot be moved")
                        print("Check if the folder has good permission status ")
                        time.sleep(5)
                except Exception as e:
                    print("Error copying file")
                    print(f"Shutil says: {e}")
                    time.sleep(5)
            refresh_variable()
            inject_menupage()
        elif menu_selection == 2:
            menu_exit = True
            os.system('clear')
            print("Starting Ranger")
            print("Note that ranger is a vi based file picker so only use arrows, esc and enter for navigation")
            time.sleep(3)
            if IS_ANDROID_SYSTEM == True and ANDROID_TARGET_VARIABLE in os.environ:
                if os.path.isfile("/data/data/com.termux/files/usr/bin/ranger"):
                    try:
                        os.system(f"func/select.sh {LANDING}")
                        os.remove(f"{TARGET_DIR}/system.img")
                    except:
                        os.system('clear')
                        print("Can't see the ranger command in your system... Selection aborted")
                        time.sleep(5)
            else:
                if os.path.isfile("/usr/bin/ranger"):
                    try:
                        os.system(f"func/select.sh {LANDING}")
                        os.remove(f"{TARGET_DIR}/system.img")
                    except:
                        os.system('clear')
                        print("Can't see the ranger command in your system... Selection aborted")
                        time.sleep(5)
            if SYSIMG_SELECT != "Not Present":
                try:
                    # Decompress from XZ
                    with lzma.open(f"{SYSIMG_SELECT}", 'rb') as f_in:
                        with open(f"{TARGET_DIR}/system.img", 'wb') as f_out:
                            shutil.copyfileobj(f_in, f_out)
                except FileNotFoundError:
                    print(f"File {SYSIMG_SELECT} not found")
                except Exception as e:
                    print(f"ERROR: {e}")
                    time.sleep(5)
            refresh_variable()
            inject_menupage()
        
        elif menu_selection == 3:
            menu_exit = True
            refresh_variable()
            os.system('clear')
            inject_menupage()
        elif menu_selection == None: 
            os.system('clear')
            menu_exit = True
            mainmenu()



        
def build_menupage():
    os.system('clear')
    build_title = f"     Super-patch\n   Build Menupage\n\nPress ESC or Q to Quit\n\n\n Here, you can build your own custom super.img\nSo you can install any of your loved GSI ROMs\n\n\nDebug:\nSuper Image Size: {SUPER_SIZE}\nSuper Image Main Size: {SUPER_MAIN}\nSYSTEM IMG size: {SYSTEM_IMG}\nODM IMG size: {ODM_IMG}\nPRODUCT IMG size: {PRODUCT_IMG}\nVENDOR IMG size: {VENDOR_IMG}\nSYSTEM EXT IMG size: {SYSTEM_EXT_IMG}\nSelected Image: {SYSIMG_SELECT}\n\n"
    items = [ "< Back", "Build with img only", "Build + file compressed as tar", "Refresh Variables" ]
    menu_exit = False
    
    main_menu = TerminalMenu(
        menu_entries=items,
        menu_cursor=" [B]> ",
        title = build_title,
        cycle_cursor= False
    )

    while not menu_exit:
        menu_selection = main_menu.show()
        
        if menu_selection == 0:
            menu_exit = True
            os.system('clear')
            mainmenu()
        elif menu_selection == 1:
            menu_exit = True
            def confirm():
                os.system('clear')
                build_title = f"   WARNING\n\nAre you sure to build it with img only???"
                items = [ "No", "Yes" ]
                menu_exit = False
                
                main_menu = TerminalMenu(
                    menu_entries=items,
                    menu_cursor="(:O ) --->",
                    title = build_title,
                    cycle_cursor=True,
                    default_selection = 0
                )
                
                while not menu_exit:
                    menu_selection = main_menu.show()
                    
                    if menu_selection == 0:
                        menu_exit = True
                        os.system('clear')
                        build_menupage()
                    elif menu_selection == 1:
                        menu_exit = True
                        os.system('clear')
                        os.system(f'func/pack.sh --imgonly')
                        build_menupage()
                    elif menu_selection == None: 
                        os.system('clear')
                        menu_exit = True
                        build_menupage()
            confirm()
        elif menu_selection == 2:
            menu_exit = True
            def confirm():
                os.system('clear')
                build_title = f"   WARNING\n\nAre you sure to build it with img only???"
                items = [ "No", "Yes" ]
                menu_exit = False
                
                main_menu = TerminalMenu(
                    menu_entries=items,
                    menu_cursor="(:O ) --->",
                    title = build_title,
                    cycle_cursor=True,
                    default_selection = 0
                )
                
                while not menu_exit:
                    menu_selection = main_menu.show()
                    
                    if menu_selection == 0:
                        menu_exit = True
                        os.system('clear')
                        build_menupage()
                    elif menu_selection == 1:
                        menu_exit = True
                        os.system('clear')
                        os.system(f'func/pack.sh --tarfile')
                        build_menupage()
                    elif menu_selection == None: 
                        os.system('clear')
                        menu_exit = True
                        build_menupage()
            confirm()
        elif menu_selection == 3:
            menu_exit = True
            refresh_variable()
            os.system('clear')
            build_menupage()
        elif menu_selection == None: 
            os.system('clear')
            menu_exit = True
            main_menu()

def about():
    os.system('clear')
    about_title = f"  Super-patch\n\nVersion: {VERSION} - {BUILD} \n\nReworked with Python\nFor legacy Bash version, run legacy_launch.sh instead\n\nSuper-patch is a piece of tool that would try to port GSI Roms to your samsung devices\nCreated by: SUFandom\nConcept based of: Takumi123x"
    items = [ "< Back" ]
    menu_exit = False
    
    main_menu = TerminalMenu(
        menu_entries=items,
        menu_cursor=" [A]> ",
        title = about_title,
        cycle_cursor= False
    )
    
    while not menu_exit:
        menu_selection = main_menu.show()
        
        if menu_selection == 0:
            menu_exit = True
            os.system('clear')
            mainmenu()
        elif main_menu == None: 
            menu_exit = True
            os.system('clear')
            mainmenu()
    



if __name__ == "__main__":
    disclaimer()