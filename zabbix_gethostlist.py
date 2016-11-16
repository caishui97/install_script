#!/usr/bin/env python
#coding=utf-8
import json
import urllib2
#xiaorui.cc
url = "http://192.168.7.11/zabbix/api_jsonrpc.php"
header = {"Content-Type": "application/json"}
# request json
data = json.dumps(
{
    "jsonrpc":"2.0",
    "method":"host.get",
    "params":{
        "output":["hostid","name"],
        "filter":{"host":""}
    },
    "auth":"fd83bc7f99cc114f1d2691de30355338",
    "id":1,
})
# create request object
request = urllib2.Request(url,data)
for key in header:
    request.add_header(key,header[key])
# get host list
try:
    result = urllib2.urlopen(request)
except URLError as e:
    if hasattr(e, 'reason'):
        print 'We failed to reach a server.'
        print 'Reason: ', e.reason
    elif hasattr(e, 'code'):
        print 'The server could not fulfill the request.'
        print 'Error code: ', e.code
else:
    response = json.loads(result.read())
    result.close()
    print "Number Of Hosts: ", len(response['result'])
    for host in response['result']:
        print "Host ID:",host['hostid'],"Host Name:",host['name']
