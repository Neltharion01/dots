#!/bin/sh
set -e

. /etc/os-release
if [ "$ID" != alpine ]; then
    echo "Only for Alpine"
    exit 1
fi
cd "$(dirname "$0")"

### Installation
install() { install -m644 "$@"; }
install bashrc /etc/bash/drakohost.sh
install sshd.conf /etc/ssh/sshd_config.d/drakohost.conf

install htoprc /etc/htoprc
install -D htoprc-root ~/.config/htop/htoprc
install nanorc /etc/nanorc

install -D ../common/fastfetch.jsonc /etc/fastfetch/config.jsonc
install -D ../common/startup.py /etc/python/startup.py
install -m755 ../common/py /usr/local/bin/py
install -m755 ../common/randint /usr/local/bin/randint

pkgs="eza htop fastfetch miniserve xxd bat wget file 7zip nano nano-syntax bash tmux"
if ! pkg show $pkgs 2>/dev/null >/dev/null; then
    apk add $pkgs --virtual dhbase
fi

# No chsh on Alpine
sed 's|root:x:0:0:root:/root:/bin/sh|root:x:0:0:root:/root:/bin/bash|' -i /etc/passwd

rc-service sshd restart
