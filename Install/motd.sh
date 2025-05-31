#!/data/data/com.termux/files/usr/bin/bash

motd_indent=" "
size=`expr $(tput cols) - 35`
size=$((size / 2))
for i in $(seq 0 1 $size); do
    motd_indent=$motd_indent" "
done

colors1=""
for i in {0..7}; do
    colors1=$colors1"\e[;48;5;${i}m  \e[0m"
done

colors2=""
for i in {8..15}; do
    colors2=$colors2"\e[;48;5;${i}m  \e[0m"
done

motd="\
${motd_indent}╭───────────────────────────────╮
${motd_indent}│   \e[;97m\e[40m \e[2;97;40m\e[0m    termux: ${TERMUX_VERSION}      │
${motd_indent}│   \e[;43m  \e[;40m \e[0m        os: ${OSTYPE}│
${motd_indent}│  \e[;40m \e[;107m \e[;40m   \e[0m      cpu: aarch64      │
${motd_indent}│ \e[;43m \e[;40m    \e[;43m \e[0m    shell: $(zsh --version | awk '{print $1,$2}')      │
${motd_indent}│                               │
${motd_indent}│\e[;33m󰮯\e[0m \e[1;32m󰊠\e[0m \e[1;34m󰊠\e[0m \e[1;31m󰊠\e[0m \e[1;35m󰊠\e[0m     ${colors1} │
${motd_indent}│ 󰰥󰯸󰰟󰰐󰰨󰰱       ${colors2} │
${motd_indent}╰───────────────────────────────╯
"

# android: Android 15
#  device: samsung SM-X910
#  termux: ${TERMUX_VERSION}
#      os: ${OSTYPE}
#     cpu: aarch64
#   shell: $(zsh --version | awk '{print $1,$2}')
#
echo -e "$motd"
