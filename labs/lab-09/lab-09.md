# Lab 09 - sudoers ⚙️

Users who have been given administrative privileges are known as a *sudoers*. That name is also the name of the sudo permissions file.

It is stored in `/etc/sudoers`

Take a look at that file now.

> Note: I'll be using a Debian client system for this portion of the lab.

- View the sudoers file

The sudoers file is where we can specify privileges for groups and individual users. However, the recommended way to modify the file is to use the `visudo` command. But this command will require administrative access, so we would have to add sudo before the command. To do this, simply type:

`sudo visudo`

**Example of visudo on Debian**

```console
#
# This file MUST be edited with the 'visudo' command as root.
#
# Please consider adding local content in /etc/sudoers.d/ instead of
# directly modifying this file.
#
# See the man page for details on how to write a sudoers file.
#
Defaults	env_reset
Defaults	mail_badpass
Defaults	secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# Host alias specification

# User alias specification

# Cmnd alias specification

# User privilege specification
root	ALL=(ALL:ALL) ALL

# Allow members of group sudo to execute any command
%sudo	ALL=(ALL:ALL) ALL

# See sudoers(5) for more information on "#include" directives:

#includedir /etc/sudoers.d
```

Looking toward the bottom of the file, you will note that the root account has ALL permissions. So does the sudo group (referenced as %sudo). But this can be changed. The sudo group can be limited, or new groups can be created with their own permissions. Individual accounts can also be assigned particular permissions to the system.

> Note:	In Fedora/RHEL/CentOS systems, the %wheel group takes the place of %sudo. This applies to the sudoers file and if you want to apply administrative permissions to a user account.

> Tip: By default sudo asks for the password of the user. It won't ask again for 5 minutes. To increase this timeout, add the following line to the sudoers file:
	
		`Defaults:sysadmin timestamp_timeout=30`
    
> That changes the timeout to 30 minutes for sysadmin. Modify it as you wish, but it is not suggested to modify it to 0 (which is infinite).

This is just a primer. There is plenty more to users, groups, permissions, sudo, and so on. But this is the core of what is happening on a Debian or Ubuntu system. It's one of the more complicated concepts in the Linux operating system. If you can understand this, then you can understand just about anything in Linux.

👍 **Excellent!** 👍

---

## 📃 Extra Credit

Learn more about the sudoers file:

`man sudoers`

---

## 🎚️ Take it to the Next Level!

You can add plugins to sudoers.

Question: You want to add an auditing plugin for sudoers. Where should you reference this plugin?

Answer can be found [here](../../z-more-stuff/next-level-answers.md#lab-09).