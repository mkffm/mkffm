# mkffm-small
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
# mkffm-tiny
This script will download and compile the smallest (but tested and working)
static build of ffmpeg you could ever ask. All external libs and supporting
programs are pulled in from git, so expect the script to brake some times.
This script is tested and working fine on Debian 8 and Ubuntu 14.04 and up.
The resulting binary is only good for one purpose: To grab my favorite shows
from my DVB-T USB STICK to MP4 file for watching later, using CRON, a custom
ffmpeg grabbing script and this tiny ffmpeg binary on my raspberry-pi.
Features:
Enabled programs:		ffmpeg ffprobe
External libraries:	libfdk_aac libx264
Enabled decoders:		aac ac3 dvbsub h264 libfdk_aac mp2 mp3 mpeg2video mpegvideo
Enabled encoders:		libfdk_aac libx264
Enabled hwaccels:		none
Enabled parsers:		aac ac3 dvbsub h264 mpeg4video mpegaudio mpegvideo
Enabled demuxers:		mpegts
Enabled muxers:		mov mp4
Enabled protocols:	file http tcp udp
Enabled filters:		aformat anull aresample atrim format null overlay scale setpts trim
Enabled bsfs:			none
Enabled indevs:		none
Enabled outdevs:		none
License:				nonfree and unredistributable
