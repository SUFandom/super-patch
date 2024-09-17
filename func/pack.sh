#!/bin/bash

# Pack v1

LAB="$(realpath .)/imgbuild"
TMP="$(realpath cached_proc)"



case $1 in
    "--imgonly")
        echo "Using Legacy Packing method"
        echo "Means, running a component from early bash script to proceed"
        if [ "$(find $LAB/system.img -type f ! -size 0 -printf '%S\n' | sed 's/.\.[0-9]*//')" == 1 ]; then 
            echo "Processing..."
        else 
            echo "Something needs to be taken care of... Please Wait..."
            simg2img $LAB/system.img $LAB/system.raw.img
        fi
        if [ -e "$LAB/odm.img" ]; then
            if [ -e "$LAB/product.img" ]; then
                echo "Product already present"
                #echo "Warning: If the patching didn't work, you can ask the group for help"
                if [ "$(ls -nl $LAB/product.img | awk '{print $5}')" -gt 6000 ]; then 
                    echo "Replacing Product.img as it identifies to be a potential stock Product, with universal product.img"
                    cp -rf fake-props/product.img $LAB/product.img
                else 
                    echo "Confirmed to be a potential universal product.img detected..."
                fi 
            else 
                echo "Product does not exist, probably external interference or old AP device..."
                echo "Replacing it with Universal Product.img"
                cp -rf fake-props/product.img $LAB/product.img
                echo "Done"
            fi 
            echo "Starting Building"
            echo "You may see header errors, but that just mean that its doing something right..."
            lpmake --metadata-size 65536 --super-name super --metadata-slots 2 --device super:$(<$TMP/super_size.txt) --group main:$(<$TMP/super_main.txt) --partition system:readonly:$(ls -nl $LAB/system.img | awk '{print $5}'):main --image system=$LAB/system.img --partition vendor:readonly:$(ls -nl $LAB/vendor.img | awk '{print $5}'):main --image vendor=$LAB/vendor.img --partition product:readonly:$(ls -nl $LAB/product.img | awk '{print $5}'):main --image product=$LAB/product.img --partition odm:readonly:$(ls -nl $LAB/odm.img | awk '{print $5}'):main --image odm=$LAB/odm.img --sparse --output $LAB/super.img
            echo "OK!"
        else 
            if [ -e "$LAB/product.img" ]; then 
                echo "Product already Present"
                #echo "If patching didn't work, then you can ask the group for help"
                if [ "$(ls -nl $LAB/product.img | awk '{print $5}')" -gt 6000 ]; then 
                    echo "Replacing Product.img as it identifies to be a potential stock Product, with universal product.img"
                    cp -rf fake-props/product.img $LAB/product.img
                else 
                    echo "Confirmed to be a potential universal product.img detected..."
                fi 
            else 
                echo "Product does not exist, probably external interference or old AP device..."
                echo "Replacing it with Universal Product.img"
                cp -rf fake-props/product.img $LAB/product.img
                echo "Done"
            fi 
            if [ -e "$LAB/system_ext.img" ]; then 
                echo "System_ext already present, so fake system_ext is no longer needed."
            else 
                echo "System_ext is not present, it could be an external interference"
                echo "Trying to add Universal System_ext"
                cp -rf fake-props/system_ext.img $LAB/product.img
                echo "Done"
            fi 
            echo "Starting Building"
            echo "You may see header errors, but that's just mean that its doing something right"
            lpmake --metadata-size 65536 --super-name super --metadata-slots 2 --device super:$(<$TMP/super_size.txt) --group main:$(<$TMP/super_main.txt) --partition system:readonly:$(ls -nl $LAB/system.img | awk '{print $5}'):main --image system=$LAB/system.img --partition vendor:readonly:$(ls -nl $LAB/vendor.img | awk '{print $5}'):main --image vendor=$LAB/vendor.img --partition product:readonly:$(ls -nl $LAB/product.img | awk '{print $5}'):main --image product=$LAB/product.img --partition system_ext:readonly:$(ls -nl $LAB/system_ext.img | awk '{print $5}'):main --image system_ext=$LAB/system_ext.img --sparse --output $LAB/super.img
        fi
        echo "DONE" 
        ;;
    "--tarfile")
        echo "Using Legacy Packing method"
        echo "Means, running a component from early bash script to proceed"
        if [ "$(find $LAB/system.img -type f ! -size 0 -printf '%S\n' | sed 's/.\.[0-9]*//')" == 1 ]; then 
            echo "Processing..."
        else 
            echo "Something needs to be taken care of... Please Wait..."
            simg2img $LAB/system.img $LAB/system.raw.img
        fi
        if [ -e "$LAB/odm.img" ]; then
            if [ -e "$LAB/product.img" ]; then
                echo "Product already present"
                #echo "Warning: If the patching didn't work, you can ask the group for help"
                if [ "$(ls -nl $LAB/product.img | awk '{print $5}')" -gt 6000 ]; then 
                    echo "Replacing Product.img as it identifies to be a potential stock Product, with universal product.img"
                    cp -rf fake-props/product.img $LAB/product.img
                else 
                    echo "Confirmed to be a potential universal product.img detected..."
                fi 
            else 
                echo "Product does not exist, probably external interference or old AP device..."
                echo "Replacing it with Universal Product.img"
                cp -rf fake-props/product.img $LAB/product.img
                echo "Done"
            fi 
            echo "Starting Building"
            echo "You may see header errors, but that just mean that its doing something right..."
            lpmake --metadata-size 65536 --super-name super --metadata-slots 2 --device super:$(<$TMP/super_size.txt) --group main:$(<$TMP/super_main.txt) --partition system:readonly:$(ls -nl $LAB/system.img | awk '{print $5}'):main --image system=$LAB/system.img --partition vendor:readonly:$(ls -nl $LAB/vendor.img | awk '{print $5}'):main --image vendor=$LAB/vendor.img --partition product:readonly:$(ls -nl $LAB/product.img | awk '{print $5}'):main --image product=$LAB/product.img --partition odm:readonly:$(ls -nl $LAB/odm.img | awk '{print $5}'):main --image odm=$LAB/odm.img --sparse --output $LAB/super.img
            echo "OK!"
        else 
            if [ -e "$LAB/product.img" ]; then 
                echo "Product already Present"
                #echo "If patching didn't work, then you can ask the group for help"
                if [ "$(ls -nl $LAB/product.img | awk '{print $5}')" -gt 6000 ]; then 
                    echo "Replacing Product.img as it identifies to be a potential stock Product, with universal product.img"
                    cp -rf fake-props/product.img $LAB/product.img
                else 
                    echo "Confirmed to be a potential universal product.img detected..."
                fi 
            else 
                echo "Product does not exist, probably external interference or old AP device..."
                echo "Replacing it with Universal Product.img"
                cp -rf fake-props/product.img $LAB/product.img
                echo "Done"
            fi 
            if [ -e "$LAB/system_ext.img" ]; then 
                echo "System_ext already present, so fake system_ext is no longer needed."
            else 
                echo "System_ext is not present, it could be an external interference"
                echo "Trying to add Universal System_ext"
                cp -rf fake-props/system_ext.img $LAB/product.img
                echo "Done"
            fi 
            echo "Starting Building"
            echo "You may see header errors, but that's just mean that its doing something right"
            lpmake --metadata-size 65536 --super-name super --metadata-slots 2 --device super:$(<$TMP/super_size.txt) --group main:$(<$TMP/super_main.txt) --partition system:readonly:$(ls -nl $LAB/system.img | awk '{print $5}'):main --image system=$LAB/system.img --partition vendor:readonly:$(ls -nl $LAB/vendor.img | awk '{print $5}'):main --image vendor=$LAB/vendor.img --partition product:readonly:$(ls -nl $LAB/product.img | awk '{print $5}'):main --image product=$LAB/product.img --partition system_ext:readonly:$(ls -nl $LAB/system_ext.img | awk '{print $5}'):main --image system_ext=$LAB/system_ext.img --sparse --output $LAB/super.img
        fi
        echo "Packing"
        tar -cvf $LAB/super_finish.tar $LAB/super.img
        if [ "$2" == "--nodelete" ]; then
            echo "Skip deleting image"
        else
            rm -rf $LAB/super.img
        fi
        echo "Done"
        sleep 5
        ;;
    "--help")
        echo ""
        echo "Super-patch Packer"
        echo "A minibash script component for Super-patch"
        echo ""
        echo "Args"
        echo "./pack.sh --[imgonly/tarfile] --nodelete"
        echo ""
        echo "  --imgonly       Create super.img only"
        echo "  --tarfile       Create super.img + compressed with tar"
        echo "                  with 0 compression algorithms"
        echo "  --nodelete      Works if you invoke --tarfile"
        echo "                  Preventing deletion of super.img"
        echo "                  After job process is done"
        echo ""
        ;;
    *)
        $0 --help
        ;; 
esac
        
        
