#!/usr/bin/env bash
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





# 16        34

#
#echo
#
#printf "Standard"
#
#echo
#echo "--- Standard Colors ---"
#echo
#
#cprintf "<u> %-12s </u>" " "
#cprintf "<u> %-9s</u>" "${COLORS[@]}"
#printf "\n"
#for ((b = 0; b < ${#COLORS[@]}; b++)); do
#   bgcolor="${COLORS[$b]}"
#   cprintf " %-12s " "${bgcolor}"
#   for ((f = 0; f < ${#COLORS[@]}; f++)); do
#      fgcolor="${COLORS[$f]}"
#      cprintf "<bg:${bgcolor,,}> <fg:${fgcolor}>nN</fg> <fg:${fgcolor}!>bB</fg> <fg:${fgcolor}->dD</fg> </bg>"
#   done
#   cprintf "\n"
#done
#
#echo
#echo "--- High Colors ---"
#echo
#declare -a HIGH_COLORS=("Black" "Red" "Green" "Yellow" "Blue" "Magenta" "Cyan" "White")
#cprintf "<u> %-12s </u>" " "
#cprintf "<u> %-9s</u>" "${HIGH_COLORS[@]}"
#printf "\n"
#for ((b = 0; b < ${#COLORS[@]}; b++)); do
#   bgcolor="${COLORS[$b]}"
#   cprintf " %-12s " "${bgcolor^}"
#   for ((f = 0; f < ${#COLORS[@]}; f++)); do
#      fgcolor="${COLORS[$f]}"
#      cprintf "<bg:${bgcolor^}> <fg:${fgcolor^}>nN</fg> <fg:${fgcolor^}!>bB</fg> <fg:${fgcolor^}->dD</fg> </bg>"
#   done
#   cprintf "\n"
#done
#
#
#
###echo
###
#### Basic colors
##COLORS=("black" "red" "green" "yellow" "blue" "magenta" "cyan" "white")
##DASHES="$(printf "%*s" 15 "" | tr ' ' '-')"
##SEP="$(cprintf "+-%12.12s-+-%13.13s-+-%13.13s-+-%13.13s-+\n" "${DASHES}" "${DASHES}" "${DASHES}" "${DASHES}")"
##
##echo
##echo "--- Standard Colors ---"
##echo
##
##cprintf "For standard colors, the intensity modifiers have the following effect
##
##   <b>Bold Modifier      (!)</b>: Apply the BOLD effect.
##   <b>Italics Modifier   (*)</b>: Apply the ITALICS effect.
##   <b>Bright Modifier    (+)</b>: The color is converted to the high intensity equivalent.
##   <b>Dim Modifier       (-)</b>: Apply the DIM effect.
##   <b>Underline Modifier (_)</b>: Apply the UNDERLINE effect.
## \n
##"
##printf "%b\n" "$SEP"
##cprintf "| %-12s | %-13s | %-13s | %-13s | %-13s \n" "Name" "Alias" "Bright (+)" "Dim (-)"
##printf "%b\n" "$SEP"
##for ((i = 0; i < ${#COLORS}; i++)); do
##   color="${COLORS[i]}"
##   alias="${color,,}"
##   # Capitalize the first letter of the color
##   cprintf "| %-12s | <fg:${alias}>%-13s</fg> | <fg:${alias}+>%-13s</fg> | <fg:${alias}->%-13s</fg> |" "${color^}" "${alias}" "${alias}+" "${alias}-"
##   cprintf "\n"
##done
##printf "%b\n" "$SEP"
##
##echo
##echo "--- High Colors ---"
##echo
##cprintf "<b>Note: High colors are not supported on all terminals.</b>
##
##For high colors, the intensity modifiers have the following effect
##
##   <b>Bold Modifier      (!)</b>: Apply the BOLD effect.
##   <b>Italics Modifier   (*)</b>: Apply the ITALICS effect.
##   <b>Bright Modifier    (+)</b>: Apply the BOLD effect.
##   <b>Dim Modifier       (-)</b>: The color is converted to the standard color
##   <b>Underline Modifier (_)</b>: Apply the UNDERLINE effect.
##
##\n
##"
##printf "%b\n" "$SEP"
##cprintf "| %-12s | %-13s | %-13s | %-13s | %-13s \n" "Name" "Alias" "Bold (+)" "Standard (-)"
##printf "%b\n" "$SEP"
##for ((i = 0; i < ${#COLORS}; i++)); do
##   color="${COLORS[i]}"
##   alias="${color^}"
##   # Capitalize the first letter of the color
##   cprintf "| %-12s | <fg:${alias}>%-13s</fg> | <fg:${alias}+>%-13s</fg> | <fg:${alias}->%-13s</fg> |" "${color^}" "${alias}" "${alias}+" "${alias}-"
##   cprintf "\n"
##done
##printf "%b\n" "$SEP"
##echo
##
#### Effect Modifiers
##
#### Background colors
##echo "--- Background Colors ---"
##cprintf "<bg:red><fg:white>White on red</fg></bg>\n"
##cprintf "<bg:green><fg:black>Black on green</fg></bg>\n"
##cprintf "<bg:blue><fg:yellow>Yellow on blue</fg></bg>\n"
##cprintf "<bg:yellow><fg:black>Black on yellow</fg></bg>\n"
##echo
##
### Text styles
##echo "--- Text Styles ---"
##cprintf "<b>Bold text</b>\n"
##cprintf "<i>Italic text</i>\n"
##cprintf "<u>Underlined text</u>\n"
##cprintf "<dim>Dim text</dim>\n"
##cprintf "<inv>Inverted text</inv>\n"
##echo
##
##echo "--- Modifiers ---"
##echo
##cprintf "Normal text <fg:red+*_>Bright red italic underlined</fg> Back to normal\n"
##cprintf "Normal text <fg:red!_>Bold red underlined</fg> Back to normal\n"
##cprintf "Normal text <fg:red!>Bold red</fg> Back to normal\n"
##cprintf "Normal text <fg:red>red</fg> Back to normal\n"
##cprintf "Normal text <bg:blue-^~>Dim blue inverse background</bg> Back to normal\n"
##cprintf "Normal text <fg:green+>Extended green</fg> Back to normal\n"
##cprintf "Normal text <fg:green+=>Extended green with strikethrough</fg> Back to normal\n"
##echo
##
###cprintf "<fg:red*>Italic red text</fg>\n"
###cprintf "<fg:red_>Underlined red text</fg>\n"
###cprintf "<fg:red+>High red text</fg>\n"
###cprintf "<fg:red!>Bold red text</fg>\n"
###cprintf "<fg:red->Dim red text</fg>\n"
###cprintf "<fg:red~>Inverted red text</fg>\n"
##
##
##
###
### Combined styles
##echo "--- Combined Styles ---"
##cprintf "<b><fg:red>Bold red text</fg></b>\n"
##cprintf "<u><fg:blue>Underlined blue text</fg></u>\n"
##cprintf "<i><fg:green>Italic green text</fg></i>\n"
##cprintf "<b><u><fg:magenta>Bold underlined magenta</fg></u></b>\n"
##cprintf "<bg:cyan><fg:black><b>Bold black on cyan</b></fg></bg>\n"
##echo
##
#### Nested colors
##echo "--- Nested Colors ---"
##cprintf "<fg:red>Red <fg:blue>blue <fg:green>green</fg> blue</fg> red</fg>\n"
##cprintf "<bg:yellow><fg:black>Yellow bg <bg:red><fg:white>red bg</fg></bg> yellow bg</fg></bg>\n"
##echo
##
#### Numeric color codes
##echo "--- Numeric Color Codes ---"
##for ((i=0; i<=255; i+=4)); do
##   cprintf "<bg:$i>%03s</bg> <bg:$i>%03s</bg> <bg:$i>%03s</bg> <bg:$i>%03s</bg>\n" $i $(($i+1)) $(($i+2)) $(($i+3))
##done
#####
#####cprintf "<fg:0>Color 0</fg> <fg:1>Color 1</fg> <fg:2>Color 2</fg> <fg:3>Color 3</fg>\n"
#####cprintf "<fg:4>Color 4</fg> <fg:5>Color 5</fg> <fg:6>Color 6</fg> <fg:7>Color 7</fg>\n"
####echo
####
##### Random colors
####echo "--- Random Colors ---"
####cprintf "<fg:random>Random color 1</fg>\n"
####cprintf "<fg:random>Random color 2</fg>\n"
####cprintf "<fg:random>Random color 3</fg>\n"
####echo
####
##### Special characters
####echo "--- Special Characters ---"
####cprintf "Use &lt; for less than and &gt; for greater than\n"
####cprintf "Example: if x &lt; 5 and y &gt; 10\n"
####echo
####
##### Printf formatting
####echo "--- Printf Formatting ---"
####name="Alice"
####age=25
####height=5.6
####cprintf "<fg:green>Name:</fg> <b>%s</b>\n" "$name"
####cprintf "<fg:blue>Age:</fg> <b>%d</b> years old\n" "$age"
####cprintf "<fg:cyan>Height:</fg> <b>%.1f</b> feet\n" "$height"
####echo
####
##### Error output with ceprintf
####echo "--- Error Output (ceprintf to stderr) ---"
####echo "The following lines go to stderr:"
####ceprintf "<fg:red><b>ERROR:</b></fg> This is an error message\n"
####ceprintf "<fg:yellow><b>WARNING:</b></fg> This is a warning message\n"
####ceprintf "<fg:red+><b>CRITICAL:</b></fg> This is a critical message\n"
####echo
####
##### Complex example
####echo "--- Complex Example ---"
####cprintf "<bg:blue><fg:white><b> STATUS REPORT </b></fg></bg>\n"
####cprintf "<fg:green>✓</fg> Database: <b><fg:green>Connected</fg></b>\n"
####cprintf "<fg:yellow>⚠</fg> Cache: <b><fg:yellow>Degraded</fg></b>\n"
####cprintf "<fg:red>✗</fg> API: <b><fg:red>Disconnected</fg></b>\n"
####echo
####
####echo "=== Demo Complete ==="
