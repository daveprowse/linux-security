# Lab 22 - UFW ⚙️

The Uncomplicated FireWall (developed by Ubuntu), is designed for Ubuntu and works well on Debian. It is not designed for Red Hat and its derivatives.
This is a front-end firewall utility that interfaces with the iptables back-end tool and ultimately, iptables (or nftables) themselves.

In this lab we'll show how to install UFW, enable the UFW service, enable the UFW firewall itself, and create and remove some rules - testing as we go. I'll be testing on a Debian server (as root), but an Ubuntu server would work just as well.

> Warning! You will need to work locally at the console of the virtual machine for this lab. This is because once enabled, the firewall will shutdown subsequent SSH connections.

## Setup UFW

To begin, we'll install and enable UFW. On Ubuntu it might already be installed. However, other distributions, such as Debian, will need to install it.

`apt install ufw`

After that we need to make sure the service is enabled and started.

`systemctl status ufw`

If it is not enabled and started, do so:

`systemctl --now enable ufw`

Now, turn on the firewall itself.

`ufw enable`

That's it, UFW is enabled and running. Let's test it with the nmap utility from a remote machine.

`nmap 10.0.2.51`

> Note: If you don't have nmap, you can install is with `apt install nmap`.

This should show that the host has no ports open.

Let's take a look at the main configuration file for UFW:

`vim /etc/default/ufw`

>	Note the default global rules. All inbound and forwarded connections are being dropped, while any outbound connections are allowed. Here's an example of that on the Debian system:

```bash
# Set the default input policy to ACCEPT, DROP, or REJECT. Please note that if
# you change this you will most likely want to adjust your rules.
DEFAULT_INPUT_POLICY="DROP"

# Set the default output policy to ACCEPT, DROP, or REJECT. Please note that if
# you change this you will most likely want to adjust your rules.
DEFAULT_OUTPUT_POLICY="ACCEPT"

# Set the default forward policy to ACCEPT, DROP or REJECT.  Please note that
# if you change this you will most likely want to adjust your rules
DEFAULT_FORWARD_POLICY="DROP"
```

> Note: For the actual rules configuration file go to /etc/ufw/ and access user.rules to start.

## Create inbound rules

Now that we enabled the firewall, we can't connect to the server anymore! If you were to test it from a client, SSH connections would fail. But most of the time, you will want to run a firewall - but with exceptions. One exception is SSH.

### Enable SSH

Let's enable inbound ssh port with the following command:

`ufw allow 22/tcp`

or by service name:

`ufw allow ssh`

Now, lets show the rule:

`ufw show added`

This should show that the UFW rule has been added to allow inbound SSH. Now, attempt to SSH into the server from a client system. It should work.

> Note:	To view the access log, go to /var/log/ufw.log

### Scan the System

Now, scan the server from a remote system with netcat.

`nc -v 10.0.2.51 22`

`nc -v 10.0.2.51 80`

Examine the results.

### Deny SSH

In some firewalling scenarios you might need to deny a service. Let's deny SSH now with the following command:

`ufw deny ssh`

Enter the `ufw status` command to verify that it is working. You will note that the "SSH allow" rule is gone. The deny rule now takes precedence as shown below:

```console
root@deb51:~# ufw status
Status: active

To                         Action      From
--                         ------      ----
22/tcp                     DENY        Anywhere                  
22/tcp (v6)                DENY        Anywhere (v6)   
```

## Delete a Rule

It could be that you want to allow SSH over IPv4, but not over IPv6. UFW creates separate rules for both IP systems (by default) unless you specify otherwise. In this case, we have both set to deny. We could delete the IPv4, and afterward create a rule that allows IPv4 SSH access.

But first, we delete the SSH IP4 rule. The easiest way to do this is to delete the rule *number*. to find out the rule numbers, issue the following command:

`ufw status numbered`

You should see the rule numbers on the left, for example: 

```console
root@deb51:~# ufw status numbered
Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 22/tcp                     DENY IN     Anywhere                  
[ 2] 22/tcp (v6)                DENY IN     Anywhere (v6)   
```

So the rule we wnat to delete is Rule #1. Do this with the following command:

`ufw delete 1`

That's it. Check it again with `ufw status` and it should be gone. Now create an allow rule for SSH over IPv4 only. And check it:

```console
root@deb51:~# ufw allow proto tcp to 0.0.0.0/0 port 22
Rule added
root@deb51:~# ufw status numbered
Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 22/tcp                     ALLOW IN    Anywhere                  
[ 2] 22/tcp (v6)                DENY IN     Anywhere (v6)    
```
	
Now we can see that SSH over IPv4 is allowed, but SSH over IPv6 is not. Great work!

> Note:	That was just one example of many. And the networking options are vast. You will need to tweak your rules based on your network configuration and needs.

> Note: If you find that you don't need IPv6, you can simply disable it globally. Go to:

>		/etc/default/ufw

>and change IPV6=YES to IPV6=NO. Then reload the service: `ufw reload`. Alternatively, you could restart the UFW service: `systemctl restart ufw` or `ufw disable` and `ufw enable`.

## Disable UFW, Delete the Rules, and Disable the UFW Service

Careful with the following command. It removes the rules and resets the firewall to a disabled state!

`ufw reset`

Then, stop and disable the service to bring the system back to its original state before we began the lab.

`systemctl --now disable ufw`

👍 **Your very first firewall! Great Work!** 👍

---

## 📃 Extra Credit

Learn more about UFW:

`ufw --help`

`man ufw`

[Basic UFW usage](https://help.ubuntu.com/community/UFW)

[More advanced usage and configs](https://wiki.ubuntu.com/UncomplicatedFirewall)

---
