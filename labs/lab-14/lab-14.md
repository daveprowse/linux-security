# Lab 14 - Reducing the Attack Surface ⚙️

This lab shows how to stop and disable a service, and check the open ports of a system. For this lab I'll be demonstrating on a Debian client system.

- Stop the networking service

	`systemctl stop networking`

	Then, check its status with `systemctl status networking`

- Disable the service

	`systemctl disable networking`

	Then check its status again.

	> Note: The service can be stopped *and* disabled with one command:
	`systemctl --now disable networking`

- Start and enable the networking service at the same time:

	`systemctl --now enable networking`

- Show all services and unit files:

	`systemctl list-unit-files`

	This displays the unit file information (enable/disable) for services and other unit files in Linux.

> Note: Truncate it and filter with: `systemctl list-unit-files --type service | grep enabled`.

- Show list-units information with systemctl:

	`systemctl list-units`

> Note: Take notice of the difference between the `list-unit-files` and `list-units` options.

- Check for open ports being used by services

	`ss -tulnw`

	Example results:

	```
	user@deb52:~$ ss -tulnw
	Netid         State           Recv-Q          Send-Q                    Local Address:Port                    Peer Address:Port         
	icmp6         UNCONN          0               0                                     *:58                                 *:*            
	udp           UNCONN          0               0                         192.168.122.1:53                           0.0.0.0:*            
	udp           UNCONN          0               0                        0.0.0.0%virbr0:67                           0.0.0.0:*            
	udp           UNCONN          0               0                               0.0.0.0:44050                        0.0.0.0:*            
	udp           UNCONN          8448            0                         192.168.122.1:5353                         0.0.0.0:*            
	udp           UNCONN          8448            0                             10.0.2.52:5353                         0.0.0.0:*            
	udp           UNCONN          0               0                               0.0.0.0:5353                         0.0.0.0:*            
	udp           UNCONN          0               0                               0.0.0.0:5353                         0.0.0.0:*            
	udp           UNCONN          0               0                               0.0.0.0:56590                        0.0.0.0:*            
	udp           UNCONN          0               0                                  [::]:45721                           [::]:*            
	udp           UNCONN          0               0                                  [::]:5353                            [::]:*            
	tcp           LISTEN          0               100                           127.0.0.1:20959                        0.0.0.0:*            
	tcp           LISTEN          0               100                           127.0.0.1:20000                        0.0.0.0:*            
	tcp           LISTEN          0               100                             0.0.0.0:4000                         0.0.0.0:*            
	tcp           LISTEN          0               100                           127.0.0.1:12001                        0.0.0.0:*            
	tcp           LISTEN          0               100                           127.0.0.1:12002                        0.0.0.0:*            
	tcp           LISTEN          0               100                           127.0.0.1:25001                        0.0.0.0:*            
	tcp           LISTEN          0               80                            127.0.0.1:3306                         0.0.0.0:*            
	tcp           LISTEN          0               100                           127.0.0.1:26002                        0.0.0.0:*            
	tcp           LISTEN          0               32                        192.168.122.1:53                           0.0.0.0:*            
	tcp           LISTEN          0               9                               0.0.0.0:21                           0.0.0.0:*            
	tcp           LISTEN          0               128                             0.0.0.0:22                           0.0.0.0:*            
	tcp           LISTEN          0               128                           127.0.0.1:7001                         0.0.0.0:*            
	tcp           LISTEN          0               100                                [::]:4000                            [::]:*            
	tcp           LISTEN          0               128                                   *:80                                 *:*            
	tcp           LISTEN          0               9                                  [::]:21                              [::]:*            
	tcp           LISTEN          0               128                                [::]:22                              [::]:*            
	tcp           LISTEN          0               128                               [::1]:7001                            [::]:*    
	```

	Scroll over to see the open ports. You can see that the DHCP client (port 67), DNS (port 53), SSH (port 22), and several others are opened. Those are ports that aare opened on the inbound side. Every open port is a potential vulnerability. Normally, a client such as this would have no legitimate reason to have port 22 open (amoong other ports). We could close that port by stopping and disabling the service with one command.

	Don't do this on your system (so you don't lose SSH) but here is an example:

	`systemctl --now disable ssh`

	You can use curly braces {} to stop and disable multiple services at the same time. For example:

	`systemctl --now disable {service1,service2}`

👍 **Perfectomundo!** 👍

---

## 📃 Extra Credit

Learn more about the `systemctl` command:

`systemctl --help`

`man systemctl`

---
## 🎚️ Take it to the Next Level!

Question: How can you use `systemctl` to check/enable/disable services on a remote system?

Answer can be found [here](../../z-more-stuff/next-level-answers.md#lab-14).
