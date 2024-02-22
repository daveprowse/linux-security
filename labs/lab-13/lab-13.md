# Lab 13 - Installing Security Updates Only ⚙️

Let's show how to install just the security updates in Fedora-based systems and Debian-based systems. In this lab we will:

- Show the `dnf update --security` option in Fedora.
- Demonstrate how to install individual security advisories in Fedora.
- Show how to install individual updates in Debian.
- Demonstrate how to install security updates only in Debian with the `apt-get` command.
- Show how to work wth Unattended Updates in Debian.

## Fedora-based Systems

> Note: When I say "Fedora-based systems" I mean the entire tree of Fedora including Fedora Server and Workstation, CentOS Stream, Red Hat Enterprise Linux (RHEL), and all of the RHEL binary copies (Rocky Linux, AlmaLinux, Oracle Linux, etc...)

It's fairly simple to install security updates only, and disregard the rest of the application updates. To do so, add the `--security` option to your `dnf` command.

For example, to check for security updates only:

`sudo dnf check-update --security`

To install the security updates:

`sudo dnf update --security`

Try those on your system now...

> Note: Remember, if you do not add the `--security` option to the end of the command, the operating system will automatically install *all* updates including patches, application updates, bug fixes, and so on.

Easy enough right? But what if you want to install a *single* security update?

First of all, you have to become aware of them. I recomemnd signing up for the various Linux mailing lists that you support. For example:

https://access.redhat.com/security/security-updates/

If you find that there is a specific security update that you need to get (and only that update) you can install it in the following manner:

`sudo dnf update --advisory=<Update_ID>`

For example:

`sudo dnf update --advisory=RHSA-2024:0773`

This is an "important", or high-severity, fix for the squid server running on Red Hat. The year it was released was 2024 and the actual ID is "0773".

Of course, you could install individual updates with the basic `dnf install <package_name>` command as well, but that is designed more for applications and less critical files as opposed to actual security updates.

## Debian-based Systems

In Debian (as of the writing of this lab) there is no simple option that you can use to install security updates only (as is the case with Fedora). But we do have some alternatives.

### Install Single Packages

For example, if we only wanted to upgrade Apache, we could issue a command such as this:

`sudo apt install apache2`  (accepted method)

or

`sudo apt install --only-upgrade apache2`

This will upgrade the Apache web server only, and avoid causing any issues with other applications or portions of Linux.

> Note: Something I see often in the field is when a technician simply issues the command: `sudo apt update && apt upgrade -y`. Scary, because this downloads and installs all available updates. This can be problematic (at best) because it could cause conflicts, the breaking of packages, and so on, especially on a server system. Be very careful with this command!

As always, you should keep abreast of the latest security vulnerabilities and updates for your distro of Linux. For example, check out this Debian link:

https://www.debian.org/security/#DSAS 

This shows the latest security advisories. For example, on Feb. 9th, 2024, there was a security update for the libgit2 package.

If need be, you could update a single package such as this one in the following manner:

`sudo apt install libgit2`

> Note: We use the `install` option even when upgrading in Debian/Ubuntu.

> **IMPORTANT!** Knowledge is power, right? Keep on top of those security updates!

### Search for and Install all Security Updates with apt-get

> Note: Now, we're going to get into a little bit of the "beyond" for this course!

List all available security updates (only) from the command line:

`sudo apt-get -s dist-upgrade | grep "^Inst" | grep -i security`

In Debian, this will show all available security updates that come from the "stable-security" repository. You could then install individual updates from the list as shown earlier, or install them all with something similar to:

`apt-get -s dist-upgrade | grep "^Inst" | grep -i security | awk -F " " {'print $2'} | xargs apt-get install`

> Note: You will have to do this as root in a Debian system.

This should install the security updates only. Fantastic! But what happened here? Well, we used the `grep` command to filter for security-based installation files and the `awk` command to specify the second element of each result (which are the names of the packages to be updated). Then it ran the `apt-get install` to actually install them via xargs.

> Note: We are using `apt-get` here instead of `apt`. This is one of those times when it is recommended to do so because `apt` is considered less stable within scripts (though it can work).

### Use the unattended upgrades Program

The unattended-upgrades program can be used to automatically update the system. It can also be used to simplify the above process of installing security updates only.

- First, check if it is already loaded on the system. (It is not installed by default with Debian bu might be available on Ubuntu.)

- Then, if necessary, install it:

  `sudo apt install unattended-upgrades`

- Now, configure it:

  `sudo dpkg-reconfigure unattended-upgrades`

  Select "Yes" to configure unattended upgrades so that it will automatically update the system.

  > Warning! This will now automatically update the system. In many cases, this is not desired in a professional work environment.

  > Warning: Installing Unattended Upgrades will start a service of the same name (unattended-upgrades.service) which will run automatically and uses at least 13 MB of RAM. This may be unacceptable for many server installations.

- Now, modify Unattended Upgrades so that it will install security updates only.

  - Open `/etc/apt/apt.conf.d/50unattended-upgrades`
  - Locate the "origin..." line items.
  - Comment out (//) all origins except for the security-based ones. If the main "Debian" origin is not commented out, the program will attempt to install all updates, which is not desired, and will be time consuming.
  - Open `/etc/apt/apt.conf.d/10periodic` and modify the periodic updates as you see fit.

- Run the program as a dry run to see if it works:

  `sudo unattended-upgrade --dry-run -d`

- Then, run it for real by removing the `--dry-run` option.

👍 **Fantastic work!! You Rule!** 👍

---

> Note: You might also be interested in using Bash, Cron, Ansible, or a third-party program called Debsecan to configure the installation of security updates to your liking. Personally, I prefer the `apt-get` method above. But to each their own!

---
