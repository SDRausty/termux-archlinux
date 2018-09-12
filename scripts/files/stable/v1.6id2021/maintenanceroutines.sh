#!/bin/env bash
# Copyright 2017-2018 by SDRausty. All rights reserved.  🌎 🌍 🌏 🌐 🗺
# Hosted sdrausty.github.io/TermuxArch courtesy https://pages.github.com
# https://sdrausty.github.io/TermuxArch/README has info about this project. 
# https://sdrausty.github.io/TermuxArch/CONTRIBUTORS Thank you for your help.  
# _STANDARD_="function name" && STANDARD="variable name" are under construction.
################################################################################

sysinfo() {
	spaceinfo
	printf "\\n\\e[1;32mGenerating TermuxArch system information; Please wait…\\n\\n" 
	systeminfo ## & spinner "Generating" "System Information…" 
	printf "\\e[38;5;76m"
	cat "${wdir}setupTermuxArchSysInfo$STIME".log
	printf "\\n\\e[1mThis information may be quite important when planning issue(s) at https://github.com/sdrausty/TermuxArch/issues with the hope of improving \`setupTermuxArch.sh\`;  Include input and output, along with screenshot(s) relavent to X, and similar.\\n\\n"
	exit
}

systeminfo () {
	printf "Begin TermuxArch system information.\\n" > "${wdir}setupTermuxArchSysInfo$STIME".log
	printf "\\ndpkg --print-architecture result:\\n\\n" >> "${wdir}setupTermuxArchSysInfo$STIME".log
	dpkg --print-architecture >> "${wdir}setupTermuxArchSysInfo$STIME".log
 	printf "\\ngetprop results:\\n\\n" >> "${wdir}setupTermuxArchSysInfo$STIME".log
	printf "%s %s\\n" "[getprop gsm.sim.operator.iso-country]:" "[$(getprop gsm.sim.operator.iso-country)]" >> "${wdir}setupTermuxArchSysInfo$STIME".log
	printf "%s %s\\n" "[getprop net.bt.name]:" "[$(getprop net.bt.name)]" >> "${wdir}setupTermuxArchSysInfo$STIME".log
	printf "%s %s\\n" "[getprop persist.sys.locale]:" "[$(getprop persist.sys.locale)]" >> "${wdir}setupTermuxArchSysInfo$STIME".log
	printf "%s %s\\n" "[getprop ro.build.target_country]:" "[$(getprop ro.build.target_country)]" >> "${wdir}setupTermuxArchSysInfo$STIME".log
	printf "%s %s\\n" "[getprop ro.build.version.release]:" "[$(getprop ro.build.version.release)]" >> "${wdir}setupTermuxArchSysInfo$STIME".log
	printf "%s %s\\n" "[getprop ro.build.version.preview_sdk]:" "[$(getprop ro.build.version.preview_sdk)]" >> "${wdir}setupTermuxArchSysInfo$STIME".log
	printf "%s %s\\n" "[getprop ro.build.version.sdk]:" "[$(getprop ro.build.version.sdk)]" >> "${wdir}setupTermuxArchSysInfo$STIME".log
	printf "%s %s\\n" "[getprop ro.com.google.clientidbase]:" "[$(getprop ro.com.google.clientidbase)]" >> "${wdir}setupTermuxArchSysInfo$STIME".log
	printf "%s %s\\n" "[getprop ro.com.google.clientidbase.am]:" "[$(getprop ro.com.google.clientidbase.am)]" >> "${wdir}setupTermuxArchSysInfo$STIME".log
	printf "%s %s\\n" "[getprop ro.com.google.clientidbase.ms]:" "[$(getprop ro.com.google.clientidbase.ms)]" >> "${wdir}setupTermuxArchSysInfo$STIME".log
	printf "%s %s\\n" "[getprop ro.product.device]:" "[$(getprop ro.product.device)]" >> "${wdir}setupTermuxArchSysInfo$STIME".log
	printf "%s %s\\n" "[getprop ro.product.cpu.abi]:" "[$(getprop ro.product.cpu.abi)]" >> "${wdir}setupTermuxArchSysInfo$STIME".log
	printf "%s %s\\n" "[getprop ro.product.first_api_level]:" "[$(getprop ro.product.first_api_level)]" >> "${wdir}setupTermuxArchSysInfo$STIME".log
	printf "%s %s\\n" "[getprop ro.product.locale]:" "[$(getprop ro.product.locale)]" >> "${wdir}setupTermuxArchSysInfo$STIME".log
	printf "%s %s\\n" "[getprop ro.product.manufacturer]:" "[$(getprop ro.product.manufacturer)]" >> "${wdir}setupTermuxArchSysInfo$STIME".log
	printf "%s %s\\n" "[getprop ro.product.model]:" "[$(getprop ro.product.model)]" >> "${wdir}setupTermuxArchSysInfo$STIME".log
	printf "\\nuname -a results:\\n\\n" >> "${wdir}setupTermuxArchSysInfo$STIME".log
	uname -a >> "${wdir}setupTermuxArchSysInfo$STIME".log
	printf "\\n" >> "${wdir}setupTermuxArchSysInfo$STIME".log
	for n in 0 1 2 3 4 5 
	do 
		echo "BASH_VERSINFO[$n] = ${BASH_VERSINFO[$n]}"  >> "${wdir}setupTermuxArchSysInfo$STIME".log
	done
	printf "\\ncat /proc/cpuinfo results:\\n\\n" >> "${wdir}setupTermuxArchSysInfo$STIME".log
	cat /proc/cpuinfo >> "${wdir}setupTermuxArchSysInfo$STIME".log
	printf "\\nDownload directory information results:\\n\\n" >> "${wdir}setupTermuxArchSysInfo$STIME".log
	if [[ -d /sdcard/Download ]]; then echo "/sdcard/Download exists"; else echo "/sdcard/Download not found"; fi >> "${wdir}setupTermuxArchSysInfo$STIME".log 
	if [[ -d /storage/emulated/0/Download ]]; then echo "/storage/emulated/0/Download exists"; else echo "/storage/emulated/0/Download not found"; fi >> "${wdir}setupTermuxArchSysInfo$STIME".log
	if [[ -d "$HOME"/downloads ]]; then echo "$HOME/downloads exists"; else echo "~/downloads not found"; fi >> "${wdir}setupTermuxArchSysInfo$STIME".log 
	if [[ -d "$HOME"/storage/downloads ]]; then echo "$HOME/storage/downloads exists"; else echo "$HOME/storage/downloads not found"; fi >> "${wdir}setupTermuxArchSysInfo$STIME".log 
	printf "\\nDevice information results:\\n\\n" >> "${wdir}setupTermuxArchSysInfo$STIME".log
	if [[ -e /dev/ashmem ]]; then echo "/dev/ashmem exists"; else echo "/dev/ashmem does not exist"; fi >> "${wdir}setupTermuxArchSysInfo$STIME".log 
	if [[ -r /dev/ashmem ]]; then echo "/dev/ashmem is readable"; else echo "/dev/ashmem is not readable"; fi >> "${wdir}setupTermuxArchSysInfo$STIME".log 
	if [[ -e /dev/shm ]]; then echo "/dev/shm exists"; else echo "/dev/shm does not exist"; fi >> "${wdir}setupTermuxArchSysInfo$STIME".log 
	if [[ -r /dev/shm ]]; then echo "/dev/shm is readable"; else echo "/dev/shm is not readable"; fi >> "${wdir}setupTermuxArchSysInfo$STIME".log 
	if [[ -e /proc/stat ]]; then echo "/proc/stat exits"; else echo "/proc/stat does not exit"; fi >> "${wdir}setupTermuxArchSysInfo$STIME".log 
	if [[ -r /proc/stat ]]; then echo "/proc/stat is readable"; else echo "/proc/stat is not readable"; fi >> "${wdir}setupTermuxArchSysInfo$STIME".log 
	printf "\\nDisk report $usrspace on /data $(date)\\n" >> "${wdir}setupTermuxArchSysInfo$STIME".log 
	printf "\\ndf $INSTALLDIR results:\\n\\n" >> "${wdir}setupTermuxArchSysInfo$STIME".log
	df "$INSTALLDIR" >> "${wdir}setupTermuxArchSysInfo$STIME".log 2>/dev/null ||:
	printf "\\ndf results:\\n\\n" >> "${wdir}setupTermuxArchSysInfo$STIME".log
	df >> "${wdir}setupTermuxArchSysInfo$STIME".log 2>/dev/null ||:
	printf "\\ndu -hs $INSTALLDIR results:\\n\\n" >> "${wdir}setupTermuxArchSysInfo$STIME".log
	du -hs "$INSTALLDIR" >> "${wdir}setupTermuxArchSysInfo$STIME".log 2>/dev/null ||:
	printf "\\nls -al $INSTALLDIR results:\\n\\n" >> "${wdir}setupTermuxArchSysInfo$STIME".log
	ls -al "$INSTALLDIR" >> "${wdir}setupTermuxArchSysInfo$STIME".log 2>/dev/null ||:
	printf "\\nEnd \`setupTermuxArchSysInfo$STIME.log\` system information.\\n\\n\\e[0mShare this information along with your issue at https://github.com/sdrausty/TermuxArch/issues; include input and output.  This file is found in \`""${wdir}setupTermuxArchSysInfo$STIME.log\`.  If you think screenshots will help in a quicker resolution, include them in the post as well.  \\n" >> "${wdir}setupTermuxArchSysInfo$STIME".log
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
		echo "Copying $1.md5 to $INSTALLDIR…" 
		cp "$1".md5  "$INSTALLDIR"
		echo "Copying $1 to $INSTALLDIR…" 
		cp "$1" "$INSTALLDIR"
 	elif [[ "$lcp" = "1" ]];then
		echo "Copying $1.md5 to $INSTALLDIR…" 
		cp "$wdir$1".md5  "$INSTALLDIR"
		echo "Copying $1 to $INSTALLDIR…" 
		cp "$wdir$1" "$INSTALLDIR"
 	fi
# 	ls  "$INSTALLDIR"
}

loadimage() { 
	_NAMESTARTARCH_ 
 	spaceinfo
	printf "\\n" 
	_WAKELOCK_
	_PREPINSTALLDIR_ 
  	copyimage ## "$@" & spinner "Copying" "…" 
	_PRINTMD5CHECK_
	md5check
	_PRINTCU_ 
	rm -f "$INSTALLDIR"/*.tar.gz "$INSTALLDIR"/*.tar.gz.md5
	_PRINTDONE_ 
	_PRINTCONFIGUP_ 
	touchupsys 
	printf "\\n" 
	_WAKEUNLOCK_ 
	_PRINTFOOTER_
	set +Eeuo pipefail
	"$INSTALLDIR/$startbin" ||:
	set -Eeuo pipefail
	_PRINTSTARTBIN_USAGE_
	_PRINTFOOTER2_
	exit
}

refreshsys() { # Refreshes
	printf '\033]2; setupTermuxArch.sh refresh 📲 \007'
 	_NAMESTARTARCH_  
 	spaceinfo
	cd "$INSTALLDIR"
	_SETLANGUAGE_
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
	_MAKEFINISHSETUP_
	makesetupbin 
	makestartbin 
	_SETLOCALE_
	printf "\\n" 
	_WAKELOCK_
	printf '\033]2; setupTermuxArch.sh refresh 📲 \007'
	printf "\\n\\e[1;32m==> \\e[1;37m%s \\e[1;32m%s %s 📲 \\a\\n" "Running" "$(basename "$0")" "$args" 
	"$INSTALLDIR"/root/bin/setupbin.sh ||: 
 	rm -f root/bin/finishsetup.sh
 	rm -f root/bin/setupbin.sh 
	printf "\\e[1;34mThe following files have been updated to the newest version.\\n\\n\\e[0;32m"
	ls "$INSTALLDIR/$startbin" |cut -f7- -d /
	ls "$INSTALLDIR"/bin/we |cut -f7- -d /
	ls "$INSTALLDIR"/root/bin/* |cut -f7- -d /
	printf "\\n" 
	_WAKEUNLOCK_ 
	_PRINTFOOTER_ 
	printf "\\a"
	sleep 0.015
	printf "\\a"
	set +Eeuo pipefail
	"$INSTALLDIR/$startbin" ||:
	set -Eeuo pipefail
	_PRINTSTARTBIN_USAGE_
	_PRINTFOOTER2_
}

spaceinfo() {
	declare spaceMessage=""
	units="$(df "$INSTALLDIR" 2>/dev/null | awk 'FNR == 1 {print $2}')" 
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
	if [[ "$CPUABI" = "$CPUABIX86" ]] || [[ "$CPUABI" = "$CPUABIX86_64" ]] ; then
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
		if [[ "$CPUABI" = "$CPUABI8" ]] ; then
			if [[ "$usspace" < "1.5" ]] ; then
				spaceMessage="\\n\\e[0;33mTermuxArch: \\e[1;33mFREE SPACE WARNING!  \\e[1;30mStart thinking about cleaning out some stuff.  \\e[33m$usrspace of free user space is available on this device.  \\e[1;30mThe recommended minimum to install Arch Linux in Termux PRoot for aarch64 is 1.5G of free user space.\\n\\e[0m"
			else
				spaceMessage=""
			fi
		elif [[ "$CPUABI" = "$CPUABI7" ]] ; then
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
	if [[ "$CPUABI" = "$CPUABI8" ]] ; then
		if [[ "$usrspace" -lt "1500000" ]] ; then
			spaceMessage="\\n\\e[0;33mTermuxArch: \\e[1;33mFREE SPACE WARNING!  \\e[1;30mStart thinking about cleaning out some stuff.  \\e[33m$usrspace $units of free user space is available on this device.  \\e[1;30mThe recommended minimum to install Arch Linux in Termux PRoot for aarch64 is 1.5G of free user space.\\n\\e[0m"
		else
			spaceMessage=""
		fi
	elif [[ "$CPUABI" = "$CPUABI7" ]] ; then
		if [[ "$usrspace" -lt "1250000" ]] ; then
			spaceMessage="\\n\\e[0;33mTermuxArch: \\e[1;33mFREE SPACE WARNING!  \\e[1;30mStart thinking about cleaning out some stuff.  \\e[33m$usrspace $units of free user space is available on this device.  \\e[1;30mThe recommended minimum to install Arch Linux in Termux PRoot for armv7 is 1.25G of free user space.\\n\\e[0m"
		else
			spaceMessage=""
		fi
	elif [[ "$CPUABI" = "$CPUABIX86" ]] || [[ "$CPUABI" = "$CPUABIX86_64" ]] ; then
		if [[ "$usrspace" -lt "800000" ]] ; then
			spaceMessage="\\n\\e[0;33mTermuxArch: \\e[1;33mFREE SPACE WARNING!  \\e[1;30mStart thinking about cleaning out some stuff.  \\e[33m$usrspace $units of free user space is available on this device.  \\e[1;30mThe recommended minimum to install Arch Linux in Termux PRoot for x86 and x86_64 is 800M of free user space.\\n\\e[0m"
		else
			spaceMessage=""
		fi
	fi
}

userspace() {
	usrspace="$(df "$INSTALLDIR" 2>/dev/null | awk 'FNR == 2 {print $4}')"
	if [[ "$usrspace" = "" ]] ; then
		usrspace="$(df "$INSTALLDIR" 2>/dev/null | awk 'FNR == 3 {print $3}')"
	fi
}

## EOF
