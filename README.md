# SAMSUNG GSI TO SUPER BUILDER

This is still in development, but its almost done!

---

Badges:

![alttext](https://img.shields.io/static/v1?label=status%20on%20git&message=devel(Developement)&color=red&style=flat-square)

![alttext](https://img.shields.io/static/v1?label=Status%20on%20Termux&message=working&color=brightgreen&style=flat-square&logo=android) ![alttext](https://img.shields.io/static/v1?label=Status%20on%20WSL&message=ERROR&color=red&style=flat-square&logo=windowsterminal) ![alttext](https://img.shields.io/badge/Debian-WORKING-brightgreen?style=flat-square&logo=debian) ![alttext](https://img.shields.io/badge/Arch_Linux-Unstable-red?style=flat&logo=archlinux)


---

This Script works on Debian/Ubuntu, Termux, and Arch Linux


## Credits due who supported the project:

- [Takumi123x](https://github.com/Takumi123x) - which some parts of this code are based of [rou](https://github.com/Takumi123x/rou), this repository, `super-patch` is just a UI reskin using [dialog](https://invisible-island.net/dialog/) as a backend with some added features in
- [Exynos 850 Group in Telegram](https://t.me/a12schat)
- KiriTheThird on Telegram

---

## Introduction

What is super-patch?

Super-patch is a Samsung GSI to Super Builder, as partition tables are getting more complex, this script can help you make sure any GSI with any A/B Partition modes will work! **BUT IT DOES NOT GUARANTEE THAT IT WILL REALLY WORK BECAUSE GSIs TEND TO NOT WORK IN SOME DEVICES REGARDLESS OF USING THIS TOOL**

## Whats Up!

Check update [notes](/updates/notes/0.9.md)

## Table Chart!

| THINGS                                                     | ROU | SUPER-PATCH |
|------------------------------------------------------------|-----|-------------|
| TD-based GSI BUILDING                                      |  ✅  |      ✅      |
| NON-TD Based GSI BUILDING                                  |  ✅  |      ✅      |
| RENAME OUTPUT BUILDS                                       |  ❌  |      ✅      |
| CHANGE DIRECTORY BUILD                                     |  ✅  |      ✅      |
| BUILT-IN WIKI                                              |  ❌  |      ✅      |
| AP Extract                                                 |  ✅  |      ✅      |
| ODM Support (For MediaTek and UniSOC-based Samsung Devices) |  ✅  |      ❌      |
| GSI PICKER                                                 |  ❌  |      ✅      |
| GSI FILE DOWNLOAD                                          |  ❌  |      ❌      |
| Multi Language                                             |  ❌  |      ❌      |

Rou is very simple and sticks to its core purpose while super-patch make sure that the building process are mostly happen in the terminal, with little intervention on the outside (soon)

# Instructions

### For Arch Linux users and/or its relations

Before proceeding to run `builder.sh`, please try to run `arch_dependencies_install.sh` to continue or else your builds wont work


Well you want to build a Super for your Samsung Device, well this script got you!


But first, check if your device is compatible [here](https://github.com/phhusson/treble_experimentations/wiki/Samsung)

[*For Samsung Galaxy A12 List*](https://github.com/phhusson/treble_experimentations/wiki/Samsung-Galaxy-A12s-%28Exynos-850%29) because unlike other devices of Samsung that can work with fastbootd, Galaxy A12 is different

First copy these:

```
cd ~ && apt update && apt upgrade && apt update && apt install git curl dialog -y && git clone https://github.com/SUFandom/super-patch
```


After that, run this:

```
cd super-patch && chmod +x *.sh && ./builder.sh
```

First, you will be greeted by this:

![Alt text](/media_md/img/env.png)

*Notes:*
*For arch users, please avoid selecting the Arch Option unless you run `./builder.sh --inst_archlinux`* *because `paru` needs to be ran as user as first init, quite inconvinent tbh*

After you selected the options there, there will be prompts to warn you about installation and such

![Alt text](/media_md/img/are_u_debian.png)

*Note: the script will crash itself as a failsafe to ensure that theres nothing else being done on a root session*

After that, There will be a disclaimer which you can press enter, then the main menu shows up, you have options


![Alt text](media_md/img/image.png)

The target dir mentions where the building takes place, the screenshot sample just shows the WSL directory, for android it would be `/data/data/com.termux/files/home/storage/image_build` which basically means your `/storage/emulated/0/image_build`

Put your AP image file (we recommend you use magisked AP using Magisk Delta, get that on Exynos 850 Telegram group) to the target dir mentioned

After that you will see this after entering the highlighted Extract AP/Super

![Alt text](media_md/img/image_1.png)

Select Extract AP

Then it should extract 

After that you should go back to the menu, select Extract Super then it should extract Super.img

After that this comes up:

![Alt text](media_md/img/image_2.png)

Altho it is preferrable to do manually on this part as this is not fixed yet, go to Zarchiver, then the image_build directory, delete product.img and system.img. After that Extract the GSI Image and rename it to system.img then put it to the image_build folder 

After that:

![Alt text](media_md/img/image3.png)

Go back to main menu and then select Build Super > Build 

Wait paitiently until it asks the name

![Alt text](media_md/img/image_4.png)

You can go enter then it will save by default but if you want to rename the output file, make sure it doesn't has spaces on it or the script will break

After that, its done, you can find it in the image_build with the tar file ready to be flashed using ODIN

If you have questions, go to Telegram group 

---

## System Requirements 

Windows:
- WSL 2 With Hyper-V support and 8GB of RAM 

Android:
- Termux 0.118 with ARM64 Device, 4GB of RAM and 128GB of Storage 

Debian:
- Celeron N3060, with 128GB SSD, 4GB of RAM

Arch Linux:
- Celeron N3060, with 128GB SSD, 4GB of RAM

