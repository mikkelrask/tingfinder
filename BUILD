#!/usr/bin/env python
"""
This script will open dba.dk in a headless Chrome browser, and search the
products within a certain pricerange, saved in an excel sheet or CSV file.
"""

import os # Import OS to create directories if nessecary
import time # We use time to do waits between pages
import datetime
import pickle # Pickle is a simple database, to store the number of ads
import csv # CSV is the fileformat of the product sheet.
from notify import notification # we use notify to send notifications to the user
from selenium import webdriver # Selenium is what opens up the browser, and does the stuff
from selenium.webdriver.chrome.options import Options # Options are passed to the Chrome browser
from selenium.webdriver.common.keys import Keys # Keys is so we can send keys to inputs.

# Chrome settings
chrome_options = Options()
chrome_options.add_argument("--no-sandbox") # linux only
#chrome_options.add_argument("--incognito")
chrome_options.add_argument("--headless")

#Initialize the browser and declare where to go
driver = webdriver.Chrome(options=chrome_options)
PRICE = 0
MAXPRICE = 0
PRODUCT = ""
cookie = False

# Full path to the CSV that holds out search terms, and min/max prices.
FILE_NAME_PATH

DATA_FOLDER_PATH

def remove(string):
    """
    remove spaces from PRODUCT to create individual .dat filename
    """
    return string.replace(" ","")

def plus(string):
    """
    replace spaces from PRODUCT to filename
    """
    return string.replace(" ","+")

def den_blaa_avis():
    """
    Search dba.dk for instances of each line in the CSV file.
    If we got any hits, we print it to std.out
    """
    DBA = "https://dba.dk"

    try:
        # See if we have any data on the given product if not db antal = 0
        db_antal = pickle.load(open(DATA_FOLDER + \
                                    remove(PRODUCT) + "_dba.dat", "rb"))
    except:
        db_antal = 0

    driver.get(DBA) # Open DBA.dk in the chrome browser
    driver.implicitly_wait(5)

    try:
        # Try to click the reject cookies button if it's there.
        driver.find_element_by_id("onetrust-reject-all-handler").click()
    except:
        cookie = True

    search = driver.find_element_by_id("searchField")

    search.send_keys(PRODUCT) # send search term / product name
    search.send_keys(Keys.RETURN)
    time.sleep(5)

    driver.find_element_by_xpath("//h4[contains(text(), 'Pris')]").click() # Set our price wishes
    price = driver.find_element_by_class_name("rangeFrom") # Min value
    price.send_keys(PRICE)
    price = driver.find_element_by_class_name("rangeTo") # Max value
    price.send_keys(MAXPRICE)
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
            string = str(antal[0]) + ' annoncer fundet på DBA.dk. ' + \
                                    str(diff) + '+ ift forrige søgning.'
            print(str(antal[0]) + ' annoncer fundet. ' + str(diff) + '+ ift forrige søgning.')
            print("URL: " + driver.current_url)
            # Dump the new number of items into the database
            pickle.dump(int(antal[0]), open(DATA_FOLDER + \
                                            remove(PRODUCT) + "_dba.dat", "wb"))
            notification(string,title=PRODUCT) # Send notification
        elif diff == 0:
            # If the number of hits is the same as last search:
            print("Ingen nye annoncer.")
            print("URL: " + driver.current_url)
        else:
            # If there are fewer hits than earlier:
            print(str(antal) + " fundet. " + str(diff) + " færre end sidste søgning")
            print("URL: " + driver.current_url)
            # Dump the new number of items into the database
            pickle.dump(int(antal[0]), open(DATA_FOLDER + \
                                            remove(PRODUCT) + "_dba.dat", "wb"))
    except:
        print(PRODUCT + " ikke fundet i prisklassen.")

# Check the same on GulGratis
def gul_og_gratis():
    """
    Check gulgratis.dk for all products.
    """
    GG = "https://www.guloggratis.dk/s/q-"
    try: # See if we have any data on the given product else db antal is 0
        db_antal = pickle.load(open(DATA_FOLDER + \
                                    remove(PRODUCT) + "_gg.dat", "rb"))
    except:
        db_antal = 0

    # On this page we use the search query directly in the URL we're fetching.
    query = plus(PRODUCT)
    gg_url = GG+query+"?price="+PRICE+"-"+MAXPRICE
    driver.get(gg_url)
    driver.implicitly_wait(5)

    try:
        # If we can find the accept cookies button, click it
        driver.find_element_by_id("onetrust-accept-btn-handler").click()
    except:
        cookie = False

    time.sleep(5)

    try:
        gg_antal = int(driver.find_element_by_xpath("//h1[contains(text(),\
        'Søgeresultat for')]/following-sibling::span").get_attribute("innerHTML"))

        diff = gg_antal - db_antal
        if diff > 0:
            # If diff is a positive number, we got new ads.
            string = str(gg_antal) + " fundet på GulGratis.dk. " + \
                str(diff) + "+ ift. forrige søgning."
            print(str(gg_antal) + " fundet. " + str(diff) + \
                  "+ ifh. forrige søgning")
            print("URL:" + driver.current_url)
            notification(string,title=PRODUCT)
            # Dump the new number of items into the database
            pickle.dump(gg_antal, open(DATA_FOLDER + \
                                       remove(PRODUCT) + "_gg.dat", "wb"))
        elif diff == 0:
            print("Ingen nye annoncer.")
            print("URL: " + driver.current_url)
        else:
            print(gg_antal + " fundet. " + str(diff) + " ift forrige søgning.")
            print("URL:" + driver.current_url)
    except:
        print(PRODUCT + " ikke fundet i prisklassen.")

def Lauritz_com():
    """
    Search lauritz.com for our products.
    """
    try: # See if we have any data on the given product else db antal is 0
        db_antal = pickle.load(open(DATA_FOLDER + \
                                    remove(PRODUCT) + "_l.dat", "rb"))
    except:
        db_antal = 0

    driver.get("https://lauritz.com")
    driver.implicitly_wait(5)
    try:
        driver.find_element_by_id("CybotCookiebotDialogBodyLevelButtonLevelOptinDeclineAll").click()
    except:
        cookie = True

    search = driver.find_element_by_id("SearchTextBox")
    search.send_keys(PRODUCT)
    search.send_keys(Keys.ENTER)
    driver.implicitly_wait(5)
    time.sleep(5)
    if int(MAXPRICE)<=2000:
        filter = driver.find_element_by_xpath("//option[contains(text(), 'Under 2,000 DKK')]")
    elif int(MAXPRICE)<=5000:
        filter = driver.find_element_by_xpath("//option[contains(text(), 'Under 5,000 DKK')]")
    elif int(MAXPRICE)<=10000:
        filter = driver.find_element_by_xpath("//option[contains(text(), 'Under 10,000 DKK')]")
    elif int(MAXPRICE)<=20000:
        filter = driver.find_element_by_xpath("//option[contains(text(), 'Under 20,000 DKK')]")
    else:
        filter = driver.find_element_by_tag_name("body")
    filter.click()
    time.sleep(5)
    try:
        antal_annoncer = driver.find_element_by_id("List_TotalItemCount")
        antal_annoncer_string = antal_annoncer.get_attribute("innerHTML")
        # Single out the integer
        l_antal = [int(i) for i in antal_annoncer_string.split() if i.isdigit()]
        diff = int(l_antal[0]) - db_antal
        if diff > 0:
            # If diff is a positive number, we got new ads.
            string = str(l_antal[0]) + " fundet på GulGratis.dk. " + \
                str(diff) + "+ ift. forrige søgning."
            print(str(l_antal[0]) + " fundet. " + str(diff) + \
                  "+ ifh. forrige søgning")
            print("URL:" + driver.current_url)
            notification(string,title=PRODUCT)
            # Dump the new number of items into the database
            pickle.dump(l_antal[0], open(DATA_FOLDER + \
                                       remove(PRODUCT) + "_l.dat", "wb"))
        elif diff == 0:
            print("Ingen nye annoncer.")
            print("URL: " + driver.current_url)
        else:
            print(int(l_antal[0]) + " fundet. " + str(diff) + " ift forrige søgning.")
            print("URL: " + driver.current_url)
            pickle.dum(l_antal[0], open(DATA_FOLDER + \
                                     remove(PRODUCT) + "_l.dat", "wb"))
    except:
        print(PRODUCT + " ikke fundet i prisklassen.")




print("Søger...")
print(datetime.datetime.now())
print(" ")
with open(FILE_NAME, "r") as csvfile:
    datareader = csv.reader(csvfile)
    # Run once for each line in our search agent csv file.
    for row in datareader:
        PRODUCT = row[0]
        PRICE = row[1]
        MAXPRICE = row[2]
        # Printing output to std.out
        print("Produkt: " + PRODUCT)
        print("Pris: " + PRICE + "-" + MAXPRICE)
        print("- ")
        print("Den Blå Avis:")
        den_blaa_avis() # Output from DBA.dk
        print("- ")
        print("Gul og Gratis: ")
        gul_og_gratis() # Output from GulGratis.dk
        print("- ")
        print("Lauritz.com: ")
        Lauritz_com() # Output from Lauritz.com
        print(" ")
        print("-----------------------------------------")
        print(" ")

if cookie == True:
    cookie = False
else:
    cookie = True
driver.quit()
