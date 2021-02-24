#!/usr/bin/env bash

#- Installing Tingfinder in /usr/local/bin and making it executable. 
#- Creates data folder in $HOME/.cache/
#- Creates search-agent.csv in $HOME
#- Makes sure Python is installed
#- Makes sure pip is installed
#- Installs libs found in requirements.txt
BOLD=$(tput bold)
NORMAL=$(tput sgr0)

BIN_FOLDER=/usr/local/bin/ # Must be in your path to work proper.
DATA_FOLDER="$HOME"/.cache/tingfinder/data/
CONFIG_FOLDER="$HOME"/.config/tingfinder
GITHUB_URL="https://raw.githubusercontent.com/mikkelrask/tingfinder/main/BUILD"

echo "Install script for ${BOLD}tingfinder.py${NORMAL} - a dba/gulgratis crawler made with selenium."
echo ""
echo "The script will install ${BOLD}tingfinder${NORMAL} in ${BOLD}$BIN_FOLDER${NORMAL} "
echo "and create a data cache folder in ${BOLD}$DATA_FOLDER${NORMAL}."
echo ""
echo "It will also make sure the latest version of ${BOLD}Selenium${NORMAL}, ${BOLD}chromedriver${NORMAL} and and ${BOLD}notify-send${NORMAL} is installed through pip."
echo ""
echo "${BOLD}:: Proceed with installation? [Y/n]${NORMAL}"
read ANSWER
case $ANSWER in                                                                                                                                                                       
     [Yy]|[Yy][Ee][Ss])                                                          
         printf 'Continuing with installation.\n' ;;                             
     [Nn]|[Nn][Oo])                                                              
         printf 'Abandoning installation.\n'                                     
         exit 0 ;;                                                               
     *)                                                                          
         printf 'ERROR: Invalid response -- quitting.\n' 1>&2                    
         exit 2 ;;                                                               
esac       
# Check what OS we are running
echo "${BOLD}!${NORMAL} Detecting OS"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "${BOLD}+${NORMAL} OS: ${BOLD}$OSTYPE${NORMAL} found"
        echo "${BOLD}+${NORMAL} PIP: Installing requirements.txt"
        command -v python3 >/dev/null 2>&1 &&  sudo pip install --upgrade -r ./requirements.txt # POSIX-compliant
        echo "${BOLD}+${NORMAL} PIP: Finished"
elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
        echo "${BOLD}PIP:${NORMAL} Installing requirements.txt"
        echo "OS ${BOLD}$OSTYPE${NORMAL} found"
        command -v python3 >/dev/null 2>&1 &&  pip3 install -r ./requirements.txt # POSIX-compliant
else
    echo "${BOLD}!${NORMAL} Please install dependencies according to your OS. - ${BOLD}requirements.txt${NORMAL}"
fi

if [ ! -f /tmp/tingfinder ]
then
    echo "${BOLD}+${NORMAL} Fetching temporary BUILD files."
    wget -q --show-progress --progress=bar:force:noscroll $GITHUB_URL -O  /tmp/tingfinder
else
    echo "${BOLD}Buildfile already exists. Download latest version? [Y/n]${NORMAL}"
    read ANSWER
    case $ANSWER in
        [Yy]|[Yy][Ee][Ss])                                                          
        echo "${BOLD}+${NORMAL} Continuing with installation.\n"
        wget -q --show-progress --progress=bar:force:noscroll $GITHUB_URL -O  /tmp/tingfinder ;;
        [Nn]|[Nn][Oo])                                                              
        echo "${BOLD}!${NORMAL} Abandoning installation.\n"
        exit 0 ;;                                                               
        *)                                                                          
        printf 'ERROR: Invalid response -- quitting.\n' 1>&2                    
        exit 2 ;;                                                               
    esac          
fi

echo "${BOLD}+${NORMAL} Check if "$HOME"/.cache/tingfinder/data exists."
if [ ! -d $DATA_FOLDER ]
then
    mkdir -p $DATA_FOLDER
    echo "${BOLD}+${NORMAL} Data directory created."
    sed -i '/DATA_FOLDER_PATH/c\DATA_FOLDER="'$DATA_FOLDER'"' /tmp/tingfinder
    echo "${BOLD}+${NORMAL} Data directory path changed to "$DATA_FOLDER" in temporary BUILD file"
    echo ""
else
    echo "${BOLD}*${NORMAL} "$DATA_FOLDER" already exists. Skipping."
    echo ""
fi 

if [ ! -f $HOME/.config/tingfinder/search-agent.csv ]
then
    if [ ! -d $CONFIG_FOLDER ]
    then
        echo "${BOLD}+ ${NORMAL} Creating config folder at $CONFIG_FOLDR"
        mkdir -p $CONFIG_FOLDER
    fi
    FILE_NAME_PATH=$HOME"/.config/tingfinder/search-agent.csv"
    cp ./search-agent.csv $HOME/.config/tingfinder/search-agent.csv 
    echo "${BOLD}+${NORMAL} \"search-agent.csv\" copied to "$HOME
    sed -i '/FILE_NAME_PATH/c\FILE_NAME = "'$FILE_NAME_PATH'"' /tmp/tingfinder
    echo "${BOLD}+${NORMAL} \"search-agent.csv\" Path changed to "$HOME" in temporary BUILD file"
    echo ""
else
    echo "${BOLD}!${NORMAL} \"search-agent.csv\" already exists. Skipping."
    echo ""
fi

if [ ! -f $BIN_FOLDER/tingfinder ]
then
    sudo cp /tmp/tingfinder $BIN_FOLDER/tingfinder.py
    echo "${BOLD}+${NORMAL} Copied tingfinder to $BIN_FOLDER"
    sudo chmod +x $BIN_FOLDER"tingfinder.py"
else
    echo "${BOLD}*${NORMAL} tingfinder.py already exists in $BIN_FOLDER - Reinstall? [Y/n]."    
    read ANSWER
    case $ANSWER in
        [Yy]|[Yy][Ee][Ss])                                                          
        printf 'Continuing with installation.\n'                     
        wget -q --show-progress --progress=bar:force:noscroll $GITHUB_URL -O  /tmp/tingfinder
        sudo cp /tmp/tingfinder $BIN_FOLDER/tingfinder.py
        echo "${BOLD}+${NORMAL} Copied tingfinder to $BIN_FOLDER"
        sudo chmod +x $BIN_FOLDER"tingfinder.py" ;;
        [Nn]|[Nn][Oo])                                                              
        printf 'Abandoning installation.\n'                                     
        exit 0 ;;                                                               
        *)                                                                          
        printf 'ERROR: Invalid response -- quitting.\n' 1>&2                    
        exit 2 ;;                                                               
        esac          
fi

rm /tmp/tingfinder
echo "${BOLD}+${NORMAL} Done cleaning - temporary files removed."
printf "${BOLD}+${NORMAL} Installation done.\n\nTo start using tingfinder please open ${BOLD}search-agent.csv${NORMAL} in a text editor, and edit the products you\'re looking for.\nThe format is: \"name of product\",min-price,max-price"
