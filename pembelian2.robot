*** Setting ***
Library    Selenium2Library
Library    RequestsLibrary
Library    Collections
Resource    page_resource/dashboard.robot

*** Keywords ***


*** Test Cases ***
Login Ke Bee Cloud
    Buka Browser Ke Bee Cloud
    Masukkan Username Login Bee Cloud
    Masukkan Password Login Bee Cloud
    Klik Tombol Login Bee Cloud
    Tunggu Sampai Masuk Dashboard

Masuk Ke Pembelian
