 # Bash 4 / ksh93
 
 declare -A homedir    # Declare associative array
#  typeset -A homedir    # Declare associative array
 homedir=(             # Compound assignment
     [jim]=/home/jim
     [silvia]=/home/silvia
     [alex]=/home/alex
 )
 
 homedir[ormaaj]=/home/ormaaj # Ordinary assignment adds another single element
 
 for user in "${!homedir[@]}"; do   # Enumerate all indices (user names)
     printf 'Home directory of user %s is: %q\n' "$user" "${homedir[$user]}"
 done
