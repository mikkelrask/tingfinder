# Tingfinder.py

Tingfinder is a webcrawler made with python and selenium, that searches 3 of the major trading platforms in denmark; Den Blå Avis, Gul&Gratis and Lauritz.com for a predefined list of products, that we look for. 

Basicly we got a `.csv` file with our search terms, realistic minimum price and our max price. Then tingfinder tells us if we got any hits, how many, and a direct link to the overview page for the given platform. 

## Why?
Well, I know I didn't reinvent the wheel or anything like that, I was just playing around with python, and wanted to learn more about selenium as a tool. And at first I wanted to try out the "amazon price tracker"-idea, that almost every programming youtuber has tried to convince me to do, and from what I can figure out, amazon has now stopped supporting bots scraping their website, so I had to look elsewhere for websites to play with. 

I then made a simple version, where I could put in a specific product, and let the app notify me, whenever it was for sale.

One thing lead to another, and here is where we ended up, where I specialized the whole script for my friend who does trading with used furniture and stuff like that. However I still find it very useful for my own sake, and do use it on my own.  

### Requirements
Before installing make sure you have following programs installed:
[python, pip](https://www.python.org/downloads/), [google chrome](https://www.google.com/chrome/) and [chromedriver](https://chromedriver.chromium.org/downloads).

## Installing
```
git clone https://github.com/mikkelrask/tingfinder.git
cd tingfinder
sudo chmod +x install.sh
./install.sh
```
# How it works
Like mentioned I use a library called [Selenium](https://pypi.org/project/selenium/) to basicly open up a headless (no window) instance of Google Chrome, and product by product visit the trading platforms, insert our search terms and min/max prices, and notify us, if there's any hits.

It saves the number of hits for each product line in a cache data folder, and only notifies us, if the number of hits has gone up, since our last search.

The script uses [notify-send](https://pypi.org/project/notify-send/) to alert us, when products has shown up in our searches, just as the std.output tells us what it does at any given moment. Usually I forward the std.out to a file called output.log on my desktop. 

How I use it, is through a cronjob that runs once every half hour, as long as my computer is on, and simply ship the output to the log on my desktop. 

If you have [cron](https://wiki.archlinux.org/index.php/Cron) installed on your system you can add tingfinder.py to your cronjobs by firing up a terminal and type 
`crontab -e`

In that file you put in this line - and remember to put your username where it says YOUR-USER

`*/30 * * * * /usr/local/bin/tingfinder.py > /home/YOUR-USER/Desktop/output.log`

## Uninstalling
Open up the git folder you downloaded, change permissions to uninstall.sh to be executable and run the uninstall script.
`cd tingfinder`
`sudo chmod +x uninstall.sh`
`./uninstall.sh`

## Where do I want to go
Well, it's not like I have major plans for this scraper, but in the interest of learning, I still want to make this better.
- I want to make a single database, rather than one for each product and platform. 
- I want the user to be able to give the script arguments to disable and enable different platforms
- I want the user to be able to give the script an argument to use a specific csv file path (default is in $HOME/tingfinder.csv)
- Use [phantomJS](https://pypi.org/project/phantomjs/) instead of headless Chrome to let it be run on servers.
- I want the script to have a man page and a `-h` flag to show it as well.
- I want the user to be able to pick an HTML/md rapport, as output options.
