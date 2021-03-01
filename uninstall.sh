#!/usr/bin/env bash
BOLD=$(tput bold)
NORMAL=$(tput sgr0)

BIN_FOLDER=/usr/local/bin/ # Must be in your path to work proper.
DATA_FOLDER="$HOME"/.cache/tingfinder/
CONFIG_FOLDER="$HOME"/.config/tingfinder/
ERRNO=0
echo "This will remove ${BOLD}Tingfinder.py${NORMAL} and all it's settings"
echo ""
echo "${BOLD}Following files and directories will be deleted:${NORMAL}"
echo "- $BIN_FOLDER"tingfinder.py
echo "- $CONFIG_FOLDER"
echo "- $DATA_FOLDER"
echo ""
echo "${BOLD}:: Proceed? [Y/n]${NORMAL}"
read ANSWER
case $ANSWER in                                                                                                                                                                       
     [Yy]|[Yy][Ee][Ss])                                                          
         printf '\n' ;;                             
     [Nn]|[Nn][Oo])                                                              
         printf "${BOLD}[!]${NORMAL} No programs or settings was removed. Abandoning process.\n"
         exit 0 ;;                                                               
     *)                                                                          
         printf "${BOLD}[!] ERROR:${NORMAL} Invalid response - quitting.\n" 1>&2                    
         exit 2 ;;                                                               
esac       

if [ -d $HOME/.cache/tingfinder ]
then
    sudo rm -rf $HOME/.cache/tingfinder/
    echo "${BOLD}+${NORMAL} Data cache (${BOLD}$DATA_FOLDER${NORMAL}) removed"
else
    ((ERRNO=ERRNO+1))
    echo "${BOLD}! ERROR:${NORMAL} ${BOLD}$DATA_FOLDER${NORMAL} not found - Nothing to remove."
fi

if [ -d $CONFIG_FOLDER ]
then
    sudo rm -rf $CONFIG_FOLDER 
    echo "${BOLD}+${NORMAL} Config folder (${BOLD}$CONFIG_FOLDER${NORMAL}) removed"
else
    ((ERRNO=ERRNO+1))
    echo "${BOLD}! ERROR: $HOME/.config/tingfinder/search-agent.csv${NORMAL} not found - Nothing to remove."
fi

if [ -f /usr/local/bin/tingfinder.py ]
then
    sudo rm /usr/local/bin/tingfinder.py
    echo "${BOLD}+${NORMAL} "$BIN_FOLDER"tingfinder.py removed"
else
    ((ERRNO=ERRNO+1))
    echo "${BOLD}! ERROR: Tingfinder.py${NORMAL} not found in ${BOLD}$BIN_FOLDER${NORMAL} - Nothing to remove."
fi
echo ""

if [ $ERRNO == 3 ]
then
    echo "${BOLD}[!] ERROR:${NORMAL} Nothing to remove - exiting."
elif [ $ERRNO != 0 ]
    then
        echo "${BOLD}+${NORMAL} Uninstalled with $ERRNO errors."
else
    echo "${BOLD}+${NORMAL} Finished job. Tingfinder.py has successfully been removed."
fi
