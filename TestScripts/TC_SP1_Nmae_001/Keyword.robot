*** Settings ***
Resource          ../../Resource/GlobalKeywords/GlobalKeywords.robot
Resource          Wording.robot

*** Keywords ***
Openweb
    Web.Launch browser    https://www.google.com/
    Web.Input data    name    q    ${excel.testdata1}
    Web.Enter    name    q
    Web.Kill browser
