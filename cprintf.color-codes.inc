#? Display the available color codes
COLORS=("black" "red" "green" "yellow" "blue" "magenta" "cyan" "white")
_CPRINTF_ANSI_ESC=$'\033'
printf "\n=== Color Aliases ===\n\n"
printf "For the standard color space, we use names that are all in lower case\n\n"
printf "   "
for ((f = 0; f < ${#COLORS[@]}; f++)); do
   cprintf "<bg:0> <fg:$((7-f))> %-8s</fg> </bg>" "${COLORS[f],,}"
done
cprintf "\n"
printf "   "
for ((f = 0; f < ${#COLORS[@]}; f++)); do
   cprintf "<bg:$f> <fg:$((7-f))!> %-8s</fg> </bg>" "${COLORS[f],,}"
done
cprintf "\n"
printf "\nCapitalized named colors represent bright versions of the corresponding colors.\n\n"
printf "   "
for ((f = 0; f < ${#COLORS[@]}; f++)); do
   cprintf "<bg:$((f+8))> <fg:$((16-f))!> %-8s</fg> </bg>" "${COLORS[f]^}"
done
cprintf '\n'

printf "\n=== Color Codes ===\n\n"
printf "Standard: "
for ((f = 0; f < ${#COLORS[@]}; f++)); do
   cprintf "<bg:$f> <fg:$((8-f))>%3s</fg> </bg>" "$f"
done
cprintf '\n'
printf "High    : "
for ((f = 0; f < ${#COLORS[@]}; f++)); do
   cprintf "<bg:$((f+8))> <fg:$((15-f))>%3s</fg> </bg>" $((f+8))
done
cprintf '\n\n'

PATTERN_LEFT="$(printf "<bg:%%s> <fg:%s!>%%%%-3s</fg> </bg>" 255 255 255 255 255 255)"
PATTERN_RIGHT="$(printf "<bg:%%s> <fg:%s!>%%%%-3s</fg> </bg>" 0 0 0 0 0 0)"
for ((i=16; i<=28; i+=6)); do
   for ((j=0; j<6; j++)); do
      printf '%10s' ' '
      ccl=$((i + (j*36)))
      ccr=$(((i+18) + (j*36)))
      codes=(
         $((ccl)) $((ccl +1)) $((ccl +2)) $((ccl +3)) $((ccl +4)) $((ccl +5))
         $((ccr)) $((ccr +1)) $((ccr +2)) $((ccr +3)) $((ccr +4)) $((ccr +5))
      )

      cprintf "$(printf "$PATTERN_LEFT $PATTERN_RIGHT" "${codes[@]}")\n" "${codes[@]}"
   done
   cprintf '\n'
done
for ((j=0; j<4; j++)); do
   if [[ $j == 0 ]]; then
      cprintf '%8s: ' 'Greys'
   else
      cprintf '%10s' ' '
   fi
   for ((k=0; k<6; k++)); do
      color_code=$((232 + (j*6) +k))
      fg=255
      if [ $j -gt 1 ]; then
         fg=0
      fi
      cprintf "<bg:${color_code}> <fg:$fg!>%-3s</fg> </bg>" ${color_code}
   done
   cprintf '\n'
done
cprintf '\n'
