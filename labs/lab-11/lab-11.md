# Lab 11 - Updating Debian and Ubuntu ⚙️

In this lab we'll focus on the Advanced Package Tool (APT) that is used by Debian and Ubuntu (and many other derivatives of Debian).

The apt tool can be used to: check for updates, install individual updates, install all updates, upgrade to a new version of the OS, install individual programs, and more. It is a powerful tool and should be used accordingly - with caution.

## Update all programs

> Warning! The following procedure will update the entire system to the latest point release and will update any existing programs that have updates available. Use with caution!

At a Debian or Ubuntu system type the following command:

```console
apt update && apt upgrade -y
```

> Note:	You will need root or sudo access to accomplish this.

This command does the following:

1. Checks for updates based on the "sources.list" file.
2. Downloads and installs all updates

It does this automatically without any other user intervention. While this is okay for a client system (usually), we might need to use more caution when working with servers. 

## Update a server

Here we will update a Debian server, but we will do so in a more step-by-step fashion.

First, let's run `apt update` by itself so that the system will search for updates.

Next, lets view what those updates are:

`apt list --upgradeable`

**Example on Debian Server**

Here's an example of the two previous commands:

```console
root@deb51:~# apt update
Hit:1 http://deb.debian.org/debian buster InRelease
Get:2 http://security.debian.org/debian-security buster/updates InRelease [65.4 kB]
Get:3 http://deb.debian.org/debian buster-updates InRelease [51.9 kB]
Get:4 http://security.debian.org/debian-security buster/updates/main Sources [180 kB]
Get:5 http://security.debian.org/debian-security buster/updates/main amd64 Packages [271 kB]
Get:6 http://security.debian.org/debian-security buster/updates/main Translation-en [145 kB]
Fetched 714 kB in 0s (1,469 kB/s)                              
Reading package lists... Done
Building dependency tree       
Reading state information... Done
1 package can be upgraded. Run 'apt list --upgradable' to see it.
root@deb51:~# apt list --upgradeable
Listing... Done
libopenjp2-7/stable 2.3.0-2+deb10u2 amd64 [upgradable from: 2.3.0-2+deb10u1]
N: There is 1 additional version. Please use the '-a' switch to see it
```

In the example, we see that the file libopenjp2-7 can be upgraded (slightly). That file is part of a package called OpenJPEG which deals with JPEG compression. This could be considered to be bloat (unnecessary software) on a server, especially if we are working in the command line only with no desktop environment (which you normally should be if working on Debian server). 

> Note: This is just an example. Your server will have different information based on what is installed, and when you run the commands!

In this example, we have a several options. We could:

- Do nothing. This is, in fact, a common option.

- Update the individual file (which is done with the apt install command)

	`apt install libopenjp2-7`

- Update the whole system (which would only update that file anyway in this case)

	`apt upgrade`

- Or, choose to remove the file or JPEG compression altogether in an effort to remove bloat. For example:

	`apt remove libopenjp2-7`

If we choose one of the second or third options, the file gets updated, and a subsequent execution of `apt update` will result in a message telling us that "all packages are up to date". If we choose the last option, the file and other dependent files are removed, and a subsequent `apt update` will, again, show that all packages are up to date.

## Update another package that was previously installed

For example, update the OpenSSH pacakge:

`apt install openssh-server`

That updates the SSH server on the system (if an update is available).

I think that's enough for now!

👍 **Excellent work! We are on our way to a "hardened" system.** 👍

---

## 📃 Extra Credit

Learn more about the `apt` command:

`apt --help`

`man apt`

---
## 🎚️ Take it to the Next Level!

Question: You want to use the `apt` command find out if ssh is installed but you don't want to sort through 30 pages of installed programs. What command could you issue?

Answer can be found [here](../../z-more-stuff/next-level-answers.md#lab-11).
