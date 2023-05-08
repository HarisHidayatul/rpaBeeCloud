*** Setting ***
# Library    SeleniumLibrary
Library    Selenium2Library
Library    RequestsLibrary
Library    Collections

#inisialisasi variable
Variables    init.py

*** Variables ***
# ${base_url}    http://localhost:8080
${child_url}    /robot/api/pembayaran/show
${Tanggal}    00-00-00
${Termin}    kosong
${loopCount}    ${0}
${xpathListCabang}    //*[@id="select2-results-1"]/li
${xpathListCabang2}    //*[@id="select2-results-1"]
# ${xpathTablePembelian}    /html/body/div[3]/div[2]/div[1]/div[2]/div/div[2]/div[2]/form/div[1]/div[4]/div/div/table/tbody

*** Keywords ***


*** Test Cases ***
Buka Browser Dan Lakukan Login
    Open Browser    https://app.beecloud.id/site/login    Edge
    Maximize Browser Window
    input text    id:loginform-username    ${username_bee_cloud}
    input text    id:loginform-password    ${password_bee_cloud}
    click element    xpath://*[@id="login-form"]/div[3]/ul/button
    Sleep    3s

Buka Menu Pembayaran Kemudian Buat Baru
    click element    xpath:/html/body/div[3]/div[1]/div/div/ul/li[8]/a
    Sleep   1s
    click element    xpath:/html/body/div[3]/div[1]/div/div/ul/li[8]/ul/li[2]/a
    Sleep   1s
    click element    xpath:/html/body/div[3]/div[2]/div/div[1]/p/a[2]
    Sleep    2s

Get API Pembayaran Kemudian Lakukan Input Data
    #Masukkan Cabang
    click element    xpath://*[@id="s2id_branch_id"]/a
    Press Keys    xpath://*[@id="s2id_autogen1_search"]    CTRL+a+BACKSPACE
    # input text    xpath://*[@id="s2id_autogen1_search"]    ampel
    ${count_cabang}    get element count    xpath:${xpathListCabang}
    log to console    ${count_cabang}
    FOR    ${index}    IN RANGE    1    ${count_cabang}
        ${textCabang}    Get Text    xpath:${xpathListCabang2}/li[${index}]/div
        log to console    ${textCabang}
        IF    '${textCabang}' == 'trial'    BREAK
        Press Key    xpath://*[@id="s2id_autogen1_search"]    \ue015
        # /html/body/div[10]/ul/li[2]/div/span
    END
    Press Keys    xpath://*[@id="s2id_autogen1_search"]    ENTER
    
    # FOR    ${index}    IN RANGE    0    ${indexCabang}
    #     Press Key    xpath://*[@id="s2id_autogen1_search"]    \ue015
    #     Sleep     1s
    # END
    # Press Keys    xpath://*[@id="s2id_autogen1_search"]    ENTER
    # Sleep    1s

Logout BeeCloud
    click element    xpath://*[@id="dropdownuser"]/div/div[1]
    Sleep    1s
    click element    xpath://*[@id="dropdownuser"]/li[7]/a
    Sleep    3s