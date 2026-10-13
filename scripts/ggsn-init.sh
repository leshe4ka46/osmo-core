#!/usr/bin/env bash

DEFAULT_IF=$(ip -4 route show default | awk '{print $5; exit}')

iptables -A FORWARD -i apn0 -o "$DEFAULT_IF" -j ACCEPT
iptables -A FORWARD -i "$DEFAULT_IF" -o apn0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -t nat -A POSTROUTING -s 172.16.222.0/24 -o "$DEFAULT_IF" -j MASQUERADE


