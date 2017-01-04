#!/bin/bash

ip link set enp0s3 up
dhcpcd enp0s3

brctl addbr br0

ip link set enp0s8 up
ip link set br0 up

ip addr add 10.0.3.1/24 dev br0

iptables  -I INPUT -i br0 -p udp --dport 67 -j ACCEPT
iptables  -I INPUT -i br0 -p tcp --dport 67 -j ACCEPT
iptables  -I INPUT -i br0 -p udp --dport 53 -j ACCEPT
iptables  -I INPUT -i br0 -p tcp --dport 53 -j ACCEPT
iptables  -I FORWARD -i br0 -j ACCEPT
iptables  -I FORWARD -o br0 -j ACCEPT

iptables -t nat -A POSTROUTING -s 10.0.3.0/24 ! -d 10.0.3.0/24 -j MASQUERADE
iptables -t mangle -A POSTROUTING -o br0 -p udp -m udp --dport 68 -j CHECKSUM --checksum-fill

dnsmasq \
-q \
--strict-order \
--pid-file=/var/run/dnsmasq.pid \
--conf-file= \
--dhcp-range 10.0.3.2,10.0.3.254 \
--dhcp-lease-max=253 \
--dhcp-no-override \
--dhcp-leasefile=/var/lib/misc/dnsmasq.br0.leases \
--dhcp-authoritative
