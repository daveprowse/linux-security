# Lab 15 - Creating and Repairing a Degraded System ⚙️

This lab demonstrates how one failed service or program will cause a "degraded system". The lab is run on a Debian client.

## Check the System Status

First, let's check our current system status. We can do this with the following command:

`systemctl status`

Hopefully, your system will show that it is "Running" in green. That means that no services have failed. If not, well then, you will learn how to troubleshoot the problem in this lab!

## Cause a Service to Fail

Here we'll type an error into the SSH server configuration file. When we attempt to restart SSH, it will fail. That will then cause the system to become degraded.  

1. Open the `sshd_config` file. It is located in `/etc/ssh`.
2. Locate the line that says `#Port 22`, and modify it to read `Port22----$%^`
3. Restart the SSH server service: `systemctl restart ssh`. You should see the failure. For example:

```console
root@deb52:/etc/ssh# systemctl restart sshd
Job for ssh.service failed because the control process exited with error code.
See "systemctl status ssh.service" and "journalctl -xe" for details.
```

> Note: On Fedora-based systems you will use the name "sshd". On Debian systems use "ssh".

## Start Troubleshooting

Now, type the following command:

`systemctl status`

This should result in a "degraded" system (shown in red).

Unfortunately, this command does not show what has failed, or how. But you can find any failed services by issuing the command:

`systemctl --failed`.

This should result in something similar to the following:

```console
root@deb52:/etc/ssh# systemctl --failed
  UNIT        LOAD   ACTIVE SUB    DESCRIPTION                
● ssh.service loaded failed failed OpenBSD Secure Shell server

LOAD   = Reflects whether the unit definition was properly loaded.
ACTIVE = The high-level unit activation state, i.e. generalization of SUB.
SUB    = The low-level unit activation state, values depend on unit type.

1 loaded units listed. Pass --all to see loaded but inactive units, too.
To show all installed unit files use 'systemctl list-unit-files'.
```

We can see that the ssh service has failed. We can check the ssh and sshd services individually with the systemctl or journalctl commands. Examples:

`systemctl status ssh` or `systemctl status sshd`

`journalctl -u ssh` or `journalctl -u sshd`

If systemctl doesn't go back in time far enough in the logs, then journalctl is the tool to use. By issuing the command `journalctl -u ssh` we can see why and where the actual error occurred:

```console
Apr 07 16:48:15 deb52 sshd[5193]: /etc/ssh/sshd_config line 13: Badly formatted port number.
```

It tells us exactly where to look to analyze the problem more: the sshd_config file on line 13. That is, of course, what we messed up in the first place!

> Note: You could have also run the `journalctl -xe` command (as the Linux error message stated) but that will give you a ton of information that you would need to sift through. Using the -u option with the particular service name will usually save you time. And you can put that extra time in a bottle for later use if you wish.

## Fix the Problem and Verify Full Functionality

Access the SSH configuration file:

`sudo vim /etc/ssh-sshd_config`

Change the line that we modified earlier back to the original: `#Port 22`

Restart the service:

`systemctl restart ssh`

Check the system with a `systemctl status`. At this point, it should once again say that the State is "running" in green.

👍 **And all is well in Linux Land. YES!** 👍

---

## 📃 Extra Credit

Learn more about the `sshd_config` file:

`man sshd_config`

---
