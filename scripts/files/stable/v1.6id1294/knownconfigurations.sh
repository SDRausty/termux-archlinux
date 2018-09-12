#!/bin/env bash
# Copyright 2017-2018 by SDRausty. All rights reserved.  🌎 🌍 🌏 🌐 🗺
# Hosting https://sdrausty.github.io/TermuxArch courtesy https://pages.github.com
# https://sdrausty.github.io/TermuxArch/CONTRIBUTORS Thank you for your help.
# https://sdrausty.github.io/TermuxArch/README has information about this project.
################################################################################
# `bash setupTermuxArch.sh manual` shall create `setupTermuxArchConfigs.sh` from this file in your working directory.  Run `bash setupTermuxArch.sh` and `setupTermuxArchConfigs.sh` loads automaticaly.  `bash setupTermuxArch.sh help` has more information.  Change mirror (https://wiki.archlinux.org/index.php/Mirrors and https://archlinuxarm.org/about/mirrors) to desired geographic location in `setupTermuxArchConfigs.sh` to resolve 404 and checksum issues.  The following user configurable variables are available in this file:   
# cmirror="http://mirror.archlinuxarm.org/"
cmirror="http://os.archlinuxarm.org/"
# dm=aria2c	# Works wants improvement 
# dm=axel tba	# Not fully implemented
# dm=lftp 	# Works wants improvement 
# dm=curl	# Works 
# dm=wget	# Works 
# dmverbose="-v" # Uncomment for verbose download manager output with curl and wget;  for verbose output throughout runtime, change this setting setting in `setupTermuxArch.sh` also.  
koe=1

aarch64() {
	file=ArchLinuxARM-aarch64-latest.tar.gz
	mirror=os.archlinuxarm.org
	path=/os/
	makesystem 
}

armv5l() {
	file=ArchLinuxARM-armv5-latest.tar.gz
	mirror=os.archlinuxarm.org
	path=/os/
	makesystem 
}

armv7lAndroid () {
	file=ArchLinuxARM-armv7-latest.tar.gz 
	mirror=os.archlinuxarm.org
	path=/os/
	makesystem 
}

armv7lChrome() {
	file=ArchLinuxARM-armv7-chromebook-latest.tar.gz
	mirror=os.archlinuxarm.org
	path=/os/
	makesystem 
}

# Information at https://www.archlinux.org/news/phasing-out-i686-support/ and https://archlinux32.org/ regarding why i686 is currently frozen at release 2017.03.01-i686.  $file is read from md5sums.txt

i686() { 
	mirror=archive.archlinux.org
	path=/iso/2017.03.01/
	makesystem 
}

x86_64() { # $file is read from md5sums.txt
	mirror=mirror.rackspace.com
	path=/archlinux/iso/latest/
	makesystem 
}

# Appending to the PRoot statement can be accomplished on the fly by creating a *.prs file in /var/binds.  The format is straightforward, `prootstmnt+="option command "`.  The space is required before the last double quote.  `info proot` and `man proot` have more information about what can be configured in a proot init statement.  `setupTermuxArch.sh manual refresh` will refresh the installation globally.  If more suitable configurations are found, share them at https://github.com/sdrausty/TermuxArch/issues to improve TermuxArch.  

prs() { 
prootstmnt="exec proot "
if [[ -z "${kid:-}" ]]; then
	prootstmnt+=""
elif [[ "$kid" ]]; then
 	prootstmnt+="--kernel-release=4.14.15 "
fi
if [[ "$koe" ]]; then
	prootstmnt+="--kill-on-exit "
fi
prootstmnt+="--link2symlink -0 -r $INSTALLDIR "
if [[ ! -r /dev/shm ]] ; then 
	if [[ -r /dev/ashmem ]] ; then 
	 	prootstmnt+="-b /dev/ashmem:/dev/shm " 
	else
		prootstmnt+="-b $INSTALLDIR/tmp:/dev/shm " 
	fi
fi
if [[ -f /proc/stat ]] ; then
	if [[ ! "$(head /proc/stat)" ]] ; then
		prootstmnt+="-b $INSTALLDIR/var/binds/fbindprocstat:/proc/stat " 
	fi
else
	prootstmnt+="-b $INSTALLDIR/var/binds/fbindprocstat:/proc/stat " 
fi
if [ -n "$(ls -A "$INSTALLDIR"/var/binds/*.prs)" ]; then
    for f in "$INSTALLDIR"/var/binds/*.prs ; do
      . "$f"
    done
fi
prootstmnt+="-b \"\$ANDROID_DATA\" -b /dev/ -b \"\$EXTERNAL_STORAGE\" -b \"\$HOME\" -b /proc/ -b /storage/ -b /sys/ -w \"\$PWD\" /usr/bin/env -i HOME=/root TERM=$TERM "
}
prs 

## EOF
