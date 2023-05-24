import redfish

import json

REDFISH_OBJ = redfish.redfish_client(base_url='https://ukko3-801-man.local.cs.helsinki.fi', username='',password='', default_prefix='/redfish/v1/')

REDFISH_OBJ.login(auth='session')

res = REDFISH_OBJ.get('/redfish/v1/Chassis/System.Embedded.1/Power/PowerControl',None)

parsed = json.loads(res.text)

watts=parsed['PowerConsumedWatts']

with open("powerconsumed.txt","a") as file:

    file.write(str(watts))

    file.write(",")

watts=parsed['PowerAllocatedWatts']

with open("poweralloc.txt","a") as file:

    file.write(str(watts))

    file.write(",")

REDFISH_OBJ.logout()
