# Lab 05 - Policy Configuration ⚙️

In this lab we will:

- Modify password minimum length and criteria in the `common-password` file.

## Modify Password Minimum Length

In Debian and Ubuntu you can change the minimum password length and other criteria in `/etc/pam.d/common-password`. Open the file now:

`sudo vim /etc/pam.d/common-password`

Find the following line:

```console
password [success=1 default=ignore] pam_unix.so obscure yescrypt
```

To change the minimum password length, add `minlen=12` to the end of that line so that it looks like this:

```console
password [success=1 default=ignore] pam_unix.so obscure yescrypt minlen=12
```

Now, instead of a 6 character password minimum, Debian will require 12 character passwords from users. Increase the number as you see fit, or based on organizational policies!

## Modify Password Criteria

You can also add criteria such as requiring uppercase letters and special characters. First, on Debian and Ubuntu, password quality has to be installed.

`sudo apt install libpam-pwquality`

Once done, the common-password file should now show a new line above the previous line that we modified that says `pam_pwquality.so`.

Now you can have additional options to the new line ending in `pam_pwquality.so`:

- To require uppercase letters: `ucredit=1`

- To require lowercase letters: `dcredit=1`

- To require special (or other) characters: `ocredit=1`

- To require that a certain amount of password criteria be included: `minclass=2`

- To specifically require a particular amount of characters, use the minus sign. For example, `ocredit=-1`. Note the *-1* instead of a 1.

Here's an example of a configuration that requires 12 characters, a minimum of 1 uppercase, 1 lowercase, and *2* special characters.

```console
# here are the per-package modules (the "Primary" block)
password	requisite			pam_pwquality.so retry=3 ucredit=1 dcredit=1 ocredit=-2 minclass=3
password	[success=1 default=ignore]	pam_unix.so obscure use_authtok try_first_pass yescrypt minlen=12
```

Now, go ahead and try changing a user account's password with the `passwd` command. See if your new password selections comply with the new criteria!

> **Warning:** Be sure to test this with a standard user account, and not the root account! It's easy to forget a password!

> Note:	This portion of the lab will work differently on Fedora/RHEL/CentOS systems. There you use the Authselect tool.

---
That completes the lab!

👍 **You are doing great!** 👍

---

## 📃 Extra Credit

> Note: All Extra Credit assignments are optional! But worth it!

Learn more about `pam.d`.

`man pam.d`

---

## 🎚️ Take it to the Next Level

As always, be sure to review the entire lesson when you finish it. Then, take it to the next level!

You can modify the default maximum and minimum password ages in Linux. It can be done in `/etc/login.defs`.

Question: What are the names of the defaults that you would modify?

Answers can be found [here](../../z-more-stuff/next-level-answers.md#lab-05).
