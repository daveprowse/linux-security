# Lab 25 - Translating iptables to nftables ⚙️

You might work with a system that requires iptables, or perhaps you are more fluent with iptables than nftables. To help in your nftables learning process there is an iptables to nftables translator. It's not perfect, but it can be quite helpful if you are transitioning from one to the other.

In this lab I will be working on a Debian Server as root.

## Install the iptables-translate Command

Debian 12 server does not have iptables installed by default, and the `iptables-translate` command is part of that utility. So we will have to install iptables now:

`apt install iptables`

Note that the service need not run. But on certain systems it will be running. We are going to leave it disabled for now. We simply want to use the `iptables-translate` command in this lab.

Verify that the command will work:

`iptables-translate --version`

That should display the version of the program.

> Note: If a person actually had iptables running, that person should backup the configuration. For example: `iptables-save >/tmp/iptables.dump`

## Enable nftables

Enable nftables now by typing the following command:

`systemctl --now enable nftables`

> Note: Make sure there are no other firewalls running on the system.

Verify that it is running:

`systemctl status nftables`

Check the default nftables configuration:

`nft list ruleset`

It should show a basic, insecure nftables configuration.

## Translate an iptables command to nftables

Now, let's say that we wanted to allow port 22 access inbound. Let's also imagine that we knew how to do it in iptables, but not with nftables. Translate!

`iptables-translate -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT`

This should result in an nft-based conversion similar to the following:

`nft add rule ip filter INPUT tcp dport 22 ct state new counter accept`

This is good, and can aid a person who is navigating from iptables to nftables. But it is not perfect. It would have to be modified for the table and chain in question (plus, it is case sensitive). For example:

`nft add rule inet filter input tcp dport 22 ct state new counter accept`

Run that command now.

This should work in a typical Debian server with nftables running.

  > Note: In fact, we did something similar to this in a previous lab, and it is written in a much cleaner way: `nft add rule inet ports_table input tcp dport 22 accept`. This is part of the beauty of nftables. Once you get to know it, it is generally accepted that it uses cleaner syntax than iptables.

Check your work:

`nft list ruleset`

This should show the new rule in the nftables configuration within the input chain.

## Clean Up

Flush the ruleset:

`nft flush ruleset`

Disable nftables:

`systemctl --now disable nftables`

Remove the iptables program (and iptables-translate command):

`apt purge iptables`

Reboot the computer for good measure and verify network access.

---

## That's it. Great work! You blew away nftables! 🌪️

---

## 📃 Extra Credit

For more information, consider the following sources:

https://wiki.nftables.org/wiki-nftables/index.php/Simple_rule_management

https://wiki.archlinux.org/title/nftables

---
