# Lab 08 - Using the sudo Command ⚙️

sudo has multiple meanings. First, sudo is a program that runs on Linux systems which associates permissions with users and groups. sudo is also a group that a user can be added to in Debian/Ubuntu and similar systems. By default, once added to the sudo group, the user becomes an administrator. Finally, sudo is a command. When it precedes another command it allows the command to be run as an administrator. For example, `apt update` requires sudo rights. So for a typical user who acts as an admin to do an update, that user must type `sudo apt update`. Any command that requires administrative privileges needs to be preceeded by sudo. The only case where this is not true is if you are logged in as root.

## Work with sudo

> Note: The examples in this section are performed on a Debian Server.

- Install sudo

	Many Linux distributions already have sudo installed. You can easily find out by typing `sudo`. If not installed, it will tell you the command is not recognized. Debian (running as a server) does not have sudo installed by default. To install it, as root, type the following:

	`apt install sudo`

- Attempt to use sudo

	Login as sysadmin: `su - sysadmin`

	Type `apt update`. It won't work, because the sysadmin account would need to use the sudo command first.

	Type `sudo apt update`. It still won't work because the sysadmin account is not yet an actual administrator. It has not been added to the sudo group.

	Example below:

	```
	root@deb51:~# su - sysadmin
	sysadmin@deb51:~$ apt update
	Reading package lists... Done
	E: Could not open lock file /var/lib/apt/lists/lock - open (13: Permission denied)
	E: Unable to lock directory /var/lib/apt/lists/
	W: Problem unlinking the file /var/cache/apt/pkgcache.bin - RemoveCaches (13: Permission denied)
	W: Problem unlinking the file /var/cache/apt/srcpkgcache.bin - RemoveCaches (13: Permission denied)
	sysadmin@deb51:~$ sudo apt update
	sudo: unable to resolve host deb51: No address associated with hostname

	We trust you have received the usual lecture from the local System
	Administrator. It usually boils down to these three things:

	    #1) Respect the privacy of others.
	    #2) Think before you type.
	    #3) With great power comes great responsibility.

	[sudo] password for sysadmin: 
	sysadmin is not in the sudoers file.  This incident will be reported.
	```

	Logout of sysadmin and back into root.

## Use sudo on a system with a sudo user

You can accomplish this portion of the lab on just about any other Linux distribution that has an administrator. (Good examples include Ubuntu, Fedora, and Debian running as a client with a desktop.)

- Login to the system as the main user account with administrative permissions (not as root).
- Run the `apt update` command. This should fail with a "permission denied" message.
- Run the command again but with `sudo`.

	`sudo apt update`

	Now, the command should work (as long as the user is an administrator) and you should see if there are any updates that can be installed on the system.

That's it. You can see the security barrier here. Without `sudo` preceding the command, the user cannot accomplish administrative tasks, even if the user *is* an administrator on the system. 

Practice with it!

## Use the sudo command to gain access as root

You can also use the sudo command to gain access to the root account, In fact, on Fedora and Ubuntu Desktop, this is required by default.

If you are working on one of these systems, try the following with an administrator account:

`sudo -i`

That should request the password of the user with administrator rights, not the root account password, as would be the case if you typed `su -`.

If successful, this will place you in a root shell.

In the case of default Fedora Workstation and Ubuntu Desktop installations, the `su` and `su -` commands will not allow you access to the root account because the root account is currently protected (and has no password associated with it). Only an administrator account that was created during the installation will be able to access root, and only with the `sudo -i` command. 

> **IMPORTANT!**  As a best practice, use the `passwd` command to assign a complex and lengthy password to the root account - if you haven't already!

Exit out of the root account when done.

> **Tech Tip** Use the `Ctrl+D` keyboard shortcut to quickly exit out of a user's shell. 

👍 **Great Work! Continue!** 👍

---

## 📃 Extra Credit

Get your sudo judo going. Learn more about the sudo command:

`sudo --help`

`man sudo`

---

## 🎚️ Take it to the Next Level!

Question: You want to utilize AskPass to supply the sudo password during the execution of an administrative command such as `apt update`. Which option should you use?

Answer can be found [here](../../z-more-stuff/next-level-answers.md#lab-08).