#video2bootanimation by @e1phn

ui_print "-------------------------------------------------- "
ui_print " Video to Bootanimation                            "
ui_print "-------------------------------------------------- "
ui_print " by tg @e1phn      |   Version: 1                  "
ui_print "-------------------------------------------------- " 
ui_print "-------------------------------------------------- " 
ui_print " "

# Path to zip, ffmpeg, and additional files in the module's bin directory
zipbin="$MODPATH/bin/zip"
ffmpeg="$MODPATH/bin/ffmpeg"
cfg_file="/sdcard/cfg"
webroot_source="$MODPATH/webroot"

# Ensure zip and ffmpeg have executable permissions
chmod +x "$zipbin"
chmod +x "$ffmpeg"

# Check if zip and ffmpeg are working
if ! $zipbin --help >/dev/null; then abort "CANNOT LOAD zip, please check the binary"; fi
if ! $ffmpeg -version >/dev/null; then abort "CANNOT LOAD ffmpeg, please check the binary"; fi

# Define the specific video file to look for
video="/sdcard/bootvideo.mp4"

# Check if the video file exists
if [ ! -f "$video" ]; then
  abort "CANNOT find bootvideo.mp4 in /sdcard"
fi

ui_print " -- Found video: $video"
ui_print " "


# Default resolution and frame rate
default_frame_rate=26
default_resolution=""

# Check for the cfg file
if [ -f "$cfg_file" ] && [ -r "$cfg_file" ]; then
  # Read the cfg file
  read -r cfg_content < "$cfg_file"
  
  # Check if the cfg file has the expected format
  if [[ "$cfg_content" =~ ^[0-9]+[[:space:]][0-9]+[[:space:]][0-9]+$ ]]; then
    # Extract resolution and fps from cfg file
    res=$(echo "$cfg_content" | tr -s ' ' '\n')
    width=$(echo "$res" | head -n 1)
    height=$(echo "$res" | head -n 2 | tail -n 1)
    frame_rate=$(echo "$res" | tail -n 1)
    
    ui_print " -- Custom resolution and fps from cfg: ${width}x${height} ${frame_rate}fps"
  else
    ui_print " -- Invalid cfg file format or content. Using default device resolution and fps."
    frame_rate=$default_frame_rate
  fi
else
  ui_print " -- No cfg file found or unreadable. Using default device resolution and fps."
  frame_rate=$default_frame_rate
fi

# Set resolution for desc.txt
if [ -z "$width" ] || [ -z "$height" ]; then
  # Fallback to device resolution if custom resolution is not set
  ui_print " -- Determining default device resolution..."
  if cmd window size >/dev/null; then
    screen=$(cmd window size | cut -d: -f2 | tr -d " ")
    if [ -z "$screen" ]; then
      abort "CANNOT get screen size"
    else
      res=${screen//x/ }
      width=$(echo "$res" | cut -d' ' -f1)
      height=$(echo "$res" | cut -d' ' -f2)
      ui_print "    RESOLUTION=$width x $height"
      ui_print " "
    fi
  else
    abort "CANNOT GET SCREEN SIZE"
  fi
fi

# Prepare directories in /data/local/tmp
ui_print " -- Preparing to extract resources in /data/local/tmp"
TMP_DIR="/data/local/tmp/bootanim"
rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR/bootanimation" "$TMP_DIR/result"
result="$TMP_DIR/result/bootanimation.zip"

# Set permissions for the temporary directories
set_perm_recursive $TMP_DIR 0 0 0755 0755

# Analyzing & making Bootanimation
ui_print " -- Generating animation from $video..."

# Debug: Check if video file is readable
if [ ! -r "$video" ]; then
    abort "VIDEO FILE IS NOT READABLE: $video"
fi

# Generate frames using ffmpeg
ffmpeg_command="$ffmpeg -i \"$video\" -vf \"scale=${width}:${height}\" -f image2 \"$TMP_DIR/bootanimation/00%05d.jpg\""

# Debug: Print the ffmpeg command before execution
ui_print " -- Executing ffmpeg command: $ffmpeg_command"
eval $ffmpeg_command

# Check for ffmpeg execution error
if [ $? -ne 0 ]; then
    abort "FFMPEG COMMAND FAILED: $ffmpeg_command"
fi

# Count frames
count=$(ls -1 "$TMP_DIR/bootanimation" | wc -l)

if [ "$count" -eq 0 ]; then
    abort "CANNOT generate any frames from the video"
fi

ui_print "    Processed $count frames from $(basename "$video")"
ui_print " "

# Create desc.txt for bootanimation
cd "$TMP_DIR/result" || abort "CANNOT change to result directory"
if [ -n "$width" ] && [ -n "$height" ]; then 
   # Create the desc.txt file with resolution and frame rate
   echo "$width $height $frame_rate" > "$TMP_DIR/result/desc.txt" # Save to result directory
else
   abort "CANNOT get resolution and fps"
fi

# Distribute frames into parts if frame count exceeds 400
max_frames_per_part=400
part_index=0
frame_count=0

mkdir -p "$TMP_DIR/result/part$part_index"

for frame in "$TMP_DIR/bootanimation"/*.jpg; do
  mv "$frame" "$TMP_DIR/result/part$part_index/"
  frame_count=$((frame_count + 1))
  
  # Create a new part directory after every 400 frames
  if [ "$frame_count" -ge "$max_frames_per_part" ]; then
    frame_count=0
    part_index=$((part_index + 1))
    mkdir -p "$TMP_DIR/result/part$part_index"
  fi
done

# Add lines to desc.txt for each part
for i in $(seq 0 "$part_index"); do
  echo "p 1 0 part$i" >> "$TMP_DIR/result/desc.txt"
done

# Create the bootanimation.zip
ui_print " -- Packing bootanimation.zip with zip..."
cd "$TMP_DIR/result" || abort "CANNOT change to result directory"

# Create the bootanimation.zip with the directory structure
cd $TMP_DIR/result/
su -c $zipbin -r -0 /data/local/bootanimation.zip ./*

# Copy Index.html
mkdir $MODPATH/webroot
cp $MODPATH/index.html $MODPATH/webroot

# Check if original bootanimation.zip exists and place the new one systemlessly
ui_print " -- Checking where original bootanimation.zip is located..."

if [ -f "/system/product/media/bootanimation.zip" ]; then
   ui_print " -- Original bootanimation.zip found in /product/media"
   dest_dir="$MODPATH/system/product/media/"
elif [ -f "/system/media/bootanimation.zip" ]; then
   ui_print " -- Original bootanimation.zip found in /system/media"
   dest_dir="$MODPATH/system/media/"
else
   abort "CANNOT find original bootanimation.zip in /system/product/media or /system/media"
fi

# Create destination directory and move bootanimation.zip
mkdir -p "$dest_dir"
mv /data/local/bootanimation.zip "$dest_dir/bootanimation.zip"

# Set permissions for the destination directory
set_perm_recursive "$dest_dir" 0 0 0755 0644

ui_print " -- Bootanimation replaced systemlessly"
ui_print " -- Done"
ui_print " "

# Exiting
rm -rf $MODPATH/bin
rm -rf /data/local/tmp/bootanim
rm $MODPATH/index.html
rm $MODPATH/customize.sh

# Set permissions for the module
set_perm_recursive $MODPATH/system 0 0 0755 0644

unity_custom() {
: # Leave this empty unless adding custom installation/uninstallation logic
}
