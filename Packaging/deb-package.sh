#!/bin/bash

# Move to the base folder where the script is located.
cd $(dirname $0)

SOFTWARE_ROOT=$(readlink -f "..")
SOFTWARE_NAME="blizzard-mime-types"
OUTPUT_ROOT="$SOFTWARE_ROOT/release"
SOFTWARE_VERSION="1.1"

RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
LOG_PREFIX="${GREEN}[SOFTWARE]:"
LOG_PREFIX_ORANGE="${ORANGE}[SOFTWARE]:"
LOG_PREFIX_RED="${RED}[SOFTWARE]:"
LOG_SUFFIX='\033[0m'


SOFTWARE_VERSIONED_NAME="$SOFTWARE_NAME-$SOFTWARE_VERSION"
SOFTWARE_TARBALL_NAME="$SOFTWARE_NAME"_"$SOFTWARE_VERSION"
SOFTWARE_DEBUILD_ROOT="$OUTPUT_ROOT/$SOFTWARE_VERSIONED_NAME"

# Update Debian changelog
cd $SOFTWARE_ROOT
dch -v $SOFTWARE_VERSION-1
cd - > /dev/null

if [ ! -d "$SOFTWARE_DEBUILD_ROOT" ]; then	
	# Copy the sources to the build directory
	mkdir -p "$SOFTWARE_DEBUILD_ROOT"
	cp -r "$SOFTWARE_ROOT/debian/" $SOFTWARE_DEBUILD_ROOT
	cp -r "$SOFTWARE_ROOT/mime-definitions/" $SOFTWARE_DEBUILD_ROOT
	cp "$SOFTWARE_ROOT/"* "$SOFTWARE_DEBUILD_ROOT"

	# Create an *.orig.tar.xz archive if one doesn't exist already
	ORIG_TAR="$OUTPUT_ROOT/$SOFTWARE_TARBALL_NAME.orig.tar.xz"
	if [ ! -f "$ORIG_TAR" ]; then
		cd "$SOFTWARE_DEBUILD_ROOT/"
		tar -cJf "$ORIG_TAR" "."
		cd - > /dev/null
	fi
	
	# Build the debian package
	read -p "Ready to build the debian package. Continue? [y/N] " -n 1 -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		cd "$SOFTWARE_DEBUILD_ROOT"
		debuild -S -k28C56D2F
	fi							
fi
