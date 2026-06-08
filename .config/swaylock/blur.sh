set -euo pipefail

img="/tmp/swaylock-$(id -u).png"
blur="/tmp/swaylock-$(id -u)-blur.png"

grim "$img"
magick "$img" -blur 0x8 "$blur"

swaylock -f -i "$blur"

rm -f "$img" "$blur"

