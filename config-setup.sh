#!/bin/bash
#
#small script to copy over configuration files for emulators
#Version 0.6
#Please report any errors via a pull request
#
#
clear
echo "RetroRig requires dialog and git for installation tasks. Installing..."
sudo apt-get install git dialog >> /dev/null

while true; do
    cmd=(dialog --backtitle "LibreGeek.org RetroRig Installer" --menu "Choose your option" 22 76 16)
    options=(1 "Install Software"
             2 "Set up configuration files and init scripts"
             3 "Pull latest files (exit and restart script after!)"
             4 "Update emulator binaries"
             5 "Upgrade System (use with caution!)"
             6 "Reboot PC"
             7 "Exit" )
    choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
    if [ "$choices" != "" ]; then
	case $choices in
            1) 	
		echo "Installing required programs..."
		sleep 2s
		clear

		#add multi-arch support
		sudo dpkg --add-architecture i386

		#add repository for pcsx2 (PS2 emulator)
		sudo add-apt-repository -y ppa:gregory-hainaut/pcsx2.official.ppa

		#add repository for dolphin-emu
		sudo add-apt-repository -y ppa:glennric/dolphin-emu
		sudo apt-get update
		sudo apt-get install -y xboxdrv curl zsnes nestopia pcsxr pcsx2:i386\
		mame mupen64plus dconf-tools qjoypad xbmc dolphin-emu-master stella
	
		#xbmc does not (at least for Ubuntu's repo pkg) load the
		#dot files without loading XBMC at least once
		#copy in default folder base from first run:
		mkdir -pv $HOME/RetroRig/.xbmc/
		cp -Rv $HOME/RetroRig/XBMC/* $HOME/.xbmc/

		#Auto-pull of RCB will be automated with curl later!
		cd $HOME/.xbmc/addons && curl romcollectionbrowser.googlecode.com/files/script.games.rom.collection.browser-2.0.10.zip > ~/.xbmc/addons/script.games.rom.collection.browser-2.0.10.zip
		unzip -e script.games.rom.collection.browser-2.0.10.zip
		#set proper permission for addon
		chmod 755 script.games.rom.collection.browser-2.0.10/
		cd $HOME/RetroRig/
		echo ""
		echo "RetroRig files cloned into: $HOME/RetroRig"	 
		sleep 5s
		
		#clear
		clear
		;;
	    2) 
		echo "Seting up configuration files"
		sleep 3s
		clear

		#disable screensaver, XBMC will manage this
		#export display to allow gsettings running in terminal window
		export DISPLAY=:0.0
		gsettings set org.gnome.settings-daemon.plugins.power active false
		gsettings set org.gnome.desktop.screensaver idle-activation-enabled false

		#having some trouble with the screensaver re-enabling itself
		#for now, remove gnome-screensaver, should not be needed
		#due to XBMC having its own.
		sudo apt-get remove -y gnome-screensaver

		#setup skelton folders for XBMC Rom Collection Browser
		#ROMs		
		mkdir -pv $HOME/Games/ROMs/Atari\ 2600/
		mkdir -pv $HOME/Games/ROMs/Gamecube/
		mkdir -pv $HOME/Games/ROMs/Mame4All/
		mkdir -pv $HOME/Games/ROMs/N64/
		mkdir -pv $HOME/Games/ROMs/NES/
		mkdir -pv $HOME/Games/ROMs/SNES/
		mkdir -pv $HOME/Games/ROMs/PS2/
		mkdir -pv $HOME/Games/ROMs/PS1/
		mkdir -pv $HOME/Games/ROMs/sgenroms/
		mkdir -pv $HOME/Games/ROMs/SNK\ Neo\ Geo/

		#Artwork
		mkdir -pv $HOME/Games/Artwork/

		#Emulators (if any fall here)		
		mkdir -pv $HOME/Games/Artwork/Atari\ 2600/
		mkdir -pv $HOME/Games/Artwork/Gamecube/
		mkdir -pv $HOME/Games/Artwork/Mame4All/
		mkdir -pv $HOME/Games/Artwork/N64/
		mkdir -pv $HOME/Games/Artwork/NES/
		mkdir -pv $HOME/Games/Artwork/SNES/
		mkdir -pv $HOME/Games/Artwork/PS2/
		mkdir -pv $HOME/Games/Artwork/PS1/
		mkdir -pv $HOME/Games/Artwork/sgenroms/
		mkdir -pv $HOME/Games/Artwork/SNK\ Neo\ Geo/

		#Saves (if any)		
		mkdir -pv $HOME/Games/Saves/Atari\ 2600/
		mkdir -pv $HOME/Games/Saves/Gamecube/
		mkdir -pv $HOME/Games/Saves/Mame4All/
		mkdir -pv $HOME/Games/Saves/N64/
		mkdir -pv $HOME/Games/Saves/NES/
		mkdir -pv $HOME/Games/Saves/SNES/
		mkdir -pv $HOME/Games/Saves/PS2/
		mkdir -pv $HOME/Games/Saves/PS1/
		mkdir -pv $HOME/Games/Saves/genroms/
		mkdir -pv $HOME/Games/Saves/SNK\ Neo\ Geo/

		#create dotfiles
		mkdir -pv $HOME/.qjoypad3/
		mkdir -pv $HOME/.dolphin-emu/Config/
		mkdir -pv $HOME/.config/mupen64plus/
		mkdir -pv $HOME/.nestopia/
		mkdir -pv $HOME/.gens/
		mkdir -pv $HOME/.zsnes/
		mkdir -pv $HOME/.mame/cfg/
		mkdir -pv $HOME/.pcsx/
		mkdir -pv $HOME/.config/pcsx2/

		#xboxdrv director located in common area for startup
		sudo mkdir -pv /usr/share/xboxdrv/

		#Tools		
		mkdir -pv $HOME/Games/Tools/

		#configs		
		mkdir -pv $HOME/Games/Configs/

		#Nestopia
		#default path: /home/$USER/.nestopia
		cp -v $HOME/RetroRig/Nestopia/nstcontrols $HOME/.nestopia/

		#gens
		#default path: /home/$USER/.gens
		#Global config
		cp -v $HOME/RetroRig/Gens-GS/gens.cfg $HOME/.gens/

		#ZSNES
		#default path: /home/$USER/.zsnes
		#Controller config
		cp -v $HOME/RetroRig/ZSNES/zinput.cfg $HOME/.zsnes/
		#emulator config
		cp -v $HOME/RetroRig/ZSNES/zsnesl.cfg $HOME/.zsnes/

		#mame
		#default path: /home/$USER/.mame
		#Main config
		cp -v $HOME/RetroRig/MAME/mame.ini $HOME/.mame/
		#controller config
		cp -Rv $HOME/RetroRig/MAME/default.cfg $HOME/.mame/cfg/

		#pcsx
		#default path: /home/$USER/.pcsx
		#Main config
		cp -v $HOME/RetroRig/pcsx/pcsx.cfg $HOME/.pcsx/

		#pcsx2
		#default path: /home/$USER/.config/pcsx2
		#Main config
		cp -v $HOME/RetroRig/pcsx2/PCSX2-reg.ini $HOME/.config/pcsx2/

		#mupen64pluspwd
		#default path: /home/$USER/.config/mupen64plus
		#Main config
		cp -v $HOME/RetroRig/mupen64plus/mupen64plus.cfg $HOME/.config/mupen64plus/

		#dolphin
		#default path /home/$USER/.dolphin-emu/
		#emulator config
		cp -Rv /$HOME/RetroRig/Dolphin/Dolphin.ini $HOME/.dolphin-emu/Config/
		#Gamecube controller config
		cp -Rv /$HOME/RetroRig/Dolphin/GCPadNew.ini $HOME/.dolphin-emu/Config/
		#Wii controller config
		#[PENDING]

		#opengl config
		cp -Rv /$HOME/RetroRig/Dolphin/gfx_opengl.ini $HOME/.dolphin-emu/Config/

		#copy configs for other utilities
		cp -v $HOME/RetroRig/controller-cfg/retro-gaming.lyt $HOME/.qjoypad3/
		
		#add xbox controller init script
		sudo cp -v $HOME/RetroRig/controller-cfg/xpad-wireless.xboxdrv\
		/usr/share/xboxdrv/
		sudo cp -v $HOME/RetroRig/init-scripts/xboxdrv /etc/init.d/
		sudo update-rc.d xboxdrv defaults

		#blacklist xpad
		sudo cp -v $HOME/RetroRig/init-scripts/blacklist.conf /etc/modprobe.d/

		#create autostart for XBMC snd qjoypad
		sudo cp -v /usr/share/applications/xbmc.desktop /etc/xdg/autostart/
		sudo cp -v $HOME/RetroRig/controller-cfg/qjoypad.desktop /etc/xdg/autostart/

		#clear and prompt
		sleep 3s
	        ;;
            3)
		echo "updating git repo"
		sleep 2s
		cd $HOME/RetroRig/
		git pull 
		sleep 3s
		;;
            4)  
		echo "updating binaries"
		sudo apt-get install -y xboxdrv zsnes nestopia pcsxr pcsx2:i386\
		mame mupen64plus qjoypad xbmc dolphin-emu-master stella	
		sleep 3s
		;;
            5)  
		echo "updating system"
		sudo apt-get update
		sudo apt-get upgrade
		sleep 3s
		;;
            6)  
	        echo "Rebooting in 5 seconds, press CTRL+C to cancel"
                sleep 5s
                sudo reboot 
		;;
            7)  break
                ;;
         esac
     else
	 break
     fi
done     
clear



