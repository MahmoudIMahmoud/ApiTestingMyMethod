*** Settings ***
Documentation    Suite description
Resource   ../resources/APICallLib.robot
Test Setup    Create Session    alias=session    url=https://cpib-integration.apps.fr01.paas.tech.orange/productManagement/v1    verify=False
*** Test Cases ***
Test it works
    [Tags]    DEBUG    test_case_id=1
    # Data setup.    
    # Like Given
    ${random_value}    Generate random string    2    123456789
    ${p_ordr_id}    Generate random string    5    1234567890
    
    # Calling the API function.  
    # Like When
    ${resp}     Api call    Disco.CreateProduct    random_value=${random_value}    product_order_id=${p_ordr_id}
    
    # Assertions.    
    # Like Then.
    log     ${resp.json()}
    Should Be Equal As Strings  ${resp.status_code}    201
