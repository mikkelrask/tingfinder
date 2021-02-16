#!/usr/bin/env bash

#- Installing Tingfinder in /usr/local/bin and making it executable. 
#- Creates data folder in $HOME/.cache/
#- Creates tingfinder.csv in $HOME
#- Makes sure Python is installed
#- Makes sure pip is installed
#- Installs libs found in requirements.txt

echo "Install script for tingfinder - a dba/gulgratis crawler made with selenium."
BIN_FOLDER=/usr/local/bin/ # Must be in your path to work proper.
DATA_FOLDER="$HOME"/.cache/tingfinder/data

# Check what OS we are running
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        command -v python3 >/dev/null 2>&1 &&  sudo pip install -r ./requirements.txt # POSIX-compliant
elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
        which python3
elif [[ "$OSTYPE" == "cygwin" ]]; then
        # POSIX compatibility layer and Linux environment emulation for Windows
        which python3
elif [[ "$OSTYPE" == "msys" ]]; then
        # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
        which python3
elif [[ "$OSTYPE" == "win32" ]]; then
        # I'm not sure this can happen.
        echo "win32"
elif [[ "$OSTYPE" == "freebsd"* ]]; then
        # ...
        echo "freebsd"
else
    echo "Could not detect OS. Exiting"
    exit
fi

cat BUILD > tingfinder

echo "Checking if "$HOME"/.cache/tingfinder/data exists."
if [ ! -d $DATA_FOLDER ]
then
    mkdir -p $DATA_FOLDER
    echo "+ Directory created."
    sed -i '/DATA_FOLDER_PATH/c\DATA_FOLDER="'$DATA_FOLDER'"' tingfinder
    echo "+ Data folder path changed to "$DATA_FOLDER" in BUILD"
    echo ""
else
    echo "* "$DATA_FOLDER" already exists. Skipping."
    echo ""
fi 

if [ ! -f $HOME/tingfinder.csv ]
then
    FILE_NAME_PATH=$HOME"/tingfinder.csv"
    cp ./tingfinder.csv $HOME 
    echo "+ \"tingfinder.csv\" copied to "$HOME
    sed -i '/FILE_NAME_PATH/c\FILE_NAME = "'$FILE_NAME_PATH'"' tingfinder
    echo "+ \"tingfinder.csv\" path changed to "$HOME
    echo ""
else
    echo "* tingfinder.csv already exists. Skipping."
    echo ""
fi

if [ ! -f $BIN_FOLDER/tingfinder ]
then
    sudo cp ./tingfinder $BIN_FOLDER/tingfinder.py
    echo "+ Copied tingfinder to $BIN_FOLDER"
    sudo chmod +x $BIN_FOLDER"tingfinder.py"
else
    printf "* tingfinder.py already exists in $BIN_FOLDER - skipping."    
fi

rm tingfinder
echo "+ Done cleaning - temporary files removed."
printf "\n -- Installation done.\n\nTo start using tingfinder please open tingfinder.csv in a text editor, and edit the products you're looking for. The format is: \"name of product\",min-price,max-price\n\nEnjoy!"
