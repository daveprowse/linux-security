#!/bin/bash

## Example of more kernel-level networking modifications. 

echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all

echo 0 > /proc/sys/net/ipv4/conf/all/forwarding

echo 1 > /proc/sys/net/ipv4/tcp_syncookies 

echo 1 > /proc/sys/net/ipv4/icmp_ignore_bogus_error_responses 

echo 1 > /proc/sys/net/ipv4/conf/all/rp_filter

echo 0 > /proc/sys/net/ipv4/conf/all/accept_redirects
echo 0 > /proc/sys/net/ipv4/conf/all/send_redirects

exit 0