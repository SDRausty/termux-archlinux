#!/bin/env bash
# Copyright 2017-2018 by SDRausty. All rights reserved.  🌎 🌍 🌏 🌐 🗺
# Hosted sdrausty.github.io/TermuxArch courtesy https://pages.github.com
# https://sdrausty.github.io/TermuxArch/README has info about this project. 
# https://sdrausty.github.io/TermuxArch/CONTRIBUTORS Thank you for your help.  
# _STANDARD_="function name" && STANDARD="variable name" are under construction.
################################################################################

declare FSTND=""

_FTCHIT_() {
	_GETMSG_
 	_PRINT_DOWNLOADING_FTCHIT_ 
	if [[ "$dm" = aria2c ]];then
		aria2c http://"$CMIRROR$path$file".md5 
		aria2c -c http://"$CMIRROR$path$file"
	elif [[ "$dm" = axel ]];then
		axel http://"$CMIRROR$path$file".md5 
		axel http://"$CMIRROR$path$file"
	elif [[ "$dm" = wget ]];then 
		wget "$DMVERBOSE" -N --show-progress http://"$CMIRROR$path$file".md5 
		wget "$DMVERBOSE" -c --show-progress http://"$CMIRROR$path$file" 
	else
		curl "$DMVERBOSE" -C - --fail --retry 4 -OL http://"$CMIRROR$path$file".md5 -O http://"$CMIRROR$path$file" 
	fi
}

_FTCHSTND_() {
	FSTND=1
	_GETMSG_
	_PRINTCONTACTING_ 
	if [[ "$dm" = aria2c ]];then
		aria2c "$CMIRROR" | tee /dev/fd/1 > "$TAMPDIR/global2localmirror"
		NLCMIRROR="$(grep Redir "$TAMPDIR/global2localmirror" | awk {'print $8'})" 
		_PRINTDONE_ 
		_PRINTDOWNLOADINGFTCH_ 
		aria2c http://"$NLCMIRROR$path$file".md5 
		aria2c -c -m 4 http://"$NLCMIRROR$path$file"
	elif [[ "$dm" = wget ]];then 
		wget -v -O/dev/null "$CMIRROR" 2>"$TAMPDIR/global2localmirror"
		NLCMIRROR="$(grep Location "$TAMPDIR/global2localmirror" | awk {'print $2'})" 
		_PRINTDONE_ 
		_PRINTDOWNLOADINGFTCH_ 
		wget "$DMVERBOSE" -N --show-progress "$NLCMIRROR$path$file".md5 
		wget "$DMVERBOSE" -c --show-progress "$NLCMIRROR$path$file" 
	else
		curl -v "$CMIRROR" 2>"$TAMPDIR/global2localmirror"
		NLCMIRROR="$(grep Location "$TAMPDIR/global2localmirror" | awk {'print $3'})" 
		_PRINTDONE_ 
		_PRINTDOWNLOADINGFTCH_ 
		curl "$DMVERBOSE" -C - --fail --retry 4 -OL "$NLCMIRROR$path$file".md5 -O "$NLCMIRROR$path$file"
	fi
}

_GETIMAGE_() {
	_PRINTDOWNLOADINGX86_ 
	_GETMSG_
	if [[ "$dm" = aria2c ]];then
		aria2c http://"$CMIRROR$path$file".md5 
		if [[ "$CPUABI" = "$CPUABIX86" ]];then
			file="$(grep i686 md5sums.txt | awk {'print $2'})"
		else
			file="$(grep boot md5sums.txt | awk {'print $2'})"
		fi
		sed '2q;d' md5sums.txt > "$file".md5
		rm md5sums.txt
		aria2c -c http://"$CMIRROR$path$file"
	elif [[ "$dm" = axel ]];then
		axel http://"$CMIRROR$path$file".md5 
		if [[ "$CPUABI" = "$CPUABIX86" ]];then
			file="$(grep i686 md5sums.txt | awk {'print $2'})"
		else
			file="$(grep boot md5sums.txt | awk {'print $2'})"
		fi
		sed '2q;d' md5sums.txt > "$file".md5
		rm md5sums.txt
		axel http://"$CMIRROR$path$file"
	elif [[ "$dm" = wget ]];then 
		wget "$DMVERBOSE" -N --show-progress http://"$CMIRROR$path"md5sums.txt
		if [[ "$CPUABI" = "$CPUABIX86" ]];then
			file="$(grep i686 md5sums.txt | awk {'print $2'})"
		else
			file="$(grep boot md5sums.txt | awk {'print $2'})"
		fi
		sed '2q;d' md5sums.txt > "$file".md5
		rm md5sums.txt
		_PRINTDOWNLOADINGX86TWO_ 
		wget "$DMVERBOSE" -c --show-progress http://"$CMIRROR$path$file" 
	else
		curl "$DMVERBOSE" --fail --retry 4 -OL http://"$CMIRROR$path"md5sums.txt
		if [[ "$CPUABI" = "$CPUABIX86" ]];then
			file="$(grep i686 md5sums.txt | awk {'print $2'})"
		else
			file="$(grep boot md5sums.txt | awk {'print $2'})"
		fi
		sed '2q;d' md5sums.txt > "$file".md5
		rm md5sums.txt
		_PRINTDOWNLOADINGX86TWO_ 
		curl "$DMVERBOSE" -C - --fail --retry 4 -OL http://"$CMIRROR$path$file" 
	fi
}

_GETMSG_() {
 	if [[ "$dm" = axel ]] || [[ "$dm" = lftp ]];then
 		printf "\\n\\e[1;32m%s\\n\\n""The chosen download manager \`$dm\` is being implemented: curl (command line tool and library for transferring data with URLs) alternative https://github.com/curl/curl chosen:  DONE"
	fi
}

## EOF
