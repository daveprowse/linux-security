# Lab 23 - firewalld ⚙️

firewalld is a front-end firewalling utility developed by Red Hat. So it's designed for Fedora, RHEL, CentOS, and other Red Hat derivatives, and is installed on them by default. It acts as an easier to use front-end for the netfilter framework than the nftables userspace utility `nft`.

In this lab we will:

- Install and enable firewalld
- Attempt to connect to the server
- Change the default active zone
- Test the firewall from a remote system
- Add a rule to allow SSH
- Test the SSH opening on the firewall
- Remove the SSH rule
- Change the active zone back to the original
- Open and close multiple ports at once
- Lock it down!
- Return the system to its original state

This is a fairly intensive lab, so take breaks if necessary!

For this lab we'll work with a CentOS server as root.

firewalld can also be installed on Debian and Ubuntu. While it is not designed for them it should work in a similar fashion.

> Note: This utility is recommended for workstations. While it is often used on servers, it is recommended to use nftables (and the nft utility) on servers and for firewalling entire networks.

## Install and Enable firewalld

> Warning! You will need to work locally at the virtual machine for this lab. This is because once enabled, the firewall will shutdown subsequent SSH connections.

- Check if the service is running:

  `systemctl status firewalld`

  If not started and enabled, do it now:

  `systemctl --now enable firewalld`

- Show the current zone

  Zones are entities that hold different configurations. For example, *block* and *deny* are more secure built-in zones, whereas *public* is a bit less secure (and commonly found as a default).

  Almost all firewalld commands start with `firewall-cmd`. To show the current zone, issue the following command:

  `firewall-cmd --get-active-zones`

  Here's an example of the output on a CentOS server:

  ```console
  [root@centos ~]# firewall-cmd --get-active-zones
  public
    interfaces: enp1s0
  ```

  Here we can see that the current active zone that the firewall is using is called *public*. This is the default option, and is fairly limited.
  
  > Note: It is very similar to the *FedoraServer* zone (which is used by Fedora Server by default).

  We also see that the network interface (enp1s0) is making use of that zone type.

- List information about the active zone:

  `firewall-cmd --list-all`

  Here is the results from our CentOS Server:

  ```console
  [root@centos ~]# firewall-cmd --list-all
  public (active)
    target: default
    icmp-block-inversion: no
    interfaces: enp1s0
    sources: Change the Active Zone back to the Original
    services: cockpit dhcpv6-client ssh
    ports: 
    protocols: 
    masquerade: no
    forward-ports: 
    source-ports: 
    icmp-blocks: 
    rich rules: 
  ```

  You can see the services that are running, and that is essentially what we are limited to. So we can ping the server, SSH into it, use the cockpit service to control it remotely from a web browser, and the server can seek to obtain an IP address from a DHCP server. We can't do much of anything else though. However, even this will not be secure enough for many environments.

> Note: There are many types of built-in zones. To see a list of them, type the following command: `firewall-cmd --get-zones`. To see in-depth information about all zones, type the following: `firewall-cmd --list-all-zones`. You can also create your own zones if you wish.

## Attempt to Connect to the Server

Try now to ping and SSH into the server. You should be able to both of these things. For example:

`ping 10.0.2.61`

and

`ssh user@10.0.2.61`

Verify that you can make these connections.

## Change the Active Zone

Let's make the system more secure by changing the default active zone. Issue the following command:

`firewall-cmd --zone=block --change-interface=enp1s0 --permanent`

> Note: You will have to change the name of your interface from *enp1s0* to whatever your network interface name is. If you are not sure than issue either the `ip a` command or the `nmcli` command. Be sure to use the *Linux name* of the network interface, and not the *NetworkManager* name.

This command changes the active zone. Check it with:

`firewall-cmd --get-active-zones`

Your interface should now be part of the *block* zone, making it more secure. Once again, you can list more information, but this time we have to add the zone name. Use the following command:

`firewall-cmd --zone=block --list-all`

You should see output similar to the following:

```console
[root@centos ~]# firewall-cmd --zone=block --list-all
block (active)
  target: %%REJECT%%
  icmp-block-inversion: no
  interfaces: enp1s0
  sources: 
  services: 
  ports: 
  protocols: 
  masquerade: no
  forward-ports: 
  source-ports: 
  icmp-blocks: 
  rich rules: 
```

Note that there are no services listed. So this zone type is more secure because it allows nothing to come through, including ping or SSH which we could accmplish earlier. You can view this further by typing the following command:

`firewall-cmd --zone=block --list-ports`

That command should show nothing because no ports are open right now, which in turn is because no services are currently allowed.

## Test the Firewall from a Remote System

Go ahead and attempt to ping the server from a remote system and SSH into it. You should not be able to do so now.

Now try scanning the server with nmap. If you don't have nmap installed, you can easily install it (`apt install nmap` or `dnf install nmap`, etc...)

Here I scan the CentOS server (10.0.2.61) from a Linux client. As you can see below, the results show that everything is filtered, and effectively no ports are open.

```console
[root@fed-client ~]# nmap -Pn 10.0.2.61
Starting Nmap 7.80 ( https://nmap.org ) at 2021-04-09 13:51 EDT
Nmap scan report for 10.0.2.61
Host is up (0.00039s latency).
All 1000 scanned ports on 10.0.2.61 are filtered
MAC Address: 52:54:00:B5:29:89 (QEMU virtual NIC)

Nmap done: 1 IP address (1 host up) scanned in 5.37 seconds
```

## Add a Rule to Allow SSH

Most of the time, we desire access to a server via SSH. So let's add a rule that allows it.

`firewall-cmd --zone=block --add-port=22/tcp --perm`

We have to specify the zone we are dealing with (block). The `--add-port` option has the ability to be configured by port number (22/tcp) or by name (ssh). We also added the `--permanent` option in abbreviated form (`--perm`) so that the port will remain open if the system is rebooted.

Now we have to reload the firewall for the change to take effect.

`firewall-cmd --reload`

Now we can check our work with the following commands:

`firewall-cmd --zone=block --list-ports`

`firewall-cmd --zone=block --list-all`

Here are the results of the second option:

```console
[root@centos ~]# firewall-cmd --zone=block --list-all
block (active)
  target: %%REJECT%%
  icmp-block-inversion: no
  interfaces: enp1s0
  sources: 
  services: 
  ports: 22/tcp
  protocols: 
  masquerade: no
  forward-ports: 
  source-ports: 
  icmp-blocks: 
  rich rules: 
```

You can see that for the "block" zone, the only port that is listed is port 22. If we had run the command with the `--add-port=ssh` option, that would show up under services. Whether you do this by service name or by port is up to you but it might be dictated by organizational policy as well. Generally, I prefer to do it by port number.

## Test the SSH Opening on the Firewall

Now you should be able to SSH into the server, but not *ping* the server.

> Note: A subsequent nmap scan from the client: `nmap -Pn 10.0.2.61` should show that everything is filtered except for the SSH port.

## Remove the SSH Rule

To remove the SSH rule, issue the following command:

`firewall-cmd --zone=block --remove-port=22/tcp --perm`

Then, reload the firewall:

`firewall-cmd --reload`

Check your work:

`firewall-cmd --zone=block --list-ports`

It should show that no ports are opened once again.

## Change the Default Zone

Up until this point we have had to use the `--zone=block` argument to make changes to that zone. That is because the *public* zone is currently the "default". Let's view the current zone and change it.

View the current zone:

`firewall-cmd --get-default-zone`

Now let's change it:

`firewall-cmd --set-default-zone block`

View the current zone again. It should display as "block".

Now, any command we run will be executed within the "block" zone by default. For example:

`firewall-cmd --list-all`

## Change the Active Zone back to the Original

Issue the following command to change the active zone for the network interface card:

`firewall-cmd --zone=public --change-interface=enp1s0 --per`

> Note: Your original zone name might be different. For example, if you are working on Fedora Server, it is probably named *FedoraServer*. Your interface name may be different as well. In addition, we have abbreviated `--permanent` even further to `--per`.

Verify the active zone:

`firewall-cmd --get-active-zones`

Now, set that public zone as the default (this is the original setting):

`firewall-cmd --set-default-zone public`

Check it with:

`firewall-cmd --list-all`

## Open and Close Multiple Ports at Once

### Open multiple ports

Now we have our original active zone. But it doesn't allow for things like HTTP, DNS, and so on. If we want those, we have to create a rule to open those ports. For example, if we wanted to run a FreeIPA server, we would need to open several ports. We could do it in the following manner:

```console
firewall-cmd --add-port={80,443,389,636,88,464}/tcp --per
```

That will open up the ports associated with HTTP, HTTPS, LDAP, Secure LDAP, and two Kerberos-based ports.

Reload the firewall and the check your work:

`firewall-cmd --reload`

`firewall-cmd --list-ports`

### Close multiple ports

```console
firewall-cmd --remove-port={80,443,389,636,88,464}/tcp --per
```

Reload the firewall, and check your work. Everything should be back to the original firewall settings.

## Lock it Down!

In the case of an emergency, you can completely lock down and isolate the system. This feature is known as *Panic Mode*.

Use the following command:

`firewall-cmd --panic-on`

That will completely cut all network connections (at least on Layer 3 within the operating system). Try it now.

Now, attempt to connect from a remote system. Try pinging, SSH, and anything else you want. It shouldn't work. Nor should the server be able to connect *out* to anything.

This can be an excellent (and quick) method of disconnecting an important server from the network in the case of a breach or other attack. It's designed to stop all activity to the system, or to an entire network if this server is being used to firewall that network.

To disable Panic Mode, use the following command:

`firewall-cmd --panic-off`

Everything should now be back to normal.

## Return the System to its Original State

Stop and disable the firewall service with the following command:

`systemctl --now disable firewalld`

Now scan it from a remote client:

`nmap 10.0.2.61`

Change the IP address as necessary for your server. Here are example results:

```console
[root@fed-client ~]# nmap 10.0.2.61
Starting Nmap 7.80 ( https://nmap.org ) at 2021-04-09 14:19 EDT
Nmap scan report for 10.0.2.61
Host is up (0.00015s latency).
Not shown: 998 closed ports
PORT     STATE SERVICE
22/tcp   open  ssh
9090/tcp open  zeus-admin
MAC Address: 52:54:00:B5:29:89 (QEMU virtual NIC)

Nmap done: 1 IP address (1 host up) scanned in 0.24 seconds
```

We didn't need the `-Pn` option this time because the server is not firewalled at all. You'll also note that the scan only took 0.24 seconds. It shows us that the SSH and zeus-admin (cockpit) ports are open. When you do this type of work, you get to see why firewalls are so important.

> IMPORTANT! If need be, you can uninstall firewalld with `dnf remove firewalld`. However, only do this if you plan to replace it with another firewall (perhaps using nftables directly).

> Note: There is a graphical version of the firewall-cmd command structure. It is called *firewall-config*, and it can be installed to a Fedora client with the `dnf install firewall-config` command.

👍 **That was an awesome lab! Great job!** 👍

---

## 📃 Extra Credit

Learn more about firewalld and the `firewall-cmd` command:

`man firewalld`

`man firewall-cmd`

[firewalld.org](https://firewalld.org/)

---

## 🎚️ Take it to the Next Level!

Question: You have a single CentOS system. You need to run a DHCPv4 server and a DNS server with the standard inbound ports open. However, you want firewalld to block everything else. What commands should you issue to accomplish this?

Answer can be found [here](../../z-more-stuff/next-level-answers.md#lab-23).