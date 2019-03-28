*** Settings ***
Suite Setup       Excel.Open Excel File  Test_Data_EX.xls
Test Setup        Runing Test Setup
Test Teardown     Runing Test Teardown
Resource          ../Resource/GlobalKeywords/GlobalKeywords.robot

*** Test Cases ***

TCSP1Nmae 
    Skip Status Execute
    Import Resource EN Language
    Web.Launch browser    https://www.google.com/
    Web.Input data    name    q    ${excel.testdata1}
    Web.Enter    name    q
    Web.Kill browser

    
    
