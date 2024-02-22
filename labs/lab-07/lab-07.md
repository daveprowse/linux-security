# Lab 07 - The su Command ⚙️

su is short for substitute user. If you ever need to login as a different user, the su command facilitates this. So for example, `su sysadmin` or `su - sysadmin` will login to the sysadmin account. One difference between the two is that `su` leaves you in the current directory that you were working in. `su -` puts you in the home directory of the user you are logging in as.

Let's demonstrate all this now. Once again, this is demonstrated on a Debian server currently logged in as root.

> Note: If you don't already have a separate testing account (for example *sysadmin*) then make that now: `adduser sysadmin`.

- Use `su` to access another account.

  Type `su sysadmin`. When you do so, it logs in as sysadmin, with no password required because you were already logged in as root. It leaves you in the same directory. Example:

  ```console
  root@deb51:~# su sysadmin
  sysadmin@deb51:/root$ ls
  ls: cannot open directory '.': Permission denied
  sysadmin@deb51:/root$ 
  ```

  Note that we are logged in as sysadmin, but it placed us in the /root directory. That is the working directory for the root account. With `su sysadmin` we didn't actually open a new login shell. And we are restricted. If we type `ls` we will get a permission denied message because the sysadmin account cannot do anything in the root directory.

  Type `logout` or `exit` to logout of the sysadmin account and return to root.

- Use `su -` to access that same account.

  Now type `su - sysadmin`. Typing `ls` works (though there is no content). Now type `pwd`. When you do so you will find that the default directory is /home/sysadmin as shown below.

  ```console
  root@deb51:~# su - sysadmin
  sysadmin@deb51:~$ ls
  sysadmin@deb51:~$ pwd
  /home/sysadmin
  sysadmin@deb51:~$ 
  ```

  This does actually create a new login shell. This is generally the preferred method, though not always.

  Logout of sysadmin and back to root.

  > Note:	To login as root, use `su` or `su -`. The name "root" is not necessary.

Practice with the su command. Try using it to connect to various accounts on the system - with and without an environment (meaning with the `-` and without it).

👍 **Fantastic!** 👍

---

## 📃 Extra Credit

Learn more about the `su` command:

`su --help`

`man su`

Note that the `su -` command can also be done with the older `su -login` or `su -l` commands. You will find several other options as well. Read through them and test them out!

---

## 🎚️ Take it to the Next Level!

It's best to log in to systems with a regular user account. Then, if root is needed, access it with `su` or `su -`. 

Question: What path with you be working in if you execute the `su -` command successfully?

Answer can be found [here](../../z-more-stuff/next-level-answers.md#lab-07).