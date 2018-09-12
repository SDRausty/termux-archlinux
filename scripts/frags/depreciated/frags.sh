
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

