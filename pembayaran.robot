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

        ${keywoard}=    convert to string    ${contentData['keywoard']}

        ${kas}=    convert to string    ${contentData['kas']}

        ${Cabang}=    convert to string    ${contentData['cabang']}

        ${Keterangan}=    convert to string    ${contentData['Keterangan']}
        
        ${idRobotPembayaran}=    convert to string    ${contentData['idRobotPembayaran']}
        @{DataPembayaran}=    Copy List    ${contentData['Data']}    deepcopy=True
        
        ${countPembayaran}=    Get length    ${DataPembayaran}
        Exit For Loop If    ${countPembayaran} == 0

        execute javascript    window.scrollTo(0,0)
        #Masukkan Tanggal
        Press Keys    xpath://*[@id="trxdate-id"]    CTRL+a+BACKSPACE
        input text    xpath://*[@id="trxdate-id"]    ${Tanggal}[0:10]
        Press Keys    xpath://*[@id="trxdate-id"]    ENTER
        Sleep    1s

        #Masukkan Cabang
        click element    xpath://*[@id="s2id_branch_id"]/a
        Press Keys    xpath://*[@id="s2id_autogen1_search"]    CTRL+a+BACKSPACE
        input text    xpath://*[@id="s2id_autogen1_search"]    ${keywoard}[0:10]
        ${scroll_cabang}    Set Variable    ${1}
        ${count_cabang}    Get Element Count    xpath://*[@id="select2-results-1"]/li
        FOR    ${index}    IN RANGE    1    ${count_cabang}
            ${textCabang}    Get Text    xpath://*[@id="select2-results-1"]/li[${index}]/div
            IF    '${textCabang}' == '${Cabang}'    BREAK
            ${scroll_cabang}=    Set Variable   ${scroll_cabang + 1}
            Press Key    xpath://*[@id="s2id_autogen1_search"]    \ue015
            Sleep     1s
        END
        #Pastikan data yang ada di cabang sudah benar
        IF    ${count_cabang} == ${1}
            ${textFinalCabang}    Get Text    xpath://*[@id="select2-results-1"]/li/div
        ELSE
            ${textFinalCabang}    Get Text    xpath://*[@id="select2-results-1"]/li[${scroll_cabang}]/div
        END
        Should Be Equal As Strings    '${textFinalCabang}'     '${Cabang}'
        Press Keys    xpath://*[@id="s2id_autogen1_search"]    ENTER
        Sleep    1s

        # Masukkan Data
        execute javascript    window.scrollTo(0, document.body.scrollHeight/3)
        FOR    ${DataLoop}    IN    @{DataPembayaran}
            #Klik pilih akun
            click element    xpath://*[@id="tabPpaid"]/div/div/div[1]/button[3]
            Sleep    1s

            #Search Akun
            Press Keys    xpath://*[@id="dlgAcc-code"]    CTRL+a+BACKSPACE
            input text    xpath://*[@id="dlgAcc-code"]    ${DataLoop['kodeAkun']}
            Press Keys    xpath://*[@id="dlgAcc-code"]    ENTER
            click element    xpath://*[@id="btn_dlgAcc"]

            Sleep    3s

            click element    xpath://*[@id="w0-container"]/table/tbody/tr/td[2]/a

            Sleep    1s

            #Masukkan jumlah bayar
            Press Keys    xpath://*[@id="dlgAccAmt-amount"]    CTRL+a+BACKSPACE
            input text    xpath://*[@id="dlgAccAmt-amount"]    ${DataLoop['total']}

            #Masukkan note di jumlah bayar untuk item
            Press Keys    xpath://*[@id="dlgAccAmt-note"]    CTRL+a+BACKSPACE
            input text    xpath://*[@id="dlgAccAmt-note"]    ${DataLoop['Notes']}

            click element    xpath://*[@id="btnAddAccAmt"]
        END

        #Klik Cara Bayar
        click element    xpath://*[@id="detail"]/div/ul/li[2]/a
        Sleep    1s

        #Pilih Cara Bayar
        click element    xpath://*[@id="tabPayd"]/div/div/div[1]/button
        Sleep    1s

        #Search cara bayar ke tunai
        click element    xpath://*[@id="s2id_dlgpaymtd_paydmtd"]/a
        input text    xpath://*[@id="s2id_autogen27_search"]    tunai
        Press Keys    xpath://*[@id="s2id_autogen27_search"]    ENTER

        #Pilih kas bank
        click element    xpath://*[@id="s2id_dlgpaymtd_refid_cash"]/a
        input text    xpath://*[@id="s2id_autogen28_search"]    ${keywoard}
        ${scroll_kas}    Set Variable    ${1}
        ${count_kas}    Get Element Count    xpath://*[@id="select2-results-28"]/li
        FOR    ${index}    IN RANGE    1    ${count_kas}
            ${textKas}    Get Text    xpath://*[@id="select2-results-28"]/li[${index}]/div
            IF    '${textKas}' == '${kas}'    BREAK
            ${scroll_kas}=    Set Variable   ${scroll_kas + 1}
            Press Key    xpath://*[@id="s2id_autogen28_search"]    \ue015
            Sleep    1s
        END
        #Pastikan data yang ada di kas sudah benar
        IF    ${count_kas} == ${1}
            ${textFinalKas}    Get Text    xpath://*[@id="select2-results-28"]/li/div
        ELSE
            ${textFinalKas}    Get Text    xpath://*[@id="select2-results-28"]/li[${scroll_kas}]/div
        END
        Should Be Equal As Strings    '${textFinalKas}'     '${kas}'
        Press Keys    xpath://*[@id="s2id_autogen28_search"]    ENTER

        #Klik add di cara bayar
        click element    xpath://*[@id="btnAddPayd"]

        #Klik keterangan
        execute javascript    window.scrollTo(0,document.body.scrollHeight)
        input text    xpath://*[@id="pay-note"]     ${Keterangan}

        #Klik simpan
        click element    xpath://*[@id="frmPay"]/div[2]/div/div/button
        Sleep    8s

        #Masukkan data setelahnya
        click element    xpath://*[@id="new_button"]

        
        #kirim respon bahwa sudah selesai dan input setelahnya
        #Lakukan send API Untuk mengirim data sukses
        create session    myssion2    ${base_url}
        ${response2}=    get request    myssion2    /robot/api/pembayaran/done/${idRobotPembayaran}
    
        #validate data
        ${status_code2}=    convert to string    ${response2.status_code}
        should be equal    ${status_code2}    200
        Sleep    3s
    END

Logout BeeCloud
    click element    xpath://*[@id="dropdownuser"]/div/div[1]
    Sleep    1s
    click element    xpath://*[@id="dropdownuser"]/li[7]
    Sleep    3s