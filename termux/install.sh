#!/bin/sh
set -e

if [ -z "$TERMUX_VERSION" ]; then
    echo "this script should be run only on termux."
    exit 1
fi
cd "$(dirname "$0")"

### Installation
alias install="install -m600"

install ../common/bashrc ~/.bashrc
echo >> ~/.bashrc
cat bashrc >> ~/.bashrc

if su --help | grep -- -i >/dev/null; then
    # Fix for magisk >29 versions
    sed -i 's/su -c/su -i -c/' ~/.bashrc
fi

# $PREFIX/etc
install ../common/wgetrc $PREFIX/etc/wgetrc

# .config
install -D htoprc ~/.config/htop/htoprc
install -D fastfetch.jsonc ~/.config/fastfetch/config.jsonc
install -D ../common/nanorc ~/.config/nano/nanorc
install -D ../common/startup.py ~/.config/python/startup.py

# .local/bin
install -m700 -D ../common/py ~/.local/bin/py
install -m700 -D ../common/randint ~/.local/bin/randint
install -m700 -D trs ~/.local/bin/trs
install -m700 -D cargo-lint ~/.local/bin/cargo-lint

# .termux
install -D light.properties ~/.termux/light.properties
install -D dark.properties ~/.termux/dark.properties
install -D termux.properties ~/.termux/termux.properties
install -D mononoki-nerd.ttf ~/.termux/font.ttf
ln -sf dark.properties ~/.termux/colors.properties
ln -sf $PREFIX/etc/motd.sh ~/.termux/motd.sh

termux-reload-settings &

pkgs="eza htop fastfetch miniserve xxd bat gitoxide wget file 7zip netcat-openbsd"
if ! pkg show $pkgs 2>/dev/null >/dev/null; then
    yes '
' | pkg in $pkgs
fi
