#!/bin/bash

cat << EOF 

Following is a script asking for your network 
parameters in order to create the necessary configuration files:

EOF

cwd=$(pwd)

read -p "Enter the IP-adress of the host where bgpd is running: " FRRIP
echo " "
echo "IP of host where FRR is running: $FRRIP"
echo "Current directory: $cwd"
echo " "

mkdir exabgp 
cd exabgp
mkdir prefixes route-batches instances

for i in {1..24}
do
echo "Creating instance$i.ini, prefixes$i.txt and route-batches$i.py"

rm instance$i.py && touch instance$i.py

cat > instance$i.py << EOF
#!/usr/bin/env python3

import sys
import time
from time import sleep

def route_smash():
    for first in range(1,223):
        for second in range(0,255):
            for third in range(0,255):
                sys.stdout.write('announce route %d.%d.%d.$i/32 next-hop 10.0.0.$i\n' % (first, second, third))
                sys.stdout.flush()
                
                
                
if __name__ == '__main__':
    try:
            route_smash()
    except (BrokenPipeError, IOError):
        sleep(10)
        route_smash()
EOF

cd instances
rm instance$i.py && touch instance$i.py

cat > instance$i.ini << EOF
process announce-routes {
    run /usr/bin/python3 ${cwd}/exabgp/route-batches/route-batches$i.py;
    encoder json;
}

neighbor $FRRIP {                    # Remote neighbor to peer with
    router-id 10.0.0.$i;             # Our local router-id
    local-address 10.0.0.$i;         # Our local update-source
    local-as 6500$i;                 # Our local AS
    peer-as 65000;                   # Peer's AS
    group-updates true;

    api {
        processes [announce-routes];
    }
}
EOF

cd  ..
cd prefixes
rm prefixes$i.txt && touch prefixes$i.txt
echo "Creating prefixes$i.txt"
python3 ${cwd}/exabgp/instance$i.py >> prefixes$i.txt
cd ..
rm instance$i.py

cd route-batches
rm route-batches$i.py && touch route-batches$i.py

cat > route-batches$i.py << EOF
#!/usr/bin/env python3

import sys
import time
import random
from time import sleep

def readFile():
    path = "${cwd}/exabgp/prefixes/prefixes$i.txt"
    with open(path) as fp:
        line = fp.readline()
        lines = []
        while line:
            lines.append(line)
            line = fp.readline()


    route_smash(lines)


def route_smash(lines):
    for i in range(len(lines)):
        sys.stdout.write(lines[i])
        sys.stdout.flush()


if __name__ == '__main__':
	try:
            readFile()
	except (BrokenPipeError, IOError):
		sleep(10)
		readFile()
EOF
cd ..
done

cd ..
cat > start_exabgp.sh << EOF
cd exabgp/instances
for j in $(eval echo {1..24}); 
do
echo "Starting instance$j"
sudo ip netns exec exa$j exabgp instance$j. ini & 
done
EOF