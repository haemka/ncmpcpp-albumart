#!/bin/bash

# This script stes the background of a capable terminal according to the cover
# image of the currently played song in MPD
 
MUSIC_DIR=$(awk -F' = ' '/mpd_music_dir/ {print $2}' ~/.config/ncmpcpp/config)
COVER=/tmp/cover.png

function reset_background
{
  printf "\e]20;;100x100+1000+1000\a"
}

{
  album="$(mpc --format %album% current)"
  file="$(mpc --format %file% current)"
  album_dir="${file%/*}"
  [[ -z "$album_dir" ]] && exit 1
  album_dir="$MUSIC_DIR/$album_dir"

  covers="$(find "$album_dir" -type d -exec find {} -maxdepth 1 -type f -iregex ".*/.*\(${album}\|cover\|folder\|artwork\|front\).*[.]\(jpe?g\|png\|gif\|bmp\)" \; )"
  src="$(echo -n "$covers" | head -n1)"
  rm -f "$COVER"
  if [[ -n "$src" ]] ; then
    windowsize=$(xdotool getwindowgeometry $WINDOWID | awk '/Geometry/ {print $2}')
    x=$(echo $windowsize | cut -d'x' -f1)
    imgsize=$((x/5))
    extsize=$((imgsize/10))
    # Evaluate URxvt color
    bg=$(xrdb -query | awk 'tolower($0) ~ /urxvt\.background:/ {print $2}')
    # check for transparency
    if [[ "${bg}" =~ ^\[[[:digit:]]{2}\]#[[:digit:]A-Fa-f]{6}$ ]]; then
      bgt=${bg:1:2}
      bgc=${bg:4}
    else
      if [[ "${bg}" =~ ^#[[:digit:]A-Fa-f]{6}$ ]]; then
        bgc=${bg}
      fi
    fi
    # Fallback to global background color
    if [ $bgc == "" ]; then
      bgc=$(xrdb -query | awk 'tolower($0) ~ /\*\.background:/ {print $2}')
    fi

    alpha=""
    if [ "${bgt}" ]; then
      alpha="-alpha set -channel A -evaluate set ${bgt}%"
    fi
    convert -size ${windowsize} xc:${bgc} ${alpha} \
      "${src}" -geometry ${imgsize}x${imgsize}+10+40 -composite \
      "${COVER}"

      if [[ -f "$COVER" ]] ; then
        printf "\e]20;${COVER}\a"
      else
        reset_background
      fi
    else
      reset_background
    fi
} &

