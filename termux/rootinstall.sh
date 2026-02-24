#!/bin/bash
set -e

if [[ $USER != root ]]; then
    echo "need root"
    exit 1
fi

install -Dv htoprc-root ~/.config/htop/htoprc
