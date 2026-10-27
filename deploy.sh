#!/bin/sh
set -e

deploy() {
    ssh "$1" << "    END"
wget -q https://github.com/Neltharion01/dots/archive/refs/heads/master.zip -O drakohost-dots.zip && \
unzip -q drakohost-dots.zip && \
./dots-master/alpine/install.sh && \
rm -rf drakohost-dots.zip dots-master
    END
}

for h in kor mrz ult; do
    deploy $h
done
