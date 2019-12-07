#!/bin/bash 
#This bash script is the first thing I run after installing Linux Mint (https://linuxmint.com/) to automatically set up my machine and install everything I use. I've included some links and notes as well. In Nemo, navigate to the directory containing this script, right-click, select "open in terminal", and type "sudo bash install_apps.sh" 
#ppa's have been used either when the app is not in the repository, or when I really want the latest version of something
#Ken Sherman 20 Sept 2019
#Permission is granted to copy, distribute and/or modify this document under the terms of the GNU Free Documentation License, Version 1.2 or any later version published by the Free Software Foundation, and/or (take your pick)
#This file is licensed under the Creative Commons Attribution-Share Alike 3.0 Unported, 2.5 Generic, 2.0 Generic and 1.0 Generic license: https://en.wikipedia.org/wiki/en:Creative_Commons

#Linux Mint 19.2 "Tina" is based on Ubuntu 18.04 Bionic Beaver and runs Cinnamon 4.2 desktop and Linux kernel 4.15
#Linux Mint 19.1 "Tessa" is based on Ubuntu 18.04 Bionic Beaver and runs Cinnamon 4.0 desktop
#Linux Mint 18.3 "Sylvia" is based on Ubuntu 16.04.3 Xenial Xerus

#Wherever you see "sudo dpkg ...." you will need to download the .deb pkg first, if you want that application. If not just comment out the line.
#https://www.shellscript.sh/variables1.html
#https://shortcutworld.com/Linux-Mint/linux/Linux-Mint_Shortcuts
#https://askubuntu.com/questions/4983/what-are-ppas-and-how-do-i-use-them/40351#40351
#https://itsfoss.com/apt-get-linux-guide/
#to view the path type $PATH. the PATH variable is set in /etc/environment, add variables here to permanently and globally change the path. Then save, logout, login. for a single session, add a folder to $PATH by using by typing for example: export PATH=~/anaconda3/bin:$PATH

#for SSD "sudo gedit /etc/fstab", add the word noatime to the line for your root partition and your other Linux partitions, just before errors=remount-ro. Note: don't add it to the line for the swap partition! Example:
#UUID=f861106a-5f65-443a-ba39-xxxxxxxx /       ext4    noatime,errors=remount-ro 0       1
#test with "mount -a", then "sudo tune2fs -l /dev/nvme0n1p2" to check default mount options.

sudo apt update
sudo apt full-upgrade -y
#dpkg to run in noninteractive
export DEBIAN_FRONTEND=noninteractive

#sudo python3 -OEs aptsources-cleanup.zip #to fix W: Target Packages … is configured multiple times”?

#install codecs for DVD playback. Actually, vlc has everything built-in now, but I think some other packages use this
sudo apt install -y libdvd-pkg 
sudo dpkg-reconfigure libdvd-pkg
#HandBrake open-source, GPL-licensed, video transcoder (always reencodes, so not good for DVD's)
#sudo add-apt-repository -y ppa:stebbins/handbrake-releases
#sudo apt update
#sudo apt install -y handbrake-gtk
#sudo apt install -y handbrake-cli

#kill process locking apt
#ps aux | grep apt
#sudo kill -9 pid
#https://community.linuxmint.com/tutorial/view/1609  Create & Use a Separate DATA Partition
#change mint to install recommended packages automatically (by deleting these files)
#sudo rm -v /etc/apt/apt.conf.d/00recommends /etc/apt/apt.conf.d/99synaptic

#networking
sudo apt-get -y install samba --install-recommends
sudo apt-get -f install
sudo smbpasswd -a ken            #add samba password for my account. networking wont work without it.
#sudo smbstatus
#smb://192.168.1.128/, smb://machine_name in nemo to connect

#https://forums.linuxmint.com/viewtopic.php?t=226519 cups-common unix printing system
sudo apt-get install cups -y
#canon printer driver
chmod +x linux-UFRII-drv-v360-usen/install.sh
sudo bash linux-UFRII-drv-v360-usen/install.sh
sudo apt-get install -f -y
#http://localhost:631 to configure printer via cups
#sudo apt-get install cups-pdf -y  #produces inferior bitmap pdf's, so don't install this
#sudo apt-get install redshift redshift-gtk -y #already included in mint 19

#cmake this installs v 3.5.1, 3.12.3 is latest, see https://cmake.org/download/
sudo apt-get install cmake -y
sudo apt-get install cmake-qt-gui -y
#chmod +x cmake-3.12.3-Linux-x86_64.sh
#sudo sh cmake-3.12.3-Linux-x86_64.sh --prefix=/usr/bin --skip-license
#clone a repot: git clone https://github.com/ggodreau/sxsw2019.git
sudo apt install -y git
#QT grab latest (this is a .run file, haven't tried it): https://download.qt.io/archive/qt/5.13/5.13.0/
sudo apt-get install build-essential software-properties-common -y
sudo apt-get install qtcreator -y
sudo apt-get install qtdeclarative5-dev -y
sudo apt install qt5-default -y
sudo apt install -y qt5-doc
sudo apt install -y qt5-doc-html qtbase5-doc-html
sudo apt install -y qtbase5-examples
sudo apt-get update
sudo apt-get install gcc g++ gcc-multilib -y
sudo apt-get update
#to verify
#gcc 
#How to Install the GCC C++ Compiler on Linux Mint
# https://prognotes.net/2016/04/install-gcc-cpp-compiler-linux-mint/
#AVR arduino
sudo apt install -y avrdude avrdude-doc binutils-avr gcc-avr avr-libc uisp flex byacc bison gdb-avr
#ls -l /dev/ttyACM* to determine usb port names, then add the group (e.g. "dialout") to your user account. also lsusb
sudo usermod -a -G dialout ken
#To see  which  tty's  are  currently in use, you can simply look into the file /proc/tty/drivers
#FTDI usb device is likely to be /dev/ttyUSB0 see https://www.silabs.com/community/interface/knowledge-base.entry.html/2016/06/06/fixed_tty_deviceass-XzTf
#to compile and link a c program led.c for an arduino uno, or a bare 328p chip, use the following script:
#avr-gcc -g -Os -mmcu=atmega328p -c led.c
#avr-gcc -g -mmcu=atmega328p -o led.elf led.o
#avr-objcopy -j .text -j .data -O ihex led.elf led.hex
#avr-size --format=avr --mcu=atmega328p led.elf

#avrdude -v -c avrisp -p m328p -P /dev/ttyACM0 -b 19200 -D -U flash:w:led.hex:i
#to use the arduino as an ISP, upload the ArduinoISP sketch to the Arduino using arduino IDE with board:genuine uno, Programmer: AVRISP mk II. use -c avrisp in the avrdude command above at 19200. (use -c arduino to upload to an arduino normally at 115200).
#note: atmega328p chip purchased from mouser did not function at all until 16mhz xtal connected to pins 9 and 10 (20 pf caps to ground on both pins). once chip is working it is possible to reprogram the fuses to internal oscillator at 8 mhz.
#avrdude -v -patmega328p -cavrisp -P /dev/ttyACM0 -b 19200 -e -Ulock:w:0x3F:m -Uefuse:w:0xFD:m -Uhfuse:w:0xDE:m -Ulfuse:w:0xFF:m 
#install arduino IDE, extract arduino-1.8.9-linux64.tar.xz to home directory, then ./install.sh

#codeblocks http://www.codeblocks.org/
#sudo apt-get install -y build-essential codeblocks codeblocks-contrib
#can also try
#sudo add-apt-repository ppa:damien-moore/codeblocks-stable
#sudo apt-get update
#sudo apt-get install -y build-essential codeblocks codeblocks-contrib
#mkdir codeblocks
#tar -xf codeblocks_17.12-1_amd64_stable.tar.xz -C codeblocks
#download the deb file here: http://www.codeblocks.org/downloads/26
#codeblocks
sudo dpkg -i codeblocks/*17.12*.deb
sudo apt-get install -f -y
#visual studio code
sudo dpkg -i code_1.28.2-1539735992_amd64.deb
#ctrl-p ext install ms-python.python From File > Preferences > Settings set telemetry.enableTelemetry=F
# ext install ms-vscode.cpptools
# https://thisdavej.com/build-an-amazing-html-editor-using-visual-studio-code/
# https://code.visualstudio.com/docs?start=true
#valgrind - debugging and profiling. http://cs.ecs.baylor.edu/~donahoo/tools/valgrind/
sudo apt install valgrind -y
#gnu octave: mint 19.2 has 4.2.2-1, 5.1.0 is latest
sudo apt-add-repository -y ppa:octave/stable
sudo apt-get update
sudo apt-get install octave -y
sudo apt-get install octave-doc -y
sudo apt-get install octave-info -y
sudo apt-get install octave-htmldoc -y
#octave development header files and mkoctfile (required to install Octave Forge packages); and 
sudo apt-get install liboctave-dev -y
#octave-dbg
#sudo apt-get install -y octave-control octave-image octave-io octave-optim octave-signal octave-statistics
#alternately
#sudo apt-get install flatpak
#flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
#flatpak install flathub org.octave.Octave
#flatpak uninstall org.octave.Octave
#snap
#sudo apt update
#sudo apt install snapd
#maxima mint 19.2 has v 18.02, 19.09 is latest
sudo add-apt-repository -y ppa:blahota/wxmaxima
sudo apt-get update
sudo apt-get install wxmaxima -y
#copy cform.lisp to /home/ken/.maxima (script to output c code)
cp cform.lisp $HOME/.maxima

#scilab, includes xcos
#sudo apt install -y scilab-full-bin #I think this simply downloads the pkg. it doesn't seem to install anything
sudo apt install -y scilab
#RPN calculator
sudo apt install -y grpn
#fsearch 
sudo add-apt-repository -y ppa:christian-boxdoerfer/fsearch-daily
sudo apt-get update
sudo apt-get install fsearch-trunk -y
#https://github.com/cboxdoerfer/fsearch/wiki/Build-instructions
#disable wake on mouse movement: http://www.das-werkstatt.com/forum/werkstatt/viewtopic.php?f=7&t=1985

#Anaconda virtual environment conveniently installs Python, the Jupyter Notebook, spyder and other commonly used packages for scientific computing and data science.
sudo bash Anaconda3-2019.07-Linux-x86_64.sh -b
#conda info, may need to add path to anaconda: export PATH=~/anaconda3/bin:$PATH
#To remove the entire Anaconda installation directory just delete it: rm -rf ~/anaconda3, rm -rf ~/.conda
#create a virtual environment: conda create -n myenv python=3.6, activate: source activate myenv, source deactivate myenv, jupyter notebook, pip install --ignore-installed --upgrade , pip install keras
#https://www.tensorflow.org/install/pip
#To check it using Jupyter Notebook (IPython Notebook: In [1]: import tensorflow as tf, In [2]: tf.__version__

#https://medium.com/@mengjiunchiou/how-to-set-keras-with-tensorflow-with-conda-virtual-environment-on-ubuntu-5d56d22e3dc7
#https://docs.python.org/3.7/tutorial/
#alternately you can install python and jupyter directly
#python package installer see https://pip.pypa.io/en/stable/
#sudo apt install -y python3-dev python3-pip
#sudo pip3 install -U virtualenv
#sudo pip3 install -y jupyter
#python3 --version
#pip3 --version
#virtualenv --version
#https://www.tensorflow.org/install/  https://www.tensorflow.org/tutorials
#pip3 install tensorflow #cpu only
#pip3 install tensorflow-gpu  # nvidea gpu enabled


#https://forums.linuxmint.com/viewtopic.php?t=178572  Linux Mint + KXStudio Audio Production setup
#Prepare Linux for professional audio production (lowlatency kernel probably unnecessary)
#sudo apt install linux-lowlatency -y
sudo adduser ken audio 
#logout and login again to make  above effective
sudo apt-get update
sudo apt-get install qjackctl -y
sudo apt-get install gedit  -y
#Change rtprio to "95" and memlock to "unlimited" #(after qjackctl installed) - done automatically with latest
#sudo gedit /etc/security/limits.d/audio.conf #(after qjackctl installed)
#Add KXStudio repository from KXStudio.linuxaudio.org : KXStudio-repos.deb see http://kxstudio.linuxaudio.org/Repositories
#https://www.linuxjournal.com/content/jack-sync-primer-linux-users
# Install required dependencies if needed (wasn't necessary on mint 18.3)
sudo apt-get install libglibmm-2.4-1v5 -y
# Download package file
#wget https://launchpad.net/~kxstudio-debian/+archive/kxstudio/+files/kxstudio-repos_9.5.1~kxstudio3_all.deb
#wget https://launchpad.net/~kxstudio-debian/+archive/kxstudio/+files/kxstudio-repos-gcc5_9.5.1~kxstudio3_all.deb
# Install it
sudo dpkg -i kxstudio-repos_9.5.1~kxstudio3_all.deb
sudo apt-get install -f -y
# Install required dependencies if needed
sudo apt-get install -y apt-transport-https software-properties-common wget
#enable GCC5 packages
sudo dpkg -i kxstudio-repos-gcc5_9.5.1~kxstudio3_all.deb
sudo apt-get update
sudo apt install pulseaudio-module-jack -y
sudo apt-get install -y rakarrack #guitar effects processor
sudo apt-get install guitarix -y #guitar preamp
#to install RME hammerfall GUI tools, install alsa-tools
#hdspmixer is the Linux equivalent of the Totalmix application from RME. It is a tool to control the advanced routing features of the RME Hammerfall DSP soundcard series. http://www.linuxfromscratch.org/blfs/view/6.1/multimedia/alsa-tools.html  
#measure latency: connect the left output on the Scarlett to input 1 on the Scarlett using a quarter-inch cable. In a terminal, run jack_iodelay Connect capture_1 to jack_iodelay’s input, and connect jack_iodelay’s output to playback_1 http://mikelococo.com/2017/09/usb-audio-latency/
#aplay -l to list all available Alsa devices. 
#sudo apt install -y alsa-tools
#sudo apt install -y alsa-tools-gui
#aplay -1 #alsamixer
#sudo apt-get install ardour #this is an old version. latest is 5.12 from http://ardour.org/  
#jackd --version (1.19.12)
#https://ask.audio/articles/connecting-bitwig-studio-to-other-audio-applications
# VST plugins compiled for native Linux: http://linux-sound.org/linux-vst-plugins.html
# No WINE required, just a compliant host such as Ardour, Bitwig, Renoise
#https://www.learndigitalaudio.com/how-linux-audio-works-vs-windows-audio-2017
#MuseScore (v3 latest) notation software (use ppa for latest version). v 2.0.2 in mint 18 repository
#sudo add-apt-repository -y ppa:mscore-ubuntu/mscore-stable
#sudo apt-get update
sudo apt-get install musescore -y
sudo dpkg -i bitwig-studio-2.4.3.deb
sudo apt-get install -f -y
sudo apt-get install playitslowly -y
#sudo apt install aeolus
#sudo apt install hexter
sudo apt install -y hydrogen
sudo apt install -y yoshimi
sudo apt install -y zynaddsubfx
sudo apt install -y qsynth #play soundfonts
sudo apt install -y carla  #plugin host
sudo apt install -y drumgizmo
sudo apt install -y dgedit #drum kit editor for drumgizmo
#IF any of the plugins crash and makes bitwig hang, open up a terminal and do a "ps -A |grep bitwig" find the pid's and kill it. Bitwig usually has some crash saves that will save you.
#https://answers.bitwig.com/questions/14096/how-to-use-windows-vst-plug-ins-in-bitwig22-linux
#https://theproducersplug.com/product/edirol-orchestral-vst-free-download/

#hardware info command
apt install hwinfo -y
apt install pydf -y
apt install smartmontools -y
#smartctl -d ata -a -i /dev/sde1  #report HD smart info
sudo apt install gsmartcontro -y
sudo apt install hardinfo -y
#i-nex (cpuz clone
#sudo add-apt-repository -y ppa:gambas-team/gambas3
#sudo add-apt-repository -y ppa:i-nex-development-team/stable
#sudo apt-get update
#sudo apt-get install i-nex
#sudo apt remove i-nex && sudo apt autoremove
#Notepadqq
sudo add-apt-repository -y ppa:notepadqq-team/notepadqq
sudo apt-get update
sudo apt-get install notepadqq -y
#spotify
#clementine music player/organizer https://www.clementine-player.org/downloads
#sudo dpkg -i clementine*.deb
#Clementine Is the most complete audio player you can get on linux. It is a port of Amarok 1.4 to the Qt 4 framework and the GStreamer multimedia framework 
#sudo add-apt-repository -y ppa:me-davidsansome/clementine
#sudo apt-get update
sudo apt-get install clementine -y
sudo apt-get install projectm-pulsaudio -y
#sudo apt-get install -f -y
#sudo apt-get autoremove
#kodi - open-source home theater software. I haven't tried it. vlc plays movies well.
#sudo apt-get install software-properties-common
#sudo add-apt-repository -y ppa:team-xbmc/ppa
#sudo apt-get update
#sudo apt-get install kodi
#https://kodi.wiki/view/HOW-TO:Install_Kodi_for_Linux

#firewire & DV
apt-get install coriander -y
apt-get install dvgrab -y
sudo apt install kino -y
#rename -n -v 's/^(.{3})//' * delete 1st 3 char from filename
#umount -v /dev/sde1
#uses about 1 GB RAM:
#sudo badblocks -b 4096 -c 131072 -s -n /dev/sde
#much faster, but obliterates disc contents: 120GB/20 min, should be able to do 8TB in 2.5 days?
#makes numerous passes with different test patterns
#sudo badblocks -b 4096 -c 131072 -s -w /dev/sde
#-t random uses random test pattern
#overwrite drive /dev/sde: dd if=/dev/zero of=/dev/sde count=5 bs=10M
#cgdisk /dev/sde to create a new partition table. If that fails, sudo parted /dev/sde, then
#mklabel msdos, mkpart primary ext4 1 10000, quit #sudo mkfs.ext4 /dev/sde
#https://superuser.com/questions/1219746/trying-to-get-a-functioning-dev-sda-again-after-nuking-it-with-dd/1219757
#sudo e2label /dev/sde1 pname #name the partition
#see also gddrescue to clone a hard drive

#sudo killall gpartedbin
#sudo killall gparted
#Attempt to fix an NTFS partition. Install ntfs-3g with sudo apt-get install ntfs-3g, e.g. ntfsfix /dev/hda6
# dvgrab -rewind -fraw -t -s 0 -autosplit=10 dv-
# dvgrab -rewind -fraw -t -s 0 -autosplit=10 -guid 0x08004601016145a8 dv-
# dvgrab -rewind -fraw -timesys -s 0 -autosplit=10 -guid 0x080046010326fd82 dv-
#dvgrab -input * -fraw -autosplit=10 -s 0 -t -t dv- #splits the file, but there is no timecode in a dv file, only in a tape
#cinerella
#sudo add-apt-repository -y ppa:cinelerra-ppa/ppa
#sudo apt-get update
#sudo apt-get install cinelerra-cv -y
# https://www.catswhocode.com/blog/19-ffmpeg-commands-for-all-needs
#xvid is the codec used by the NIX photo frame
#ffmpeg -i input file -vf yadif -vcodec libxvid -qscale:v 6 output.mp4
#Avidemux, ffmpeg deinterlace 
#ffmpeg -i input_file.dv -vf yadif output.mp4
#concat multiple .vob files into one:
#ffmpeg -i 'concat:VTS_01_1.VOB|VTS_01_2.VOB|VTS_01_3.VOB|VTS_01_4.VOB' -acodec copy -vcodec copy combined.mpg

#sudo add-apt-repository -y ppa:jonathonf/ffmpeg-3
#sudo apt-get update
sudo apt install ffmpeg -y
#KDEnlive - video editor
sudo add-apt-repository -y ppa:sunab/kdenlive-release
sudo apt-get update
sudo apt-get install kdenlive -y
#photo management
sudo apt install jhead -y
#jhead -ft *.jpg set Date Modified = Exif time
#rename all photos in folder to the date-time the image was taken; jhead -autorot -nf%Y-%m-%d-%H%M%S *.jpg
#linux case sensitive so *.JPG may also be necessary
#gimp v 2.8 installed in mint 19.2, get latest with ppa
sudo apt-remove --autoremove -y gimp
sudo add-apt-repository -y ppa:otto-kesselgulasch/gimp
sudo apt-get update
sudo apt-get install gimp -y
sudo apt-get install -y gimp-gmic #cool photo effects plugin
#hugin 2019 panorama stitcher (check version in mint 19.3 repository
sudo add-apt-repository ppa:ubuntuhandbook1/apps
sudo apt update
sudo apt install -y hugin
#to remove sudo apt-get remove --autoremove hugin hugin-tools

#"Scanner Access Now Easy" tools. Adds file | create | xscanimage in GIMP. enables network scanning for MF4800
sudo apt install -y sane
sudo apt install -y xsane #graphical front end for sane
#sudo apt install -y gscan2pdf #may be useful. 

#removing
#sudo apt-get install ppa-purge
#sudo ppa-purge ppa:otto-kesselgulasch/gimp
#sudo apt-get install gthumb -y  #too buggy unfortunately, uses GB memory and cpu, often fails to display thumbnails
sudo apt-add-repository -y ppa:lumas/photoqt #super fast, excellent photo management app
sudo apt update
sudo apt install -y photoqt

#RAW photo editing, see also https://www.darktable.org/
sudo apt-get install rawtherapee -y
#sudo add-apt-repository -y ppa:dhor/myway
#sudo apt-get update
#sudo apt-get install rawtherapee
#Remove RawTherapee from Ubuntu
#For uninstalling it from the system, run the below command:
#sudo apt-get remove rawtherapee
#sudo add-apt-repository --remove ppa:dhor/myway
#sudo apt-get install digikam
#nemo tools
sudo apt install -y nemo-terminal
sudo apt-get install nemo-image-converter -y
sudo apt-get install nemo-gtkhash -y #compute sha-256
sudo apt-get install nemo-seahorse -y #encryption
sudo apt-get install nemo-rabbitvcs -y #SVN and git version control access
sudo apt-get install nemo-media-columns -y #add columns of exif data

#K3B DVD burning sw
sudo apt-get install k3b -y
sudo apt install brasero -y
sudo apt-get install gparted -y
#freecad
sudo add-apt-repository -y ppa:freecad-maintainers/freecad-stable
sudo apt-get update
sudo apt-get install -y freecad
#ODA File Converter (for dwg conversion)
sudo dpkg -i ODAFileConverter_QT5_lnxX64_4.7dll.deb
#OpenSCAD The Programmers Solid 3D CAD Modeller http://www.openscad.org
sudo add-apt-repository -y ppa:openscad/releases 
sudo apt-get update
sudo apt-get install openscad -y
#inkscape - vector graphics, see also https://convertio.co/cdr-svg/
sudo add-apt-repository -y ppa:inkscape.dev/stable
sudo apt-get update
sudo apt-get install inkscape -y
sudo apt-get install python-uniconvertor -y #graphics file import-export filters
#No module named sk1libs.utils.fs needs to be fixed in uniconvertor
sudo apt-get install karbon -y
#krita photoshop like pixel drawing program
sudo add-apt-repository -y ppa:kritalime/ppa
sudo apt-get update
sudo apt-get install krita -y
#Luminance HDR is used for creating High Dynamic Range (HDR) images. http://www.anyhere.com/gward/hdrenc/hdr_encodings.html
#sudo add-apt-repository -y ppa:dhor/myway
#sudo apt-get update
#sudo apt-get install luminance-hdr -y

#turn trackpad on/off via keyboard: win "mou" select "mouse and trackpad"  Ctrl-Tab twice, Enter, Tab Enter
#Remove flash
sudo apt-get purge adobe-flashplugin -y

#Mint tweaks:
#https://sites.google.com/site/easylinuxtipsproject/mint-cinnamon-first
#cherrytree
sudo add-apt-repository -y ppa:giuspen/ppa
sudo apt-get update
sudo apt-get install cherrytree -y
#Mint already includes libre office, to install a later version from .deb file, remove old version first
#sudo apt-get -y remove --purge libreoffice-core && sudo apt-get -y autoremove
#reboot to get rid of all remnants of the old version. Download and unpack the .deb file
#http://download.documentfoundation.org/libreoffice/stable/6.0.0/deb/
#sudo dpkg -i LibreOffice*/DEBS/*.deb
sudo apt install libreoffice-help-en-ussudo -y
#chromium browser
sudo apt-get install chromium-browser -y
#chromium --disk-cache-dir=/dev/nul #to disable page caching
#project management https://sourceforge.net/projects/projectlibre/files/ProjectLibre/1.8/projectlibre_1.8.0-1.deb/download
sudo dpkg -i projectlibre*.deb
sudo apt-get install -f -y

sudo apt remove thunderbird -y
sudo apt remove rhythmbox -y
#evolution email
#sudo add-apt-repository -y ppa:fta/gnome3 #does not support xenial
#sudo apt-get update 
sudo apt-get install evolution -y
#sudo apt-get install readpst - not needed, evolution can import .pst
#readpst -j 2 -o evolution -q -r KenSherman.pst
#https://www.systutorials.com/240792/evolution-save-data-configure-files-linux/

#sudo add-apt-repository ppa:gnome3-team/gnome3-staging #only for latest ubuntu kernel (18)
#sudo apt-get update
#sudo apt-get install evolution
#Unison data synchronization http://www.pcurtis.com/ubuntu-files.htm#unison
sudo apt-get -y install unison-gtk ssh winbind sshfs 
#rsync is much faster: rsync -avu --delete . /media/veracrypt1  from current folder to /media/veracrypt1
# -a Do the sync preserving all filesystem attributes
#-v run verbosely
#-u skip files that are newer on the receiver
#--delete delete the files in target folder that do not exist in the source, /home/user/A: source folder, /home/user/B: target folder 
#screenshots
sudo apt-get install shutter -y
sudo apt-get install libgoo-canvas-perl -y
#Go to system settings, keyboard, shortcuts, add custom shortcut, then the + button to add the following:
#name:Snip area to clipboard
#command:shutter -s
#shortcut: Click one of the “unassigned” entries at the bottom and hit ctrl-shift-a (like MWSnap)
#add another:
#name:Shutter window to clipboard
#command:shutter -a
#shortcut: ctrl-shift-w (like MWSnap)
#add another:
#name:Shutter desktop to clipboard
#command:shutter -f
#shortcut: ctrl-shift-d (like MWSnap)

#wine --version see https://wiki.winehq.org/Ubuntu and https://linuxconfig.org/install-wine-on-ubuntu-18-04-bionic-beaver-linux for installation of the proper version. #remove current wine first if it is installed: 
#rm -Rf ~/.wine
#sudo apt purge -y wine*

#wine latest version:
#sudo dpkg --add-architecture i386
#wget -nc https://dl.winehq.org/wine-builds/winehq.key
#sudo apt-key add winehq.key
#Ubuntu 18.04 & Linux Mint 19.x 
#sudo apt-add-repository -y 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main' 
#rm -f winehq.key
#sudo apt update
#sudo apt-get install --install-recommends winehq-stable -y
#sudo apt install -y winehq-devel playonlinux
#sudo apt-get install mono-complete -y
#sudo apt install wine-stable winetricks -y
#winetricks corefonts #install corefonts

#to install from the repository just do this:
#mint 19.1 installs wine 3. From playonlinux you can install v 3.2 & other versions and manage wine bottles
sudo dpkg --add-architecture i386
sudo apt install -y wine64 
sudo apt install -y playonlinux
sudo apt install winetricks -y
winetricks corefonts #install corefonts
sudo apt install dosbox -y
#SPLAT! is an RF Signal Propagation, Loss, And Terrain analysis tool 20 MHz and 20 GHz. https://www.qsl.net/kd2bd/splat.html
sudo apt install -y splat

#antenna codes. see https://www.qsl.net/5b4az/
sudo apt install -y xnec2c #graphical version of nec2c
sudo apt install -y nec2c #c translation of nec2 fortran program
#multiphysical simulation software https://www.csc.fi/web/elmer, $ ElmerGUI to run the GUI
#sudo apt-add-repository -y ppa:elmer-csc-ubuntu/elmer-csc-ppa
#sudo apt update
#sudo apt install -y elmerfem-csc
#alternately you can install from the repository (this installs v 6.1.0 on Mint 18.3)
sudo apt install -y elmer

#https://appdb.winehq.org/
#wine stores application shortcuts here: /home/ken/.local/share/applications/wine/Programs
#launcher command field: wine /home/ken/.wine/drive_c/Program\ Files/FEMM64/femm_nomath.exe
#native dll's are sometimes needed to run windows programs, to use them instead of the wine versions, run winecfg, then in the tab “Libraries”, select “riched20” for example, in “New override for library” and click “Add”. 
#Then edit the “riched20” overrides to be “native”.
#to fix the following error:
#The following signatures couldn't be verified because the public key is not available: NO_PUBKEY 76F1A20FF987672F
#do this:
#sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 76F1A20FF987672F

#calibre
sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin
#google books downloader. convert *.png book.pdf to create a pdf. need to edit /etc/ImageMagick-6/policy.xml and change the PDF rights from none to read|write there
git clone https://github.com/tokland/pysheng
cd pysheng
sudo python setup.py install
#./pysheng-gui

#kicad  v5.1.2 is latest May 2019
sudo add-apt-repository --yes ppa:js-reynaud/kicad-5.1
sudo apt-get update
sudo apt-get install kicad -y
sudo apt -y install --install-recommends kicad kicad-demo kicad-doc-en

#sigrok open source signal analysis for logic analyzers, MSOs, oscilloscopes, multimeters, LCR meters, etc
#sudo apt install pulseview -y #(v .4.0, latest is 0.4.1). compile from source for latest version.
#sigrok-cli -d brymen-bm257 --show
#sigrok-meter dependencies;
#sudo apt-get install pyqt4-dev-tools
sudo bash pulseview.sh

#disable touchpad when mouse enabled
sudo add-apt-repository --yes ppa:atareao/atareao
sudo apt-get update
sudo apt-get install touchpad-indicator -y
#intel powertop
sudo apt-get install powertop -y
sudo apt-get install htop -y
#Master PDF Editor https://code-industry.net/masterpdfeditor/ 
sudo dpkg -i master-pdf-editor-5.1.68_qt5.amd64.deb

#https://github.com/iamadamdev/bypass-paywalls-firefox

#encryption https://www.veracrypt.fr/en/Home.html (requires interaction)
#wget https://launchpad.net/veracrypt/trunk/1.23/+download/veracrypt-1.23-setup.tar.bz2
#To prevent VeraCrypt from unmounting volumes on sleep\suspend edit the file /etc/default/veracrypt, change line VERACRYPT_SUSPEND_UNMOUNT="yes"
#To VERACRYPT_SUSPEND_UNMOUNT="no" Changes take effect immediately after saving the file. No need to reboot nor restart any services.
#sudo apt install cryfs 
#
./veracrypt-1.23-setup-gui-x64
#Encfs https://vgough.github.io/encfs/
#to use, enter the following command, p for paranoi mode, place files into the Private directory, encrypted copies will then be synced to the other dir which then Dropbox will sync (if this is your Dropbox dir). Do not delete or lose the .encfs.xml file (it’s hidden by default).EncFS won’t automatically mount itself after you restart your system, so just rerun the command. If you want your EncFS file system automatically mounted each time you log in, you can use gnome-encfs. gnome-encfs adds your EncFS password to your GNOME keyring and automatically mounts it each time you log in.
#https://www.techrepublic.com/blog/five-apps/protect-your-data-with-these-five-linux-encryption-tools/
#encfs ~/Dropbox/encrypted ~/Private
sudo apt-get install encfs -y
#install gnome-encfs-manager:
sudo add-apt-repository -y ppa:gencfsm/ppa
sudo apt-get update && sudo apt-get install gnome-encfs-manager -y
#haven't tried this yet
#sudo add-apt-repository -y ppa:eugenesan/ppa 
#sudo apt-get update
#sudo apt-get install encfs -y
#rclone - sync to cloud storage. rclone config to configure. see https://rclone.org/docs/
curl https://rclone.org/install.sh | sudo bash
#trash can utility installed by default, eg $gvfs-trash *.txt, gvfs-ls, gvfs-trash --empty

#vmware (requires interaction)
#sudo su -c "apt-get install gcc build-essential"
chmod +x VMware-Player-15.0.0-10134415.x86_64.bundle
sudo sh VMware-Player-15.0.0-10134415.x86_64.bundle /s
#to remove
#sudo  vmware-installer -u vmware-workstation
#add monitor.allowLegacyCPU = "true" To /etc/vmware/config to run on legacy processors
#change System Settings / Preferences / Privacy / Never forget old files' = True or vm's won't show in vmware player GUI
#If you have sufficient host memory (eg. >=8GB) and your VMs are configured for sufficiently small memory usage (e.g. >=4GB) you can run the VM completely in memory. Add the following line to the bottom of your /etc/vmware/config file:
#prefvmx.minVmMemPct = "100"

#STM32CubeIDE: IDE for embedded c++ on STMicroelectronics family of embedded chips
sudo bash st-stm32cubeide_1.0.2_3566_20190716_0927_amd64.deb_bundle.sh

#mariadb-server is a fork of MySQL server, if you need it.
#sudo apt-get install mariadb-server
#Install MSF Penetration Testing Framework - https://community.linuxmint.com/tutorial/view/2348
#curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \
#chmod 755 msfinstall && \
#./msfinstall
#The above will add the Rapid7 APT repostitory and install the package metasploit-framework. 

#powertop --html=powertop (generates report)
#https://www.youtube.com/watch?v=AZ-9uZlOAGg kicad 5 new features
#winecfg

#notes
#Mouse, ctrl-tab 3x, tab, enter turn on/off touchpad
#nemo icons: Use Edit->Preferences and then the Preview tab, show thumbnails: never 
#Now, apply “i” attribute the file immutable. prevents deletion or modification. 
#sudo chattr +i file.txt
#firefox toggle browser.urlbar.doubleClickSelectsAll;false  browser.urlbar.clickSelectsAll;true
#dom.webnotifications.enabled in about:
#dom.event.clipboardevents.enabled set to FALSE

#udisksctl mount -b /dev/sda1
#This command can be used to synchronize a folder, and also resume copying when it's aborted half way. The command to copy one disk is:

#rsync -avxHAXW --progress / /new-disk/

#-a  : all files, with permissions, etc..
#-v  : verbose, mention files
#-x  : stay on one file system
#-H  : preserve hard links (not included with -a)
#-A  : preserve ACLs/permissions (not included with -a)
#-X  : preserve extended attributes (not included with -a)
#-W (--whole-file), To improve the copy speed, avoid calculating deltas/diffs of the files (default when source and dest are local)

#sudo chown -R username:username /partition/mount-point, for example
#sudo chown -R ken:ken /media/ken/backup
#ps aux | grep apt #find o ut what process is locking apt
#kill -9 <pid> #to kill it
#In contrast to clear, or Ctrl+L, reset will actually completely re-initialise the terminal, instead of just clearing the screen. However, it won't re-instantiate the shell (bash). 
#aport collects data from crashed processes. to temp stop it, sudo service apport stop
#permanently stop it: sudo gedit /etc/default/apport then change enabled=0

#usb image writer in Accessories works well, so the following is not needed:
#balena-etcher - copies iso file to bootable flash media
#echo "deb https://deb.etcher.io stable etcher" | sudo tee /etc/apt/sources.list.d/balena-etcher.list
#sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 379CE192D401AB61
#sudo apt update
#sudo apt install balena-etcher-electron

#killall nemo to restart
#Fn Alt F2, r to restart cinnamon, lg - start the Melange debugger, xkill - kill an app by pointing at its window gnome-terminal - open a terminal window with bash in it
#Ctrl+Alt+backspace to restart X windows. http://www.brunolinux.com/01-First_Things_To_Know/Skinny_Elephants.html
#pkill -HUP -f "cinnamon --replace"
#killall -HUP cinnamon
#If Cinnamon keeps crashing: I just had the problem appear when I did an 'update' of Mint 16.
#In my case, switching to root brought up everything correctly, so I knew that it wasn't a driver problem... just something in my personal configuration. After a bit of searching, the following sequence worked great for me:

#(1) rm -rf .local/share/cinnamon
#(2) rm -rf .cinammon
#(3) reboot

#uname -r
#upgrade tool from 18.3 to 19
#sudo apt install mintupgrade
#mintupgrade check
#mintupgrade upgrade
#https://fossbytes.com/install-linux-mint-19-tara-guide/

#broadcom BCM4311 wifi not working on D830. First, go to system settings | Driver Manager and turn on the broadcom drivers before trying this, although that did not work for me.
#sudo lshw -class network
#sudo apt-get purge bcmwl-kernel-source
#sudo apt-get update
#sudo apt-get install firmware-b43-installer
#oddly, now driver Manager shows the BCM4311 not being used, although it is working. DO NOT CHANGE or it will undo the above
#https://easylinuxtipsproject.blogspot.com/p/speed-mint.html#ID5.1
#xed admin:///etc/NetworkManager/conf.d/default-wifi-powersave-on.conf
#change 3 to 2 to disable power management of wifi chip
#iwconfig
#ffmpeg -i master.wav -codec:a libmp3lame -qscale:a 2 master.mp3
#https://www.youtube.com/watch?v=poFOeFvsGy8
#CAUTION! adding modes with xrandr blows away proper setings for the default display eDP-1-1, even though I changed setting for DP-1-1 only. Now I have to enter xrandr commands for the primary display after rebooting or logging out which is very annoying. I have not figured out how to fix this.  
#To Add display mode for old analog monitors whose resolution is not detected. first, determine the resolution of the monitor. let's say its 1680x1050. from a command promt type "cvt 1680 1050" (use the actual resolution you desire) This will display the coordinated video timing (cvt) for that vesa mode, such as 
#1680x1050 59.95 Hz (CVT 1.76MA) hsync: 65.29 kHz; pclk: 146.25 MHz
#Modeline "1680x1050_60.00"  146.25  1680 1784 1960 2240  1050 1053 1059 1089 -hsync +vsync
#type the following commands, copying everything after "Modeline"
#xrandr --newmode "1680x1050_60.00"  146.25  1680 1784 1960 2240  1050 1053 1059 1089 -hsync +vsync
#xrandr --addmode DP-1-1 1680x1050_60.00, where "DP-1-1" is the ID of your external monitor found by entering xrandr with no arguments. lxrandr will show this mode as active.
#fix display mode: gksudo gedit /etc/X11/xorg.conf, add this line to the Monitor section:
#Modeline "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
#Then add this line to the Screen section, above SubSection "Display"
#Option "ModeValidation" "AllowNonEdidModes"
#see https://forums.linuxmint.com/viewtopic.php?t=219820

#notepadqq: Ctrl-(Fn)-End: end of file
#df -h check space utilization on disks
# lsblk command (list block devices) 
#sudo fdisk -l prints out the partition table on all your block devices
#ls -la /dev/ttyACM0   Check the current permissions and owner/group of the device
#sudo usermod -a -G dialout ken   add the group dialout to ken user. logout, then login
#inxi -Fxz      list system characteristics
