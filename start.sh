#!/bin/bash

echo
echo "Calling Mothership....."
echo

# create terraswarm directory in /etc
mkdir -p /etc/terraswarm
# grab the python client contact script
wget -O /etc/terraswarm/client.py https://raw.githubusercontent.com/terraswarm/SwarmScripts/master/client.py
# only if the file does not exist
#wget -nc -O /etc/terraswarm/client.py [location]

# run python script
/usr/bin/python /etc/terraswarm/client.py
