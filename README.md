# Cocktail Machine Readme
## Install
Make sure that I2C is enabled
>sudo raspi-config

Interfaces -> I2C

Copy all Files to the raspberry pi.
Give the install.sh file excution rights: 
> sudo chmod +x install.sh

You might have to create a crontab with the command
> sudo crontab -e

then select a text editor, and save the file.
 
Execute the Script: 
> sudo ./install.sh

If the machine only shows the welcome screen, there ususally is no DB access.
Reboot the machine
## Manual start up
execute python/cocktailMachine.py as a python script:
> python python/cocktailMachine.py
## Properties of the machine
The hostname should always be ***"cocktail-machine"***.
