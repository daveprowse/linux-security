# Lab 10 - Assigning a Regular User sudo Permissions ⚙️

> Note: For this lab I will be using an Ubuntu Server and a CentOS server.

## Assigning sudo permissions in Ubuntu

- Create a new account named *sysadmin*. (Choose another account name if you are already using this.)
  
	Example: `adduser sysadmin`

- Attempt to execute an `apt update` command. It should result in an error similar to the following:

```console
E: Could not open lock file /var/lib/apt/lists/lock - open (13: Permission denied)
```

- Now attempt it by preceding the command with `sudo`. This should also fail, similar to the following:

```console
[sudo] password for sysadmin: 
sysadmin is not in the sudoers file.  This incident will be reported.
```

The problem is that the *sysadmin* account is not an administrator (or superuser) on the system. This is a built-in safeguard in Linux and an example of the principle of least privilege.

However, let's say that you wanted the *sysadmin* account to be able to execute administrative commands. (The name "sysadmin" would suggest that it is the case, right?!)

We could add the sysadmin account to the sudo group, thereby making *sysadmin* a "sudoer".

- Issue the following command:

	`usermod -aG sudo sysadmin`

That modifies the sysadmin account, and adds it to the sudo group. Now, it should have administrative privileges.

> Note: The above command will work as root, but other administrative users will need to precede it with `sudo`.

- Login as sysadmin again:

	`su - sysadmin`

	And attempt to update the system:

	`sudo apt update`

	The first time you use the `sudo` command, the system should request the user's password. Type it. The command should now work and the program will tell us how many packages can be updated. That's it, sysadmin now has administrative privileges. But only as long as the command sudo precedes the administrative command.

## Assigning sudo (wheel) permissions in CentOS

> Note: If you don't have a sysadmin user, create one now with the command `useradd sysadmin`.

In Fedora/RHEL/CentOS systems, the %wheel group takes the place of %sudo. This applies to the sudoers file and if you want to apply administrative permissions to a user account. So for example as root:

`usermod -aG wheel sysadmin`

If you are working as a different user with administrative permissions, precede the previous command with `sudo`.

> Note: If you don't already have a sysadmin account, build one, and then run the above command.

This adds the *sysadmin* account to the %wheel group.

Run the following command:

`id sysadmin`

This should show the wheel group (instead of the sudo group) - displayed as (10)wheel.

Now run this command:

`sudo visudo`

Take a look at the end of the sudoers file. You should see "%wheel" listed there as well instead of sudo.

However, keep in mind that while the group name is different, the *command* `sudo` is the same. 

> Note: In older Ubuntu systems, the %admin group was used, but it is unlikely that you will encounter that. 

👍 **Fantastic! You are doing Awesome!** 👍

---

## 📃 Extra Credit

Learn more about the `usermod` command:

`sudo usermod --help`

`man usermod`

---
