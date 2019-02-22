# Scrape Google Trends results for presidential hopefuls
# Gabriel Perez-Putnam 2/22/19

from selenium import webdriver
from selenium.webdriver.common.keys import Keys
import random
import time


def sleep_time(x):
    """Sleep for X seconds times a number between 0 and 1"""
    random_time = random.random() *2* x
    time.sleep(random_time)

def get_zip_stores(driver,zip):
    driver.get(DG_url)
    driver.switch_to.frame("StoreLocator")
    driver.find_element_by_xpath("//select[@name='searchradius']/option[text()='100 MILES']").click()
    sleep_time(5)
    main_input = driver.find_element_by_id("inputchild")
    input_zip  = main_input.find_element_by_class_name("form-control")
    input_zip.clear()
    input_zip.send_keys(zip)
    input_zip.send_keys(Keys.RETURN)
    # get stores
    sleep_time(5)
    stores = driver.find_elements_by_class_name("poi-item")
    zip_stores = []
    for store in stores:
        info = store.get_attribute('innerText').split('\n')
        zip_stores.append(info)
    # print(zip_stores)
    return(zip_stores)

def clean_row_for_export(variables):
    """Prepares a row of data for export"""
    row = (',').join(variables) + '\n'
    return row

def export_to_file(file_name, stores_info):
    """Export the beer information to a file"""
    with open(file_name, 'w+', encoding='utf-8') as f:
        header = ['Store_Number', 'Address', 'City', 'State_Zip']
        export_header = clean_row_for_export(header)
        f.write(export_header)
        for city in stores_info:
            for store in city:
                row = clean_row_for_export(store)
                f.write(row)

def iterate_states(driver):
    """go through list of zipcodes that cover pa with 100 mile rad"""
    zipcodes = ['15642','16061','16833','16823','18702','17543','15530']
    sleep_time(4)
    driver.get(DG_url)
    all_stores = []
    for zip in zipcodes:
        print(zip)
        sleep_time(4)
        stores = get_zip_stores(driver,zip)
        all_stores.append(stores)
    driver.switch_to.default_content()
    return all_stores

def main():
    """controller"""
    # create a new Chrome session
    driver = webdriver.Chrome(executable_path='C:/Users/perez_g/Desktop/Web Scrapping/env/Scripts/chromedriver.exe')
    driver.maximize_window()
    driver.implicitly_wait(30)

    # URL of initial search
    global DG_url
    DG_url = "https://www.dollargeneral.com/store-locator.html"
    stores_info = iterate_states(driver)
    print(stores_info)
    export_to_file('dollar_general_locations.txt', stores_info)

main()
