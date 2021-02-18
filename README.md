# Tingfinder 🔎

Tingfinder is a webcrawler made with python and selenium, that searches 3 of the major trading platforms in denmark; Den Blå Avis, Gul&Gratis and Lauritz.com for a predefined list of products, that we look for. A wrapper, basicly.

We got a "search agent" - a simple `.csv` file that holds our search terms, realistic minimum price and our max price. Then tingfinder tells us if we got any hits, how many, and a direct link to the overview page for the given platform. 

## How it works
Like mentioned I used the [Selenium](https://pypi.org/project/selenium/) library to open up a headless (no window) Chrome instance, and line by line, product by product visit the 3 trading platforms, insert our search terms and min/max prices, and notify us, if there's any hits.

It saves the number of hits for each product line in a cache data folder, and only notifies us, if the number of hits has gone up, since our last search. For now it uses a tiny [pickle](https://pypi.org/project/pickle-database/) database to store the values.

The script uses [notify-send](https://pypi.org/project/notify-send/) to alert us, when products has shown up in our searches, just as the std.output tells us what it does at any given moment. Usually I forward the std.out to a file called output.log on my desktop. 

How I personally use it, is automatically through a cronjob, that runs on it's own every 30 minutes, as long as my computer is turned on, and simply ship the output to a log file on my desktop. 

Open your crontab (*nix-systems only)
`crontab -e`

In that file you put in this line - and remember to put your username where it says YOUR-USER

`*/30 * * * * /usr/local/bin/tingfinder.py > /home/YOUR-USER/Desktop/output.log`
and save.
## Why?
Well, I know I didn't reinvent the wheel or anything like that, I was just playing around with python, and wanted to learn more about selenium as a tool. And at first I wanted to try out the "amazon price tracker"-idea, that almost every programming youtuber has tried to convince me to do, and from what I can figure out, amazon has now stopped supporting bots scraping their website, so I had to look elsewhere for websites to play with. 

I then made a simple version, where I could put in a specific product, and let the app notify me, whenever it was for sale.

One thing lead to another, and here is where we ended up, where I specialized the whole script for my friend who does trading with used furniture and stuff like that. However I still find it very useful for my own sake, and do use it on my own.  

# TL;DR
## Requirements
Before installing tingfinder make sure you have following programs in your system:
[python, pip](https://www.python.org/downloads/), [google chrome](https://www.google.com/chrome/) and [chromedriver](https://chromedriver.chromium.org/downloads).

The install script handles the python requirements, which are:
selenium, notify, chromedriver and rich.

## Install
### Linux/macOS:
```
git clone https://github.com/mikkelrask/tingfinder.git
cd tingfinder
sudo chmod +x install.sh
./install.sh
```

### Windows
I have not created any installer for windows.
Please download the latest `standalone` version from the [releases](https://github.com/mikkelrask/tingfinder/releases) page. It works just the same, but can not at the moment be run automatically.

### Uninstall
Go to the git directory, change uninstall.sh permissions to be executable and run the it.
```
cd tingfinder
sudo chmod +x uninstall.sh
./uninstall.sh
```

# To-do
 - ☑️ Switch to a single database, rather than one for each product and platforrm. 
 - ☑️ Ability to enable/disable platforms by giving the script flags/attrubutee
 - ☑️ Ability to choose a specific csv file through a flag
 - ☑️ Switch to [phantomJS](https://pypi.orhjkjkjg/project/phantomjs/) instead of headless Chrome to let it be run on servers.
 - ☑️ I want the script to have a man page and a `-h` flag to show it as well.
 - ☑️ [I](I) want the user to be able to pick an HTML/md rapport, as output options.
