*** Settings ***
Library     Collections
Library     OperatingSystem
Library     String
Library     RequestsLibrary
Library     JSONSchemaLibrary    .
Library     scripts.py
#Var files:
Variables     ../APIsSchema/apischema.yaml
*** Keywords ***
Render the query params
    [Arguments]       ${templatefile}    &{params}
    ${qryparams}    Get File    ./templates/${templatefile}
    ${qryparams}    Render The Template    ${qryparams}    &{params}
    # ${qryparams}    To Json    ${qryparams}
    ${qryparams}    Set Variable    ${qryparams.strip()}
    ${ln}    Get Length    ${qryparams}
    Return From Keyword If    ${ln}<1    ${None}
    @{lines}    Split To Lines    ${qryparams}
    ${length}   Get Length        ${lines}
    &{qryParams}    Create Dictionary
    FOR    ${line}    IN    @{lines}
           @{row}    Split String    ${line}    :
           Log List    ${row}
           ${key}    Set Variable    ${row}[0]
           ${value}  Evaluate        ":".join($row[1:])    #${row}[-1]
           Set To Dictionary          ${qryParams}    ${key.strip()}=${value.strip()}
    END
    [Return]    ${qryparams}


Render file dictionary
    [Arguments]    ${filedescriptor}    &{params}
    ${conetnts}    Get Binary File    ${filedescriptor}
    &{files}    Create Dictionary    file=${conetnts}
    [Return]    ${files}


Api call
    [Arguments]    ${apiname}    &{params}
    ${descriptor}    Set Variable    ${APIs.${apiname}}
    ${template}    Get File    ./templates/${descriptor.bodyTemplate}
    # Run Keyword Unles
    &{reqparams}    Create Dictionary    &{params}
    ${body}    Render The Template       ${template}    &{reqparams}
    Log    ${body}
    ${headers}    get file    ./templates/${descriptor.headers}
    ${reqheaders}    Render The Template    ${headers}        &{reqparams}
    ${reqheaders}    Str To Json    ${reqheaders}
    ${uri}    Set Variable    ${descriptor.uri}
    ${uri}    Render The Template    ${uri}    &{reqparams}
    ${action}    Convert To Lower Case    ${descriptor.action}

    #========================================================
    ${keys}    Get Dictionary Keys    ${descriptor}
    ${found}     Get Index From List    ${keys}    params
    Log    ${found}
    Run Keyword If    ${found}>=0    Log    it is there and params= ${descriptor.params}

    #===========================

    ${qryparams}    Set Variable    ${EMPTY}
    Run Keyword If    ${found}>=0    Log    ${descriptor.params}
    ${qryparams}    Run Keyword If    ${found}>=0    Render the query params    ${descriptor.params}    &{reqparams}


    #=========================
    ${files}=        Set Variable    ${EMPTY}
    ${filesfound}    Get Index From List    ${keys}    files
    &{files}    Run Keyword If   ${filesfound}>0    Render file dictionary    ${descriptor.files}    &{reqparams}
    # ...        Run Keywords    ${files}=  Get Binary File    ${descriptor.files}    AND    ${files}    Create Dictionary    file=${files}

    #=====================================
    ${response}    Run Keyword If
    ...               "${action}"=="post"    POST On Session     session    ${uri}    headers=${reqheaders}    data=${body}    files=${files}
    ...    ELSE IF    "${action}"=="get"     Get On Session      session    ${uri}    headers=${reqheaders}    params=${qryparams}
    ...    ELSE IF    "${action}"=="put"     Put On Session      session    ${uri}    headers=${reqheaders}    data=${body}
    ...    ELSE IF    "${action}"=="delete"  Delete On Session   session    ${uri}    headers=${reqheaders}    params=${qryparams}
    ...    ELSE IF    "${action}"=="patch"   Patch On Session    session    ${uri}    headers=${reqheaders}    data=${body}

    ${CurlTxt}  convert to curl     ${response.request}
    log     ${CurlTxt}
    [Return]    ${response}

#
#
#
Validate response schema
    [Arguments]    ${apiname}    ${code}    ${reponse}
    ${descriptor}    Set Variable    ${APIs.${apiname}}
    ${expectedresponses}    Set Variable    ${descriptor.Responses}
    Log Many    ${expectedresponses}
    ${expectedresponse}    Set Variable    ${expectedresponses['${code}']}
    Log Many    ${reponse}
    Validate Json    ${expectedresponse}    ${reponse.json()}
