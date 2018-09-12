#!/bin/env bash
# Copyright 2017-2018 by SDRausty. All rights reserved.  🌎 🌍 🌏 🌐 🗺
# Hosting https://sdrausty.github.io/TermuxArch courtesy https://pages.github.com
# https://sdrausty.github.io/TermuxArch/CONTRIBUTORS Thank you for your help.  
# https://sdrausty.github.io/TermuxArch/README has information about this project. 
################################################################################

LC_TYPE=( "LANG" "LANGUAGE" "LC_ADDRESS" "LC_COLLATE" "LC_CTYPE" "LC_IDENTIFICATION" "LC_MEASUREMENT" "LC_MESSAGES" "LC_MONETARY" "LC_NAME" "LC_NUMERIC" "LC_PAPER" "LC_TELEPHONE" "LC_TIME" )

_CALLSYSTEM() {
	declare COUNTER=""
	if [[ "$CPUABI" = "$CPUABIX86" ]] || [[ "$CPUABI" = "$CPUABIX86_64" ]];then
		getimage
	else
		if [[ "$mirror" = "os.archlinuxarm.org" ]] || [[ "$mirror" = "mirror.archlinuxarm.org" ]]; then
			until ftchstnd;do
				ftchstnd ||: 
				sleep 2
				printf "\\n"
				COUNTER=$((COUNTER + 1))
				if [[ "$COUNTER" = 4 ]];then 
					_PRINTMAX_ 
					exit
				fi
			done
		else
			ftchit
		fi
	fi
}

copystartbin2path() {
	if [[ ":$PATH:" == *":$HOME/bin:"* ]] && [[ -d "$HOME"/bin ]]; then
		BPATH="$HOME"/bin
	else
		BPATH="$PREFIX"/bin
	fi
	cp "$INSTALLDIR/$startbin" "$BPATH"
	printf "\\e[0;34m 🕛 > 🕦 \\e[1;32m$startbin \\e[0mcopied to \\e[1m$BPATH\\e[0m.\\n\\n"
}

detectsystem() {
	printdetectedsystem
	if [[ "$CPUABI" = "$CPUABI5" ]];then
		armv5l
	elif [[ "$CPUABI" = "$CPUABI7" ]];then
		detectsystem2 
	elif [[ "$CPUABI" = "$CPUABI8" ]];then
		aarch64
	elif [[ "$CPUABI" = "$CPUABIX86" ]];then
		i686 
	elif [[ "$CPUABI" = "$CPUABIX86_64" ]];then
		x86_64
	else
		_PRINTMISMATCH_ 
	fi
}

detectsystem2() {
	if [[ "$(getprop ro.product.device)" == *_cheets ]];then
		armv7lChrome 
	else
		armv7lAndroid  
	fi
}

lkernid() {
	declare kid=""
	ur="$("$PREFIX"/bin/applets/uname -r)"
	declare -i KERNEL_VERSION="$(echo "$ur" |awk -F'.' '{print $1}')"
	declare -i MAJOR_REVISION="$(echo "$ur" |awk -F'.' '{print $2}')"
	declare -- tmp="$(echo "$ur" |awk -F'.' '{print $3}')"
	declare -- MINOR_REVISION="$(echo "${tmp:0:3}" |sed 's/[^0-9]*//g')"
	if [[ "$KERNEL_VERSION" -le 2 ]]; then
		kid=1
	else
		if [[ "$KERNEL_VERSION" -eq 3 ]]; then
			if [[ "$MAJOR_REVISION" -lt 2 ]]; then
				kid=1
			else
				if [[ "$MAJOR_REVISION" -eq 2 ]] && [[ "$MINOR_REVISION" -eq 0 ]]; then
					kid=1
				fi
			fi
		fi
	fi
}

lkernid 

mainblock() { 
	namestartarch 
	spaceinfo
	_PREPINSTALLDIR
	detectsystem 
	wakeunlock 
	_PRINTFOOTER_
	"$INSTALLDIR/$startbin" ||:
	printstartbinusage
	_PRINTFOOTER2_
}

makefinishsetup() {
	binfnstp=finishsetup.sh  
	_CFLHDR root/bin/"$binfnstp"
	cat >> root/bin/"$binfnstp" <<- EOM
versionid="v1.6 id1294"
	printf "\\n\\e[0;32m%s\\e[1;32m%s\\e[0;32m%s\\e[1;32m%s\\e[0;32m%s\\n\\n\\e[1;32m%s\\e[0;32m" "To generate locales in a preferred language, you can use " "Settings > Language & Keyboard > Language " "in Android.  Then run " "${0##*/} r " "for a quick system refresh." "==> "
   	locale-gen ||:
	printf "\\n\\e[1;34m:: \\e[1;37mRemoving redundant packages for Termux PRoot installation…\\n"
	EOM
	if [[ -e "$HOME"/.bash_profile ]];then
		grep "proxy" "$HOME"/.bash_profile | grep "export" >> root/bin/"$binfnstp" 2>/dev/null ||:
	fi
	if [[ -e "$HOME"/.bashrc ]];then
		grep "proxy" "$HOME"/.bashrc  | grep "export" >> root/bin/"$binfnstp" 2>/dev/null ||:
	fi
	if [[ -e "$HOME"/.profile ]];then
		grep "proxy" "$HOME"/.profile | grep "export" >> root/bin/"$binfnstp" 2>/dev/null ||:
	fi
	if [[ -z "${lcr:-}" ]] ; then
	 	if [[ "$CPUABI" = "$CPUABI5" ]];then
	 		printf "pacman -Rc linux-armv5 linux-firmware --noconfirm --color=always 2>/dev/null ||:\\n" >> root/bin/"$binfnstp"
	 	elif [[ "$CPUABI" = "$CPUABI7" ]];then
	 		printf "pacman -Rc linux-armv7 linux-firmware --noconfirm --color=always 2>/dev/null ||:\\n" >> root/bin/"$binfnstp"
	 	elif [[ "$CPUABI" = "$CPUABI8" ]];then
	 		printf "pacman -Rc linux-aarch64 linux-firmware --noconfirm --color=always 2>/dev/null ||:\\n" >> root/bin/"$binfnstp"
	 	fi
		if [[ "$CPUABI" = "$CPUABIX86" ]];then
			printf "./root/bin/keys x86\\n" >> root/bin/"$binfnstp"
		elif [[ "$CPUABI" = "$CPUABIX86_64" ]];then
			printf "./root/bin/keys x86_64\\n" >> root/bin/"$binfnstp"
		else
	 		printf "./root/bin/keys\\n" >> root/bin/"$binfnstp"
		fi
		if [[ "$CPUABI" = "$CPUABIX86" ]] || [[ "$CPUABI" = "$CPUABIX86_64" ]];then
			printf "./root/bin/pci gzip sed \\n" >> root/bin/"$binfnstp"
		else
	 		printf "./root/bin/pci \\n" >> root/bin/"$binfnstp"
		fi
	fi
	cat >> root/bin/"$binfnstp" <<- EOM
	printf "\\n\\e[1;34m%s  \\e[0m" "🕛 > 🕤 Arch Linux in Termux is installed and configured 📲 " 
	printf "\\e]2;%s\\007" " 🕛 > 🕤 Arch Linux in Termux is installed and configured 📲 "
	EOM
	chmod 770 root/bin/"$binfnstp" 
}

makesetupbin() {
	_CFLHDR root/bin/setupbin.sh 
	cat >> root/bin/setupbin.sh <<- EOM
versionid="v1.6 id1294"
	unset LD_PRELOAD
	EOM
	echo "$prootstmnt /root/bin/finishsetup.sh ||:" >> root/bin/setupbin.sh 
	chmod 700 root/bin/setupbin.sh
}

makestartbin() {
	_CFLHDR "$startbin" 
	cat >> "$startbin" <<- EOM
versionid="v1.6 id1294"
	unset LD_PRELOAD
	declare -g ar2ar="\${@:2}"
	declare -g ar3ar="\${@:3}"
	_PRINTUSAGE_() { 
	printf "\\n\\e[0;32mUsage:  \\e[1;32m$startbin \\e[0;32mStart Arch Linux as root.  This account should only be reserved for system administration.\\n\\n	\\e[1;32m$startbin command command \\e[0;32mRun Arch Linux command from Termux as root user.\\n\\n	\\e[1;32m$startbin login user \\e[0;32mLogin as user.  Use \\e[1;32maddauser user \\e[0;32mfirst to create a user and the user's home directory.\\n\\n	\\e[1;32m$startbin raw \\e[0;32mConstruct the \\e[1;32mstartarch \\e[0;32mproot statement.  For example \\e[1;32mstartarch raw su - user \\e[0;32mwill login to Arch Linux as user.  Use \\e[1;32maddauser user \\e[0;32mfirst to create a user and the user's home directory.\\n\\n	\\e[1;32m$startbin su user command \\e[0;32mLogin as user and execute command.  Use \\e[1;32maddauser user \\e[0;32mfirst to create a user and the user's home directory.\\n\\n\\e[0m"'\033]2; TermuxArch '$startbin' help 📲  \007' 
	}

	# [] Default Arch Linux in Termux PRoot root login.
	if [[ -z "\${1:-}" ]];then
	EOM
		echo "$prootstmnt /bin/bash -l  " >> "$startbin"
	cat >> "$startbin" <<- EOM
		printf '\033]2; TermuxArch $startbin 📲  \007'
	# [?|help] Displays usage information.
	elif [[ "\$1" = [?]* ]] || [[ "\$1" = -[?]* ]] || [[ "\$1" = --[?]* ]] || [[ "\$1" = [Hh]* ]] || [[ "\$1" = -[Hh]* ]] || [[ "\$1" = --[Hh]* ]];then
		_PRINTUSAGE_
	# [command args] Execute a command in BASH as root.
	elif [[ "\$1" = [Cc]* ]] || [[ "\$1" = -[Cc]* ]] || [[ "\$1" = --[Cc]* ]];then
		printf '\033]2; $startbin command args 📲  \007'
		touch $INSTALLDIR/root/.chushlogin
	EOM
		echo "$prootstmnt /bin/bash -lc \"\$ar2ar\" " >> "$startbin"
	cat >> "$startbin" <<- EOM
		printf '\033]2; $startbin command args 📲  \007'
		rm -f $INSTALLDIR/root/.chushlogin
	# [login user|login user [options]] Login as user [plus options].  Use \`addauser user\` first to create this user and the user's home directory.
	elif [[ "\$1" = [Ll]* ]] || [[ "\$1" = -[Ll]* ]] || [[ "\$1" = --[Ll]* ]] || [[ "\$1" = [Uu]* ]] || [[ "\$1" = -[Uu]* ]] || [[ "\$1" = --[Uu]* ]] ;then
		printf '\033]2; $startbin login user [options] 📲  \007'
	EOM
		echo "$prootstmnt /bin/su - \"\$ar2ar\" " >> "$startbin"
	cat >> "$startbin" <<- EOM
		printf '\033]2; $startbin login user [options] 📲  \007'
	# [raw args] Construct the \`startarch\` proot statement.  For example \`startarch r su - archuser\` will login as user archuser.  Use \`addauser user\` first to create this user and the user home directory.
	elif [[ "\$1" = [Rr]* ]] || [[ "\$1" = -[Rr]* ]] || [[ "\$1" = --[Rr]* ]];then
		printf '\033]2; $startbin raw args 📲  \007'
	EOM
		echo "$prootstmnt /bin/\"\$ar2ar\" " >> "$startbin"
	cat >> "$startbin" <<- EOM
		printf '\033]2; $startbin raw args 📲  \007'
	# [su user command] Login as user and execute command.  Use \`addauser user\` first to create this user and the user's home directory.
	elif [[ "\$1" = [Ss]* ]] || [[ "\$1" = -[Ss]* ]] || [[ "\$1" = --[Ss]* ]];then
		printf '\033]2; $startbin su user command 📲  \007'
		if [[ "\$2" = root ]];then
			touch $INSTALLDIR/root/.chushlogin
		else
			touch $INSTALLDIR/home/"\$2"/.chushlogin
		fi
	EOM
		echo "$prootstmnt /bin/su - \"\$2\" -c \"\$ar3ar\" " >> "$startbin"
	cat >> "$startbin" <<- EOM
		printf '\033]2; $startbin su user command 📲  \007'
		if [[ "\$2" = root ]];then
			rm -f $INSTALLDIR/root/.chushlogin
		else
			rm -f $INSTALLDIR/home/"\$2"/.chushlogin
		fi
	else
		_PRINTUSAGE_
	fi
	EOM
	chmod 700 "$startbin"
}

makesystem() {
	wakelock
	_CALLSYSTEM
	_PRINTMD5CHECK_
	md5check
	_PRINTCU_ 
	rm -f "$INSTALLDIR"/*.tar.gz "$INSTALLDIR"/*.tar.gz.md5
	_PRINTDONE_ 
	_PRINTCONFIGUP_ 
	touchupsys 
}

md5check() {
	if "$PREFIX"/bin/applets/md5sum -c "$file".md5 1>/dev/null ; then
		_PRINTMD5SUCCESS_
		printf "\\e[0;32m"
		preproot ## & spinner "Unpacking" "$file…" 
	else
		rm -f "$INSTALLDIR"/*.tar.gz "$INSTALLDIR"/*.tar.gz.md5
		_PRINTMD5ERROR_
	fi
}

_PREPROOTDIR() {
	cd "$INSTALLDIR"
	mkdir -p etc 
	mkdir -p var/binds 
	mkdir -p root/bin
	mkdir -p usr/bin
}

_PREPINSTALLDIR() {
	_PREPROOTDIR
	_SETLANGUAGE_
	addREADME
	addae
	addauser
	addbash_logout 
	addbash_profile 
	addbashrc 
	addcdtd
	addcdth
	addcdtmp
	addch 
	adddfa
	addfbindexample
	addbinds
	addexd
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
	addtour
	addtrim 
	addyt
	addwe  
	addv 
	makefinishsetup
	makesetupbin 
	makestartbin 
}

preproot() {
	if [[ "$(ls -al "$INSTALLDIR"/*z | awk '{ print $5 }')" -gt 557799 ]] ; then
		if [[ "$CPUABI" = "$CPUABIX86" ]] || [[ "$CPUABI" = "$CPUABIX86_64" ]];then
	 		proot --link2symlink -0 bsdtar -xpf "$file" --strip-components 1  
		else
	 		proot --link2symlink -0 "$PREFIX"/bin/applets/tar -xpf "$file" 
		fi
	else
		printf "\\n\\n\\e[1;31m%s \\e[0;32m%s \\e[1;31m%s\\n\\n\\e[0m" "Download Exception!  Execute" "bash setupTermuxArch.sh $args" "again…"
		printf "\\e]2;%s\\007" "Execute \`bash setupTermuxArch.sh $args\` again…"
		exit
	fi
}

runfinishsetup() {
	printf "\\e[0m"
	if [[ "$fstnd" ]]; then
		nmir="$(echo "$nmirror" |awk -F'/' '{print $3}')"
		sed -e '/http\:\/\/mir/ s/^#*/# /' -i "$INSTALLDIR"/etc/pacman.d/mirrorlist
		sed -e "/$nmir/ s/^# *//" -i "$INSTALLDIR"/etc/pacman.d/mirrorlist
	else
	if [[ "$ed" = "" ]];then
		editors 
	fi
	if [[ ! "$(sed 1q  "$INSTALLDIR"/etc/pacman.d/mirrorlist)" = "# # # # # # # # # # # # # # # # # # # # # # # # # # #" ]];then
		editfiles
	fi
		"$ed" "$INSTALLDIR"/etc/pacman.d/mirrorlist
	fi
	printf "\\n"
	"$INSTALLDIR"/root/bin/setupbin.sh ||:
}

_SETLANGUAGE_() { # This function uses device system settings to set locale.  To generate locales in a preferred language, you can use "Settings > Language & Keyboard > Language" in Android; Then run `setupTermuxArch.sh r for a quick system refresh.
	ULANGUAGE="unkown"
	LANGIN[0]="$(getprop user.language)"
	LANGIN[1]="$(getprop user.region)"
	LANGIN[2]="$(getprop persist.sys.country)"
	LANGIN[3]="$(getprop persist.sys.language)"
	LANGIN[4]="$(getprop persist.sys.locale)"
 	LANGIN[5]="$(getprop ro.product.locale)"
	LANGIN[6]="$(getprop ro.product.locale.language)"
	LANGIN[7]="$(getprop ro.product.locale.region)"
	touch "$INSTALLDIR"/etc/locale.gen 
	ULANGUAGE="${LANGIN[0]:-unknown}_${LANGIN[1]:-unknown}"
       	if ! grep "$ULANGUAGE" "$INSTALLDIR"/etc/locale.gen 1>/dev/null ; then 
		ULANGUAGE="unknown"
       	fi 
 	if [[ "$ULANGUAGE" != *_* ]];then
 		ULANGUAGE="${LANGIN[3]:-unknown}_${LANGIN[2]:-unknown}"
 	       	if ! grep "$ULANGUAGE" "$INSTALLDIR"/etc/locale.gen 1>/dev/null ; then 
 			ULANGUAGE="unknown"
 	       	fi 
 	fi 
	for i in "${!LANGIN[@]}"; do
		if [[ "${LANGIN[i]}" = *-* ]];then
 	 		ULANGUAGE="${LANGIN[i]//-/_}"
			break
		fi
	done
 	if [[ "$ULANGUAGE" != *_* ]];then
 		ULANGUAGE="${LANGIN[6]:-unknown}_${LANGIN[7]:-unknown}"
 	       	if ! grep "$ULANGUAGE" "$INSTALLDIR"/etc/locale.gen 1>/dev/null ; then 
 			ULANGUAGE="unknown"
 	       	fi 
 	fi 
 	if [[ "$ULANGUAGE" != *_* ]];then
   		ULANGUAGE="en_US"
 	fi 
	printf "\\n\\e[1;32m%s\\e[0;32m%s\\e[1;32m%s\\e[0;32m%s\\n" "Setting locales to: " "Language " ">> $ULANGUAGE << " "Region"
}

_SETLOCALE_() { # This function uses device system settings to set locale.  To generate locales in a preferred language, you can use "Settings > Language & Keyboard > Language" in Android; Then run `setupTermuxArch.sh r for a quick system refresh.
	FTIME="$(date +%F%H%M%S)"
	echo "##  File locale.conf generated by setupTermuxArch.sh at" ${FTIME//-}. > etc/locale.conf 
	for i in "${!LC_TYPE[@]}"; do
	 	echo "${LC_TYPE[i]}"="$ULANGUAGE".UTF-8 >> etc/locale.conf 
	done
	sed -i "/\\#$ULANGUAGE.UTF-8 UTF-8/{s/#//g;s/@/-at-/g;}" etc/locale.gen 
}

touchupsys() {
	addmotd
	_SETLOCALE_
	runfinishsetup
	rm -f root/bin/finishsetup.sh
	rm -f root/bin/setupbin.sh 
}

wakelock() {
	_PRINTWLA_ 
	am startservice --user 0 -a com.termux.service_wake_lock com.termux/com.termux.app.TermuxService > /dev/null
	_PRINTDONE_ 
}

wakeunlock() {
	_PRINTWLD_ 
	am startservice --user 0 -a com.termux.service_wake_unlock com.termux/com.termux.app.TermuxService > /dev/null
	_PRINTDONE_ 
}

## EOF
