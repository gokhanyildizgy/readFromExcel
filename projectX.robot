*** Settings ***
Documentation                                       Hotel Crawler
Library                                             Collections
Library                                             Selenium2Library
Library                                             String
Library                                             ExcelLibrary
Library                                             CSVLibrary

*** Variables ***
${browser}          chrome
${url}              https://www.etstur.com/

*** Test Cases ***
Read csv file to a list example test
  @{list}=  read csv file to list  /Users/gokhanyildiz/Desktop/hotels.csv
  Log  ${list[0]}
  Log  ${list[1]}
  log to console  ${list[0]}
  log to console  ${list[1]}
  set global variable  ${list[0]}

Hotel Search
    [Documentation]            Search Hotels from Excel File
    open browser               ${url}    ${browser}
    maximize browser window
    Login
    User Searches an Hotel  ${hotel_name}
    Choose Dates and Search
    Click First Hotel
    Click Add Person Info Button
    Add Person
    Click Continue To Payment Button
    Quit Browser

*** Keywords ***
Login
    click element  css=#userMenu > div.status.non-login > a.login
    wait until page contains element  id=memberOperationsContainer
    input text  id=userName  hotelsearchets@gmail.com
    input text  id=pass  denemeEts123
    click element  id=loginButton
    wait until page contains    Hotel Search

User Searches an Hotel
    [Arguments]  ${hotel_name}
    go to  https://www.etstur.com/${hotel_name}

Choose Dates and Search
    scroll to "id=checkInDate" element
    click element  id=checkInDate
    : FOR    ${INDEX}    IN RANGE    1    6
    \    click element  css=#searchRoomSection > div.room-search > fieldset.fieldset.check-in > div > div > div > div.datepick-nav > a.datepick-cmd.datepick-cmd-next
    click element  css=#searchRoomSection > div.room-search > fieldset.fieldset.check-in > div > div > div > div.datepick-month-row > div.datepick-month.first > table > tbody > tr:nth-child(2) > td:nth-child(3) > a
    click element  css=#searchRoomSection > div.room-search > fieldset.fieldset.check-in > div > div > div > div.datepick-month-row > div.datepick-month.first > table > tbody > tr:nth-child(4) > td:nth-child(4) > a
    click element  id=searchRoomBtn

Click First Hotel
    scroll to "id=selectRoomBtn0" element
    ${first_hotel}  get webelement  id=selectRoomBtn0
    click element  ${first_hotel}
    wait until page contains  Ekstra Ürünler Ekle


Click Add Person Info Button
    ${add_person}  get webelement  id=btn-nextPersonInfo
    scroll to "${add_person}" element
    click element  ${add_person}
    wait until page contains  Kişi Bilgileri

Add Person
    click element  xpath=//*[@id="aduldRow1"]/div[1]/a
    wait until page contains element  id=modalWindowContent
    sleep  2
    click element  id=contactBtn0
    sleep  1

Click Continue To Payment Button
    scroll to "id=btn-nextPayment" element
    click element  id=btn-nextPayment
    wait until page contains  Ödeme Seçenekleri
    wait until page contains  Rezervasyon Bilgileriniz
    wait until page contains  Ahmet Arikan

Scroll to "${Element}" element
    wait until element is visible  ${Element}
    ${Height}    Get Vertical Position    ${Element}
    ${Height}    convert to integer    ${Height}
    ${Height}    evaluate    ${Height}+150
    Execute Javascript  window.scrollTo(0, ${Height})
    sleep    1

Quit Browser
    close all browsers
