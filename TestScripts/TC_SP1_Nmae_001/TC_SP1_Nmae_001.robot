*** Settings ***
Suite Setup       Excel.Open Excel Files    Test_Data_EX.xls
Test Setup        Runing Test Setup
Test Teardown     Runing Test Teardown
Resource          Keyword.robot

*** Test Cases ***
TCSP1Nmae
    Skip Status Execute
    Openweb
