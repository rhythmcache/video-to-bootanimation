# mp4-to-bootanimation
A Magisk/KernelSU script that sets an MP4 video as the android device's boot animation.

# How to Use
Rename your MP4 video to `bootvideo.mp4` and place it in your internal storage (`/storage/emulated/0/`).  
You can create a file named `cfg` in internal storage and can configure the resolution and FPS of your boot animation by editing that file.
For example, entering `720 1280 25` in cfg file will set the boot animation resolution to 720x1280 and the FPS to 25.  
If you delete the `cfg` file or leave it empty, the module will automatically detect your screen resolution and configure itself accordingly while running. The default FPS is fixed and will be 26 , but as i said you can configure it by creating a cfg file.

# Bugs
- Might not work on MIUI/HyperOS.
- Might not work on devices of non-arm64 architecture , to fix you have to put `ffmpeg` and `zip` binary of respective architecture to the module"s bin folder. (you have to find the binary by yourself)
- Script doesn’t terminate : KernelSU may show the status as "flashing" even though the flashing process is complete. As soon as you see `done` in the output, press the back button.
- The module doesn’t appear in the KernelSU/Magisk module list until you reboot the device.
- I set a restriction in script about FPS that you cant increase it more than 45 , but it seems not be working,i tested and found out even 60FPS is working so i dont know if this is a bug or feature LOL


#Questions?
[ask here](https://t.me/scr1ptcraftchat)


#Download

[Download Latest Release](https://github.com/rhythmcache/video-to-bootanimation/releases/download/v2/video-to-bootanimation-main.zip)
