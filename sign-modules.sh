#!/bin/sh

MOK=modules_signing
#declare -A MODULES

help() {
        cat << EOF
        
        Usage create key-pair:
            $0 -c

    creates a key-pair to sign kernel-modules and registers it in UEFI to allow self signed kernel-modules for secure-boot

        Usage sign modules: 
            $0 <modulename> [<modulename>] [<modulename>]...
            $0 -k <kernelversion> <modulename> [<modulename>] [<modulename>]...
            $0 -k <kernelversion> -f <modulesfile>
            $0 -f <modulesfile>

        -k <kernelversion>      output of »uname -r«
                                if not given, it takes current kernelversion

        -f <modulesfile>        plaintext file with newlineseparated list of modules to sign    

    signs a list of modules with the created and registered key for secureboot
EOF
}
    
set -- $(getopt "hck:f:" "$@")

while : 
do
    case $1 in
        -h)
            help
            exit 0
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
            exit 0
            ;;
        -k)
            shift
            KVERS=$1
            shift
            ;;
        -f)
            shift
            MODULES=($(cat $1))
            shift
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "wrong option" 
            help
            exit 1
            ;;
    esac
done

if [ -z ${KVERS+x} ]; then
    KVERS=$(uname -r)
fi

if [ -z ${MODULES+x} ]; then
    MODULES=($@)
fi

echo "Sign kernel modules »${MODULES[*]}« for kernel-version ${KVERS}"
for i in ${MODULES[*]}; do 
    echo sign $i
    echo sudo /usr/src/kernels/${KVERS}/scripts/sign-file sha256 ./$MOK.priv ./$MOK.der $(modinfo -n ${i})
    sudo /usr/src/kernels/${KVERS}/scripts/sign-file sha256 ./$MOK.priv ./$MOK.der $(modinfo -n ${i})
done
