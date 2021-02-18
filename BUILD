#!/usr/bin/env python
"""
This webscraper opens a headless chrome window and seaches for line in the
tingfinder.csv file on the danish trading platforms dba.dk, gulgratis.dk and
auction house Lauritz.com (experimental)
"""

import time # We use time to do waits between pages
import datetime
import pickle # Pickle is a simple database, to store the number of ads
import csv # CSV is the fileformat of the product sheet.
from rich.console import Console
from notify import notification # we use notify to send notifications to the user
from selenium import webdriver # Selenium is what opens up the browser, and does the stuff
from selenium.webdriver.chrome.options import Options # Options are passed to the Chrome browser
from selenium.webdriver.common.keys import Keys # Keys is so we can send keys to inputs.

# Rich console
console = Console()
# Chrome settings
chrome_options = Options()
chrome_options.add_argument("--no-sandbox") # linux only
#chrome_options.add_argument("--incognito")
chrome_options.add_argument("--headless")

#Initialize the browser and declare where to go
driver = webdriver.Chrome(options=chrome_options)
MIN_VALUE = 0
MAX_VALUE = 0
SEARCH_TERM = ""
COOKIE = False

# Full path to the CSV that holds out search terms, and min/max prices.
FILE_NAME_PATH

DATA_FOLDER_PATH

def slugify(string):
    """
    Turns the seach term into a system friendly format.
    Used to create the database filename for each product/search term.
    """
    return string.replace(" ","-")

def add_plus(string):
    """
    Replaces spaces with plus signs in the passed text string.
    Is used to create a direct search query URL to GulGratis.
    """
    return string.replace(" ","+")

def den_blaa_avis():
    """
    Opens dba.dk, reject cookies, input search terms and prices.
    Notifies user if the number of hits is larger than last search.
    
    """
    dba_url = "https://dba.dk"

    try:
        # See if we have any data on the given product if not db antal = 0
        db_antal = pickle.load(open(DATA_FOLDER + \
                                    slugify(SEARCH_TERM) + "_dba.dat", "rb"))
    except:
        db_antal = 0

    driver.get(dba_url) # Open dba_url.dk in the chrome browser
    driver.implicitly_wait(5)

    try:
        # Try to click the reject COOKIEs button if it's there.
        driver.find_element_by_id("onetrust-reject-all-handler").click()
    except:
        COOKIE = True

    search = driver.find_element_by_id("searchField")

    search.send_keys(SEARCH_TERM) # send search term / product name
    search.send_keys(Keys.RETURN)
    time.sleep(5)

    driver.find_element_by_xpath("//h4[contains(text(), 'Pris')]").click() # Set our price wishes
    price = driver.find_element_by_class_name("rangeFrom") # Min value
    price.send_keys(MIN_VALUE)
    price = driver.find_element_by_class_name("rangeTo") # Max value
    price.send_keys(MAX_VALUE)
    price.send_keys(Keys.RETURN)
    time.sleep(5)

    try:
        # if the td containing "annoncer" exists, it means we have hits on our search.
        antal_annoncer_string = driver.find_element_by_xpath("//td[contains(text(),\
                    'annoncer')]").get_attribute("innerHTML").strip()
        # Extract the integer from the text
        antal = [int(i) for i in antal_annoncer_string.split() if i.isdigit()]
        diff = int(antal[0]) - db_antal # Calculate the difference, if any.
        if diff > 0:
            # If our diff is a positive number:
            string = str(antal[0]) + ' annoncer fundet på dba_url.dk. ' + \
                                    str(diff) + '+ ift forrige søgning.'
            print(str(antal[0]) + ' annoncer fundet. ' + str(diff) + '+ ift forrige søgning.')
            print("URL: " + driver.current_url)
            # Dump the new number of items into the database
            pickle.dump(int(antal[0]), open(DATA_FOLDER + \
                                            slugify(SEARCH_TERM) + "_dba.dat", "wb"))
            notification(string,title=SEARCH_TERM) # Send notification
        elif diff == 0:
            # If the number of hits is the same as last search:
            print("- Ingen nye annoncer. (" + str(antal[0]) + ")")
            print("- URL: " + driver.current_url)
        else:
            # If there are fewer hits than earlier:
            print("- " + str(antal) + " fundet. " + str(diff) + " færre end sidste søgning")
            print("- URL: " + driver.current_url)
            # Dump the new number of items into the database
            pickle.dump(int(antal[0]), open(DATA_FOLDER + \
                                            slugify(SEARCH_TERM) + "_dba.dat", "wb"))
    except:
        print("- " + SEARCH_TERM + " ikke fundet i prisklassen.")

# Check the same on GulGratis
def gul_og_gratis():
    """
    Creates a search query URL for the passed search term and opens
    the URL, accept potential cookies and grabs the number of posts/ads 
    and then notifies the users if diff is higher than last search.
    """
    try: # See if we have any data on the given product else db antal is 0
        db_antal = pickle.load(open(DATA_FOLDER + \
                                    slugify(SEARCH_TERM) + "_gg.dat", "rb"))
    except:
        db_antal = 0

    # On this page we use the search query directly in the URL we're fetching.
    query = add_plus(SEARCH_TERM)
    gulgratis_url_base = "https://www.guloggratis.dk/s/q-"
    gulgratis_url_complete = gulgratis_url_base+query+"?price="+MIN_VALUE+"-"+MAX_VALUE #Build the correct URL
    driver.get(gulgratis_url_complete) # Open search page
    driver.implicitly_wait(5)

    try:
        # If we can find the accept cookie button, click it
        driver.find_element_by_id("onetrust-accept-btn-handler").click()
    except:
        COOKIE = False

    time.sleep(5)

    try: # If there is an H1 tag containing the text "Søgeresultat for" we continue
        gg_antal = int(driver.find_element_by_xpath("//h1[contains(text(),\
        'Søgeresultat for')]/following-sibling::span").get_attribute("innerHTML"))

        diff = gg_antal - db_antal # Compare fresh number of hits with stored ones
        
        if diff > 0:
            # If diff is a positive number, we got new ads.
            string = str(gg_antal) + " fundet på GulGratis.dk. " + \
                str(diff) + "+ ift. forrige søgning."
            print("- " + str(gg_antal) + " fundet. " + str(diff) + \
                  "+ ifh. forrige søgning") # Print result
            print("- URL: " + driver.current_url) # Print URL to products
            notification(string,title=SEARCH_TERM) # Notify the user
            # Dump the new number of items into the database
            pickle.dump(gg_antal, open(DATA_FOLDER + \
                                       slugify(SEARCH_TERM) + "_gg.dat", "wb"))
        elif diff == 0: # If there is products to show, but the number is the same as last search.
            print("- Ingen nye annoncer. (" + gg_antal + ")")
            print("- URL: " + driver.current_url)
        else: # If diff is negative, some products have been removed/sold
            print("- " + gg_antal + " fundet. " + str(diff) + " ift forrige søgning.")
            print("- URL: " + driver.current_url)
    except:
        print("- " + SEARCH_TERM + " ikke fundet i prisklassen.")

def Lauritz_com():
    """
    Search lauritz.com for our products.
    """
    try: # See if we have any data on the given product else db antal is 0
        db_antal = pickle.load(open(DATA_FOLDER + \
                                    slugify(SEARCH_TERM) + "_l.dat", "rb"))
    except:
        db_antal = 0

    driver.get("https://lauritz.com")
    driver.implicitly_wait(5)
    try: # Decline cookies
        driver.find_element_by_id("CybotCookiebotDialogBodyLevelButtonLevelOptinDeclineAll").click()
    except:
        COOKIE = True

    search = driver.find_element_by_id("SearchTextBox")
    search.send_keys(SEARCH_TERM)
    search.send_keys(Keys.ENTER)
    driver.implicitly_wait(5)
    if int(MAX_VALUE)<=2000: # Dial in the price. I use the MAX_VALUE and compare to the filtering options.
        filter = driver.find_element_by_xpath("//option[contains(text(), 'Under 2,000 DKK')]")
    elif int(MAX_VALUE)<=5000:
        filter = driver.find_element_by_xpath("//option[contains(text(), 'Under 5,000 DKK')]")
    elif int(MAX_VALUE)<=10000:
        filter = driver.find_element_by_xpath("//option[contains(text(), 'Under 10,000 DKK')]")
    elif int(MAX_VALUE)<=20000:
        filter = driver.find_element_by_xpath("//option[contains(text(), 'Under 20,000 DKK')]")
    else:
        filter = driver.find_element_by_tag_name("body")
    filter.click() # Click the filtering option
    driver.implicitly_wait(5)
    try:
        antal_annoncer = driver.find_element_by_id("List_TotalItemCount")
        antal_annoncer_string = antal_annoncer.get_attribute("innerHTML")
        # Single out the integer
        l_antal = [int(i) for i in antal_annoncer_string.split() if i.isdigit()]
        diff = int(l_antal[0]) - db_antal
        if diff > 0:
            # If diff is a positive number, we got new ads.
            string = str(l_antal[0]) + " fundet på Lauritz.com. " + \
                str(diff) + "+ ift. forrige søgning."
            print("- " + str(l_antal[0]) + " fundet. " + str(diff) + \
                  "+ ifh. forrige søgning")
            print("URL: " + driver.current_url)
            notification(string,title=SEARCH_TERM)
            # Dump the new number of items into the database
            pickle.dump(l_antal[0], open(DATA_FOLDER + \
                                       slugify(SEARCH_TERM) + "_l.dat", "wb"))
        elif diff == 0:
            print("- Ingen nye annoncer. (" + l_antal[0] + ")")
            print("- URL: " + driver.current_url)
        else:
            print("- " + int(l_antal[0]) + " fundet. " + str(diff) + " ift forrige søgning.")
            print("- URL: " + driver.current_url)
            pickle.dum(l_antal[0], open(DATA_FOLDER + \
                                     slugify(SEARCH_TERM) + "_l.dat", "wb"))
    except:
        print("- " + SEARCH_TERM + " ikke fundet i prisklassen.")




with console.status("[bold green] Søger") as status:
    print(datetime.datetime.now())
    print(" ")
    with open(FILE_NAME, "r") as csvfile:
        datareader = csv.reader(csvfile)
        # Run once for each line in our search agent csv file.
        for row in datareader:
            SEARCH_TERM = row[0]
            MIN_VALUE = row[1]
            MAX_VALUE = row[2]
            # Printing output to std.out
            console.print("[bold green]Produkt:[/bold green] \"" + SEARCH_TERM + "\"")
            console.print("[bold green]Pris: [/bold green]" + MIN_VALUE + "-" + MAX_VALUE)
            print(" ")
            console.print("[bold green]DBA.DK")
            den_blaa_avis() # Output from dba.dk
            print(" ")
            console.print("[bold green]GulGratis.dk ")
            gul_og_gratis() # Output from GulGratis.dk
            print(" ")
            console.print("[bold green]Lauritz.com: ")
            Lauritz_com() # Output from Lauritz.com
            print(" ")
            console.print("[bold red]-----------------------------------------")
            print(" ")

if COOKIE == True:
    COOKIE = False
else:
    COOKIE = True
driver.quit()
