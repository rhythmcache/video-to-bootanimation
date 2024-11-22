## video-to-bootanimation
A Magisk/KernelSU script that sets an MP4 video as the android device's boot animation.

## How to Use
Rename your MP4 video to `bootvideo.mp4` and place it in your internal storage (`/storage/emulated/0/`).  
You can create a file named `cfg` in internal storage and can configure the resolution and FPS of your boot animation by editing that file.
For example, entering `720 1280 25` in cfg file will set the boot animation resolution to 720x1280 and the FPS to 25.  
If you delete the `cfg` file or leave it empty, the module will automatically detect your screen resolution and configure itself accordingly while running. The default FPS is fixed and will be 26 , but as i said you can configure it by creating a cfg file.

## Bugs
- Might not work on MIUI/HyperOS.
- Might not work on devices of non-arm64 architecture , to fix you have to put `ffmpeg` and `zip` binary of respective architecture to the module"s bin folder. (you have to find the binary by yourself)
- Script doesn’t terminate : KernelSU may show the status as "flashing" even though the flashing process is complete. As soon as you see `done` in the output, press the back button.


## Use On Linux Terminal or Termux
- copy and paste this on termux or Linux terminal
- creates a flashable magisk module
- no need to create cfg or rename video , script will prompt to enter path 
- Flash created zip in magisk or kernel su or aPatch
```
curl -sSL https://github.com/rhythmcache/video-to-bootanimation/releases/download/v2/cbootanim.sh -o cbootanim.sh
chmod +x cbootanim.sh
./cbootanim.sh
```





#Questions?
[ask here](https://t.me/ximistuffschat)


#Download

[Download Latest Release](https://github.com/rhythmcache/video-to-bootanimation/releases/download/v2/video-to-bootanimation-main.zip)
