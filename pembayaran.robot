*** Setting ***
# Library    SeleniumLibrary
Library    Selenium2Library
Library    RequestsLibrary
Library    Collections

*** Variables ***
${base_url}    http://localhost:8080
${child_url}    /dummy/pembayaran
${Tanggal}    00-00-00
${Termin}    kosong
${loopCount}    ${0}
# ${xpathTablePembelian}    /html/body/div[3]/div[2]/div[1]/div[2]/div/div[2]/div[2]/form/div[1]/div[4]/div/div/table/tbody

*** Keywords ***


*** Test Cases ***
Buka Browser Dan Lakukan Login
    Open Browser    https://app.beecloud.id/site/login    Edge
    Maximize Browser Window

    input text    id:loginform-username    hidayatulloh.haris@gmail.com
    input text    id:loginform-password    KNw8CeD0
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
        ${Cabang}=    convert to string    ${contentData['Cabang']}
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
        input text    xpath://*[@id="s2id_autogen1_search"]    ${Cabang}[0:10]
        Press Keys    xpath://*[@id="s2id_autogen1_search"]    ENTER
        Sleep    1s

        # Masukkan Data
        execute javascript    window.scrollTo(0, document.body.scrollHeight/3)
        FOR    ${DataLoop}    IN    @{DataPembayaran}
            click element    xpath://*[@id="tabPpaid"]/div/div/div[1]/button[3]
            Press Keys    xpath://*[@id="dlgAcc-code"]    CTRL+a+BACKSPACE
            input text    xpath://*[@id="dlgAcc-code"]    ${DataLoop['kodeAkun']}
            Press Keys    xpath://*[@id="dlgAcc-code"]    ENTER
            click element    xpath://*[@id="btn_dlgAcc"]

            Sleep    3s

            click element    xpath://*[@id="w0-container"]/table/tbody/tr/td[2]/a

            Sleep    1s

            Press Keys    xpath://*[@id="dlgAccAmt-amount"]    CTRL+a+BACKSPACE
            input text    xpath://*[@id="dlgAccAmt-amount"]    ${DataLoop['jumlahBayar']}
            click element    xpath://*[@id="btnAddAccAmt"]
        END
    END

Logout BeeCloud
    click element    xpath://*[@id="dropdownuser"]/div/div[1]
    Sleep    1s
    click element    xpath://*[@id="dropdownuser"]/li[7]
    Sleep    3s