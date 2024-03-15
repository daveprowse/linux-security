# Lab 27 - Securing SSH ⚙️

Using SSH by itself is much more secure than older alternatives such as Telnet. But SSH has its own set of vulnerabilities. This lab demonstrates how to make SSH more secure than it already is.

In this lab we'll:

- Change the default inbound SSH port
- Disable password-based SSH
- Disable the root login via SSH
- Create exclusive SSH groups
- Configure SSH authentication options

These configurations will all be accomplished in: `/etc/ssh/sshd_config`

This is a larger lab, so plan to take breaks periodically.

> Note: For this lab I'll be working directly in the console of a Debian server (as root). That will function as the SSH server. I'll use a Debian client system as the SSH client.

## Change the SSH Inbound Port

An SSH server uses port 22 inbound by default. This is well-known. However, many port scans that are performed by would be invaders only scan for the first 1000 ports of a system. If we change the port to something less known that is above the first 1000 ports, then it can increase the security of the server.

On the Debian server, open the sshd_config file:

`vim /etc/ssh/sshd_config`

Find the line that indicates the port number. It should be near the beginning of the file. By default it is commented out, but it will say `#Port 22`.

As an example, we'll change it to port 2222. So change the line that reads `#Port 22` to:

`Port 2222`

Here's an example of the first 15 lines of the file:

```console
# $OpenBSD: sshd_config,v 1.103 2018/04/09 20:41:22 tj Exp $

# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.

# This sshd was compiled with PATH=/usr/bin:/bin:/usr/sbin:/sbin

# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options override the
# default value.

Port 2222
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::
```

Save and close the file.

Then, restart the sshd service:

`systemctl restart sshd`

  ---

  **Notes:**

  - If you are running a firewall, you will need to open that new port on the firewall. For example: `firewall-cmd --add-port=2222/tcp --permanent`. For more information on firewalld, see [this lab](../lab-23/).
  - If you are on a system that uses SELinux, you will need to execute the appropriate `semanage` command to tell SELinux that SSH is using a different port. See [this lab](../lab-21/) for more information.
  - If you are using a Fedora-based system, then know that they still refer to the SSH service as `sshd`, whereas Debian/Ubuntu have migrated to the `ssh` name. But as of the writing of this lab you can use `sshd` in both distros.
  
  ---

Now, on the Debian client, attempt to ssh into the server using the new port:

`ssh user@10.0.2.51 -p 2222`

The `-p` option specifies the port to use. You should see results similar to the following:

```console
user@deb-client:~$ ssh user@10.0.2.51 -p 2222
Enter passphrase for key '/home/user/.ssh/id_rsa': 
Linux deb51 4.19.0-16-amd64 #1 SMP Debian 4.19.181-1 (2021-03-19) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Mon Apr 12 17:52:58 2021 from 10.0.2.52
user@debserver:~$ 
```

After successfully connecting, exit out by typing `exit`. Great work!

> **💫 TECH TIP**: Press the `Ctrl + D` shortcut to exit out of an SSH session.

## Disable Password-based SSH

Although our client will now connect to the server with a key instead of a password, the server can still be accessed by other systems and other users via password. We can disable password-based SSH altogether on the server.

As root on the Debian server, open `/etc/ssh/sshd_config` again and find the line that says:

`#PasswordAuthentication yes`

Uncomment it and change it to:

`PasswordAuthentication no`

Save and exit the file. 

Restart the service: `systemctl restart sshd`.

This will disallow password-based authentication to that SSH server across the board.

**Test**

- Attempt to connect from a separate user account (one that does not have any SSH keys setup). It should not work!
- Verify that user accounts *with* SSH keys can still connect.

## Disable the root Login Altogether

While root cannot login to an openSSH server via password by default, the root account can still connect via a key. We take that ability away by modifying the following line in the sshd_config file:

`PermitRootLogin prohibit-password`

to:

`PermitRootLogin no`

**Test**

Attempt to connect from the client to the SSH server with the root account. For example:

`ssh root@10.0.2.51`

It should fail!

## Restrict access by creating an exclusive group

Don't just allow anyone to connect! By creating an exclusive group, we specify and organize the users that are allowed to connect.

Create a new group. For example:

`addgroup ssh-allowed`

Now, add the user account to the new group:

`adduser user ssh-allowed`

Verify the existence of "user" within the "ssh-allowed" group:

`groups user`

Open the SSH Server config file once again:

`vim /etc/ssh/sshd_config`

and add the group to the end of the config file:

`AllowGroups ssh-allowed`

---
💫 **Tech Tip:** You could also echo that line to the file without opening it:

    `echo "AllowGroups ssh-allowed" >> /etc/ssh/sshd_config`
  
  Just be sure to append the file with a double alligator `>>` . This applies to any lines that we add to config files, but for these labs I want you to open and get to know the configuration files. 

---

Now, test the SSH connection to the server with the user account. It should work.

> **Warning!** Don't forget that we changed the port to 2222!

Next, remove the user acount from the ssh-allowed group.

`deluser user ssh-allowed`

Now attempt to SSH in again. It should fail, as all other accounts that are not members of "ssh-allowed" will fail.

## Authentication Settings

The default authentication settings for an SSH server leave something to be desired - especially if you have confidential data, or mission-critical systems. 

Let's show a few ways to harden the authentication options:

### Lower the Maximum Amount of Authentication Attempts

When a user connects to an SSH server with a password, the user get's a certain amount of attempts to type the correct password.

> Note: The actual number listed is 6. However, some systems have safegaurds that only allow three attempts maximum, regardless of this setting.

Let's change this setting to `1` so that a user has to type the password correctly the first time.

Find the line: `MaxAuthTries` and change it from 6 to 1.

Restart the sshd service.

Attempt to connect from a client using user-based authentication. Type an incorrect password. You should only get one chance.

Now, change the setting back to 6 and restart the sshd service.

Attempt to connect from a client once again. Try incorrect passwords. Even though the setting is at 6, you will probably only get three chances from the client. This is a standard "three strikes and you're out" rule which could be controlled from one of several different configurations.

### Set a Minimum Login Grace Time

When a user attempts to login to an SSH server via password, the user will have either 2 minutes to type in a password or unlimited time, depending on the configuration. This could be considered too much grace time. Reduce it by uncommenting the line below and modifying as shown:

`LoginGraceTime 15s`

Now, make a connection to the SSH server but don't type the password. Wait 15 seconds and then attempt to type the password. The result should be a timed out connection. For example, you might see the following:

```console
Connection closed by 10.0.2.51 port 22
```

### Disable X11 Forwarding

X11 Forwarding is when an SSH client can run X-based programs (graphical programs) locally from the SSH server. This can be a security risk because an attacker can use the X11 tunnel in a malicious manner.

To disable this find the line `X11Forwarding` and set it to `no`.

Restart the sshd service.

> Note: This can also be turned off at the client side in `/etc/ssh/ssh_config`. The setting is `ForwardX11 no`.

> Note: If you are SSH'ing into a server with no desktop, then there isn't too much fear of trying to run graphical applications remotely, because they are probably not installed - but you never know. In order to test this more effectively, try using two Linux systems that each have desktops installed. You could test it with a simple program such as `gedit` or `gnome-clocks`.

> Note: Some client systems require the `-X` or `-Y` option when connecting in order to run X sessions. However, in newer versions of OpenSSH this may not be necessary.

> Note: In many cases you can use the command `systemctl reload sshd` in lieu of `systemctl restart sshd`.

And there is much more. As you can see, there are dozens of settings in `sshd_config`, many of which are security-, or accessibility-related.

## Summary

Think of how many hackers attempt to get into servers that allow inbound SSH connections. There are tons, not to mention bots. So... you could argue that there can't be enough protection for an SSH server.

So some fundamental ways to increase the security of the SSH server are to: use a different and less known port; disable password-based SSH; restrict SSH access by user and group; disable root login; reduce the maximum authentication attempts; and set up SSH timeouts.

Another concept mentioned is key management. Security companies find thousands (if not millions) of floater keys on corporate networks all the time. That's because there often is no proper key management (SSH certificate authority, or other solution) and it results in SSH key sprawl - where the admins literally don't know where many of the keys are.

Most of these concepts don't just apply to SSH servers, they apply to just about any "server" or mover of information. It could be a switch, router, PC, and of course, your actual traditional servers.

And these security techniques only scratch the surface of what can be accomplished. Always be looking to improve on the security of your servers.

---

👍 **All SSH'd out? Take a break, then come back for more!** 👍

---

## 📃 Extra Credit

For more information about the sshd_config file:

`man sshd_config`

Try running a virtual machine on the cloud (Linode, Digital Ocean, etc...) and make your initial root connection. How is `sshd_config` configured for root?

For more information about SSH guidelines, see this [NIST document](
https://nvlpubs.nist.gov/nistpubs/ir/2015/nist.ir.7966.pdf).

---
