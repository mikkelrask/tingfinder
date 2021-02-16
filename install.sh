#!/usr/bin/env bash

#- Installing Tingfinder in /usr/local/bin and making it executable. 
#- Creates data folder in $HOME/.cache/
#- Creates tingfinder.csv in $HOME
#- Makes sure Python is installed
#- Makes sure pip is installed
#- Installs libs found in requirements.txt
BOLD=$(tput bold)
NORMAL=$(tput sgr0)
clear
echo "Install script for ${BOLD}tingfinder${NORMAL} - a dba/gulgratis crawler made with selenium."
BIN_FOLDER=/usr/local/bin/ # Must be in your path to work proper.
DATA_FOLDER="$HOME"/.cache/tingfinder/data

# Check what OS we are running
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        command -v python3 >/dev/null 2>&1 &&  sudo pip install -r ./requirements.txt # POSIX-compliant
elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
        command -v python3 >/dev/null 2>&1 &&  pip3 install -r ./requirements.txt # POSIX-compliant
else
    echo "${BOLD}!${NORMAL} Please install dependencies according to your OS. - ${BOLD}requirements.txt${NORMAL}"
fi

if [ ! -f /tmp/tingfinder ]
then
    echo "${BOLD}+${NORMAL} Creating temp files."
    cat BUILD > /tmp/tingfinder
fi

echo "${BOLD}+${NORMAL} Checking if "$HOME"/.cache/tingfinder/data exists."
if [ ! -d $DATA_FOLDER ]
then
    mkdir -p $DATA_FOLDER
    echo "${BOLD}+${NORMAL} Data directory created."
    sed -i '/DATA_FOLDER_PATH/c\DATA_FOLDER="'$DATA_FOLDER'"' /tmp/tingfinder
    echo "${BOLD}+${NORMAL} Data directory path changed to "$DATA_FOLDER" in BUILD file"
    echo ""
else
    echo "${BOLD}*${NORMAL} "$DATA_FOLDER" already exists. Skipping."
    echo ""
fi 

if [ ! -f $HOME/tingfinder.csv ]
then
    FILE_NAME_PATH=$HOME"/tingfinder.csv"
    cp ./tingfinder.csv $HOME 
    echo "${BOLD}+${NORMAL} \"tingfinder.csv\" copied to "$HOME
    sed -i '/FILE_NAME_PATH/c\FILE_NAME = "'$FILE_NAME_PATH'"' /tmp/tingfinder
    echo "${BOLD}+${NORMAL} \"tingfinder.csv\" path changed to "$HOME
    echo ""
else
    echo "${BOLD}*${NORMAL} tingfinder.csv already exists. Skipping."
    echo ""
fi

if [ ! -f $BIN_FOLDER/tingfinder ]
then
    sudo cp /tmp/tingfinder $BIN_FOLDER/tingfinder.py
    echo "${BOLD}+${NORMAL} Copied tingfinder to $BIN_FOLDER"
    sudo chmod +x $BIN_FOLDER"tingfinder.py"
else
    printf "${BOLD}*${NORMAL} tingfinder.py already exists in $BIN_FOLDER - skipping."    
fi

rm /tmp/tingfinder
echo "${BOLD}+${NORMAL} Done cleaning - temporary files removed."
printf "\n - Installation done.\n\nTo start using tingfinder please open tingfinder.csv in a text editor, and edit the products you're looking for. The format is: \"name of product\",min-price,max-price\n\nEnjoy!"
