# Cocktail Machine Readme
## Install
Copy all Files to the raspberry pi.
Give the install.sh file excution rights: 
> sudo chmod +x install.sh

Execute the Script: 
> sudo ./install.sh

If the machine only shows the welcome screen, there ususally is no DB access.
Reboot the machine
## Manual start up
execute python/cocktailMachine.py as a python script:
> python python/cocktailMachine.py
## Properties of the machine
The hostname should always be ***"cocktail-machine"***.

After running the install.sh script there will always be the setting for a wifi connection named:

***SSID***: cocktail-machine

***PASSWORD***: cocktail-machine

This just so you can throw a wifi connection that the raspi knows, so you dont have to open the case (yet again).