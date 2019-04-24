*** Settings ***
Library           Selenium2Library
Library           OperatingSystem
Library           Collections
Library           String
Library           DateTime
Resource          Import_Librarys.robot

*** Keywords ***
Allow Permission
    Mobile.Click button    @{AllowButton}

Calculates
    [Arguments]    ${Sentence}
    ${Return}    Evaluate    ${Sentence}
    [Return]    ${Return}

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

Conditions
    [Arguments]    ${FirstCondition}    ${Opaeration}    ${FinalCondition}
    ${Return}    Run Keyword And Ignore Error    Run Keyword If    "${FirstCondition}"${Opaeration}"${FinalCondition}"    Run Keyword    Log To Consoles    "${FirstCondition}"${Opaeration}"${FinalCondition}"
    ...    ELSE    Run Keyword    Log To Consoles    "${FirstCondition}"${Opaeration}"${FinalCondition}"
    Should Be Equal    @{Return}[0]    PASS

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

Excel.Open Excel Files
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
    ${DATEFILE}    Get Current Date
    ${DATEFILE}    Convert Date    ${DATEFILE}    epoch
    ${DirectoryTestData}    Replace String    ${CURDIR}    Resource\\GlobalKeywords    TestData
    ${DirectoryTEMP}    Replace String    ${DirectoryTestData}    TestData    Temp
    Copy File    ${DirectoryTestData}\\${arg1}    ${DirectoryTEMP}\\${DATEFILE}${arg1}
    Set Suite Variable    ${DirectoryTestData}    ${DirectoryTestData}\\${arg1}
    Set Suite Variable    ${DirectoryTEMP}    ${DirectoryTEMP}\\${DATEFILE}${arg1}
    [Return]    ${DirectoryTEMP}

Excel.Write Return Status
    Open Excel    ${DirectoryTestData}
    ${Index}    Get Index From List    ${DATA}    ${ListStatus}
    Put String To Cell    ${SheetNames}    ${Index}    @{DATA}[0]    ${StatusTC}
    ${Local}    Remove String    ${DirectoryTestData}    .xls
    Save Excel    ${Local}_Result.xls

Get Date Time
    [Arguments]    ${Imgname}
    ${DateTime}    Get Current Date
    ${Date}    Convert Date    ${DateTime}    result_format=%Y-%m-%d
    ${Directory}    Replace String    ${CURDIR}    Resource\\GlobalKeywords    Result/${Date}
    Set Suite Variable    ${Directory}
    ${Date}    Replace String    ${DateTime}-${Imgname}    :    -
    ${Date}    Replace String    ${Date}    ${SPACE}    -
    Set Suite Variable    ${Date}

Get OTP Fail
    @{Int}    Sub String    123456
    : FOR    ${Index}    IN    @{Int}
    \    Mobile.Click button    ${Index}

Get OTP Pass
    [Arguments]    ${ListHeader}    ${CheckHeader}    ${CheckValue}
    Mobile.Scroll down
    ${OTP}    Mobile.Get message    OTP
    ${GetOTP}    Sub Regexp Matches    ${OTP}    ${SPACE}(......)${SPACE}
    @{GetOTP}    Sub String    ${GetOTP}
    Mobile.Scroll top
    : FOR    ${Index}    IN    @{GetOTP}
    \    Mobile.Click button    ${Index}
    # Exxel

Get Webelement by value
    [Arguments]    ${Wording}
    ${xPath}    Get Webelement    //*[@text='${Wording}' or @value='${Wording}']
    [Return]    ${xPath}

Get Webelement by xPath
    [Arguments]    ${xPathID}
    ${xPath}    Get Webelement    ${xPathID}
    [Return]    ${xPath}

Ignore Error Page Contains
    [Arguments]    ${xPathID}    ${Sec}=5
    ${Return}    Run Keyword And Ignore Error    Wait Until Page Contains Element    ${xPathID}    ${Sec}
    ${Return}    Set Variable    @{Return}[0]
    [Return]    ${Return}

# Import Resource EN Language
#     [Documentation]    TH or EN
#     Log To Consoles    Import Resource EN Language
#     Import Resource    ../../TestData/Wordings/EN_Language.robot

# Import Resource TH Language
#     [Documentation]    TH or EN
#     Log To Consoles    Import Resource TH Language
#     Import Resource    ../../TestData/Wordings/TH_Language.robot
    #Web

Log To Consoles
    [Arguments]    ${Message}
    Log    ${Message}
    Log To Console    ${Message}
    Time Stamp Logs    ${Message}

Remove All String
    [Arguments]    ${Index}    @{Removables}
    ${Return}    Remove String    ${Index}    @{Removables}
    [Return]    ${Return}

Replace All String
    [Arguments]    ${Index}    ${Wording}    ${Replace}
    ${Return}    Replace String    ${Index}    ${Wording}    ${Replace}
    [Return]    ${Return}

Replace Xpath
    [Arguments]    ${xPathID}
    Set Library Search Order    AppiumLibrary
    ${xPath}    Get Webelement    ${xPathID}
    [Return]    ${xPath}

Runing Test Setup
    Excel.Read Data
    # Log Start

Runing Test Teardown
    Function result
    Excel.Write Return Status
    # Object_Center

Skip Status Execute
    Pass Execution If    '${ListStatus}'=='No Test'    ${ListStatus}
    Run Keyword If    '${ListStatus}'=='PASS'    ${ListStatus}
    # Functions

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

Time Stamp Logs
    [Arguments]    ${MessageLog}
    ${TimeStamp}    Get Current Date
    ${Directory}    Replace String    ${CURDIR}    Resource\\GlobalKeywords    Result
    Append To File    ${Directory}/Debug.log    [DEBUG][${TimeStamp}][${MessageLog}]${\n}

Turn On Cellular
    Mobile.Scroll down
    ${Return}    Run Keyword And Ignore Error    Wait Until Page Contains Element    @{WIFI_On}
    Run Keyword If    '@{Return}[0]'=='PASS'    Run Keyword    Mobile.Click element    @{WIFI_On}
    ${Return}    Run Keyword And Ignore Error    Wait Until Page Contains Element    @{Cellular_Off}
    Run Keyword If    '@{Return}[0]'=='PASS'    Run Keyword    Mobile.Click element    @{Cellular_Off}
    Mobile.Scroll top
    Mobile.Sleep    seconds=5

Turn On Wifi
    Mobile.Scroll down
    ${Return}    Run Keyword And Ignore Error    Wait Until Page Contains Element    @{WIFI_Off}
    Run Keyword If    '@{Return}[0]'=='PASS'    Run Keyword    Mobile.Click button    @{WIFI_Off}
    ${Return}    Run Keyword And Ignore Error    Wait Until Page Contains Element    @{Cellular_On}
    Run Keyword If    '@{Return}[0]'=='PASS'    Run Keyword    Mobile.Click button    @{Cellular_On}
    Mobile.Scroll top
    Mobile.Sleep    seconds=5

Web.Capture Screenshot
    [Arguments]    ${Imgname}=CaptureScreenshot
    Set Library Search Order    Selenium2Library
    Log To Consoles    ${Imgname}
    Capture Page Screenshot
    Get Date Time    ${Imgname}
    ${Directorys}    Replace String    ${Directory}    Resource\\GlobalKeywords    TestResults
    Append To File    ${Directorys}/${TEST_NAME}/README.md    ${EMPTY}
    Capture Page Screenshot    ${Directorys}/${TEST_NAME}/${Date}.png
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
    # Wait Until Page Contains    ${Message}
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

Write Return Status
    Open Excel    ${DirectoryTestData}
    Log    ${ListStatus}=>${StatusTC}
    ${Index}    Get Index From List    ${DATA}    ${ListStatus}
    Put String To Cell    ${SheetNames}    ${Index}    @{DATA}[0]    ${StatusTC}
    ${Local}    Remove String    ${DirectoryTestData}    .xls
    Save Excel    ${Local}_Result.xls

Function result
    : FOR    ${Index}    IN    No Test    PASS
    \    Run Keyword If    '${ListStatus}'=='${Index}'    Run Keyword    Log Pass    ${Index}
    : FOR    ${Index}    IN    Run    FAIL
    \    Run Keyword If    '${ListStatus}'=='${Index}'    Run Keyword    Log Fail    ${TEST_STATUS}
    Log files
    Log Variables

Log files
    ${DateTime}    Get Current Date
    ${Date}    Convert Date    ${DateTime}    result_format=%Y-%m-%d
    ${Directory}    Replace String    ${CURDIR}    Resource\\GlobalKeywords    Result/${Date}
    ${h}    ${m}    ${s}    @{time}    Get Modified Time    ${Directory}    hour,min,sec
    File Result    ${Directory}/${TEST_NAME}    ${Directory}/${h}-${m}-${s}_${StatusTC}_${TEST_NAME}
    Append File Result    ${Directory}/LogTest.txt    ${DateTime}\t    ${StatusTC}\t    ${h}-${m}-${s}_${TEST_NAME}\t    ${\n}
    Append File Result    ${Directory}/TestResult.xls    ${EMPTY}
    @{GetFileSize}    Get Modified Time    ${Directory}/TestResult.xls    year,month,day
    Run Keyword If    '@{GetFileSize}[0]-@{GetFileSize}[1]-@{GetFileSize}[2]'<'${Date}'    Run Keyword    Append File Result    ${Directory}/TestResult.xls    Execute Date Time\t    Test Case name\t
    ...    TestResult\t    Status Execuet\t    ${\n}
    Append File Result    ${Directory}/TestResult.xls    '${DateTime}\t    ${TEST_NAME}\t    ${h}-${m}-${s}_${TEST_NAME}\t    ${StatusTC}\t    ${\n}
    Log To Console    End : Row Data \n

Log Pass
    [Arguments]    ${Logs}
    Get Date Time    ${EMPTY}
    ${Directorys}    Replace String    ${Directory}    Resource\\GlobalKeywords    TestResults
    Append To File    ${Directorys}/${TEST_NAME}/README.md    ${EMPTY}
    Set Suite Variable    ${StatusTC}    ${Logs}

Log Fail
    [Arguments]    ${Logs}
    Get Date Time    ${EMPTY}
    ${Directorys}    Replace String    ${Directory}    Resource\\GlobalKeywords    TestResults
    Append To File    ${Directorys}/${TEST_NAME}/README.md    ${EMPTY}
    Set Suite Variable    ${StatusTC}    ${Logs}

Append File Result
    [Arguments]    ${DirectoryTestResult}    @{Message}
    : FOR    ${Index}    IN    @{Message}
    \    Append To File    ${DirectoryTestResult}    ${Index}

File Result
    [Arguments]    ${Source}    ${Destination}
    Copy Directory    ${Source}    ${Destination}
    Empty Directory    ${Source}
    Remove Directory    ${Source}

Log Start
    Get Date Time    ${EMPTY}
    ${Directorys}    Replace String    ${Directory}    Resource\\GlobalKeywords    TestResults
    Append To File    ${Directorys}/${TEST_NAME}/README.md    ${EMPTY}
