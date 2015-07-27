#!/bin/bash

#
# script: OpenVPN rutas_down.sh
#

# Verbose mode
#set -x

#route del -net 150.100.0.0 netmask 255.255.0.0 gw $route_net_gateway
route del -net 150.200.0.0 netmask 255.255.0.0 gw $route_net_gateway
route del -net 150.200.122.0 netmask 255.255.255.0 gw $route_net_gateway
route del -net 150.210.0.0 netmask 255.255.255.0 gw $route_net_gateway
route del -net 150.210.2.0 netmask 255.255.255.0 gw $route_net_gateway
route del -net 150.210.4.0 netmask 255.255.255.0 gw $route_net_gateway
route del -net 150.210.47.0 netmask 255.255.255.0 gw $route_net_gateway
route del -net 150.210.33.0 netmask 255.255.255.0 gw $route_net_gateway
route del -net 150.160.25.0 netmask 255.255.255.0 gw $route_net_gateway
route del -net 150.160.26.0 netmask 255.255.255.0 gw $route_net_gateway
route del -net 150.100.131.0 netmask 255.255.255.0 gw $route_net_gateway
route del -net 150.100.161.0 netmask 255.255.255.0 gw $route_net_gateway
route del -net 150.100.180.0 netmask 255.255.255.0 gw $route_net_gateway
route del -net 150.100.182.0 netmask 255.255.255.0 gw $route_net_gateway
route del -net 150.100.183.0 netmask 255.255.255.0 gw $route_net_gateway
route del -net 150.100.196.0 netmask 255.255.255.0 gw $route_net_gateway
route del -net 150.100.246.0 netmask 255.255.255.0 gw $route_net_gateway
route del 150.200.215.11 gw $route_net_gateway

