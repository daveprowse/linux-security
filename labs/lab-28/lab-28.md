# Lab 28 - Terminating SSH Connections ⚙️

By default in Linux, sessions can run a long time. It might be that you want to terminate SSH connections.

> Note: I'll be working on a Debian server for this lab, using tmux to split the screen into two terminals.

## View SSH Connections

First, make sure that there are no current connections to your SSH server.

Then, at the server, issue the following command:

`pgrep -c sshd`

If there are no client SSH connections, this should result in an answer of `1`. that is the local administrative SSH connection and will always be there.

Now, go ahead and connect via SSH from a client system to the server.

Then check the connections again:

`pgrep -c sshd`

Now you should see a result of `3`. That is normal. This shows the SSH connection from client to server and from server to client. (It's a two-way tunnel! Did I just coin a phrase?)

Another way to view the connections is with the `ps` command:

`ps -ef | grep ssh`

This might result in something similar to the following:

```console
root@debserver:~# ps -ef | grep ssh
root         568       1  0 11:29 ?        00:00:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
root         831       1  0 12:00 ?        00:00:00 ssh-agent
root         897     568  0 12:09 ?        00:00:00 sshd: user [priv]
user         903     897  0 12:09 ?        00:00:00 sshd: user@pts/2
root         918     914  0 12:10 pts/2    00:00:00 grep ssh
```

Here we can see all SSH connections that are occurring on the server. For example, the third and fourth lines show the connection from the client system. It will always show two connections for this - from server to client, and from client to server. The process IDs are listed as well. For example, in the fourth line we see PID 903 and 897.

In another terminal, run the following command:

`ss -punt`

You should see the SSH connections with IP addresses and ports used, plus the same PID information. For example:

```console
root@debserver:~# ss -punt
Netid      State      Recv-Q      Send-Q           Local Address:Port             Peer Address:Port       Process      
tcp        ESTAB      0           0                    10.0.2.51:22                  10.0.2.52:43474       users:(("sshd",pid=903,fd=4),("sshd",pid=897,fd=4))
```

Now, watch the SSH connections in real-time:

`watch ss -punt`

This will show the current network connections to the server and will update the list every 2 seconds.

Now, on the client in a separate terminal, make another SSH connection.

View it on the server. It should pop up within the `watch` command immediately. You will see the `pgrep -c sshd` command show `5` connections now. But in reality, we now have two actual SSH connections that we can practice terminating.

## Terminate SSH Connections

Go back to the first terminal on the server. (Again, a split screen setup such as `tmux` or `gnu/screen` can be very beneficial here.)

Terminate the first SSH connection by it's PID. In our example, we have an SSH connection using PID 903. To terminate that connection we could type:

`kill 903`

Once done that will close the SSH connection at the client side. That session will also disappear from the `watch ss` command on the server.

This is a good combination of commands because you can monitor SSH sessions in real time, by PID and their corresponding IP address.

Let's go ahead and make one more SSH connection to the server so that we have two to work with. View the connections at the server via the `watch` command which should still be running.

Now, terminate all connections:

`pkill --signal KILL sshd`

That should close both SSH sessions from the client.

Take a look at the `watch ss` command. There should be no incoming connections now.

Likewise, a `pgrep -c sshd` will show a single connection only (the local root). Fantastic!

Another option is to use the `killall` command. While most Linux distributions have this installed by default, Debian server (because of its leanness) does not. Install it with the following command:

`apt install psmisc`

Then terminate all ssh connections:

`killall "sshd"`

That will terminate all SSH-based connections, including the root SSH process: a `pgrep -c sshd` would show 0 connections. To get the default root connection back, simply restart the `sshd` service. 

## Auto-Terminate Terminal and SSH Sessions

Let's say you wanted to auto-terminate an SSH session after a specific amount of inactivity. This used to be available with the `ClientAliveInterval` and `ClientAliveAccountMax` options, but after OpenSSH 8.2 it was discontinued.

However, there's always a way with Linux (and Bash), right? We could use the `TMOUT` environment variable. By default, this is not set, but we could set it by the individual user or globally so that it terminates shells (and SSH sessions launched from the terminal) automatically.

### Example by the Individual User

At the SSH Server within the user account that would be connecting via SSH, modify the file: `~/.bash_profile`. Add the following:

```bash
TMOUT=180
readonly TMOUT
export TMOUT
```

What does this do? It sets the shell inactivity timeout to 180 seconds. After 180 seconds of inactivity, the SSH shell session will end. (Local shell sessions too!)

The `readonly TMOUT` makes the environment variable read-only, meaning the user cannot modify it. The `export TMOUT` command exports the variable so that it is active throughout the session. Because it is located in `.bash_profile`, it will be persistent across reboots.

> Note: You could also use the .bashrc file, but .bash_profile is a better practice. If you don't have one, simply create one!

### Global Example

At the SSH Server (as root), create a custom Bash script inside `/etc/profile.d`. So for example:

`vim /etc/profile.d/custom.sh`

Then add the following to that script:

```bash
#!/bin/bash

TMOUT=180
readonly TMOUT
export TMOUT
```

Careful with this though, it affects ***all*** users - including root! (Though root could be excluded through various means.)

This will create a 180 second (3-minute) inactivity timeout for all user shells, whether they are local, or created via SSH sessions from remote systems. Whoa!

> Note: You could also do this in the file `/etc/profile`, but it is recommended that custom scripts be placed in `/etc/profile.d` to avoid any potential conflicts. No need to `chmod` the script. It will be read by the operating system at boot time.

Try this on your ***test*** systems! That completes the lab.

> **TECH TIP:** With Bash, anything is possible. This was just one teeny-weensy example. Dream it, and it can be done. So if there are particular users, computers, sessions, shells... whatever, that you need terminated, or otherwise modified, use Bash. You won't regret it.

👍 **YES!** 👍

---

## 📃 Extra Credit

One important topic that we are not covering here is SSH Key Management. To avoid SSH key sprawl, you need to manage and audit your keys. Take a look at the following webpage for more information:

[SSH.COM Key Management](https://www.ssh.com/academy/iam/ssh-key-management)

---
