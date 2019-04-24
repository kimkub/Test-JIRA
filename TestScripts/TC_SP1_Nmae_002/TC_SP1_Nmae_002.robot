*** Settings ***
Suite Setup       Excel.Open Excel Files    Test_Data_EX.xls
Test Setup        Runing Test Setup
Test Teardown     Runing Test Teardown
Resource          Keyword.robot

*** Test Cases ***
TCSP2Nmae
    Skip Status Execute
    Open Browser    https://www.google.com/webhp?hl=th&sa=X&ved=0ahUKEwjuhMebvKnhAhUHK48KHd9AAA0QPAgH    chrome
    Wait Until Page Contains Element    //input[@name="q"]
    Input Text    //input[@name="q"]    ${excel.testdata1}
    Wait Until Page Contains Element    //div[@id="lga"]
    Click Element    //div[@id="lga"]
    Wait Until Page Contains Element    xpath=(//input[@name="btnK"])[2]
    Click Element    xpath=(//input[@name="btnK"])[2]
    Web.Kill browser
