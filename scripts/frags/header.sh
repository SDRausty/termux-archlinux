#!/bin/env bash
# Copyright 2017-2018 by SDRausty. All rights reserved.  🌎 🌍 🌏 🌐 🗺
# Hosted https://sdrausty.github.io/TermuxArch courtesy https://pages.github.com
# https://sdrausty.github.io/TermuxArch/CONTRIBUTORS Thank you for your help.  
################################################################################
IFS=$'\n\t'
set -Eeuo pipefail
shopt -s nullglob globstar
unset LD_PRELOAD
fileheader="#!/bin/env bash\\n# Copyright 2017-2018 by SDRausty. All rights reserved.  🌎 🌍 🌏 🌐 🗺\\n# Hosting https://sdrausty.github.io/TermuxArch courtesy https://pages.github.com\\n# https://sdrausty.github.io/TermuxArch/CONTRIBUTORS Thank you for your help.\\n################################################################################\\nIFS=$'\\\\n\\\\t'\\nset -Eeuo pipefail\\nshopt -s nullglob globstar\\nunset LD_PRELOAD\\n"
addae() {
	printf $fileheader > ae
	cat >> ae <<- EOM
	watch cat /proc/sys/kernel/random/entropy_avail
	EOM
}
addae
cat ae

