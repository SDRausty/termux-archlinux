#!/bin/env bash
# Copyright 2017-2018 by SDRausty. All rights reserved.  🌎 🌍 🌏 🌐 🗺
# Hosted https://sdrausty.github.io/TermuxArch courtesy https://pages.github.com
# https://sdrausty.github.io/TermuxArch/CONTRIBUTORS Thank you for your help.  
# _STANDARD_="function name" && STANDARD="variable name" are under construction.
################################################################################
IFS=$'\n\t'
set -Eeuo pipefail
shopt -s nullglob globstar
unset LD_PRELOAD
versionid="v1.6 id1294"
## Init Functions ##############################################################

aria2cif() { 
	dm=aria2c
	if [[ -x "$(command -v aria2c)" ]] && [[ -x "$PREFIX"/bin/aria2c ]] ; then
		:
	else
		aptin+="aria2 "
		maptin+=("aria2")
		apton+=("aria2c")
	fi
}

aria2cifdm() {
	if [[ "$dm" = aria2c ]] ; then
		aria2cif 
	fi
}

_ARG2DIR_() {  # Argument as rootdir.
	arg2="${@:2:1}"
	if [[ -z "${arg2:-}" ]] ; then
		rootdir=/arch
		_PREPTERMUXARCH_
	else
		rootdir=/"$arg2" 
		_PREPTERMUXARCH_
	fi
}

axelif() { 
	dm=axel
	if [[ -x "$(command -v axel)" ]] && [[ -x "$PREFIX"/bin/axel ]] ; then
		:
	else
		aptin+="axel "
		maptin+=("axel")
		apton+=("axel")
	fi
}

axelifdm() {
	if [[ "$dm" = axel ]] ; then
		axelif 
	fi
}

bsdtarif() {
	tm=bsdtar
	if [[ -x "$(command -v bsdtar)" ]] && [[ -x "$PREFIX"/bin/bsdtar ]] ; then
		:
	else
		aptin+="bsdtar "
		maptin+=("bsdtar")
		apton+=("bsdtar")
	fi
}

chk() {
	if "$PREFIX"/bin/applets/sha512sum -c termuxarchchecksum.sha512 1>/dev/null ; then
 		chkself "$@"
		printf "\\e[0;34m%s \\e[1;34m%s \\e[1;32m%s\\e[0m\\n" " 🕛 > 🕜" "TermuxArch $versionid integrity:" "OK"
		loadconf
		. archlinuxconfig.sh
		. espritfunctions.sh
		. getimagefunctions.sh
		. maintenanceroutines.sh
		. necessaryfunctions.sh
		. printoutstatements.sh
		if [[ "$opt" = bloom ]] ; then
			rm -f termuxarchchecksum.sha512 
		fi
		if [[ "$opt" = manual ]] ; then
			manual
		fi
	else
		printsha512syschker
	fi
}

chkdwn() {
	if "$PREFIX"/bin/applets/sha512sum -c setupTermuxArch.sha512 1>/dev/null ; then
		printf "\\e[0;34m 🕛 > 🕐 \\e[1;34mTermuxArch download: \\e[1;32mOK\\n\\n"
		if [[ "$tm" = tar ]] ; then
	 		proot --link2symlink -0 "$PREFIX"/bin/tar xf setupTermuxArch.tar.gz 
		else
	 		proot --link2symlink -0 "$PREFIX"/bin/applets/tar xf setupTermuxArch.tar.gz 
		fi
	else
		printsha512syschker
	fi
}

chkself() {
	if [[ -f "setupTermuxArch.tmp" ]] ; then
		if [[ "$(<setupTermuxArch.sh)" != "$(<setupTermuxArch.tmp)" ]] ; then
			cp setupTermuxArch.sh "${wdir}setupTermuxArch.sh"
			printf "\\e[0;32m%s\\e[1;34m: \\e[1;32mUPDATED\\n\\e[1;32mRESTART\\e[1;34m: \\e[0;32m%s %s \\n\\n\\e[0m"  "${0##*/}" "${0##*/}" "$args"
			exit 231
# 			.  "${wdir}setupTermuxArch.sh" "$@"
		fi
	fi
}

curlif() {
	dm=curl
	if [[ -x "$(command -v curl)" ]] && [[ -x "$PREFIX"/bin/curl ]] ; then
		:
	else
		aptin+="curl "
		maptin+=("curl")
		apton+=("curl")
	fi
}

curlifdm() {
	if [[ "$dm" = curl ]] ; then
		curlif 
	fi
}

dependbp() {
	if [[ "$CPUABI" = "$CPUABIX86" ]] || [[ "$CPUABI" = "$CPUABIX86_64" ]] ; then
		bsdtarif 
		prootif 
	else
		prootif 
	fi
}

depends() { # Checks for missing commands.  
	printf "\\e[1;34mChecking prerequisites…\\n\\e[1;32m"
# 	# Checks if download manager is set. 
	aria2cifdm 
	axelifdm 
	lftpifdm 
	curlifdm 
	wgetifdm 
# 	# Checks if download manager is present. 
# 	# IMPORTANT NOTE: CURRENTLY ONLY curl AND wget ARE THOROUGHLY TESTED.   All the download managers are NOT yet fully implemented.    
	if [[ "$dm" = "" ]] ; then
		if [[ -x "$(command -v curl)" ]] || [[ -x "$PREFIX"/bin/curl ]] ; then
			curlif 
		elif [[ -x "$(command -v wget)" ]] && [[ -x "$PREFIX"/bin/wget ]] ; then
			wgetif 
		elif  [[ -x "$(command -v aria2c)" ]] || [[ -x "$PREFIX"/bin/aria2c ]]; then
			aria2cif 
	 	elif [[ -x "$(command -v lftpget)" ]] || [[ -x "$PREFIX"/bin/lftpget ]] ; then
			lftpif 
	 	elif [[ -x "$(command -v axel)" ]] || [[ -x "$PREFIX"/bin/axel ]] ; then
			axelif 
		fi
	fi
#	# Sets and installs wget if nothing else was found, installed and set. 
	if [[ "$dm" = "" ]] ; then
		wgetif 
	fi
	dependbp 
#	# Installs missing commands.  
	tapin "$aptin"
#	# Checks whether install missing commands was successful.  
# 	pechk "$apton"
	echo
	echo "Using ${dm:-wget} to manage downloads." 
	printf "\\n\\e[0;34m 🕛 > 🕧 \\e[1;34mPrerequisites: \\e[1;32mOK  \\e[1;34mDownloading TermuxArch…\\n\\n\\e[0;32m"
}

dependsblock() {
	depends 
	if [[ -f archlinuxconfig.sh ]] && [[ -f espritfunctions.sh ]] && [[ -f getimagefunctions.sh ]] && [[ -f knownconfigurations.sh ]] && [[ -f maintenanceroutines.sh ]] && [[ -f necessaryfunctions.sh ]] && [[ -f printoutstatements.sh ]] && [[ -f setupTermuxArch.sh ]] ; then
		. archlinuxconfig.sh
		. espritfunctions.sh
		. getimagefunctions.sh
		. knownconfigurations.sh
		. maintenanceroutines.sh
		. necessaryfunctions.sh
		. printoutstatements.sh
		if [[ "$opt" = manual ]] ; then
			manual
		fi 
	else
		cd "$tampdir" 
		dwnl
		if [[ -f "${wdir}setupTermuxArch.sh" ]] ; then
			cp "${wdir}setupTermuxArch.sh" setupTermuxArch.tmp
		fi
		chkdwn
		chk "$@"
	fi
}

dwnl() {
	if [[ "$dm" = aria2c ]] ; then
		aria2c https://raw.githubusercontent.com/sdrausty/TermuxArch/master"$dfl"/setupTermuxArch.sha512 
		aria2c https://raw.githubusercontent.com/sdrausty/TermuxArch/master"$dfl"/setupTermuxArch.tar.gz 
	elif [[ "$dm" = axel ]] ; then
		axel https://raw.githubusercontent.com/sdrausty/TermuxArch/master"$dfl"/setupTermuxArch.sha512 
		axel https://raw.githubusercontent.com/sdrausty/TermuxArch/master"$dfl"/setupTermuxArch.tar.gz 
	elif [[ "$dm" = lftp ]] ; then
		lftpget -v https://raw.githubusercontent.com/sdrausty/TermuxArch/master"$dfl"/setupTermuxArch.sha512 
		lftpget -v https://raw.githubusercontent.com/sdrausty/TermuxArch/master"$dfl"/setupTermuxArch.tar.gz 
	elif [[ "$dm" = wget ]] ; then
		wget "$dmverbose" -N --show-progress https://raw.githubusercontent.com/sdrausty/TermuxArch/master"$dfl"/setupTermuxArch.sha512 
		wget "$dmverbose" -N --show-progress https://raw.githubusercontent.com/sdrausty/TermuxArch/master"$dfl"/setupTermuxArch.tar.gz 
	else
		curl "$dmverbose" -OL https://raw.githubusercontent.com/sdrausty/TermuxArch/master"$dfl"/setupTermuxArch.sha512 -OL https://raw.githubusercontent.com/sdrausty/TermuxArch/master"$dfl"/setupTermuxArch.tar.gz
	fi
	printf "\\n\\e[1;32m"
}

intro() {
	printf '\033]2;  bash setupTermuxArch.sh $@ 📲 \007'
	_SETROOT_EXCEPTION_ 
	printf "\\n\\e[0;34m 🕛 > 🕛 \\e[1;34mTermuxArch $versionid shall attempt to install Linux in \\e[0;32m$INSTALLDIR\\e[1;34m.  Arch Linux in Termux PRoot shall be available upon successful completion.  To run this BASH script again, use \`!!\`.  Ensure background data is not restricted.  Check the wireless connection if you do not see one o'clock 🕐 below.  "
	dependsblock "$@" 
	if [[ "$lcc" = "1" ]] ; then
		loadimage "$@" 
	else
		mainblock
	fi
}

introbloom() { # Bloom = `setupTermuxArch.sh manual verbose` 
	opt=bloom 
	printf '\033]2;  bash setupTermuxArch.sh bloom 📲 \007'
	printf "\\n\\e[0;34m 🕛 > 🕛 \\e[1;34mTermuxArch $versionid bloom option.  Run \\e[1;32mbash setupTermuxArch.sh help \\e[1;34mfor additional information.  Ensure background data is not restricted.  Check the wireless connection if you do not see one o'clock 🕐 below.  "
	dependsblock "$@" 
	bloom 
}

introsysinfo() {
	printf '\033]2;  bash setupTermuxArch.sh sysinfo 📲 \007'
	printf "\\n\\e[0;34m 🕛 > 🕛 \\e[1;34msetupTermuxArch $versionid shall create a system information file.  Ensure background data is not restricted.  Run \\e[0;32mbash setupTermuxArch.sh help \\e[1;34mfor additional information.  Check the wireless connection if you do not see one o'clock 🕐 below.  "
	_PREPTERMUXARCH_
	dependsblock "$@" 
	sysinfo 
}

introrefresh() {
	printf '\033]2;  bash setupTermuxArch.sh refresh 📲 \007'
	_SETROOT_EXCEPTION_ 
	if [[ ! -d "$INSTALLDIR" ]] || [[ ! -f "$INSTALLDIR"/bin/env ]] || [[ ! -f "$INSTALLDIR"/bin/we ]] || [[ ! -d "$INSTALLDIR"/root/bin ]];then
		printf "\\n\\e[0;33m%s\\e[1;33m%s\\e[0;33m.\\e[0m\\n\\n" "The root directory structure is incorrect; Cannot continue " "setupTermuxArch.sh refresh"
		exit $?
	fi
	printf "\\n\\e[0;34m 🕛 > 🕛 \\e[1;34msetupTermuxArch $versionid shall refresh your TermuxArch files in \\e[0;32m$INSTALLDIR\\e[1;34m.  Ensure background data is not restricted.  Run \\e[0;32mbash setupTermuxArch.sh help \\e[1;34mfor additional information.  Check the wireless connection if you do not see one o'clock 🕐 below.  "
	dependsblock "$@" 
	refreshsys "$@"
}

introstnd() {
	printf '\033]2; %s\007' " bash setupTermuxArch.sh $args 📲 "
	_SETROOT_EXCEPTION_ 
	printf "\\n\\e[0;34m%s \\e[1;34m%s \\e[0;32m%s\\e[1;34m%s \\e[0;32m%s \\e[1;34m%s" " 🕛 > 🕛" "setupTermuxArch $versionid shall $introstndidstmt your TermuxArch files in" "$INSTALLDIR" ".  Ensure background data is not restricted.  Run " "bash setupTermuxArch.sh help" "for additional information.  Check the wireless connection if you do not see one o'clock 🕐 below.  "
}

introstndidstmt() { # depends $introstndid
	printf "the TermuxArch files in \\e[0;32m%s\\e[1;34m.  " "$INSTALLDIR"
}

lftpif() {
	dm=lftp
	if [[ -x "$(command -v lftp)" ]] && [[ -x "$PREFIX"/bin/lftp ]] ; then
		:
	else
		aptin+="lftp "
		maptin+=("lftp")
		apton+=("lftp")
	fi
}

lftpifdm() {
	if [[ "$dm" = lftp ]] ; then
		lftpif 
	fi
}

loadconf() {
	if [[ -f "${wdir}setupTermuxArchConfigs.sh" ]] ; then
		. "${wdir}setupTermuxArchConfigs.sh"
		_PRINTCONFLOADED_ 
	else
		. knownconfigurations.sh 
	fi
}

manual() {
	printf '\033]2; `bash setupTermuxArch.sh manual` 📲 \007'
	editors
	if [[ -f "${wdir}setupTermuxArchConfigs.sh" ]] ; then
		"$ed" "${wdir}setupTermuxArchConfigs.sh"
		. "${wdir}setupTermuxArchConfigs.sh"
		_PRINTCONFLOADED_ 
	else
		cp knownconfigurations.sh "${wdir}setupTermuxArchConfigs.sh"
 		sed -i "7s/.*/\# The architecture of this device is $CPUABI; Adjust configurations in the appropriate section.  Change mirror (https:\/\/wiki.archlinux.org\/index.php\/Mirrors and https:\/\/archlinuxarm.org\/about\/mirrors) to desired geographic location to resolve 404 and checksum issues.  /" "${wdir}setupTermuxArchConfigs.sh" 
		"$ed" "${wdir}setupTermuxArchConfigs.sh"
		. "${wdir}setupTermuxArchConfigs.sh"
		_PRINTCONFLOADED_ 
	fi
}

_NAMEINSTALLDIR_() {
	if [[ "$rootdir" = "" ]] ; then
		rootdir=arch
	fi
	INSTALLDIR="$(echo "$HOME/${rootdir%/}" |sed 's#//*#/#g')"
}

namestartarch() { # ${@%/} removes trailing slash
 	darch="$(echo "${rootdir%/}" |sed 's#//*#/#g')"
	if [[ "$darch" = "/arch" ]] ; then
		aarch=""
		startbi2=arch
	else
 		aarch="$(echo "$darch" |sed 's/\//\+/g')"
		startbi2=arch
	fi
	declare -g startbin=start"$startbi2$aarch"
}

_OPT2_() { 
	if [[ -z "${2:-}" ]] ; then
		_ARG2DIR_ "$@" 
	elif [[ "$2" = [Bb]* ]] ; then
		echo Setting mode to bloom. 
		introbloom "$@"  
	elif [[ "$2" = [Dd]* ]] || [[ "$2" = [Ss]* ]] ; then
		echo Setting mode to sysinfo.
		shift
		_ARG2DIR_ "$@" 
		introsysinfo "$@"  
	elif [[ "$2" = [Ii]* ]] ; then
		echo Setting mode to install.
		shift
		_ARG2DIR_ "$@" 
	elif [[ "$2" = [Mm]* ]] ; then
		echo Setting mode to manual.
		opt=manual
 		_OPT3_ "$@"  
	elif [[ "$2" = [Rr][Ee]* ]] ; then
		echo 
		echo Setting mode to refresh.
		shift 
		_ARG2DIR_ "$@" 
		introrefresh "$@"  
	elif [[ "$2" = [Rr]* ]] ; then
		lcr="1"
		printf "\\n\\e[1;32m%s\\e[1;34m: \\e[0;32m%s \`%s\` %s\\n\\e[0m" "Setting mode" "minimal refresh;  Use" "${0##*/} re[fresh]" "for full refresh."
		shift
		_ARG2DIR_ "$@" 
		introrefresh "$@"  
	else
		_ARG2DIR_ "$@" 
	fi
}

_OPT3_() { 
	if [[ -z "${3:-}" ]] ; then
		shift
		_ARG2DIR_ "$@" 
		intro "$@"  
	elif [[ "$3" = [Ii]* ]] ; then
		echo Setting mode to install.
		shift 2 
		_ARG2DIR_ "$@" 
		intro "$@"  
	elif [[ "$3" = [Rr][Ee]* ]] ; then
		echo 
		echo Setting mode to refresh.
		shift 2 
		_ARG2DIR_ "$@" 
		introrefresh "$@"  
	elif [[ "$3" = [Rr]* ]] ; then
		lcr="1"
		printf "\\n\\e[1;32m%s\\e[1;34m: \\e[0;32m%s \`%s\` %s\\n\\e[0m" "Setting mode" "minimal refresh;  Use" "${0##*/} re[fresh]" "for full refresh."
		shift 2 
		_ARG2DIR_ "$@" 
		introrefresh "$@"  
	else
		shift 
		_ARG2DIR_ "$@" 
		intro "$@"  
	fi
}

pe() {
	printf "\\n\\e[7;1;31m%s\\e[0;1;32m %s\\n\\n\\e[0m" "PREREQUISITE EXCEPTION!" "RUN ${0##*/} $args AGAIN…"
	printf "\\e]2;%s %s\\007" "RUN ${0##*/} $args" "AGAIN…"
	exit
}

pechk() {
	if [[ "$apton" != "" ]] ; then
		pe @apton
	fi
}

preptmpdir() { 
	mkdir -p "$INSTALLDIR/tmp"
	chmod 777 "$INSTALLDIR/tmp"
	chmod +t "$INSTALLDIR/tmp"
 	tampdir="$INSTALLDIR/tmp/setupTermuxArch$$"
	mkdir -p "$tampdir" 
}

_PREPTERMUXARCH_() { 
	_NAMEINSTALLDIR_ 
	namestartarch  
	preptmpdir
}

_PRINTCONFLOADED_() {
	printf "\\n\\e[0;34m%s \\e[1;34m%s \\e[0;32m%s\\e[1;32m%s \\e[1;34m%s \\e[1;32m%s\\n" " 🕛 > 🕑" "TermuxArch configuration" "$wdir" "setupTermuxArchConfigs.sh" "loaded:" "OK"
}

printsha512syschker() {
	printf "\\n\\e[07;1m\\e[31;1m\\n%s \\e[34;1m\\e[30;1m%s \\n\\e[0;0m\\n" " 🔆 WARNING sha512sum mismatch!  Setup initialization mismatch!" "  Try again, initialization was not successful this time.  Wait a little while.  Then run \`bash setupTermuxArch.sh\` again…"
	printf '\033]2; Run `bash setupTermuxArch.sh %s` again…\007' "$args" 
	exit 
}

printstartbinusage() {
	printf "\\n\\e[1;32m" 
 	namestartarch "$@"  
	if [[ -x "$(command -v "$startbin")" ]] ; then
		echo "$startbin" help 
		"$startbin" help 
	fi
}

_PRINTUSAGE_() {
	printf "\\n\\e[1;33m %s     \\e[0;32m%s \\e[1;34m%s\\n" "HELP" "${0##*/} help" "shall output the help screen." 
	printf "\\n\\e[1;33m %s    \\e[0;32m%s \\e[1;34m%s\\n" "TERSE" "${0##*/} he[lp]" "shall output the terse help screen." 
	printf "\\n\\e[1;33m %s  \\e[0;32m%s \\e[1;34m%s\\n" "VERBOSE" "${0##*/} h" "shall output the verbose help screen." 
	printf "\\n\\e[1;34m%s \\e[0;32m%s \\e[1;34m%s \\e[0;32m%s \\e[1;34m%s \\e[0;32m%s \\e[1;34m%s \\e[0;32m%s \\e[1;34m%s \\n\\n%s \\e[0;32m%s\\e[1;34m%s \\e[0;32m%s \\e[1;34m%s \\e[0;32m%s \\e[1;34m%s \\e[0;32m%s\\e[1;34m%s\\n" "Usage information for" "${0##*/}" "$versionid.  Arguments can abbreviated to one, two and three letters each; Two and three letter arguments are acceptable.  For example," "bash ${0##*/} cs" "shall use" "curl" "to download TermuxArch and produce a" "setupTermuxArchSysInfo$STIME.log" "system information file." "User configurable variables are in" "setupTermuxArchConfigs.sh" ".  To create this file from" "kownconfigurations.sh" "in the working directory, run" "bash ${0##*/} manual" "to create and edit" "setupTermuxArchConfigs.sh" "." 
	printf "\\n\\e[1;33m %s\\e[1;34m  %s \\e[0;32m%s \\e[1;34m%s \\e[0;32m%s \\e[1;34m%s \\e[0;32m%s \\e[1;34m%s \\e[0;32m%s \\e[1;34m%s \\e[0;32m%s \\e[1;34m%s \\e[0;32m%s \\e[1;34m%s \\e[0;32m%s\\e[1;34m%s \\e[0;32m%s \\e[1;34m%s \\e[0;32m%s \\e[1;34m%s\\n" "INSTALL" "Run" "./${0##*/}" "without arguments in a bash shell to install Arch Linux in Termux.  " "bash ${0##*/} curl" "shall envoke" "curl" "as the download manager.  Copy" "knownconfigurations.sh" "to" "setupTermuxArchConfigs.sh" "with" "bash ${0##*/} manual" "to edit preferred mirror site and to access more options.  After editing" "setupTermuxArchConfigs.sh" ", run" "bash ${0##*/}" "and" "setupTermuxArchConfigs.sh" "loads automatically from the working directory.  Change mirror to desired geographic location to resolve download errors." 
 	printf "\\n\\e[1;33m %s    \\e[0;32m%s \\e[1;34m%s\\n" "PURGE" "${0##*/} purge" "shall uninstall Arch Linux from Termux." 
	printf "\\n\\e[1;33m %s  \\e[0;32m%s \\e[1;34m%s \\e[0;32m%s \\e[1;34m%s \\e[0;32m%s\\e[1;34m%s \\n\\n" "SYSINFO" "${0##*/} sysinfo" "shall create" "setupTermuxArchSysInfo$STIME.log" "and populate it with system information.  Post this file along with detailed information at" "https://github.com/sdrausty/TermuxArch/issues" ".  If screenshots will help in resolving an issue better, include these along with information from the system information log file in a post as well." 
	if [[ "$lcc" = 1 ]] ; then
	printf "\\n\\e[1;32m" 
	awk 'NR>=639 && NR<=776'  "${0##*/}" | awk '$1 == "##"' | awk '{ $1 = ""; print }' | awk '1;{print ""}'
	fi
	printstartbinusage
}

prootif() {
	if [[ -x "$(command -v proot)" ]] &&  [[ -x "$PREFIX"/bin/proot ]] ; then
		:
	else
		aptin+="proot "
		maptin+=("proot")
		apton+=("proot")
	fi
}

rmarch() {
	namestartarch 
	_NAMEINSTALLDIR_
	while true; do
		printf "\\n\\e[1;30m"
		read -n 1 -p "Uninstall $INSTALLDIR? [Y|n] " ruanswer
		if [[ "$ruanswer" = [Ee]* ]] || [[ "$ruanswer" = [Nn]* ]] || [[ "$ruanswer" = [Qq]* ]] ; then
			break
		elif [[ "$ruanswer" = [Yy]* ]] || [[ "$ruanswer" = "" ]] ; then
			printf "\\e[30mUninstalling $INSTALLDIR…\\n"
			if [[ -e "$PREFIX/bin/$startbin" ]] ; then
				rm -f "$PREFIX/bin/$startbin" 
			else 
				printf "Uninstalling $PREFIX/bin/$startbin: nothing to do for $PREFIX/bin/$startbin.\\n"
			fi
			if [[ -e "$HOME/bin/$startbin" ]] ; then
				rm -f "$HOME/bin/$startbin" 
			else 
				printf "Uninstalling $HOME/bin/$startbin: nothing to do for $HOME/bin/$startbin.\\n"
			fi
			if [[ -d "$INSTALLDIR" ]] ; then
				rmarchrm 
			else 
				printf "Uninstalling $INSTALLDIR: nothing to do for $INSTALLDIR.\\n"
			fi
			printf "Uninstalling $INSTALLDIR: \\e[1;32mDone\\n\\e[30m"
			break
		else
			printf "\\nYou answered \\e[33;1m$ruanswer\\e[30m.\\n\\nAnswer \\e[32mYes\\e[30m or \\e[1;31mNo\\e[30m. [\\e[32my\\e[30m|\\e[1;31mn\\e[30m]\\n"
		fi
	done
	printf "\\e[0m\\n"
}

rmarchrm() {
	_SETROOT_EXCEPTION_ 
	rm -rf "${INSTALLDIR:?}"/* 2>/dev/null ||:
	find  "$INSTALLDIR" -type d -exec chmod 700 {} \; 2>/dev/null ||:
	rm -rf "$INSTALLDIR" 2>/dev/null ||:
}

rmarchq() {
	if [[ -d "$INSTALLDIR" ]] ; then
		printf "\\n\\e[0;33m %s \\e[1;33m%s \\e[0;33m%s\\n\\n\\e[1;30m%s\\n" "TermuxArch:" "DIRECTORY WARNING!  $INSTALLDIR/" "directory detected." "Purge $INSTALLDIR as requested?"
		rmarch
	fi
}

tapin() {
	if [[ "$aptin" != "" ]] ; then
		printf "\\n\\e[1;34mInstalling \\e[0;32m%s\\b\\e[1;34m…\\n\\n\\e[1;32m" "$aptin"
		pkg install "$aptin" -o APT::Keep-Downloaded-Packages="true" --yes 
		printf "\\n\\e[1;34mInstalling \\e[0;32m%s\\b\\e[1;34m: \\e[1;32mDONE\\n\\e[0m" "$aptin"
	fi
}

_SETROOT_EXCEPTION_() {
	if [[ "$INSTALLDIR" = "$HOME" ]] || [[ "$INSTALLDIR" = "$HOME"/ ]] || [[ "$INSTALLDIR" = "$HOME"/.. ]] || [[ "$INSTALLDIR" = "$HOME"/../ ]] || [[ "$INSTALLDIR" = "$HOME"/../.. ]] || [[ "$INSTALLDIR" = "$HOME"/../../ ]] ; then
		printf  '\033]2;%s\007' "Rootdir exception.  Run bash setupTermuxArch.sh $args again with different options…"	
		printf "\\n\\e[1;31m%s\\n\\n\\e[0m" "Rootdir exception.  Run the script $args again with different options…"
		exit
	fi
}

_SETROOT_() {
	if [[ "$CPUABI" = "$CPUABIX86" ]] ; then
	#	rootdir=/root.i686
		rootdir=/arch
	elif [[ "$CPUABI" = "$CPUABIX86_64" ]] ; then
	#	rootdir=/root.x86_64
		rootdir=/arch
	else
		rootdir=/arch
	fi
}

standardid() {
	introstndid="$1" 
	introstndidstmt="$(printf "%s \\e[0;32m%s" "$1 the TermuxArch files in" "$INSTALLDIR")" 
	introstnd
}

_STANDARDIF_() {
	if [[ -x "$(command -v proot)" ]] &&  [[ -x "$PREFIX"/bin/proot ]] ; then
		:
	else
		aptin+="proot "
		maptin+=("proot")
		apton+=("proot")
	fi
}

_TRPERROR_() { # Run on script error.
	local rv="$?"
	printf "\\e[?25h\\n\\e[1;48;5;138m %s\\e[0m\\n\\n" "TermuxArch WARNING:  Generated script signal ${rv:-unknown} near or at line number ${1:-unknown} by \`${2:-command}\`!"
	exit 201
}

_TRPEXIT_() { # Run on exit.
	local rv="$?"
  	printf "\\a\\a\\a\\a"
	sleep 0.4
	if [[ "$rv" = 0 ]] ; then
		printf "\\a\\e[0;32m%s %s \\a\\e[0m$versionid\\e[1;34m: \\a\\e[1;32m%s\\e[0m\\n\\n\\a\\e[0m" "${0##*/}" "$args" "DONE 🏁"
		printf "\\e]2; %s: %s \007" "${0##*/} $args" "DONE 🏁"
	else
		printf "\\a\\e[0;32m%s %s \\a\\e[0m$versionid\\e[1;34m: \\a\\e[1;32m%s %s\\e[0m\\n\\n\\a\\e[0m" "${0##*/}" "$args" "(Exit Signal $rv)" "DONE 🏁"
		printf "\033]2; %s: %s %s \007" "${0##*/} $args" "(Exit Signal $rv)" "DONE 🏁"
	fi
	printf "\\e[?25h\\e[0m"
	rm -rf "$tampdir"
	set +Eeuo pipefail 
	exit
}

_TRPSIGNAL_() { # Run on signal.
	printf "\\e[?25h\\e[1;7;38;5;0mTermuxArch WARNING:  Signal $? received!\\e[0m\\n"
	rm -rf "$tampdir"
 	exit 211 
}

_TRPQUIT_() { # Run on quit.
	printf "\\e[?25h\\e[1;7;38;5;0mTermuxArch WARNING:  Quit signal $? received!\\e[0m\\n"
	rm -rf "$tampdir"
 	exit 221 
}

wgetif() {
	dm=wget 
	if [[ ! -x "$PREFIX"/bin/wget ]] ; then
		aptin+="wget "
		maptin+=("wget")
		apton+=("wget")
	fi
}

wgetifdm() {
	if [[ "$dm" = wget ]] ; then
		wgetif 
	fi
}

## User Information: 
## Configurable variables such as mirrors and download manager options are in `setupTermuxArchConfigs.sh`.  Working with `kownconfigurations.sh` in the working directory is simple.  `bash setupTermuxArch.sh manual` shall create `setupTermuxArchConfigs.sh` in the working directory for editing; See `setupTermuxArch.sh help` for more information.  
declare -a ADM=("aria2" "axel" "curl" "lftp" "wget")
declare -a ATM=("wget" "$PREFIX/applets/tar" "tar")
declare -a args="$@"
declare aptin=""	## apt string
declare apton=""	## exception string
declare commandif=""
declare CPUABI=""
declare CPUABI5="armeabi"
declare CPUABI7="armeabi-v7a"
declare CPUABI8="arm64-v8a"
declare CPUABIX86="x86"
declare CPUABIX86_64="x86_64"
declare dfl=""	## Used for development.  
declare dm="wget"	## download manager
declare dmverbose="-q"	## -v for verbose download manager output from curl and wget;  for verbose output throughout runtime also change in `setupTermuxArchConfigs.sh` when using `setupTermuxArch.sh manual`. 
declare	ed=""
declare INSTALLDIR=""
declare lcc=""
declare lcp=""
declare opt=""
declare rootdir=""
declare wdir="$PWD/"
declare sti=""		## Generates pseudo random number.
declare STIME=""	## Generates pseudo random number.
declare tm=""		## tar manager
trap '_TRPERROR_ $LINENO $BASH_COMMAND $?' ERR 
trap _TRPEXIT_ EXIT
trap _TRPSIGNAL_ HUP INT TERM 
trap _TRPQUIT_ QUIT 
if [[ -z "${tampdir:-}" ]] ; then
	tampdir=""
fi
_SETROOT_
commandif="$(command -v getprop)" ||:
if [[ "$commandif" = "" ]] ; then
	printf "\\n\\e[1;48;5;138m %s\\e[0m\\n\\n" "TermuxArch WARNING: Run \`bash ${0##*/}\` or \`./${0##*/}\` from the BASH shell in the OS system in Termux, i.e. Amazon Fire, Android and Chromebook."
	exit
fi
## Generates pseudo random number to create uniq strings.
if [[ -f  /proc/sys/kernel/random/uuid ]] ; then
	sti="$(cat /proc/sys/kernel/random/uuid)"
	stim="${sti//-}"	
	STIME="${stim:0:3}"	
else
	sti="$(date +%s)" 
	STIME="$(echo "${sti:7:4}"|rev)" 
fi
oned="$(date +%s)" 
oneda="${oned: -1}" 
STIME="$oneda$STIME"
## Gets information with `getprop` about device.
CPUABI="$(getprop ro.product.cpu.abi)" 
## OPTIONS STATUS: UNDERGOING TESTING;  Image file and compound options are still under development.  USE WITH CAUTION!  IMPORTANT NOTE: CURRENTLY ONLY curl AND wget ARE THOROUGHLY TESTED.   All the download managers are NOT yet fully implemented.   
## GRAMMAR: `setupTermuxArch.sh [HOW] [WHAT] [WHERE]`; all options are optional for network install.  AVAILABLE OPTIONS: `setupTermuxArch.sh [HOW] [WHAT] [WHERE]` and `setupTermuxArch.sh [~/|./|/absolute/path/]systemimage.tar.gz [WHERE]`.  
## SYNTAX: [HOW (aria2c|axel|curl|lftp|wget (default 1: available on system (default 2: wget)))]  [WHAT (install|manual|purge|refresh|sysinfo (default: install))] [WHERE (default: arch)]  Defaults are implied and can be omitted.  
## USAGE EXAMPLES: `setupTermuxArch.sh wget sysinfo` will use wget as the download manager and produce a system information file in the working directory.  This can be abbreviated to `setupTermuxArch.sh ws` and `setupTermuxArch.sh w s`. Similarly, `setupTermuxArch.sh wget manual customdir` will attempt to install the installation in customdir with wget and use manual mode during instalation.  Also, `setupTermuxArch.sh wget refresh customdir` shall refresh this installation using wget as the download manager. 
## <<<<<<<<<<<<>>>>>>>>>>>>
## << Enumerated Options >>
## <<<<<<<<<<<<>>>>>>>>>>>>
## []  Run default Arch Linux install. 
if [[ -z "${1:-}" ]] ; then
	_PREPTERMUXARCH_ 
	intro "$@" 
## [./path/systemimage.tar.gz [customdir]]  Use path to system image file; install directory argument is optional. A systemimage.tar.gz file can be substituted for network install: `setupTermuxArch.sh ./[path/]systemimage.tar.gz` and `setupTermuxArch.sh /absolutepath/systemimage.tar.gz`. 
elif [[ "${args:0:1}" = . ]] ; then
 	echo
 	echo Setting mode to copy system image.
 	lcc="1"
 	lcp="1"
 	_ARG2DIR_ "$@"  
 	intro "$@" 
## [systemimage.tar.gz [customdir]]  Install directory argument is optional.  A systemimage.tar.gz file can substituted for network install.  
# elif [[ "${wdir}${args}" = *.tar.gz* ]] ; then
elif [[ "$args" = *.tar.gz* ]] ; then
	echo
	echo Setting mode to copy system image.
	lcc="1"
	lcp="0"
	_ARG2DIR_ "$@"  
	intro "$@" 
## [axd|axs]  Get device system information with `axel`.
elif [[ "${1//-}" = [Aa][Xx][Dd]* ]] || [[ "${1//-}" = [Aa][Xx][Ss]* ]] ; then
	echo
	echo Getting device system information with \`axel\`.
	dm=axel
	shift
	_ARG2DIR_ "$@" 
	introsysinfo "$@" 
## [ax[el] [customdir]|axi [customdir]]  Install Arch Linux with `axel`.
elif [[ "${1//-}" = [Aa][Xx]* ]] || [[ "${1//-}" = [Aa][Xx][Ii]* ]] ; then
	echo
	echo Setting \`axel\` as download manager.
	dm=axel
	_OPT2_ "$@" 
	intro "$@" 
## [ad|as]  Get device system information with `aria2c`.
elif [[ "${1//-}" = [Aa][Dd]* ]] || [[ "${1//-}" = [Aa][Ss]* ]] ; then
	echo
	echo Getting device system information with \`aria2c\`.
	dm=aria2c
	shift
	_ARG2DIR_ "$@" 
	introsysinfo "$@" 
## [a[ria2c] [customdir]|ai [customdir]]  Install Arch Linux with `aria2c`.
elif [[ "${1//-}" = [Aa]* ]] ; then
	echo
	echo Setting \`aria2c\` as download manager.
	dm=aria2c
	_OPT2_ "$@" 
	intro "$@" 
## [b[loom]]  Create and run a local copy of TermuxArch in TermuxArchBloom.  Useful for running a customized setupTermuxArch.sh locally, for developing and hacking TermuxArch.  
elif [[ "${1//-}" = [Bb]* ]] ; then
	echo
	echo Setting mode to bloom. 
	introbloom "$@"  
## [cd|cs]  Get device system information with `curl`.
elif [[ "${1//-}" = [Cc][Dd]* ]] || [[ "${1//-}" = [Cc][Ss]* ]] ; then
	echo
	echo Getting device system information with \`curl\`.
	dm=curl
	shift
	_ARG2DIR_ "$@" 
	introsysinfo "$@" 
## [c[url] [customdir]|ci [customdir]]  Install Arch Linux with `curl`.
elif [[ "${1//-}" = [Cc][Ii]* ]] || [[ "${1//-}" = [Cc]* ]] ; then
	echo
	echo Setting \`curl\` as download manager.
	dm=curl
	_OPT2_ "$@" 
	intro "$@" 
## [d[ebug]|s[ysinfo]]  Generate system information.
elif [[ "${1//-}" = [Dd]* ]] || [[ "${1//-}" = [Ss]* ]] ; then
	echo 
	echo Setting mode to sysinfo.
	shift
	_ARG2DIR_ "$@" 
	introsysinfo "$@" 
## [he[lp]|?]  Display terse builtin help.
elif [[ "${1//-}" = [Hh][Ee]* ]] || [[ "${1//-}" = [?]* ]] ; then
	_ARG2DIR_ "$@" 
	_PRINTUSAGE_ "$@"  
## [h|?]  Display verbose builtin help.
elif [[ "${1//-}" = [Hh]* ]] ; then
	lcc="1"
	_ARG2DIR_ "$@" 
	_PRINTUSAGE_ "$@"  
## [i[nstall] [customdir]]  Install Arch Linux in a custom directory.  Instructions: Install in userspace. $HOME is appended to installation directory. To install Arch Linux in $HOME/customdir use `bash setupTermuxArch.sh install customdir`. In bash shell use `./setupTermuxArch.sh install customdir`.  All options can be abbreviated to one, two and three letters.  Hence `./setupTermuxArch.sh install customdir` can be run as `./setupTermuxArch.sh i customdir` in BASH.
elif [[ "${1//-}" = [Ii]* ]] ; then
	echo
	echo Setting mode to install.
	_OPT2_ "$@" 
	intro "$@"  
## [ld|ls]  Get device system information with `lftp`.
elif [[ "${1//-}" = [Ll][Dd]* ]] || [[ "${1//-}" = [Ll][Ss]* ]] ; then
	echo
	echo Getting device system information with \`lftp\`.
	dm=lftp
	shift
	_ARG2DIR_ "$@" 
	introsysinfo "$@" 
## [l[ftp] [customdir]]  Install Arch Linux with `lftp`.
elif [[ "${1//-}" = [Ll]* ]] ; then
	echo
	echo Setting \`lftp\` as download manager.
	dm=lftp
	_OPT2_ "$@" 
	intro "$@" 
## [m[anual]]  Manual Arch Linux install, useful for resolving download issues.
elif [[ "${1//-}" = [Mm]* ]] ; then
	echo
	echo Setting mode to manual.
	opt=manual
	_OPT2_ "$@" 
	intro "$@"  
## [o[ption]]  Option currently under development.
elif [[ "${1//-}" = [Oo]* ]] ; then
	echo
	echo Setting mode to option.
	_PRINTUSAGE_
	_OPT2_ "$@" 
## [p[urge] [customdir]|u[ninstall] [customdir]]  Remove Arch Linux.
elif [[ "${1//-}" = [Pp]* ]] || [[ "${1//-}" = [Uu]* ]] ; then
	echo 
	echo Setting mode to purge.
	_ARG2DIR_ "$@" 
	rmarchq
## [r[e[fresh]] [customdir]]  Refresh the Arch Linux in Termux PRoot scripts created by TermuxArch and the installation itself.  Useful for refreshing the installation, locales and the TermuxArch generated scripts to their newest versions.  
elif [[ "${1//-}" = [Rr][Ee]* ]] ; then
	echo 
	echo Setting mode to refresh.
	_ARG2DIR_ "$@" 
	introrefresh "$@"  
elif [[ "${1//-}" = [Rr]* ]] ; then
	lcr="1"
	printf "\\n\\e[1;32m%s\\e[1;34m: \\e[0;32m%s \`%s\` %s\\n\\e[0m" "Setting mode" "minimal refresh;  Use" "${0##*/} re[fresh]" "for full refresh."
	_ARG2DIR_ "$@" 
	introrefresh "$@"  
## [wd|ws]  Get device system information with `wget`.
elif [[ "${1//-}" = [Ww][Dd]* ]] || [[ "${1//-}" = [Ww][Ss]* ]] ; then
	echo
	echo Getting device system information with \`wget\`.
	dm=wget
	shift
	_ARG2DIR_ "$@" 
	introsysinfo "$@" 
## [w[get] [customdir]]  Install Arch Linux with `wget`.
elif [[ "${1//-}" = [Ww]* ]] ; then
	echo
	echo Setting \`wget\` as download manager.
	dm=wget
	_OPT2_ "$@" 
	intro "$@"  
else
	_PRINTUSAGE_
fi

## EOF
