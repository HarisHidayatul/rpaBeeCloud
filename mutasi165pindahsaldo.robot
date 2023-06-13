*** Setting ***
# Library    SeleniumLibrary
Library    Selenium2Library
Library    RequestsLibrary
Library    Collections

#inisialisasi variable
Variables    init.py

*** Variables ***
# ${base_url}    http://localhost:8080
${child_url}    /robot/api/mutasi165PindahSaldo/show
${Tanggal}    00-00-00
${Termin}    kosong
${loopCount}    ${0}
*** Keywords ***


*** Test Cases ***
Buka Browser Dan Lakukan Login
    Open Browser    https://app.beecloud.id/site/login    Edge
    Maximize Browser Window
    input text    id:loginform-username    ${username_bee_cloud}
    input text    id:loginform-password    ${password_bee_cloud}
    click element    xpath://*[@id="login-form"]/div[3]/ul/button
    Sleep    3s

Buka Menu Transfer Kas Kemudian Buat Baru
    click element    xpath:/html/body/div[3]/div[1]/div/div/ul/li[8]/a
    Sleep   1s
    click element    xpath:/html/body/div[3]/div[1]/div/div/ul/li[8]/ul/li[9]/a
    Sleep   2s
    click element    xpath:/html/body/div[3]/div[2]/div/div[1]/p/a[2]
    Sleep    2s

Get API Mutasi 455 Transfer Kas Kemudian Lakukan Input Data
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
        ${idRobotMutasi165}=    convert to string    ${contentData['idRobotMutasi165']}

        ${kasAsalKeywoard}=    convert to string    ${contentData['kasAsalKeywoard']}
        ${kasAsal}=    convert to string    ${contentData['kasAsal']}

        ${kasTujuanKeywoard}=    convert to string    ${contentData['kasTujuanKeywoard']}
        ${kasTujuan}=    convert to string    ${contentData['kasTujuan']}

        ${keterangan}=    convert to string    ${contentData['keterangan']}
        ${total}=    convert to string    ${contentData['total']}

        ${cabangKeywoard}=    convert to string    ${contentData['cabangKeywoard']}
        ${cabang}=    convert to string    ${contentData['cabang']}

        execute javascript    window.scrollTo(0,0)
        #Masukkan Tanggal
        Press Keys    xpath://*[@id="cstr-trxdate"]    CTRL+a+BACKSPACE
        input text    xpath://*[@id="cstr-trxdate"]    ${Tanggal}[0:10]
        Press Keys    xpath://*[@id="cstr-trxdate"]    ENTER
        Sleep    1s

        #Masukkan Kas Asal
        click element    xpath://*[@id="s2id_kas_utama"]/a
        input text    xpath://*[@id="s2id_autogen1_search"]    ${kasAsalKeywoard}[0:10]
        ${scroll_kas_asal}    Set Variable    ${1}
        ${count_kas_asal}    Get Element Count    xpath://*[@id="select2-results-1"]/li
        FOR    ${index}    IN RANGE    1    ${count_kas_asal}
            ${textKasAsal}    Get Text    xpath://*[@id="select2-results-1"]/li[${index}]/div
            IF    '${textKasAsal}' == '${kasAsal}'    BREAK
            ${scroll_kas_asal}=    Set Variable   ${scroll_kas_asal + 1}
            Press Key    xpath://*[@id="s2id_autogen1_search"]    \ue015
            Sleep     1s
        END
        #Pastikan kas asal sudah benar lalu klik enter
        IF    ${count_kas_asal} == ${1}
            ${textFinalKasAsal}    Get Text    xpath://*[@id="select2-results-1"]/li/div
        ELSE
            ${textFinalKasAsal}    Get Text    xpath://*[@id="select2-results-1"]/li[${scroll_kas_asal}]/div
        END
        Should Be Equal As Strings    '${textFinalKasAsal}'     '${kasAsal}'
        Press Keys    xpath://*[@id="s2id_autogen1_search"]    ENTER
        Sleep    1s

        #Masukkan Kas Tujuan
        click element    xpath://*[@id="s2id_kas_tujuan"]/a
        input text    xpath://*[@id="s2id_autogen2_search"]    ${kasTujuanKeywoard}[0:10]
        ${scroll_kas_tujuan}    Set Variable    ${1}
        ${count_kas_tujuan}    Get Element Count    xpath://*[@id="select2-results-2"]/li
        FOR    ${index}    IN RANGE    1    ${count_kas_tujuan}
            ${textKasTujuan}    Get Text    xpath://*[@id="select2-results-2"]/li[${index}]/div
            IF    '${textKasTujuan}' == '${kasTujuan}'    BREAK
            ${scroll_kas_tujuan}=    Set Variable   ${scroll_kas_tujuan + 1}
            Press Key    xpath://*[@id="s2id_autogen2_search"]    \ue015
            Sleep     1s
        END
        #Pastikan kas tujuan sudah benar lalu klik enter
        IF    ${count_kas_tujuan} == ${1}
            ${textFinalKasTujuan}    Get Text    xpath://*[@id="select2-results-2"]/li/div
        ELSE
            ${textFinalKasTujuan}    Get Text    xpath://*[@id="select2-results-2"]/li[${scroll_kas_tujuan}]/div
        END
        Should Be Equal As Strings    '${textFinalKasTujuan}'     '${kasTujuan}'
        Press Keys    xpath://*[@id="s2id_autogen2_search"]    ENTER
        Sleep    1s

        #Masukkan jumlah 1
        Press Keys    xpath://*[@id="amount1"]    CTRL+a+BACKSPACE
        input text    xpath://*[@id="amount1"]    ${total}[0:10]
        Press Keys    xpath://*[@id="amount1"]    ENTER
        Sleep    1s

        #Masukkan keterangan
        input text    xpath://*[@id="cstr-note"]    ${keterangan}

        execute javascript    window.scrollTo(0,document.body.scrollHeight)
        #Masukkan Cabang
        click element    xpath://*[@id="s2id_branch_id"]/a
        Press Keys    xpath://*[@id="s2id_autogen3_search"]    CTRL+a+BACKSPACE
        input text    xpath://*[@id="s2id_autogen3_search"]    ${cabangKeywoard}[0:10]
        ${scroll_cabang}    Set Variable    ${1}
        ${count_cabang}    Get Element Count    xpath://*[@id="select2-results-3"]/li
        FOR    ${index}    IN RANGE    1    ${count_cabang}
            ${textCabang}    Get Text    xpath://*[@id="select2-results-3"]/li[${index}]/div
            IF    '${textCabang}' == '${cabang}'    BREAK
            ${scroll_cabang}=    Set Variable   ${scroll_cabang + 1}
            Press Key    xpath://*[@id="s2id_autogen3_search"]    \ue015
            Sleep     1s
        END
        #Pastikan data yang ada di cabang sudah benar
        IF    ${count_cabang} == ${1}
            ${textFinalCabang}    Get Text    xpath://*[@id="select2-results-3"]/li/div
        ELSE
            ${textFinalCabang}    Get Text    xpath://*[@id="select2-results-3"]/li[${scroll_cabang}]/div
        END
        Should Be Equal As Strings    '${textFinalCabang}'     '${cabang}'
        Press Keys    xpath://*[@id="s2id_autogen3_search"]    ENTER
        Sleep    1s

        #Klik simpan lalu buat baru
        click element    xpath://*[@id="frmCstr"]/div/div[2]/div[2]/div[2]/div/button
        Sleep    8s
        click element    xpath://*[@id="new_button"]

        #kirim respon bahwa sudah selesai dan input setelahnya
        #Lakukan send API Untuk mengirim data sukses
        create session    myssion2    ${base_url}
        ${response2}=    get request    myssion2    /robot/api/mutasi165PindahSaldo/done/${idRobotMutasi165}
    
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