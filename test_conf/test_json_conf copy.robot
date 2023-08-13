*** Settings ***
Variables    ../resources/json-cfg-loader.py   ./json-cofigs.json    ${None}
*** Test Cases ***
test it works
    log To console    Started
    Log To Console    ${name1}
    Log To Console    ${addr}