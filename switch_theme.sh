#!/usr/bin/env bash
# MIT License

# Copyright (c) 2023 guemax

# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation files
# (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge,
# publish, distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:

# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
# BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
# ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# if [[ $EUID -ne 0 ]]; then
#     echo "Please run this script as root."
#     exit 1
# fi

THEMES=(modus-vivendi modus-operandi)

themes() {
    for theme in ${THEMES[@]}; do
	echo " - $theme"
    done
}    

help() {
    cat <<EOF
Usage: $0 <THEME_NAME>

Possible themes are:
EOF
    themes
    exit 1
}

if [[ $# -eq 0 ]]; then
    help
fi

if printf "%s;" ${THEMES[@]} | grep "$1;" > /dev/null; then
    echo "Switching to theme $1."
else
    cat <<EOF
Usage: $0 <THEME_NAME>
ERROR: Unknown theme "$1".

Possible themes are:
EOF
    themes
    exit 1
fi

sed -i "s/\/home\/max\/\.config\/alacritty\/.*\.yml/\/home\/max\/\.config\/alacritty\/$1\.yml/" ~/.dotfiles/.config/alacritty/alacritty.yml
