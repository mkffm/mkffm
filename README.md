# mkffm
A script for building a small but usefull static ffmpeg binary from sources,
with "most wanted" software support included.
Builds without problems in ubuntu 14.04 and UP and Debian 8.x
You must have no "-dev" packages installed in your system, to ensure portability of the resulting binary.
All libraries and programs used for extending ffmpeg capabilities are taken from stable releases.
Features:
Enabled programs:                 ffmpeg ffprobe (ffplay if sdl1.2 exists)
External libraries:               libx264 libfdk_aac libfreetype libfontconfig libass
Resulting ffmpeg binary License:  nonfree and unredistributable
All contributions are welcome
