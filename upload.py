#!/usr/bin/python

import requests

url = 'http://192.168.1.13/bWAPP/unrestricted_file_upload.php'

cookie = {
    'PHPSESSID': 'bdcedfcab468a0efa4c414855e6e29aa',
    'security_level': '0'
}
header = {
    'User-agent': 'Mozilla/5.0 (X11; Linux x86_64; rv:45.0)\
    Gecko/20100101 Firefox/45.0',
    'Accept': 'text/html,application/xhtml+xml,application/\
    xml;q=0.9,*/*;q=0.8',
    'Accept-Language': 'en-US,en;q=0.5',
    'Accept-Encoding': 'gzip, deflate',
    'Referer': 'http://192.168.1.13/bWAPP/unrestricted_file_upload.php'
}
files = {
    'file': open('fuck.jpg', 'rb'),
    'Content-Type': 'multipart/form-data',
    'Content-Length': '475',
    'Content-Type': 'image/jpeg'
}
response = requests.post(url, headers=header, cookies=cookie, files=files)

print response
