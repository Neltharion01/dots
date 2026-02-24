#!/data/data/com.termux/files/usr/bin/bash
set -eo pipefail

die() {
    echo "$@"
    exit 1
}

cleanup() {
    cd $PREFIX/..
    rm -rf usr-n
    echo
}
trap cleanup INT EXIT

### Sanity checks
[[ -n $PREFIX ]] || die "only for termux"
cd "$PREFIX/.."
if [[ -d "usr.bak" ]]; then
    die "prefix backup usr.bak exists"
fi

### Arch?
arch="$(uname -m)"
case "$arch" in
    armv7l|armv8l) arch="arm";;
    aarch64|i686|x86_64) ;;
    *) die "Architecture not supported: $arch";;
esac

### Make usr-n
mkdir "usr-n"
cd "usr-n"

### Download bootstrap
echo "Downloading latest termux-pacman bootstrap..."
curl -LO "https://github.com/termux-pacman/termux-packages/releases/latest/download/bootstrap-$arch.zip"

### Extract
echo "Extracting bootstrap-$arch.zip..."
unzip -q "bootstrap-$arch.zip"
rm "bootstrap-$arch.zip"

### Restore symlinks
# This is just for progress
i=1
total=$(wc -l SYMLINKS.txt | cut -d ' ' -f 1)

while IFS=← read -a arr; do
    # zip supports symlinks, why is this thing used???
    ln -s "${arr[0]}" "${arr[1]}"

    # print progress
    perc=$(( $i * 100 / $total ))
    fill=$(( $i * 25 / $total ))
    empty=$(( 25 - $fill ))
    fill=$(printf "%${fill}s"); fill=${fill// /▇}
    empty=$(printf "%${empty}s")
    echo -ne "Restoring symlinks... $fill$empty $i/$total ($perc%)\r"
    (( i++ ))
done <SYMLINKS.txt
echo

rm "SYMLINKS.txt"

### Replace prefix
cd ..
PATH=/system/bin
mv -v "usr" "usr.bak"
mv -v "usr-n" "usr"

### Remove old prefix
#rm -rf "usr.bak"

# Remove cleanup trap
trap - EXIT

echo Done
