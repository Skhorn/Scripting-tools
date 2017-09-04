#!/usr/bin/python

from bs4 import BeautifulSoup
import requests
import hashlib

# URL
url = 'https://hax.tor.hu/level11/'

# Payload to send the Cookies, <Cookie_name> : <Cookie_value>
cookie = {'HAXTOR': '99vff02hdh55vkh6loe5765366'}

# Request session
session = requests.Session()

# Send in post the cookie payload + tell requests not to verify
# SSL(CA_certificates)
response = requests.post(url, cookies=cookie, verify=False).text

#print response.text

soup = BeautifulSoup(response, 'html.parser')


# Find any td tag
soup_td_search = soup.findAll('td')

# Tag 6 contains a tag b, search for it
tag_b_to_hash = soup_td_search[6].find('b')

# split it into an array
hash_array = tag_b_to_hash.text.split(',')

# Convert unicode to ascci and remove white spaces
to_md5 = [item.encode('ascii').replace(" ","") for item in hash_array]


print to_md5[0]

# Hash the string
m = hashlib.md5()
m.update(to_md5[0])
answer = m.hexdigest()

print answer

# Find an input tag with name pw
send_answer = soup.find("input", {"name" : 'pw'})

print send_answer

payload = {"pw" : answer}

# Forge a new request via get, sending the payload containing the answer,
# cookies and the no SSL verification
r = requests.get('https://hax.tor.hu/level11/?pw', params=payload, cookies=cookie, verify=False)

print r.text
