#!/bin/bash

#Remove old files
touch captured-results-$2peers-$1.txt

#Create directories
mkdir $2peers-$1
mkdir $2peers-$1/pcaps
mkdir -p Results/$1

if [[ $1 == "help" ]]
then
  echo "filter-version, #peers, round"
  exit 0
fi

read -p "Enter the network interface to capture on: " interface
read -p "Enter the MAC-address of the network interface: " MAC 

bash ../restartFRR.sh

echo "--------------------------------------"
echo "Started: $(date)"
echo "--------------------------------------"

rm capture$3-$2peers-$1.pcap parsed.txt capture.json
touch capture$3-$2peers-$1.pcap parsed.txt capture.json vtysh-pfxsnt-$2peers-$1.txt vtyshresults-$2peers-$1.txt

tshark -i $interface -f "ether src host $MAC and tcp port 179" --autostop duration:180 -w capture$3-$2peers-$1.pcap

vtysh -c 'show bgp view RS summary json' > capture.json
python3 parseJson.py $1 $2 $3

echo "Parsing file: capture$3-$2peers-$1.pcap"
cat capture$3-$2peers-$1.pcap | pbgpp --fields prefixes -f LINE -p FILE -o parsed.txt -
numberOfPrefixes=$(grep -o -i /32 parsed.txt | wc -l)
echo "$numberOfPrefixes" >> captured-results-$2peers-$1.txt
mv capture$3-$2peers-$1.pcap $2peers-$1/pcaps

sed -i 's/parsed.txt/ /g' captured-results-$2peers-$1.txt
echo "Results after $3 rounds:"
cat captured-results-$2peers-$1.txt

if [[ $3 == 10 ]]
then
average=$(python3 mean.py captured-results-$2peers-$1.txt)
delta=$(python3 diff.py captured-results-$2peers-$1.txt)
echo "$average" >> captured-results-$2peers-$1.txt
echo "Delta: $delta" >> captured-results-$2peers-$1.txt
cat captured-results-$2peers-$1.txt

average=$(python3 mean.py vtysh-pfxsnt-$2peers-$1.txt)
delta=$(python3 diff.py vtysh-pfxsnt-$2peers-$1.txt)
echo "$average" >> vtysh-pfxsnt-$2peers-$1.txt
echo "Delta: $delta" >> vtysh-pfxsnt-$2peers-$1.txt

sudo mv captured-results-$2peers-$1.txt $2peers-$1
sudo mv vtysh-pfxsnt-$2peers-$1.txt $2peers-$1
sudo mv vtyshresults-$2peers-$1.txt $2peers-$1
sudo mv $2peers-$1 Results/$1/

echo "Done"
fi