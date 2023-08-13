*** Settings ***
Library  JSONSchemaLibrary  templates/response
*** Test Cases ***
My Test Case:
  Validate Json  test-schema.json  {"foo": "bar"}