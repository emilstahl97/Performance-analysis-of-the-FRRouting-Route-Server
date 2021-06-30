#!/bin/bash

rm frr.conf && touch frr.conf

cat > frr.conf << EOF
! -- bgp --
!
! BGPd sample configuration file
!
!
hostname RS
password zebra
enable password zebra
!
!
router bgp 65000 view RS
bgp router-id 192.168.30.5
no bgp ebgp-requires-policy
EOF
for i in {1..24}
do
echo "neighbor 10.0.0.$i remote-as 6500$i" >> frr.conf
echo "neighbor 10.0.0.$i update-source cx5n0if0" >> frr.conf
echo "neighbor 10.0.0.$i ebgp-multihop" >> frr.conf
echo "neighbor 10.0.0.$i prefix-list partialIn in" >> frr.conf
echo "neighbor 10.0.0.$i prefix-list partialOut out" >>  frr.conf
done

echo "!" >> frr.conf
echo "address-family ipv4 unicast" >> frr.conf

for i in {1..24}
do
echo "neighbor 10.0.0.$i activate" >> frr.conf
echo "neighbor 10.0.0.$i route-server-client" >> frr.conf
echo "neighbor 10.0.0.$i soft-reconfiguration inbound" >> frr.conf
done

echo "exit-address-family" >> frr.conf
echo "!" >> frr.conf 

echo "ip prefix-list partialIn permit any" >> frr.conf
for i in {1..4}
do
for j in {1..5}
do
a=$((j*50))
b=$((j*40))
for k in {1..25}
do
echo "ip prefix-list partialOut deny $i.$a.$b.$k/32" >> frr.conf
done
done
done
echo "ip prefix-list partialOut permit any" >> frr.conf

echo "!" >> frr.conf
echo "log file /var/log/frr/frr.log" >> frr.conf
