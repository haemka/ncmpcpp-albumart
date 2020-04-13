# ncmpcpp-albumart

This script sets the background of a capable terminal according to the cover
image of the currently played song in MPD.
 
Initially it is supposed to work for [ncmpcpp](https://rybczak.net/ncmpcpp/)
in URxvt and supports background transparency, when configured via percentage
prefixed color code in the Xresources file.

## Requirements

| Requirement | Rationale                                                           |
|-------------|---------------------------------------------------------------------|
| MPD         | obviously                                                           |
| URxvtx      | Currently the only terminal tested and evaluated through the script |
| mpc         | Reads the current song                                              |
| gawk        | Does various string manipulations                                   |
| xrdb        | Reads the terminals configuration                                   |
| xdotool     | Checks the shells terminals window geometry                         |
| ImageMagick | Creates the background image                                        |

## Configuration

Set the `execute_on_song_change` variable in ncmpcpp's config to the path to
`art.sh`.

```
execute_on_song_change="~/.ncmpcpp/art.sh"
```

`config.example` contains the configuration used for the screenshot below.

## Screenshot

![Screenshot](https://raw.githubusercontent.com/haemka/ncmpcc-albumart/master/screenshot.png)
