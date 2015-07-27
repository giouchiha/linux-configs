#!/bin/bash

echo "Levantando NAT for Road Warriors"
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -s 10.28.0.0/24 -o eth0 -j MASQUERADE
