#!/usr/bin/env bash
. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../cprintf"

COLORS=("black" "red" "green" "yellow" "blue" "magenta" "cyan" "white")

echo "=== cprintf-${__CPRINTF_VERSION__:-2.0} Demo - All Features ==="
# Aliases
cprintf "=== Aliases ===\n
Example:

  &lt;fg:red>Red Text&lt;/fg>               - <fg:red>Red Text</fg>
  &lt;bg:red>Red background&lt;/fg>         - <bg:red>Red background</bg>
  &lt;fg:Red>Bright Red Text&lt;/fg>        - <fg:Red>Bright Red Text</fg>
  &lt;bg:Red>Bright Red background&lt;/fg>  - <bg:Red>Bright Red background</bg>\n"

printf "\nStandard: "
for ((f = 0; f < ${#COLORS[@]}; f++)); do
   cprintf "<bg:${COLORS[f],,}> <fg:${COLORS[-((f+1))]}>%-8s</fg> </bg>" "${COLORS[f],,}"
done
cprintf '\n'
printf "High    : "
for ((f = 0; f < ${#COLORS[@]}; f++)); do
   cprintf "<bg:${COLORS[f]^}> <fg:${COLORS[-((f+1))]^}>%-8s </fg></bg>" "${COLORS[f]^}"
done
cprintf '\n'

cprintf "\n=== Color Codes ===\n
Example:

  &lt;fg:1>Red Text&lt;/fg>               - <fg:1>Red Text</fg>
  &lt;bg:1>Red background&lt;/fg>         - <bg:1>Red background</bg>
  &lt;fg:9>Bright Red Text&lt;/fg>        - <fg:9>Bright Red Text</fg>
  &lt;bg:9>Bright Red background&lt;/fg>  - <bg:9>Bright Red background</bg>\n"

printf "\nStandard: "
for ((f = 0; f < ${#COLORS[@]}; f++)); do
   cprintf "<bg:$f> <fg:$((8-f))>%-2s</fg> </bg>" "$f"
done
cprintf '\n'
printf "High    : "
for ((f = 0; f < ${#COLORS[@]}; f++)); do
   cprintf "<bg:$((f+8))> <fg:$((15-f))>%-2s</fg> </bg>" $((f+8))
done
cprintf '\n\n'

PATTERN_LEFT="$(printf "<bg:%%s> <fg:%s>%%%%-3s</fg> </bg>" 255 255 255 255 255 255)"
PATTERN_RIGHT="$(printf "<bg:%%s> <fg:%s>%%%%-3s</fg> </bg>" 0 0 0 0 0 0)"
for ((i=16; i<=28; i+=6)); do
   for ((j=0; j<6; j++)); do
      printf '%10s' ' '
      ccl=$((i + (j*36)))
      ccr=$(((i+18) + (j*36)))
      codes=(
             $((ccl)) $((ccl +1)) $((ccl +2)) $((ccl +3)) $((ccl +4)) $((ccl +5))
             $((ccr)) $((ccr +1)) $((ccr +2)) $((ccr +3)) $((ccr +4)) $((ccr +5))
            )

      cprintf "$(printf "$PATTERN_LEFT     $PATTERN_RIGHT" "${codes[@]}")\n" "${codes[@]}"
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
      cprintf "<bg:${color_code}> <fg:$fg>%-3s</fg> </bg>" ${color_code}
   done
   cprintf '\n'
done
cprintf '\n'

printf "\n=== Intensity Modifiers ===\n\n"

printf "<fg:red+>High red text</fg>       - "
cprintf "<fg:red+>High red text</fg>\n"

printf "<fg:red->Dim red text</fg>        - "
cprintf "<fg:red->Dim red text</fg>\n"

printf "\n=== Effect Modifiers ===\n\n"

printf "<fg:red*>Italic red text</fg>     - "
cprintf "<fg:red*>Italic red text</fg>\n"

printf "<fg:red_>Underlined red text</fg> - "
cprintf "<fg:red_>Underlined red text</fg>\n"

printf "<fg:red!>Bold red text</fg>       - "
cprintf "<fg:red!>Bold red text</fg>\n"

printf "<fg:red~>Inverted red text</fg>   - "
cprintf "<fg:red~>Inverted red text</fg>\n"

printf "\n=== Multiple Modifiers ===\n\n"

printf "\n=== Styles ===\n\n"

echo "=== Special Characters ==="
echo
cprintf "&amp;lt;  - &lt;\n&amp;gt;  - &gt;\n&amp;amp; - &amp;\n\n"
cprintf "Example: if x <fg:magenta>&amp;lt;</fg> 5 <fg:magenta>&amp;amp;&amp;amp;</fg> y <fg:magenta>&amp;gt;</fg> 10 -> "
cprintf "if x <fg:magenta>&lt;</fg> 5 <fg:magenta>&amp;&amp;</fg> y <fg:magenta>&gt;</fg> 10\n"

echo

printf "\n=== Combined ===\n\n"
#echo "--- Nested Colors ---"
cprintf "[normal]<fg:red>[Red ]<fg:blue>[blue ]<fg:green>[green ]</fg>[blue ]</fg>[ red]</fg>[normal]\n"
cprintf "[normal]<bg:yellow><fg:black>[black on yellow]<bg:red><fg:white>[white on red]</fg>[black on red]</bg>[black on yellow]</fg></bg>[normal]\n"
cprintf "[normal]<fg:red><bg:yellow>.."
cprintf "[red on yellow]<fg:blue><bg:magenta>[blue on magenta]</bg>[red on yellow]</fg>[normal]\n"
echo
