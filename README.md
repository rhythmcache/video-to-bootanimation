# mp4-to-bootanimation
A magisk/kernel su script that can set mp4 video as the device's bootanimation

# How To Use ?
rename your mp4 video to `bootvideo.mp4` and put it in your internal storage or `/storage/emulated/0/`. 
you can set the resolution and fps of your bootanimation by editing the module cfg file.
like typing `720 1280 25` will set your bootanimation resolution to 720*1280 and bootanimation fps to 25.
if you delete the `cfg` file or leave it empty , the module will detect your screen resolution automaticaly and will configure itself a/c to that. default fps will be 26.

# Bugs
- might not work on MIUI/HyperOS
- script doesnt end on hyper os ? kernel su will show the status "flashing" even tho flashing of this module is finished. as soon as you see `done` in the output. make sure to press the back button.
- Module doesnt show in ksu/magisk module list until you reboot the device.
