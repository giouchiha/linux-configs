#!/bin/bash

echo "Deteniendo NAT for Road Warriors"
echo 0 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -D POSTROUTING -s 10.28.0.0/24 -o eth0 -j MASQUERADE
