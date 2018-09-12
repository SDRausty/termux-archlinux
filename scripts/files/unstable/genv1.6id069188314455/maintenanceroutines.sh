#!/bin/env bash
# Copyright 2017-2018 by SDRausty. All rights reserved.  🌎 🌍 🌏 🌐 🗺
# Hosting https://sdrausty.github.io/TermuxArch courtesy https://pages.github.com
# https://sdrausty.github.io/TermuxArch/CONTRIBUTORS Thank you for your help.  
# https://sdrausty.github.io/TermuxArch/README has information about this project. 
################################################################################

sysinfo() {
	spaceinfo
	printf "\\n\\e[1;32mGenerating TermuxArch system information; Please wait…\\n\\n" 
	set +Ee
	systeminfo & spinner "Generating" "System Information…" 
	set -Ee
	printf "\\e[38;5;76m"
	cat "${wdir}setupTermuxArchSysInfo$stime".log
	printf "\\n\\e[1mThis information is important if you plan to open up an issue at https://github.com/sdrausty/TermuxArch/issues to improve \`setupTermuxArch.sh\`.  Include is along with a screenshot of the topic.  Also include information about input and output.  \\n\\n"
	exit
}

systeminfo () {
	printf "Begin TermuxArch system information.\\n" > "${wdir}setupTermuxArchSysInfo$stime".log
 	printf "\\n\`termux-info\` results:\\n\\n" >> "${wdir}setupTermuxArchSysInfo$stime".log
 	termux-info >> "${wdir}setupTermuxArchSysInfo$stime".log
	printf "\\ndpkg --print-architecture result:\\n\\n" >> "${wdir}setupTermuxArchSysInfo$stime".log
	dpkg --print-architecture >> "${wdir}setupTermuxArchSysInfo$stime".log
 	printf "\\ngetprop results:\\n\\n" >> "${wdir}setupTermuxArchSysInfo$stime".log
	printf "%s %s\\n" "[getprop gsm.sim.operator.iso-country]:" "[$(getprop gsm.sim.operator.iso-country)]" >> "${wdir}setupTermuxArchSysInfo$stime".log
	printf "%s %s\\n" "[getprop net.bt.name]:" "[$(getprop net.bt.name)]" >> "${wdir}setupTermuxArchSysInfo$stime".log
	printf "%s %s\\n" "[getprop persist.sys.locale]:" "[$(getprop persist.sys.locale)]" >> "${wdir}setupTermuxArchSysInfo$stime".log
	printf "%s %s\\n" "[getprop ro.build.target_country]:" "[$(getprop ro.build.target_country)]" >> "${wdir}setupTermuxArchSysInfo$stime".log
	printf "%s %s\\n" "[getprop ro.build.version.release]:" "[$(getprop ro.build.version.release)]" >> "${wdir}setupTermuxArchSysInfo$stime".log
	printf "%s %s\\n" "[getprop ro.build.version.preview_sdk]:" "[$(getprop ro.build.version.preview_sdk)]" >> "${wdir}setupTermuxArchSysInfo$stime".log
	printf "%s %s\\n" "[getprop ro.build.version.sdk]:" "[$(getprop ro.build.version.sdk)]" >> "${wdir}setupTermuxArchSysInfo$stime".log
	printf "%s %s\\n" "[getprop ro.product.device]:" "[$(getprop ro.product.device)]" >> "${wdir}setupTermuxArchSysInfo$stime".log
	printf "%s %s\\n" "[getprop ro.product.cpu.abi]:" "[$(getprop ro.product.cpu.abi)]" >> "${wdir}setupTermuxArchSysInfo$stime".log
	printf "%s %s\\n" "[getprop ro.product.first_api_level]:" "[$(getprop ro.product.first_api_level)]" >> "${wdir}setupTermuxArchSysInfo$stime".log
	printf "%s %s\\n" "[getprop ro.product.locale]:" "[$(getprop ro.product.locale)]" >> "${wdir}setupTermuxArchSysInfo$stime".log
	printf "%s %s\\n" "[getprop ro.product.manufacturer]:" "[$(getprop ro.product.manufacturer)]" >> "${wdir}setupTermuxArchSysInfo$stime".log
	printf "%s %s\\n" "[getprop ro.product.model]:" "[$(getprop ro.product.model)]" >> "${wdir}setupTermuxArchSysInfo$stime".log
	printf "\\nuname -a results:\\n\\n" >> "${wdir}setupTermuxArchSysInfo$stime".log
	uname -a >> "${wdir}setupTermuxArchSysInfo$stime".log
	printf "\\n" >> "${wdir}setupTermuxArchSysInfo$stime".log
	for n in 0 1 2 3 4 5 
	do 
		echo "BASH_VERSINFO[$n] = ${BASH_VERSINFO[$n]}"  >> "${wdir}setupTermuxArchSysInfo$stime".log
	done
	printf "\\ncat /proc/cpuinfo results:\\n\\n" >> "${wdir}setupTermuxArchSysInfo$stime".log
	cat /proc/cpuinfo >> "${wdir}setupTermuxArchSysInfo$stime".log
	printf "\\nDownload directory information results:\\n\\n" >> "${wdir}setupTermuxArchSysInfo$stime".log
	if [[ -d /sdcard/Download ]]; then echo "/sdcard/Download exists"; else echo "/sdcard/Download not found"; fi >> "${wdir}setupTermuxArchSysInfo$stime".log 
	if [[ -d /storage/emulated/0/Download ]]; then echo "/storage/emulated/0/Download exists"; else echo "/storage/emulated/0/Download not found"; fi >> "${wdir}setupTermuxArchSysInfo$stime".log
	if [[ -d "$HOME"/downloads ]]; then echo "$HOME/downloads exists"; else echo "~/downloads not found"; fi >> "${wdir}setupTermuxArchSysInfo$stime".log 
	if [[ -d "$HOME"/storage/downloads ]]; then echo "$HOME/storage/downloads exists"; else echo "$HOME/storage/downloads not found"; fi >> "${wdir}setupTermuxArchSysInfo$stime".log 
	printf "\\nDevice information results:\\n\\n" >> "${wdir}setupTermuxArchSysInfo$stime".log
	if [[ -e /dev/ashmem ]]; then echo "/dev/ashmem exists"; else echo "/dev/ashmem does not exist"; fi >> "${wdir}setupTermuxArchSysInfo$stime".log 
	if [[ -r /dev/ashmem ]]; then echo "/dev/ashmem is readable"; else echo "/dev/ashmem is not readable"; fi >> "${wdir}setupTermuxArchSysInfo$stime".log 
	if [[ -e /dev/shm ]]; then echo "/dev/shm exists"; else echo "/dev/shm does not exist"; fi >> "${wdir}setupTermuxArchSysInfo$stime".log 
	if [[ -r /dev/shm ]]; then echo "/dev/shm is readable"; else echo "/dev/shm is not readable"; fi >> "${wdir}setupTermuxArchSysInfo$stime".log 
	if [[ -e /proc/stat ]]; then echo "/proc/stat exits"; else echo "/proc/stat does not exit"; fi >> "${wdir}setupTermuxArchSysInfo$stime".log 
	if [[ -r /proc/stat ]]; then echo "/proc/stat is readable"; else echo "/proc/stat is not readable"; fi >> "${wdir}setupTermuxArchSysInfo$stime".log 
	printf "\\nDisk report $usrspace on /data $(date)\\n" >> "${wdir}setupTermuxArchSysInfo$stime".log 
	printf "\\ndf $installdir results:\\n\\n" >> "${wdir}setupTermuxArchSysInfo$stime".log
	df "$installdir" >> "${wdir}setupTermuxArchSysInfo$stime".log 2>/dev/null ||:
	printf "\\ndf results:\\n\\n" >> "${wdir}setupTermuxArchSysInfo$stime".log
	df >> "${wdir}setupTermuxArchSysInfo$stime".log 2>/dev/null ||:
	printf "\\ndu -hs $installdir results:\\n\\n" >> "${wdir}setupTermuxArchSysInfo$stime".log
	du -hs "$installdir" >> "${wdir}setupTermuxArchSysInfo$stime".log 2>/dev/null ||:
	printf "\\nls -al $installdir results:\\n\\n" >> "${wdir}setupTermuxArchSysInfo$stime".log
	ls -al "$installdir" >> "${wdir}setupTermuxArchSysInfo$stime".log 2>/dev/null ||:
	printf "\\nEnd \`setupTermuxArchSysInfo$stime.log\` system information.\\n\\n\\e[0mShare this information along with your issue at https://github.com/sdrausty/TermuxArch/issues; include input and output.  This file is found in \`""${wdir}setupTermuxArchSysInfo$stime.log\`.  If you think screenshots will help in a quicker resolution, include them in your post as well.  \\n" >> "${wdir}setupTermuxArchSysInfo$stime".log
}

copyimage() { # A systemimage.tar.gz file can be used: `setupTermuxArch.sh ./[path/]systemimage.tar.gz` and `setupTermuxArch.sh /absolutepath/systemimage.tar.gz`
 	cfile="${1##/*/}" 
	file="$(basename "$cfile")" 
# 	echo $file
# 	echo $lcp
# 	echo lcp
# 	pwd
# 	echo pwd
 	if [[ "$lcp" = "0" ]];then
		echo "Copying $1.md5 to $installdir…" 
		cp "$1".md5  "$installdir"
		echo "Copying $1 to $installdir…" 
		cp "$1" "$installdir"
 	elif [[ "$lcp" = "1" ]];then
		echo "Copying $1.md5 to $installdir…" 
		cp "$wdir$1".md5  "$installdir"
		echo "Copying $1 to $installdir…" 
		cp "$wdir$1" "$installdir"
 	fi
# 	ls  "$installdir"
}

loadimage() { 
	namestartarch 
 	spaceinfo
	printf "\\n" 
	wakelock
	prepinstalldir 
	set +Ee
  	copyimage "$@" & spinner "Copying" "…" 
	set -Ee
	printmd5check
	md5check
	printcu 
	rm -f "$installdir"/*.tar.gz "$installdir"/*.tar.gz.md5
	printdone 
	printconfigup 
	touchupsys 
	printf "\\n" 
	wakeunlock 
	printfooter
	"$installdir/$startbin" ||:
# 	"$startbin" help
	printstarthelp
	printfooter2
}

refreshsys() { # Refreshes
	printf '\033]2; setupTermuxArch.sh refresh 📲 \007'
	nameinstalldir 
	namestartarch  
	setrootdir  
	if [[ ! -d "$installdir" ]] || [[ ! -f "$installdir"/bin/env ]] || [[ ! -f "$installdir"/bin/we ]] || [[ ! -d "$installdir"/root/bin ]];then
		printf "\\n\\e[0;33m%s\\e[1;33m%s\\e[0;33m.\\e[0m\\n" "The root directory structure is incorrect; Cannot continue " "setupTermuxArch.sh refresh"
		exit $?
	fi
	cd "$installdir"
	preprootdir
	addREADME
	addae
	addauser
	addbash_logout 
	addbash_profile 
	addbashrc 
	addcdtd
	addcdth
	addch 
	adddfa
	addfbindexample
	addbinds
	addexd
	addfibs
	addga
	addgcl
	addgcm
	addgp
	addgpl
	addkeys
	addmotd
	addmoto
	addpc
	addpci
	addprofile 
	addresolvconf 
	addt 
	addthstartarch
	addtour
	addtrim 
	addyt 
	addwe  
	addv 
	makefinishsetup
	makesetupbin 
	makestartbin 
	setlocale
	printf "\\n" 
	wakelock
	printf '\033]2; setupTermuxArch.sh refresh 📲 \007'
	printf "\\n\\e[1;32m==> \\e[1;37m%s \\e[1;32m%s %s 📲 \\a\\n" "Running" "$(basename "$0")" "$args" 
	"$installdir"/root/bin/setupbin.sh 
 	rm -f root/bin/finishsetup.sh
 	rm -f root/bin/setupbin.sh 
	printf "\\e[1;34mThe following files have been updated to the newest version.\\n\\n\\e[0;32m"
	ls "$installdir/$startbin" |cut -f7- -d /
	ls "$installdir"/bin/we |cut -f7- -d /
	ls "$installdir"/root/bin/* |cut -f7- -d /
	printf "\\n" 
	wakeunlock 
	printfooter 
	printf "\\a"
	"$installdir/$startbin" ||:
# 	"$startbin" help
	printstarthelp
	printfooter2
	exit
}

spaceinfo() {
	declare spaceMessage=""
	units="$(df "$installdir" 2>/dev/null | awk 'FNR == 1 {print $2}')" 
	if [[ "$units" = Size ]] ; then
		spaceinfogsize 
		printf "$spaceMessage"
	elif [[ "$units" = 1K-blocks ]] ; then
		spaceinfoksize 
		printf "$spaceMessage"
	fi
}

spaceinfogsize() {
	userspace 
	if [[ "$cpuabi" = "$cpuabix86" ]] || [[ "$cpuabi" = "$cpuabix86_64" ]] ; then
		if [[ "$usrspace" = *G ]] ; then 
			spaceMessage=""
		elif [[ "$usrspace" = *M ]] ; then
			usspace="${usrspace: : -1}"
			if [[ "$usspace" < "800" ]] ; then
				spaceMessage="\\n\\e[0;33mTermuxArch: \\e[1;33mFREE SPACE WARNING!  \\e[1;30mStart thinking about cleaning out some stuff.  \\e[33m$usrspace of free user space is available on this device.  \\e[1;30mThe recommended minimum to install Arch Linux in Termux PRoot for x86 and x86_64 is 800M of free user space.\\n\\e[0m"
			fi
		fi
	elif [[ "$usrspace" = *G ]] ; then
		usspace="${usrspace: : -1}"
		if [[ "$cpuabi" = "$cpuabi8" ]] ; then
			if [[ "$usspace" < "1.5" ]] ; then
				spaceMessage="\\n\\e[0;33mTermuxArch: \\e[1;33mFREE SPACE WARNING!  \\e[1;30mStart thinking about cleaning out some stuff.  \\e[33m$usrspace of free user space is available on this device.  \\e[1;30mThe recommended minimum to install Arch Linux in Termux PRoot for aarch64 is 1.5G of free user space.\\n\\e[0m"
			else
				spaceMessage=""
			fi
		elif [[ "$cpuabi" = "$cpuabi7" ]] ; then
			if [[ "$usspace" < "1.23" ]] ; then
				spaceMessage="\\n\\e[0;33mTermuxArch: \\e[1;33mFREE SPACE WARNING!  \\e[1;30mStart thinking about cleaning out some stuff.  \\e[33m$usrspace of free user space is available on this device.  \\e[1;30mThe recommended minimum to install Arch Linux in Termux PRoot for armv7 is 1.23G of free user space.\\n\\e[0m"
			else
				spaceMessage=""
			fi
		else
			spaceMessage=""
		fi
	else
		spaceMessage="\\n\\e[0;33mTermuxArch: \\e[1;33mFREE SPACE WARNING!  \\e[1;30mStart thinking about cleaning out some stuff.  \\e[33m$usrspace of free user space is available on this device.  \\e[1;30mThe recommended minimum to install Arch Linux in Termux PRoot is more than 1.5G for aarch64, more than 1.25G for armv7 and about 800M of free user space for x86 and x86_64 architectures.\\n\\e[0m"
	fi
}

spaceinfoq() {
	if [[ "$suanswer" != [Yy]* ]] ; then
		spaceinfo
		if [[ -n "$spaceMessage" ]] ; then
			while true; do
				printf "\\n\\e[1;30m"
				read -n 1 -p "Continue with setupTermuxArch.sh? [Y|n] " suanswer
				if [[ "$suanswer" = [Ee]* ]] || [[ "$suanswer" = [Nn]* ]] || [[ "$suanswer" = [Qq]* ]] ; then
					printf "\\n" 
					exit $?
				elif [[ "$suanswer" = [Yy]* ]] || [[ "$suanswer" = "" ]] ; then
					suanswer=yes
					printf "Continuing with setupTermuxArch.sh.\\n"
					break
				else
					printf "\\nYou answered \\e[33;1m$suanswer\\e[30m.\\n\\nAnswer \\e[32mYes\\e[30m or \\e[1;31mNo\\e[30m. [\\e[32my\\e[30m|\\e[1;31mn\\e[30m]\\n"
				fi
			done
		fi
	fi
}

spaceinfoksize() {
	userspace 
	if [[ "$cpuabi" = "$cpuabi8" ]] ; then
		if [[ "$usrspace" -lt "1500000" ]] ; then
			spaceMessage="\\n\\e[0;33mTermuxArch: \\e[1;33mFREE SPACE WARNING!  \\e[1;30mStart thinking about cleaning out some stuff.  \\e[33m$usrspace $units of free user space is available on this device.  \\e[1;30mThe recommended minimum to install Arch Linux in Termux PRoot for aarch64 is 1.5G of free user space.\\n\\e[0m"
		else
			spaceMessage=""
		fi
	elif [[ "$cpuabi" = "$cpuabi7" ]] ; then
		if [[ "$usrspace" -lt "1250000" ]] ; then
			spaceMessage="\\n\\e[0;33mTermuxArch: \\e[1;33mFREE SPACE WARNING!  \\e[1;30mStart thinking about cleaning out some stuff.  \\e[33m$usrspace $units of free user space is available on this device.  \\e[1;30mThe recommended minimum to install Arch Linux in Termux PRoot for armv7 is 1.25G of free user space.\\n\\e[0m"
		else
			spaceMessage=""
		fi
	elif [[ "$cpuabi" = "$cpuabix86" ]] || [[ "$cpuabi" = "$cpuabix86_64" ]] ; then
		if [[ "$usrspace" -lt "800000" ]] ; then
			spaceMessage="\\n\\e[0;33mTermuxArch: \\e[1;33mFREE SPACE WARNING!  \\e[1;30mStart thinking about cleaning out some stuff.  \\e[33m$usrspace $units of free user space is available on this device.  \\e[1;30mThe recommended minimum to install Arch Linux in Termux PRoot for x86 and x86_64 is 800M of free user space.\\n\\e[0m"
		else
			spaceMessage=""
		fi
	fi
}

userspace() {
	usrspace="$(df "$installdir" 2>/dev/null | awk 'FNR == 2 {print $4}')"
	if [[ "$usrspace" = "" ]] ; then
		usrspace="$(df "$installdir" 2>/dev/null | awk 'FNR == 3 {print $3}')"
	fi
}

## EOF
