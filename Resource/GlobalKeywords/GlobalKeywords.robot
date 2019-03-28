*** Settings ***
Library           Selenium2Library
Library           OperatingSystem
Library           Collections
Library           String
Library           DateTime
Resource          ../../TC_SP1_Nmae_001.robot
Resource          ../../TestData/Wordings/EN_Language.robot
Resource          ../../TestData/Wordings/TH_Language.robot
Resource          ../../TestData/Wordings/Wordings_EN/EN.robot
Resource          ../../TestData/Wordings/Wordings_TH/TH.robot

*** Keywords ***
Column Data Excel
    [Arguments]    ${ListHeader}    ${CheckHeader}    ${CheckValue}
    ${Int}    Get Index From List    ${ListHeader}    ${CheckHeader}
    ${Count}    Set Variable    0
    : FOR    ${index}    IN RANGE    1    ${RowCount}
    \    ${Count}    Evaluate    ${Count}+1
    \    ${ReadData}    Read Cell Data By Coordinates    ${SheetNames}    ${Int}    ${index}
    \    Run Keyword If    '${ReadData}'=='${CheckValue}'    Run Keywords    Set Test Variable    ${Count}
    \    ...    AND    Exit For Loop
    [Return]    ${Count}

Conditions Data Excel
    [Arguments]    ${ListData}    @{ListChecking}
    : FOR    ${Index}    IN    @{ListChecking}
    \    ${Return}    Run Keyword And Ignore Error    Should Contain    ${ListData}    ${Index}
    \    Run Keyword If    '@{Return}[0]'=='PASS'    Run Keywords    Set Suite Variable    ${ListStatus}    ${Index}
    \    ...    AND    Exit For Loop

Count Column Data File
    [Arguments]    ${SheetNames}
    ${ColumnCount}    Get Column Count    ${SheetNames}
    Set Suite Variable    ${ColumnCount}
    [Return]    ${ColumnCount}

Count Row Data File
    [Arguments]    ${SheetNames}
    ${RowCount}    Get Row Count    ${SheetNames}
    Set Suite Variable    ${RowCount}
    [Return]    ${RowCount}

Excel Set Variable
    [Arguments]    ${Header}    ${DATA}
    [Documentation]    Function get row data for Execute.
    ${Return}    Create List
    : FOR    ${Index}    IN RANGE    ${ColumnCount}
    \    ${String}    Remove String    @{Header}[${Index}]    ${SPACE}
    \    ${String}    Convert To Lowercase    ${String}
    \    Set Suite Variable    ${excel.${String}}    @{DATA}[${Index}]
    \    Log To Consoles    <${String}> => @{DATA}[${Index}]
    [Return]    ${Return}

Execute Run
    [Arguments]    ${Header}    ${INT}
    : FOR    ${Index}    IN    ${INT}
    \    ${DATA}    Row Data Excel    ${Index}
    \    ${Return}    Excel Set Variable    ${Header}    ${DATA}
    \    Run Keyword If    '${Return}'=='PASS'    Run Keywords    Log Set Variable    ${Header}    ${DATA}
    \    ...    AND    Exit For Loop

Header Excel
    ${Header}    Create List
    : FOR    ${index}    IN RANGE    ${ColumnCount}
    \    ${ReadData}    Read Cell Data By Coordinates    ${SheetNames}    ${index}    0
    \    Append To List    ${Header}    ${ReadData}
    Set Test Variable    ${Header}
    [Return]    ${Header}

Log Set Variable
    [Arguments]    ${Header}    ${DATA}
    [Documentation]    Function get row data for Execute.
    ${Return}    Create List
    : FOR    ${Index}    IN RANGE    ${ColumnCount}
    \    ${String}    Remove String    @{Header}[${Index}]    ${SPACE}
    \    ${String}    Convert To Lowercase    ${String}
    \    Log To Consoles    ${String} => '${excel.${String}}'

Open Excel File
    [Arguments]    ${FileName}
    ${DirectoryTEMP}    Temp Excel File    ${FileName}
    Log To Consoles    <<< OPEN EXCLE >>>
    Log To Consoles    Directory : ${DirectoryTEMP}
    Open Excel    ${DirectoryTEMP}
    ${SheetNames}    Get Sheet Names
    Set Suite Variable    ${SheetNames}    @{SheetNames}[0]
    ${ColumnCount}    Count Column Data File    ${SheetNames}
    Set Suite Variable    ${ColumnCount}
    ${RowCount}    Count Row Data File    ${SheetNames}
    Set Suite Variable    ${RowCount}
    Log To Consoles    Sheetname : ${SheetNames}
    Log To Consoles    Row Count : ${RowCount}
    Log To Consoles    Column Count : ${ColumnCount}
    Log To Consoles    ===========================================================================================================

Read Data
    Log To Consoles    \nStart : Read Row '${TEST_NAME}' Data
    ${Header}    Header Excel
    ${INT}    Column Data Excel    ${Header}    TestCaseName    ${TEST_NAME}
    ${DATA}    Row Data Excel    ${INT}
    Execute Run    ${Header}    ${INT}
    Conditions Data Excel    ${DATA}    No Test    Run    PASS    FAIL
    Log To Consoles    END : Read Row '${TEST_NAME}' Data PASS\n

Row Data Excel
    [Arguments]    ${arg1}
    ${DATA}    Create List
    : FOR    ${index}    IN RANGE    ${ColumnCount}
    \    ${ReadData}    Read Cell Data By Coordinates    ${SheetNames}    ${index}    ${arg1}
    \    Append To List    ${DATA}    ${ReadData}
    Set Test Variable    ${DATA}
    [Return]    ${DATA}

Temp Excel File
    [Arguments]    ${arg1}
    ${DATEFILE}    Get Current Date
    ${DATEFILE}    Convert Date    ${DATEFILE}    epoch
    ${DirectoryTestData}    Replace String    ${CURDIR}    Configurations    TestData
    ${DirectoryTEMP}    Replace String    ${DirectoryTestData}    TestData    Temp
    Copy File    ${DirectoryTestData}\\${arg1}    ${DirectoryTEMP}\\${DATEFILE}${arg1}
    Set Suite Variable    ${DirectoryTestData}    ${DirectoryTestData}\\${arg1}
    Set Suite Variable    ${DirectoryTEMP}    ${DirectoryTEMP}\\${DATEFILE}${arg1}
    [Return]    ${DirectoryTEMP}

Write Return Status
    Open Excel    ${DirectoryTestData}
    Log    ${ListStatus}=>${StatusTC}
    ${Index}    Get Index From List    ${DATA}    ${ListStatus}
    Put String To Cell    ${SheetNames}    ${Index}    @{DATA}[0]    ${StatusTC}
    ${Local}    Remove String    ${DirectoryTestData}    .xls
    Save Excel    ${Local}_Result.xls

Skip Status Execution
    Pass Execution If    '${ListStatus}'=='No Test'    ${ListStatus}
    Pass Execution If    '${ListStatus}'=='PASS'    ${ListStatus}
Allow Permission
    Mobile.Click button    @{AllowButton}

Turn On Wifi
    Mobile.Scroll down
    ${Return}    Run Keyword And Ignore Error    Wait Until Page Contains Element    @{WIFI_Off}
    Run Keyword If    '@{Return}[0]'=='PASS'    Run Keyword    Mobile.Click button    @{WIFI_Off}
    ${Return}    Run Keyword And Ignore Error    Wait Until Page Contains Element    @{Cellular_On}
    Run Keyword If    '@{Return}[0]'=='PASS'    Run Keyword    Mobile.Click button    @{Cellular_On}
    Mobile.Scroll top
    Mobile.Sleep    seconds=5

Turn On Cellular
    Mobile.Scroll down
    ${Return}    Run Keyword And Ignore Error    Wait Until Page Contains Element    @{WIFI_On}
    Run Keyword If    '@{Return}[0]'=='PASS'    Run Keyword    Mobile.Click element    @{WIFI_On}
    ${Return}    Run Keyword And Ignore Error    Wait Until Page Contains Element    @{Cellular_Off}
    Run Keyword If    '@{Return}[0]'=='PASS'    Run Keyword    Mobile.Click element    @{Cellular_Off}
    Mobile.Scroll top
    Mobile.Sleep    seconds=5

Get OTP Fail
    @{Int}    Sub String    123456
    : FOR    ${Index}    IN    @{Int}
    \    Mobile.Click button    ${Index}

Get OTP Pass
    Mobile.Scroll down
    ${OTP}    Mobile.Get message    OTP
    ${GetOTP}    Sub Regexp Matches    ${OTP}    ${SPACE}(......)${SPACE}
    @{GetOTP}    Sub String    ${GetOTP}
    Mobile.Scroll top
    : FOR    ${Index}    IN    @{GetOTP}
    \    Mobile.Click button    ${Index}


    # Exxel

    Excel.Column Data Excel
    [Arguments]    ${ListHeader}    ${CheckHeader}    ${CheckValue}
    ${Int}    Get Index From List    ${ListHeader}    ${CheckHeader}
    ${Count}    Set Variable    0
    : FOR    ${index}    IN RANGE    1    ${RowCount}
    \    ${Count}    Evaluate    ${Count}+1
    \    ${ReadData}    Read Cell Data By Coordinates    ${SheetNames}    ${Int}    ${index}
    \    Run Keyword If    '${ReadData}'=='${CheckValue}'    Run Keywords    Set Test Variable    ${Count}
    \    ...    AND    Exit For Loop
    [Return]    ${Count}

Excel.Conditions Data Excel
    [Arguments]    ${ListData}    @{ListChecking}
    : FOR    ${Index}    IN    @{ListChecking}
    \    ${Return}    Run Keyword And Ignore Error    Should Contain    ${ListData}    ${Index}
    \    Run Keyword If    '@{Return}[0]'=='PASS'    Run Keywords    Set Suite Variable    ${ListStatus}    ${Index}
    \    ...    AND    Exit For Loop

Excel.Count Column Data File
    [Arguments]    ${SheetNames}
    ${ColumnCount}    Get Column Count    ${SheetNames}
    Set Suite Variable    ${ColumnCount}
    [Return]    ${ColumnCount}

Excel.Count Row Data File
    [Arguments]    ${SheetNames}
    ${RowCount}    Get Row Count    ${SheetNames}
    Set Suite Variable    ${RowCount}
    [Return]    ${RowCount}

Excel.Excel Set Variable
    [Arguments]    ${Header}    ${DATA}
    [Documentation]    Function get row data for Execute.
    ${Return}    Create List
    : FOR    ${Index}    IN RANGE    ${ColumnCount}
    \    ${String}    Remove String    @{Header}[${Index}]    ${SPACE}
    \    ${String}    Convert To Lowercase    ${String}
    \    Set Suite Variable    ${excel.${String}}    @{DATA}[${Index}]
    \    Log To Consoles    <${String}> => @{DATA}[${Index}]
    [Return]    ${Return}

Excel.Execute Run
    [Arguments]    ${Header}    ${INT}
    : FOR    ${Index}    IN    ${INT}
    \    ${DATA}    Excel.Row Data Excel    ${Index}
    \    ${Return}    Excel.Excel Set Variable    ${Header}    ${DATA}
    \    Run Keyword If    '${Return}'=='PASS'    Run Keywords    Log Set Variable    ${Header}    ${DATA}
    \    ...    AND    Exit For Loop

Excel.Header Excel
    ${Header}    Create List
    : FOR    ${index}    IN RANGE    ${ColumnCount}
    \    ${ReadData}    Read Cell Data By Coordinates    ${SheetNames}    ${index}    0
    \    Append To List    ${Header}    ${ReadData}
    Set Test Variable    ${Header}
    [Return]    ${Header}

Excel.Log Set Variable
    [Arguments]    ${Header}    ${DATA}
    [Documentation]    Function get row data for Execute.
    ${Return}    Create List
    : FOR    ${Index}    IN RANGE    ${ColumnCount}
    \    ${String}    Remove String    @{Header}[${Index}]    ${SPACE}
    \    ${String}    Convert To Lowercase    ${String}
    \    Log To Consoles    ${String} => '${excel.${String}}'

Excel.Open Excel File
    [Arguments]    ${FileName}
    ${DirectoryTEMP}    Excel.Temp Excel File    ${FileName}
    Log To Consoles    <<< OPEN EXCLE >>>
    Log To Consoles    Directory : ${DirectoryTEMP}
    Open Excel    ${DirectoryTEMP}
    ${SheetNames}    Get Sheet Names
    Set Suite Variable    ${SheetNames}    @{SheetNames}[0]
    ${ColumnCount}    Excel.Count Column Data File    ${SheetNames}
    ${RowCount}    Excel.Count Row Data File    ${SheetNames}
    Log To Consoles    Sheetname : ${SheetNames}
    Log To Consoles    Row Count : ${RowCount}
    Log To Consoles    Column Count : ${ColumnCount}
    Log To Consoles    ===========================================================================================================

Excel.Read Data
    Log To Consoles    \nStart : Read Row '${TEST_NAME}' Data
    ${Header}    Excel.Header Excel
    ${INT}    Excel.Column Data Excel    ${Header}    TestCaseName    ${TEST_NAME}
    ${DATA}    Excel.Row Data Excel    ${INT}
    Excel.Execute Run    ${Header}    ${INT}
    Excel.Conditions Data Excel    ${DATA}    No Test    Run    PASS    FAIL
    Log To Consoles    END : Read Row '${TEST_NAME}' Data PASS\n

Excel.Row Data Excel
    [Arguments]    ${arg1}
    ${DATA}    Create List
    : FOR    ${index}    IN RANGE    ${ColumnCount}
    \    ${ReadData}    Read Cell Data By Coordinates    ${SheetNames}    ${index}    ${arg1}
    \    Append To List    ${DATA}    ${ReadData}
    Set Test Variable    ${DATA}
    [Return]    ${DATA}

Excel.Temp Excel File
    [Arguments]    ${arg1}
    ${DirectoryTestData}    Replace String    ${CURDIR}    Configurations    TestData\\${arg1}
    ${DirectoryTEMP}    Replace String    ${DirectoryTestData}    TestData    Temp
    Copy File    ${DirectoryTestData}    ${DirectoryTEMP}
    Set Suite Variable    ${DirectoryTestData}
    [Return]    ${DirectoryTEMP}

Excel.Write Return Status
    Open Excel    ${DirectoryTestData}
    ${Index}    Get Index From List    ${DATA}    ${ListStatus}
    Put String To Cell    ${SheetNames}    ${Index}    @{DATA}[0]    ${StatusTC}
    ${Local}    Remove String    ${DirectoryTestData}    .xls
    Save Excel    ${Local}_Result.xls

Skip Status Execute
    Pass Execution If    '${ListStatus}'=='No Test'    ${ListStatus}
    Run Keyword If    '${ListStatus}'=='PASS'    ${ListStatus}


# Functions

Get Date Time
    [Arguments]    ${Imgname}
    ${DateTime}    Get Current Date
    ${Date}    Convert Date    ${DateTime}    result_format=%Y-%m-%d
    ${Directory}    Replace String    ${CURDIR}    Configurations    Result/${Date}
    Set Suite Variable    ${Directory}
    ${Date}    Replace String    ${DateTime}-${Imgname}    :    -
    ${Date}    Replace String    ${Date}    ${SPACE}    -
    Set Suite Variable    ${Date}

Get Webelement by value
    [Arguments]    ${Wording}
    ${xPath}    Get Webelement    //*[@text='${Wording}' or @value='${Wording}']
    [Return]    ${xPath}

Get Webelement by xPath
    [Arguments]    ${xPathID}
    ${xPath}    Get Webelement    ${xPathID}
    [Return]    ${xPath}

Replace Xpath
    [Arguments]    ${xPathID}
    Set Library Search Order    AppiumLibrary
    ${xPath}    Get Webelement    ${xPathID}
    [Return]    ${xPath}

Sub Regexp Matches
    [Arguments]    ${Message}    ${Pattern}
    Set Library Search Order    AppiumLibrary
    @{SubSpring}    Get Regexp Matches    ${Message}    ${Pattern}
    ${SubSprings}    Create List
    : FOR    ${Index}    IN    @{SubSpring}
    \    ${Sub}    Remove String    ${Index}    ${SPACE}
    \    Append To List    ${SubSprings}    ${Sub}
    Set Test Variable    ${SubSprings}    @{SubSprings}[0]
    [Return]    ${SubSprings}

Sub String
    [Arguments]    ${Message}
    Set Library Search Order    AppiumLibrary
    ${SubSprings}    Get Regexp Matches    ${Message}    (.)    1
    [Return]    ${SubSprings}

Log To Consoles
    [Arguments]    ${Message}
    Log    ${Message}
    Log To Console    ${Message}
    Time Stamp Logs    ${Message}

Ignore Error Page Contains
    [Arguments]    ${xPathID}    ${Sec}=5
    ${Return}    Run Keyword And Ignore Error    Wait Until Page Contains Element    ${xPathID}    ${Sec}
    ${Return}    Set Variable    @{Return}[0]
    [Return]    ${Return}

Remove All String
    [Arguments]    ${Index}    @{Removables}
    ${Return}    Remove String    ${Index}    @{Removables}
    [Return]    ${Return}

Replace All String
    [Arguments]    ${Index}    ${Wording}    ${Replace}
    ${Return}    Replace String    ${Index}    ${Wording}    ${Replace}
    [Return]    ${Return}

Calculate
    [Arguments]    ${Sentence}
    ${Return}    Evaluate    ${Sentence}
    [Return]    ${Return}

Conditions
    [Arguments]    ${FirstCondition}    ${Opaeration}    ${FinalCondition}
    ${Return}    Run Keyword And Ignore Error    Run Keyword If    "${FirstCondition}"${Opaeration}"${FinalCondition}"    Run Keyword    Log To Consoles    "${FirstCondition}"${Opaeration}"${FinalCondition}"
    ...    ELSE    Run Keyword    Log To Consoles    "${FirstCondition}"${Opaeration}"${FinalCondition}"
    Should Be Equal    @{Return}[0]    PASS

Time Stamp Logs
    [Arguments]    ${MessageLog}
    ${TimeStamp}    Get Current Date
    ${Directory}    Replace String    ${CURDIR}    Configurations    Result
    Append To File    ${Directory}/Debug.log    [DEBUG][${TimeStamp}][${MessageLog}]${\n}

Runing Test Setup
    Excel.Read Data
    Log Start

Runing Test Teardown
    Function result
    Excel.Write Return Status

    # Object_Center

Import Resource EN Language
    [Documentation]    TH or EN
    Log To Consoles    Import Resource EN Language
    Import Resource    ${CURDIR}/Wordings/EN_Language.robot

Import Resource TH Language
    [Documentation]    TH or EN
    Log To Consoles    Import Resource TH Language
    Import Resource    ${CURDIR}/Wordings/TH_Language.robot

    #Web

Web.Capture Screenshot
    [Arguments]    ${Imgname}=CaptureScreenshot
    Set Library Search Order    Selenium2Library
    Log To Consoles    ${Imgname}
    Capture Page Screenshot
    Get Date Time    ${Imgname}
    Append To File    ${Directory}/${TEST_NAME}/README.md    ${EMPTY}
    Capture Page Screenshot    ${Directory}/${TEST_NAME}/${Date}.png
    Log To Consoles    - PASS\n

Web.Check screen wording
    [Arguments]    @{Wording}
    Set Library Search Order    Selenium2Library
    Log To Consoles    Check Value @{Wording}
    : FOR    ${index}    IN    @{Wording}
    \    ${Return}    Run Keyword And Ignore Error    Wait Until Page Contains    ${index}    30s
    \    Should Be Equal    @{Return}[0]    PASS
    Web.Capture Screenshot
    Log To Consoles    - PASS\n

Web.Enter
    [Arguments]    ${Attribute}    ${Value}
    Set Library Search Order    Selenium2Library
    Log To Consoles    Enter
    ${xPathID}    Web.Convert Attribute To xPath    ${Attribute}    ${Value}
    Wait Until Page Contains Element    ${xPathID}
    Web.Capture Screenshot
    ${xPath}    Get WebElement    ${xPathID}
    Press Key    ${xPath}    \\13
    Log To Consoles    - PASS\n

Web.Click button
    [Arguments]    ${Attribute}    ${Value}
    Set Library Search Order    Selenium2Library
    Log To Consoles    Click Button
    ${xPathID}    Web.Convert Attribute To xPath    ${Attribute}    ${Value}
    Wait Until Page Contains Element    ${xPathID}
    Web.Capture Screenshot
    ${xPath}    Get WebElement    ${xPathID}
    Click Element    ${xPath}
    Log To Consoles    - PASS\n

Web.Click element
    [Arguments]    ${Attribute}    ${Value}
    Set Library Search Order    Selenium2Library
    Log To Consoles    Click Element
    ${xPathID}    Web.Convert Attribute To xPath    ${Attribute}    ${Value}
    Wait Until Page Contains Element    ${xPathID}
    Web.Capture Screenshot
    ${xPath}    Get WebElement    ${xPathID}
    Click Element    ${xPath}
    Log To Consoles    - PASS\n

Web.Click session
    [Arguments]    ${SessionID}
    Set Library Search Order    Selenium2Library
    Log To Consoles    Click Button
    Web.Capture Screenshot
    Click Element    ${SessionID}
    Log To Consoles    - PASS\n

Web.Convert Attribute To xPath
    [Arguments]    ${Attribute}    ${Value}
    [Documentation]    *[Detail]* \ Convert text to xPath
    ...
    ...    *[Default Arguments]*
    ...
    ...    - Wording
    ...
    ...    *[Return]*
    ...
    ...    - xPath
    Set Library Search Order    Selenium2Library
    Log To Consoles    Convert Attribute To xPath
    ${Message}    Convert To Lowercase    ${Attribute}
    Run Keyword If    "${Message}"!="text"    Run Keyword    Set Test Variable    ${xPath}    //*[contains(@${Attribute}, '${Value}')]
    Run Keyword If    "${Message}"=="text"    Run Keyword    Set Test Variable    ${xPath}    //*[contains(${Attribute}(), '${Value}')]
    Log To Consoles    - PASS\n
    [Return]    ${xPath}

Web.Get List WebElements
    [Arguments]    ${Attribute}    ${Value}    ${Position}=1
    Set Library Search Order    Selenium2Library
    Log To Consoles    Get List WebElements
    ${xPathID}    Web.Convert Attribute To xPath    ${Attribute}    ${Value}
    @{SessionID}    Get WebElements    ${xPathID}
    Insert Into List    ${SessionID}    0    ${EMPTY}
    ${Return}    Set Variable    @{SessionID}[${Position}]
    Log To Consoles    - PASS\n
    [Return]    ${Return}

Web.Get message
    [Arguments]    ${Wording}
    Set Library Search Order    Selenium2Library
    Log To Consoles    Get Message
    ${xPathID}    Web.Convert Attribute To xPath    text    ${Wording}
    Wait Until Element Contains    ${xPathID}    30s
    Web.Capture Screenshot
    ${xPath}    Get Webelement by xPath    ${xPathID}
    ${Messsage}    Get Text    ${xPath}
    Log To Consoles    - PASS\n
    [Return]    ${Messsage}

Web.Input data
    [Arguments]    ${Attribute}    ${Value}    ${Message}
    Set Library Search Order    Selenium2Library
    Log To Consoles    Input Message
    ${xPathID}    Web.Convert Attribute To xPath    ${Attribute}    ${Value}
    Wait Until Page Contains Element    ${xPathID}    30s
    Web.Capture Screenshot
    ${xPath}    Get Webelement by xPath    ${xPathID}
    Input Text    ${xPath}    ${Message}
    Wait Until Page Contains    ${Message}
    Log To Consoles    - PASS\n

Web.Kill browser
    Set Library Search Order    Selenium2Library
    Log To Consoles    Kill Browser
    Close All Browsers
    Run And Return Rc And Output    Taskkill /F /IM chromedriver.exe
    Log To Consoles    - PASS\n

Web.Launch browser
    [Arguments]    ${URL}    ${BrowserType}=Chrome
    Set Library Search Order    Selenium2Library
    Log To Consoles    Launch Browser
    Open Browser    chrome://apps/    ${BrowserType}
    Maximize Browser Window
    Go To    ${URL}
    Web.Capture Screenshot
    Log To Consoles    - PASS\n

Web.Select Frame Attribute
    [Arguments]    ${Attribute}    ${Value}
    Set Library Search Order    Selenium2Library
    Log To Consoles    Select Frame Attribute
    ${xPathID}    Web.Convert Attribute To xPath    ${Attribute}    ${Value}
    Select Frame    ${xPathID}
    Log To Consoles    - PASS\n

Web.Select Frame List
    [Arguments]    @{xPathList}
    Set Library Search Order    Selenium2Library
    Log To Consoles    Select Frame List
    Unselect Frame
    : FOR    ${Index}    IN    @{xPathList}
    \    Select Frame    ${Index}
    Log To Consoles    - PASS\n

# Object_Center
Import Resource EN Language
    [Documentation]    TH or EN
    Log To Consoles    Import Resource EN Language
    Import Resource    ${CURDIR}/Wordings/EN_Language.robot

Import Resource TH Language
    [Documentation]    TH or EN
    Log To Consoles    Import Resource TH Language
    Import Resource    ${CURDIR}/Wordings/TH_Language.robot