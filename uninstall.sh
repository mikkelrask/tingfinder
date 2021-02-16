#!/usr/bin/env bash
if [ -d $HOME/.cache/tingfinder ]
then
    sudo rm -rf $HOME/.cache/tingfinder/
    echo "Removed data folder"
fi

if [ -f /usr/local/bin/tingfinder ]
then
    sudo rm /usr/local/bin/tingfinder
    echo "Removed binary"
fi

if [ -f $HOME/tingfinder.csv ]
then
    sudo rm $HOME/tingfinder.csv
    echo "Removed search agent"
fi

echo "Finished job. Tingfinder has been removed."