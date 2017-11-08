#!/bin/bash
# Vivaldi BASH Installer For Current Version On DEB and RPM Based 32-bit and 64-bit Linuxes
# Jeremy O'Connell @ https://www.cyberws.com/
# Not as well tested - use at your own risk
# Version 1.0

# Set important variables

# Vivaldi Branch To Install
VIVALDI_BRANCH="vivaldi-stable"

# Vivaldi DEB REPO URL
VIVALDI_REPO_URL="http://repo.vivaldi.com/stable/deb/pool/main/"

# System Installer
SYSTEM_INSTALLER="gdebi -n"

# Vivaldi Package Type
VIVALDI_PACKAGE_TYPE="deb"

# Does system use yum?
if command -v yum >/dev/null 2>&1
then
	SYSTEM_INSTALLER="yum install"
	VIVALDI_PACKAGE_TYPE="rpm"
fi

# Does system use dnf?
if command -v dnf >/dev/null 2>&1
then
	SYSTEM_INSTALLER="dnf install"
	VIVALDI_PACKAGE_TYPE="rpm"
fi

# System Bit Type - 64 or 32
SYSTEM_BIT_TYPE=`uname -m`
if test "$SYSTEM_BIT_TYPE" == "x86_64"
then
	# Set branch correctly and file type - different methods for rpm vs deb
	if test "$VIVALDI_PACKAGE_TYPE" == "rpm"
	then
		VIVALDI_REPO_URL="http://repo.vivaldi.com/stable/rpm/x86_64/"
		VIVALDI_BRANCH=$VIVALDI_BRANCH'-'
		VIVALDI_FILE="-1.x86_64.$VIVALDI_PACKAGE_TYPE"
	else
		VIVALDI_BRANCH=$VIVALDI_BRANCH'_'
		VIVALDI_FILE="_amd64.$VIVALDI_PACKAGE_TYPE"
	fi
else
	# Set branch correctly and file type - different methods for rpm vs deb
	if test "$VIVALDI_PACKAGE_TYPE" == "rpm"
	then
		VIVALDI_REPO_URL="http://repo.vivaldi.com/stable/rpm/i386/"
		VIVALDI_BRANCH=$VIVALDI_BRANCH'-'
		VIVALDI_FILE="-1.i386.$VIVALDI_PACKAGE_TYPE"
	else
		VIVALDI_BRANCH=$VIVALDI_BRANCH'_'
		VIVALDI_FILE="_i386.$VIVALDI_PACKAGE_TYPE"
	fi
fi

# Get information for Vivaldi repo and remove line breaks
VIVALDI_DL_PG=`curl $VIVALDI_REPO_URL | tr "\n" '|||'`

# Remove HTML and extra spaces
VIVALDI_DL_PG=`echo $VIVALDI_DL_PG | sed 's|<[^>]*>||g' | sed -e's/  */ /g'`

# Make an array
IFS='|' read -a VIVALDI_DL_ARRAY <<< "$VIVALDI_DL_PG"

# Set current version
VIVALDI_CURRENT_VERSION='1'

# Process repo entries
for VIVALDI_DL_ITEM in "${VIVALDI_DL_ARRAY[@]}"
do
	# If a stable version and amd64
	if [[ $VIVALDI_DL_ITEM == *"$VIVALDI_BRANCH"* ]] && [[ $VIVALDI_DL_ITEM == *"$VIVALDI_FILE"* ]]
	then
		IFS=' ' read -a VIVALDI_DL_ITEM_DATA <<< "${VIVALDI_DL_ITEM}"
		DL_FILE_NAME="${VIVALDI_DL_ITEM_DATA[0]}"

		# Get file version - different methods for rpm vs deb
		if test "$VIVALDI_PACKAGE_TYPE" == "rpm"
		then
			IFS='-' read -a VIVALDI_FILE_NAME_DATA <<< "$DL_FILE_NAME"
			DL_FILE_VERSION="${VIVALDI_FILE_NAME_DATA[2]}"
		else
			IFS='_' read -a VIVALDI_FILE_NAME_DATA <<< "$DL_FILE_NAME"
			DL_FILE_VERSION="${VIVALDI_FILE_NAME_DATA[1]}"
		fi

		# Update current version if file version is greater
		if (( $(echo "$DL_FILE_VERSION $VIVALDI_CURRENT_VERSION" | awk '{print ($1 > $2)}') ))
		then
			VIVALDI_CURRENT_VERSION="$DL_FILE_VERSION"
		fi
	fi
done

# Set download file
VIVALDI_DL_FILE=$VIVALDI_BRANCH$VIVALDI_CURRENT_VERSION$VIVALDI_FILE

# Download, install, then remove file
cd ~/Downloads/
curl -O $VIVALDI_REPO_URL$VIVALDI_DL_FILE
sudo $SYSTEM_INSTALLER $VIVALDI_DL_FILE
rm -f $VIVALDI_DL_FILE
