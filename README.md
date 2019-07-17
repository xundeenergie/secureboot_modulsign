# Sign linux-kernel-modules with own key for secureboot 

* Create key-pair
    
    ```
        ./sign-modules.sh -c
    ```
    you get asked for a Password for the new key. Remember it, you'll need it a reboot once to confirm the new installed key.

* Sign your proprietary modules
    
    ```
        Usage sign modules: 
            ./sign-modules.sh <modulename> [<modulename>] [<modulename>]...
            ./sign-modules.sh -k <kernelversion> <modulename> [<modulename>] [<modulename>]...
            ./sign-modules.sh -k <kernelversion> -f <modulesfile>
            ./sign-modules.sh -f <modulesfile>

        -k <kernelversion>      output of »uname -r«
                                if not given, it takes current kernelversion

        -f <modulesfile>        plaintext file with newlineseparated list of modules to sign    
    ```

* Reboot


If you have a Dualboot with Windows and Bitlocker, you have to type in you Recreation-Key for Bitlocker on first boot in Windows, because you added a key to UEFI

Every time you install a new kernel, you have to boot to the new kernel and run 

    ```
        ./sign-modules.sh -k <kernelversion> -f <modulesfile>
    ```

* Reboot

again.

