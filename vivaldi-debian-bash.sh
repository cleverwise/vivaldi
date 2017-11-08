#!/bin/bash
# Vivaldi BASH Installer For Current Version on Debian/Ubuntu Linux 64 Bit
# Jeremy O'Connell @ https://www.cyberws.com/
# Version: 1.1

# Vivaldi REPO URL
VIVALDI_REPO_URL="http://repo.vivaldi.com/stable/deb/pool/main/"

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
	if [[ $VIVALDI_DL_ITEM == *"vivaldi-stable_"* ]] && [[ $VIVALDI_DL_ITEM == *"_amd64.deb"* ]]
	then
		IFS=' ' read -a VIVALDI_DL_ITEM_DATA <<< "${VIVALDI_DL_ITEM}"
		DL_FILE_NAME="${VIVALDI_DL_ITEM_DATA[0]}"

		# Get file version
		IFS='_' read -a VIVALDI_FILE_NAME_DATA <<< "$DL_FILE_NAME"
		DL_FILE_VERSION="${VIVALDI_FILE_NAME_DATA[1]}"

		# Update current version if file version is greater
		if (( $(echo "$DL_FILE_VERSION $VIVALDI_CURRENT_VERSION" | awk '{print ($1 > $2)}') ))
		then
			VIVALDI_CURRENT_VERSION="$DL_FILE_VERSION"
		fi
	fi
done

# Set current version file name
VIVALDI_DL_FILE='vivaldi-stable_'$VIVALDI_CURRENT_VERSION'_amd64.deb'

# Download, install, then remove file
cd ~/Downloads/
curl -O $VIVALDI_REPO_URL$VIVALDI_DL_FILE
sudo gdebi -n $VIVALDI_DL_FILE
rm -f $VIVALDI_DL_FILE
