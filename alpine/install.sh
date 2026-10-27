#!/bin/sh
set -e

. /etc/os-release
if [ "$ID" != alpine ]; then
    echo "Only for Alpine"
    exit 1
fi
cd "$(dirname "$0")"

alias install="install -m644"

install ../common/bashrc /etc/bash/drakohost.sh
echo >> /etc/bash/drakohost.sh
cat bashrc >> /etc/bash/drakohost.sh

install ../common/nanorc /etc/nanorc
echo >> /etc/nanorc
cat nanorc >> /etc/nanorc

# /etc
install sshd.conf /etc/ssh/sshd_config.d/drakohost.conf
install htoprc /etc/htoprc
install tmux.conf /etc/tmux.conf
install fastfetch.jsonc /etc/fastfetch/config.jsonc
install ../common/startup.py /etc/python/startup.py
install ../common/wgetrc /etc/wgetrc

# /usr/local/bin
install -m755 ../common/py /usr/local/bin/py
install -m755 ../common/randint /usr/local/bin/randint

# ~/.config
install -D htoprc-root ~/.config/htop/htoprc

pkgs="eza htop fastfetch miniserve xxd bat wget file 7zip nano nano-syntax bash tmux"
if ! pkg show $pkgs 2>/dev/null >/dev/null; then
    setup-apkrepos -o
    apk add $pkgs --virtual dhbase
fi

# No chsh on Alpine
sed 's|root:x:0:0:root:/root:/bin/sh|root:x:0:0:root:/root:/bin/bash|' -i /etc/passwd

rc-service sshd restart
