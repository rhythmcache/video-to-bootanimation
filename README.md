# mp4-to-bootanimation
A Magisk/KernelSU script that sets an MP4 video as the android device's boot animation.

# How to Use
Rename your MP4 video to `bootvideo.mp4` and place it in your internal storage (`/storage/emulated/0/`).  
You can set the resolution and FPS of your boot animation by editing the module's `cfg` file.  
For example, entering `720 1280 25` will set the boot animation resolution to 720x1280 and the FPS to 25.  
If you delete the `cfg` file or leave it empty, the module will automatically detect your screen resolution and configure itself accordingly while running. The default FPS is fixed and will be 26. highest FPS you can configure is 45. entering value higher than 45 will be void and null.

# Bugs
- Might not work on MIUI/HyperOS.
- Might not work on devices of non-arm64 architecture , to fix you have to put `ffmpeg` and `zip` binary of respective architecture to the module"s bin folder. (you have to find the binary by yourself)
- Script doesn’t terminate : KernelSU may show the status as "flashing" even though the flashing process is complete. As soon as you see `done` in the output, press the back button.
- The module doesn’t appear in the KernelSU/Magisk module list until you reboot the device.


#Questions?
[ask here](https://t.me/scr1ptcraftchat)


#Download

[Download Latest Release](https://github.com/rhythmcache/video-to-bootanimation/releases/download/v2/mpfour2bootEd.zip)
