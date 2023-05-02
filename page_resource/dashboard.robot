*** Setting ***
Library    Selenium2Library
Library    RequestsLibrary
Library    Collections

Variables    ../test_data/bee_cloud.py

Variables    ../locator/bee_cloud.py
*** Variables ***

*** Keywords ***
Buka Browser Ke Bee Cloud
    Open Browser    https://app.beecloud.id/site/login    ${browser}
    Maximize Browser Window

Masukkan Username Login Bee Cloud
    input text    ${txt_loginUsername}    ${username_bee_cloud}

Masukkan Password Login Bee Cloud
    input text    ${txt_loginPassword}    ${password_bee_cloud}

Klik Tombol Login Bee Cloud
    click element     ${btn_login}

Tunggu Sampai Masuk Dashboard
    wait until page contains    Dashboard
    Wait For Condition    return document.readyState == "complete"