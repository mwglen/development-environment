#!/usr/bin/env bash

## Author  : Aditya Shakya
## Mail    : adi1090x@gmail.com
## Github  : @adi1090x
## Twitter : @adi1090x

# Available Styles
# >> Created and tested on : rofi 1.6.0-1
#
# style_1     style_2     style_6
# style_7     style_8     style_9

theme="style_1"
dir="$HOME/.config/rofi/launchers/colorful"

# dark
ALPHA="#00000000"
BG="#000000ff"
FG="#FFFFFFff"
SELECT="#101010ff"
COLORS=('#42A5F5' '#6D8895' '#6C77BB')

# overwrite colors file
cat > $dir/colors.rasi <<- EOF
	* {
	  al:  $ALPHA;   /* background */
	  bg:  $BG;      /* search font */
	  se:  $SELECT;  /* selected */
	  fg:  $FG;      /* text */
	  ac:  #6C77BB;  /* top color */
	}
EOF

rofi -no-lazy-grab -show drun -modi drun -theme $dir/"$theme"
