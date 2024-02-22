# Take it to the Next Level Answers

## Lab 03

Question: What is the name of the backup passwd file?

Answer: `passwd-`. It is stored alongside `passwd` within the `/etc` directory.

Question: Can you think of any other files that might benefit from an automatic Linux backup?

Answer: There are a bunch in Linux. Take a look at the `etc` directory and you will see them. If they have a dash `-` on the end of the filename, then they are automatic backups. For example, `shadow-`.

Take some time to explore the `etc` directory. You will use it often!

## Lab 04

Question: You used `adduser` to create a new user in the command-line. What command do you think you could use to add a new group?

Answer: Use the `addgroup` command in Debian and Ubuntu. Or, in Fedora/RHEL/CentOS, use the `groupadd` command.

## Lab 05

You can modify the default maximum and minimum password ages in Linux. It can be done in `/etc/login.defs`.

Question: What are the names of the defaults that you would modify?

Answer:

```console
PASS_MAX_DAYS 99999
PASS_MIN_DAYS 0
PASS_WARN_AGE 7
```

You'll have to scroll down a ways to find these.

These are known as the Password Aging Controls. You will note that there are lots of other awesome things that you can modify in `/etc/login.defs`. But be careful!

> **Tech Tip:** In Vim, use the slash key `/` to search for phrases, and the `n` key for multiple occurrences of them.

## Lab 06

Question: What is the difference between "Balanced" and "Power Saver" mode?

Answer: "Balanced" mode is the standard mode which uses typical, standard power from the power supply unit of the computer system. "Power Saver" mode (as the name implies) will save power - it offers reduced power usage but at the cost of reduced performance. Typically, you wouldn't need this in a PC or in a VM, but it can be very handy with laptops and other mobile devices that run on battery power.

## Lab 07

Question: What path with you be working in if you execute the `su -` command successfully?

Answer: You will be placed in the `/root` working directory.

> **IMPORTANT!** It's a good technique to use `sudo` powers whenever possible, and keep the root account "on the shelf" until it is absolutely required!

## Lab 08

Question: You want to utilize AskPass to supply the sudo password during the execution of an administrative command such as `apt update`. Which option should you use?

Answer: Use the `-A` option (or `--askpass) and specify the path to AskPass. This can be configured with the SUDO_ASKPASS environment variable. 

**Tech Tip:** If you tire of typing the sudo password often (it times out after 5 minutes by default) then you can modify it in the `/etc/sudoers` file with the following option:

`Defaults:<username> timestamp_timeout=30`

Change the timeout to whatever you desire. However, keep in mind that this can be a security issue, especially if you step away from the computer without locking it!

## Lab 09

Question: You want to add an auditing plugin for sudoers. Where should you reference this plugin?

Answer: Add the reference to the sudo.conf file. A default version of this file is location in `/etc`. You might add a plugin reference such as the following:

`Plugin sudoers_audit sudoers.so`

That will be dependent on the plugin installation if it is not already on your Linux system.

## Lab 11

Question: You want to use the `apt` command find out if ssh is installed but you don't want to sort through 30 pages of installed programs. What command could you issue?

Answer: Use the `apt list` command, specifically:

`apt list ssh`

This should display the following results (or something similar):

```console
❯ apt list ssh
Listing... Done
ssh/stable-security 1:9.2p1-2+deb12u2 all
```

You can see that ssh is indeed installed here from Debian's stable security repository, and that it is version 9.2. You could also find this out by typing:

`ssh -V`

## Lab 14

Question: How can you use `systemctl` to check/enable/disable services on a remote system?

Answer: To use `systemctl` in a remote connection, add the `-H` option. For example, from another system:

`systemctl -H user@10.0.2.51 status networking.service`

After you supply thre authentication credentials, this will show the status of the networking service on the system with the IP address 10.0.2.51. Note that systemctl rides on SSH here.

## Lab 23

Question: You need to run a DNS server and a DHCPv4 server with the standard inbound ports open. However, you want firewalld to block everything else. What commands should you issue to accomplish this?

Answer: Make sure that firewalld is running, preferably, using the "Block" or "Drop" zone. Then, run the following commands:

`firewall-cmd --add-port={53,67}/tcp --permanent`

`firewall-cmd --add-port={53,67}/udp --permanent`

`firewall-cmd --reload`

The default DNS port is 53. The default DHCPv4 port is 67.

> Note: Your port options (and transport layer selection) might vary. This will depend on exactly what your DNS and DHCP servers are doing and how they are configured.

## Lab 29

Question: You want to set relative permissions that will add the write permission for the group owner of a directory named `/test`. What command should you issue?

Answer: Use the following command:

`chmod g+w /test`

This will set the Group (g) permission to write (w). So `g+w`. However, it will not modify the User or Other file permissions. This is an example of *relative* permissions.