*** Settings ***
Documentation    Suite description
Resource   ../resources/APICallLib.robot
Test Setup    Create Session    alias=session    url=https://petstore.swagger.io/v2    verify=True
*** Test Cases ***
Test it works
    [Tags]    DEBUG
    ${resp}     Api call    Pet.AddPet      id=135      category_name=Cat    pet_name=Selia
    log     ${resp.json()}
    Validate response schema    Pet.AddPet    200    ${resp}
