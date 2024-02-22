# Lab 04 - Password Settings ⚙️

In this lab we will:

- Build a user account with the `adduser` command.
- Modify password settings with the `chage` command.

## Build a New User Account

Open a terminal.

As root, create a new account named *sysadmin*.

`adduser sysadmin`

> Note: If you are using a Fedora/RHEL/CentOS-based system, the better command will be `useradd`.

Assign the password *test* to the account and confirm it. You can fill out the rest of the automated form if you wish or just press enter to bypass them. Here's an example of what it looks like on a Debian server:

```console
root@deb51:~# adduser sysadmin
Adding user `sysadmin' ...
Adding new group `sysadmin' (1001) ...
Adding new user `sysadmin' (1001) with group `sysadmin' ...
Creating home directory `/home/sysadmin' ...
Copying files from `/etc/skel' ...
New password: 
Retype new password: 
passwd: password updated successfully
Changing the user information for sysadmin
Enter the new value, or press ENTER for the default
	Full Name []: Bob User
	Room Number []: 8
	Work Phone []: 5551212
	Home Phone []: 5551212
	Other []: test user
Is the information correct? [Y/n] y
root@deb51:~# 
```

- Login as the new *sysadmin* account.

  You can either logout of root and then login as sysadmin, or you can type:

  `su - sysadmin` which will start a new login shell for that account.

- Attempt to change the password:

  Type `passwd` to change the sysadmin account password. You will be prompted for the current password.

  Now enter the following new password: *test1* and confirm it.

  The system should respond by saying that you must choose a longer password. That's because Debian's default password policy for minimum length is 6 characters.

- Attempt to change the password again:

  Type `passwd` again. This time, try the password *test12*. Although it meets the minimum requirements, it could fail again. The system might tell you that "Bad: new and old password are too similar". That's because the new password has the same characters as the old password.

- Attempt to change the password a third time:

  Type `passwd` once again. This time, try the password *hello123*. This should work.

  > Note: Is *hello123* a secure password? Not really, by today's standards. At the bare minimum, passwords should be 16-20 characters, with a higher level of complexity. Length is very important. The password in question is 8 characters, it doesn't cut it in today's insecure world. It only uses lowercase letters and its only 8 characters. A more secure system would require passwords that are 16 characters minimum and use uppercase letters, lowercase letters, numbers, and special characters. For more information about password security, see the NIST SP 800-63B *Digital Identity Guidelines* document at [this link](https://pages.nist.gov/800-63-3/sp800-63b.html)

## Modify password settings with `chage`

In this lab we'll show how to change the default password settings and criteria on a Debian server as root.

- Use `chage` to change password settings

  Type the following command:

  `chage sysadmin`

  This command allows us to change the age requirements for a password as shown below:

  ```
  root@deb51:~# chage sysadmin
  Changing the aging information for sysadmin
  Enter the new value, or press ENTER for the default
    Minimum Password Age [0]: 0
    Maximum Password Age [99999]: 365
    Last Password Change (YYYY-MM-DD) [2021-04-12]: 
    Password Expiration Warning [7]: 
    Password Inactive [-1]: 
    Account Expiration Date (YYYY-MM-DD) [-1]: 2021-12-31
  root@deb51:~# 
  ```

  Here the maximum password age was changed from 99999 days to 365 days. Also, there is an account expiration date at the end of the year 2021. After December 31, 2021, the user account sysadmin will not be able to login. The other settings were not modified.

  > **Tech Tip:** While this is a good command to know, it is not used quite as often today. It has a lot of additional options which can be useful though. For example, to set a user's password to expire (make it a zero-day password) you can issue the following command:

  `chage -d 0 sysadmin`

  > This will require the sysadmin account to change its password on next login.

---
That completes the lab!

👍 **FANTASTIC!** 👍

---

## 📃 Extra Credit

Learn more about the `adduser`, `useradd` and `chage` commands! Issue the following commands in the terminal.

`man adduser`

`man useradd`

`man chage`

---

## 🎚️ Take it to the Next Level

> Remember: These questions are designed to build your knowledge. But you will need to research... and think!

Question: You used `adduser` to create a new user in the command-line. What command do you think you could use to add a new group?

Answers can be found [here](../../z-more-stuff/next-level-answers.md#lab-04).
