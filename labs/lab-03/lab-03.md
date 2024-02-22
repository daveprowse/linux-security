# Lab 03 - passwd and shadow ⚙️

In this lab we will discuss the passwd and shadow files in Linux.

## passwd

Open a terminal.

As your regular user account, type the following command:

`vim /etc/passwd`

> Note: Replace vim with your favorite editor if you wish.

This opens the passwd file. You will note that it says "read-only" at the bottom. That is because this is a protected file. We opened it as a regular user. If we wanted to edit this file, we would either need to use `sudo` or work as root.

View the root account entry in the beginning of the file. It should look similar to the following:

```bash
root:x:0:0:root:/root:/bin/bash

```

This shows that root is account 0. It also shows the home folder, as well as the user's default shell.

Look at the following example:

```bash
user:x:1000:1000:user,,,:/home/user:/bin/bash
dpro:x:1002:1002:dpro,,,:/home/dpro:/usr/bin/fish

```

This shows two users: *user* and *dpro*. Note that their user ID and group ID are shown. Regular Linux users are normally listed starting with 1000. You'll also note different home directories and default shells being used - *user* is bash, and *dpro* is fish. 

Take a couple minutes to decipher your passwd file.

You will note that there are a lot of other accounts. These are all based on the operating system, programs, and services and are not actual user accounts. Some of these are obsolete and holdovers from older versions of Linux/Unit. Others are indeed used. For example:

- sshd: The service account that is associated with Secure Shell (SSH). You will note it has the default shell set to "nologin" which means that the account cannot use a login environment in Linux. That is normally the case for service accounts.
- www-data: which is the service account that works with web servers.

> **Important!** You can make changes here to home directories and default shells used by users, but you risk breaking the account in question. Be careful when modifying the `passwd` file! But remember, to actually modify this file, you would have to be a sudoer on the system and use the `sudo` command, or work as root.

You might also have noted that there is an "x" next to each user account name. Many years ago, that was where the password was stored. However, it is wise to have passwords in a separate area from the usernames. Enter in the shadow file.

## shadow

The file `/etc/shadow` is where actual passwords (or hashed versions of them) are stored.

Try to open the file now with the following command:

`vim /etc/shadow`

You should get a "Permission Denied" message at the bottom of the screen. In this case, the file is not displayed in read-only mode, it is simply **not** displayed!

You will have to use `sudo` or work as root to view the file.

Once you do, you will see the list of accounts again, but this time with a cryptographically hashed password equivalent. Your changed password from the previous lab is stored in this file.

You will see the root account in the beginning. Once again, if you scroll down, you will see your main user account.

For example:

```console
user:$y$j9T$Heb2aEHna6XpmWULoKQ1B.$uBGU/JYIavvqZAYUBS5yZdUulKsJwqYIRundF.cIgH3:19754:0:99999:7:::
```

> **IMPORTANT!** Never show your shadow information to anyone! I did it because when I am using a test system. When I am done with this learning course I will be deleting the virtual machine.

Note the `$y` in the beginning of the long sequence of characters. That tells us that Debian Linux is using Yescrypt as its method of cryptographic hashing. Previous to Debian 12, Debian used SHA-512 (displayed as `$6`) and going back in time, the hashes were SHA-256 `$5`, Blowfish `$2a`, and MD5 `$1`. If these are spotted, you should upgrade to the latest hashing technology. Once upgraded, users should change their passwords to comply with the new hashing algorithm.

After the `$y` You have the actual salted, hashed version of the password. Then there are additional components after the colon `:`. These can be changed within Linux. Let's use the values in the example above to describe these.

- 19754 - The last password change
- 0     - Minimum password age
- 99999 - Maximum password age
- 7     - Warning period
- :::   - inactivity period, expiration date, and whether it is unused. (These are not being used in the example above.)

> Note: The last password change is measured in days since January 1, 1970. This is known as the epoch date selected as a point of convenience by Unix engineers long ago.

> **IMPORTANT!** This is not normally a file you would modify. Rather, it keeps the record of user passwords and password-based information.
---
That completes the lab!

👍 **EXCELLENT** 👍

---

## 📃 Extra Credit

> Note: All Extra Credit assignments are optional! But worth it!

Learn more about the `passwd` and `shadow` files! Issue the following commands in the terminal.

`man 5 passwd`

`man shadow`

> Note: If you enter `man passwd` it will give you the manual page for the command, not the file. Don't confuse the two! the command is known as passwd(1). The file is known as passwd(5).

---

## 🎚️ Take it to the Next Level

> Note: These questions are designed to build your knowledge. But you will need to research... and think! Here's your first one.

Question: What is the name of the passwd backup file?

Answers can be found [here](../../z-more-stuff/next-level-answers.md#lab-03).

Question: Can you think of any other files that might benefit from an automatic Linux backup?
