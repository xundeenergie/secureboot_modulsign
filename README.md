# Sign linux-kernel-modules with own key for secureboot 

* Create key-pair
    
    create_module_key.sh -c

* Sign your proprietary modules
    
    create_module_key.sh -s <modulename>[ <modulename>][ <modulename>]...
* Reboot

If you have a Dualboot with Windows and Bitlocker, you have to type in you Recreation-Key for Bitlocker on first boot in Windows, because you added a key to UEFI

Every time you install a new kernel, you have to boot to the new kernel and run 

    create_module_key.sh -s <modulename>[ <modulename>][ <modulename>]...

again.

This script creates a key. You need it for signing every module for every new kernel you install on your machine!!! Keep it save!
