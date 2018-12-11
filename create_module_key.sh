#!/bin/sh

MOK=modules_signing

case $1 in
    -h)
        echo Usage create key-pair:
            $0 -c
        echo Usage sign modules: 
            $0 -s <modulename> [<modulename>] [<modulename>]...
        shift
        ;;
    -c) 
        shift
        echo create key-pair for signing the modules

        if [ -e $MOK.priv ] ;then
            :
        else
            openssl req -new -x509 -newkey rsa:2048 -keyout $MOK.priv -outform DER -out $MOK.der -nodes -days 36500 -subj "/CN=Jakobus Schuerz/"
        fi
        sudo mokutil --import $MOK.der
        ;;


    -s)
        shift
        echo "Sign kernel modules $(uname -r)"
        for i in $@; do 
            echo sudo /usr/src/kernels/$(uname -r)/scripts/sign-file sha256 ./$MOK.priv ./$MOK.der $(modinfo -n ${i})
            sudo /usr/src/kernels/$(uname -r)/scripts/sign-file sha256 ./$MOK.priv ./$MOK.der $(modinfo -n ${i})
        done
        ;;
    *)
        echo "wrong option"
        exit 1
esac

