*** Settings ***
Variables    ../resources/json-cfg-loader.py   ./json-cofigs.json    service
*** Test Cases ***
test it works
    log To console    Started
    Log To Console    ${service['name1']}
    Log To Console    ${service.get('addr')}