# Lab 16 - Wired and Wireless Security in Linux ⚙️

In this lab we'll:

- Demonstrate how to block protocols at the kernel level with a bash script.
- Analyze network interface statistics.

I'll be using a Debian server to demonstrate during this lab. It has a wired connection named *ens3*. I'll be working as root.

> Note: Most of what we cover can be used for wired or wireless connections.

## Block Protocols at the Kernel Level

> Pre-flight: Before you start, make sure that you can ping the server from another Linux system. We want to make sure that it is accepting ICMP requests and replying to them before we block ICMP.

You can block (or allow) things at the kernel level by creating a script and pointing to that script from the network interface configuration within `/etc/network/interfaces`. Let's show that now.

### Create a Bash Script that will Block ICMP echos and Stop Forwarding

Example:

`vim /etc/network/secure-interface-ens3.sh`

> Note: Modify *ens3* with whatever the name of the interface is.

Add the following:

```console
#!/bin/bash

echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all

echo 0 > /proc/sys/net/ipv4/conf/all/forwarding
```

Save the script.

Set it to executable:

`chmod +x secure-interface-ens3.sh`

> Note: There are more options in the secure-interface-ens3.sh file in this directory.

### Add the Script to the interfaces File

Open the interfaces file with your editor:

`vim /etc/network/interfaces`

Add the following line underneath the gateway argument for the interface in question:

`pre-up /etc/network/secure-interface-ens3.sh`

So, the file might look something like this:

```console
# The primary network interface
allow-hotplug ens3
iface ens3 inet static
        address 10.0.2.51/24
        gateway 10.0.2.1 
        pre-up /etc/network/secure-interface-ens3.sh
```

This will call the script as the network interface is being brought up.

Reboot the server.

### Try Pinging the Server

Attempt to ping the server from another system that previously was able to do so. 

It should not function.

However, you should be able to SSH into the server (if that is enabled). Attempt this as well.

### Return the Server to Normal

When you are finished with the lab, return your server to normal. 

- Backup and remove the script.
- Remove the `pre-up` line item from the `/etc/network/interfaces` file. (Or comment it out if you want to use it later.)
- Reboot the server (or down and up the network interface).

Test that everything works as normal by pinging the server from a remote client and obtaining replies.

> Note: These modifications are a bit more old school. While they work, they can also be accomplished through the use of a firewall. In fact, before Linux firewalls worked directly at the kernel-level in Linux, this is one of the things that you might have done to further secure a Debian server.

## Analyze NIC Statistics

You can analyze your network interface card (NIC) statistics right from the command line. For example, go to:

`/sys/class/net/<adapter_name>/statistics`

From here you can see statistics as they are written by Linux.

- Want to see if there were any collisions? Check the *collisions* file.
- Want to see transmit or receive errors? Check the *tx_errors* and *rx_errors* files respectively.
- Or, compare the transmit and receive files (*tx_packets* and *rx+packets*) against the packets dropped files (*tx_dropped* and *rx_dropped*). If the amount of drops is equal to the packets then there could be a security issue. (Or, it could simply be that the system is dropping/blocking packets as a matter of routine.)  

Want to see the data in realtime? Try this:

`watch cat rx_packets`

Or whichever file(s) you want. Close out by pressing `Ctrl + C`. Fantastic!

> Note: In fact, the entire `<adapter_name>` directory has all kinds of great information about your network connection. If you have multiple network connections, there will be a separate directory for each. Spend some time analyzing them!

👍 **Fun - and Educational!** 👍

---

## 📃 Extra Credit

Learn more about the `/proc` directory:

`man proc`

Learn more about wireless networks and wireless security:

[Wireless Networking](<https://learning.oreilly.com/videos/comptia-a-core/9780137903740/9780137903740-CAP1_02_11_00/>)

[Wireless Security](<https://learning.oreilly.com/videos/comptia-a-core/9780137903894/9780137903894-CAP2_02_12_00/>)

Learn more about securing network access in Debian - [link](https://www.debian.org/doc/manuals/securing-debian-manual/network-secure.html)

---
