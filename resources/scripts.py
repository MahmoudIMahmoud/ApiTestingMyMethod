from jinja2 import Template
import curlify
import json

def render_the_template(template, **dataDict):
    tm = Template(template)
    return tm.render(dataDict)


def Str_To_Json(jsonstring):
    return json.loads(jsonstring)


# @keyword('Convert To Curl')
def convert_to_curl(r):
    data = curlify.to_curl(r)
    #print(data)
    # remove and modify non-postman standard curl headers to standard postman ones
    data = data.replace("curl -X ","curl --location --request ")
    data = data.replace(" -H "," --header ")
    data = data.replace("--header 'Accept:*/*'","")
    data = data.replace("--header 'Accept-Encoding:gzip, deflate, br'","")
    data = data.replace("--header 'Connection:keep-alive'","")
    data = data.replace("--header 'User-Agent:python-requests/2.27.1'","")
    print(data)
    return data