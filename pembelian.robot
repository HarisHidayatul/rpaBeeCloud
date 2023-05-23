*** Setting ***
# Library    SeleniumLibrary
Library    Selenium2Library
Library    RequestsLibrary
Library    Collections

#inisialisasi variable
Variables    init.py

*** Variables ***
# ${base_url}    http://localhost:8000
${child_url}    /robot/api/pembelian/show
${Tanggal}    00-00-00
${Termin}    kosong
${loopCount}    ${0}
${xpathTablePembelian}    /html/body/div[3]/div[2]/div[1]/div[2]/div/div[2]/div[2]/form/div[1]/div[4]/div/div/table/tbody

*** Keywords ***


*** Test Cases ***
Buka Browser Dan Lakukan Login
    Open Browser    https://app.beecloud.id/site/login    Edge
    Maximize Browser Window

    input text    id:loginform-username    ${username_bee_cloud}
    input text    id:loginform-password    ${password_bee_cloud}
    click element    xpath://*[@id="login-form"]/div[3]/ul/button
    Sleep    3s

Buka Menu Pembelian Kemudian Buat Baru
    click element    xpath://*[@id="master_menu_purc"]
    Sleep   1s
    click element    xpath://*[@id="menu_purc"]
    Sleep   3s
    click element    xpath://*[@id="add_purc"]/a[2]
    Sleep    2s

Get API Pembelian Kemudian Lakukan Input Data
    FOR    ${infinityLoop}    IN RANGE    9999
        create session    myssion    ${base_url}
        ${response}=    get request    myssion    ${child_url}
    
        #validate data
        ${status_code}=    convert to string    ${response.status_code}
        should be equal    ${status_code}    200

        ${contentType}=    get from dictionary    ${response.headers}    Content-Type
        should contain    ${contentType}    application/json

        ${contentString}=    convert to string    ${response.content}
        ${contentData}=    evaluate    json.loads($contentString)    json
        ${Tanggal}=    convert to string    ${contentData['Tanggal']}
        
        ${Keywoard}=    convert to string    ${contentData['keywoard']}

        ${Termin}=    convert to string    ${contentData['termin']}
        # log to console    ${Termin}

        ${Cabang}=    convert to string    ${contentData['cabang']}

        ${Notes}=    convert to string    ${contentData['Notes']}
        ${idRobotPembelian}=    convert to string    ${contentData['idRobotPembelian']}
        @{DataPembelian}=    Copy List    ${contentData['Data']}    deepcopy=True
        
        ${countPembelian}=    Get length    ${DataPembelian}
        Exit For Loop If    ${countPembelian} == 0

        #Masukkan Tanggal
        Press Keys    xpath://*[@id="trxdate-id"]    CTRL+a+BACKSPACE
        input text    xpath://*[@id="trxdate-id"]    ${Tanggal}[0:10]
        Press Keys    xpath://*[@id="trxdate-id"]    ENTER
        Sleep    1s

        #Masukkan termin
        click element    xpath://*[@id="s2id_cash_id-id"]/a
        input text    xpath://*[@id="s2id_autogen2_search"]    ${Keywoard}
        ${scroll_termin}    Set Variable    ${1}
        ${count_termin}    get element count    xpath://*[@id="select2-results-2"]/li
        FOR    ${index}    IN RANGE    1    ${count_termin}
            ${textTermin}    Get Text    xpath://*[@id="select2-results-2"]/li[${index}]/div
            # log to console    ${textTermin}
            IF    '${textTermin}' == '${Termin}'    BREAK
            ${scroll_termin}=    Set Variable   ${scroll_termin + 1}
            Press Key    xpath://*[@id="s2id_autogen2_search"]    \ue015
        END

        #Pastikan data yang ada di termin sudah benar
        IF    ${count_termin} == ${1}
            ${textFinalTermin}    Get Text    xpath://*[@id="select2-results-2"]/li/div
        ELSE
            ${textFinalTermin}    Get Text    xpath://*[@id="select2-results-2"]/li[${scroll_termin}]/div
        END
        Should Be Equal As Strings    '${textFinalTermin}'     '${Termin}'
        Press Keys    xpath://*[@id="s2id_autogen2_search"]    ENTER
        Sleep    1s

        #Masukkan semua input pembelian
        ${loopCount}=    Set Variable    ${0}
        FOR    ${DataLoop}    IN    @{DataPembelian}
            ${idItemLoop}    convert to string    ${DataLoop['idBeeCloud']}
            
            execute javascript    window.scrollTo(0,document.body.scrollHeight)
            Sleep   1s

            click element    xpath://*[@id="s2id_item_id"]/a
            input text    xpath://*[@id="s2id_autogen5_search"]    ${idItemLoop}
            Sleep    2s
            Press Keys    xpath://*[@id="s2id_autogen5_search"]    ENTER
            Sleep    1s
            ${loopCount}=    Set Variable    ${loopCount+1}
        END

        execute javascript    window.scrollTo(0,document.body.scrollHeight)
        Sleep    1s
        input text    xpath://*[@id="purc-note"]    ${Notes}

        IF    ${loopCount} > 1
            # /html/body/div[3]/div[2]/div[1]/div[2]/div/div[2]/div[2]/form/div[1]/div[4]/div/div/table/tbody/tr[1]/td[11]/a[1]
            # /html/body/div[3]/div[2]/div[1]/div[2]/div/div[2]/div[2]/form/div[1]/div[4]/div/div/table/tbody/tr[1]/td[11]/a[1]
            ${loopCount}=    Set Variable    ${0}
            FOR    ${DataLoop}    IN    @{DataPembelian}
                #Open file untuk edit
                ${loopCount}=    Set Variable    ${loopCount+1}
                ${newXPath}=    Set Variable    ${xpathTablePembelian}/tr[${loopCount}]/td[11]/a[1]
                
                execute javascript    window.scrollTo(0, document.body.scrollHeight/3)
                Sleep   1s

                click element    xpath:${newXPath}
                Sleep    2s

                #edit qty
                Press Keys    xpath://*[@id="dlgpurcd_qty"]    CTRL+a+BACKSPACE
                input text    xpath://*[@id="dlgpurcd_qty"]    ${DataLoop['qty']}

                #edit harga
                Press Keys    xpath://*[@id="dlgpurcd_listprice"]    CTRL+a+BACKSPACE
                input text    xpath://*[@id="dlgpurcd_listprice"]    ${DataLoop['hargaSatuan']}

                #edit gudang
                click element    xpath://*[@id="s2id_dlgpurcd_wh_id"]/a
                input text    xpath://*[@id="s2id_autogen10_search"]    ${Keywoard}
                ${scroll_gudang}    Set Variable    ${1}
                ${count_gudang}    Get Element Count    xpath://*[@id="select2-results-10"]/li
                FOR    ${index}    IN RANGE    1    ${count_gudang}
                    ${textGudang}    Get Text    xpath://*[@id="select2-results-10"]/li[${index}]/div
                    IF    '${textGudang}' == '${DataLoop['gudang']}'    BREAK
                    ${scroll_gudang}=    Set Variable   ${scroll_gudang + 1}
                    Press Key    xpath://*[@id="s2id_autogen10_search"]    \ue015
                END
                #Pastikan data yang ada di gudang sudah benar
                IF    ${count_termin} == ${1}
                    ${textFinalGudang}    Get Text    xpath://*[@id="select2-results-10"]/li/div
                ELSE
                    ${textFinalGudang}    Get Text    xpath://*[@id="select2-results-10"]/li[${scroll_gudang}]/div
                END
                Should Be Equal As Strings    '${textFinalGudang}'     '${DataLoop['gudang']}'
                Press Keys    xpath://*[@id="s2id_autogen10_search"]    ENTER

                #click update
                click element    xpath://*[@id="btnAdd"]
                Sleep    1s
            END
        ELSE
            ${newXPath}=    Set Variable    ${xpathTablePembelian}/tr/td[11]/a[1]
                
            execute javascript    window.scrollTo(0, document.body.scrollHeight/3)
            Sleep   1s

            click element    xpath:${newXPath}
            Sleep    2s

            #edit qty
            Press Keys    xpath://*[@id="dlgpurcd_qty"]    CTRL+a+BACKSPACE
            input text    xpath://*[@id="dlgpurcd_qty"]    ${DataLoop['qty']}

            #edit harga
            Press Keys    xpath://*[@id="dlgpurcd_listprice"]    CTRL+a+BACKSPACE
            input text    xpath://*[@id="dlgpurcd_listprice"]    ${DataLoop['hargaSatuan']}

            #edit gudang
            click element    xpath://*[@id="s2id_dlgpurcd_wh_id"]/a
            input text    xpath://*[@id="s2id_autogen10_search"]    ${Keywoard}
            ${scroll_gudang}    Set Variable    ${1}
            ${count_gudang}    Get Element Count    xpath://*[@id="select2-results-10"]/li
            FOR    ${index}    IN RANGE    1    ${count_gudang}
                ${textGudang}    Get Text    xpath://*[@id="select2-results-10"]/li[${index}]/div
                IF    '${textGudang}' == '${DataLoop['gudang']}'    BREAK
                ${scroll_gudang}=    Set Variable   ${scroll_gudang + 1}
                Press Key    xpath://*[@id="s2id_autogen10_search"]    \ue015
            END
            #Pastikan data yang ada di gudang sudah benar
            IF    ${count_termin} == ${1}
                ${textFinalGudang}    Get Text    xpath://*[@id="select2-results-10"]/li/div
            ELSE
                ${textFinalGudang}    Get Text    xpath://*[@id="select2-results-10"]/li[${scroll_gudang}]/div
            END
            Should Be Equal As Strings    '${textFinalGudang}'     '${DataLoop['gudang']}'
            Press Keys    xpath://*[@id="s2id_autogen10_search"]    ENTER

            #click update
            execute javascript    window.scrollTo(0,document.body.scrollHeight)
            Sleep   1s
                
            click element    xpath://*[@id="btnAdd"]
            Sleep    1s
        END

        #pilih cabang
        execute javascript    window.scrollTo(0,document.body.scrollHeight)
        click element    xpath://*[@id="s2id_purc-branch_id"]/a
        input text    xpath://*[@id="s2id_autogen6_search"]    ${Keywoard}
        ${scroll_cabang}    Set Variable    ${1}
        ${count_cabang}    Get Element Count    xpath://*[@id="select2-results-6"]/li
        FOR    ${index}    IN RANGE    1    ${count_cabang}
            ${textCabang}    Get Text    xpath://*[@id="select2-results-6"]/li[${index}]/div
            IF    '${Cabang}' == '${textCabang}'    BREAK
            ${scroll_cabang}=    Set Variable    ${scroll_cabang + 1}
            Press Key    xpath://*[@id="s2id_autogen6_search"]    \ue015
        END
        #Pastikan data yang ada di cabang sudah benar
        IF    ${count_cabang} == ${1}
            ${textFinalCabang}    Get Text    xpath://*[@id="select2-results-6"]/li/div
        ELSE
            ${textFinalCabang}    Get Text    xpath://*[@id="select2-results-6"]/li[${scroll_cabang}]/div
        END
        Should Be Equal As Strings    '${textFinalCabang}'     '${Cabang}'
        Press Keys    xpath://*[@id="s2id_autogen6_search"]    ENTER
        Sleep    1s

        #click simpan dan buat baru
        execute javascript    window.scrollTo(0,document.body.scrollHeight)
        Sleep   1s
        click element    xpath://*[@id="grpbtn-tour-purc"]/div/div/button
        Sleep    10s
        execute javascript    window.scrollTo(0,-document.body.scrollHeight)
        Sleep   1s
        click element    xpath://*[@id="new_button"]
        Sleep    2s

        
        #Lakukan send API Untuk mengirim data sukses
        create session    myssion2    ${base_url}
        ${response2}=    get request    myssion2    /robot/api/pembelian/done/${idRobotPembelian}
    
        #validate data
        ${status_code2}=    convert to string    ${response2.status_code}
        should be equal    ${status_code2}    200
        Sleep    1s

        END
        # Sleep    10s
    END

Logout BeeCloud
    click element    xpath://*[@id="dropdownuser"]/div/div[1]
    Sleep    1s
    click element    xpath://*[@id="dropdownuser"]/li[7]
    Sleep    3s

# Calling function from python
#     ${value}=    funct.add_one_to_integer    ${1}
#     SHOULD BE EQUAL    ${value}    ${2}

# Test Variables
#     ${loopCount}=    Set Variable    ${loopCount+1}
#     ${loopCount}=    Set Variable    ${loopCount+1}
#     IF    ${loopCount} < 0
#         log to console    tesssdcasdascdascdass
#     ELSE
#         ${xpath}=    Set Variable    ${xpathTable}/tr[${loopCount}]/td[11]/a[1]
#         log to console    ${xpath}
#     END
#     log to console    ${loopCount}