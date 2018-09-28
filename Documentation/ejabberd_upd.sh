#!/bin/bash

ovrldir=$(readlink -f "$(dirname "$0")/..")
ejabberd_ebuild=$(ls $ovrldir/net-im/ejabberd/*.ebuild | tail -n1)

die() {
	echo "ERROR: $@" >&2; exit 1;
}

update_pkg() {
	pkg="$1"
	atom=$(echo "$pkg" | grep -oP '[\w-_]+/[\w_.\d]+')
	ebuild=$(ls $ovrldir/$atom/*.ebuild | tail -n1)
	name=$(basename $pkg)
	dst_ebuild=$ovrldir/$atom/$name.ebuild
	git mv $ebuild $dst_ebuild
	ebuild $dst_ebuild digest || die "Failed to update $pkg"
	# TODO check deps of each dep
}

# mark all updated packages with '!' n line-start in ejabberd ebuild
while read -r pkg; do
	#echo $pkg
	update_pkg $pkg
done < <(grep -P '^!' $ejabberd_ebuild | grep -oP '[\w-_]+/[\w-_.\d]+')

#cd $ovrldir
#LANG=C git status | grep renamed

