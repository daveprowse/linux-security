# Lab 01 - User ID ⚙️

Welcome to our first lab! Remember, these lab documents are designed to accompany the corresponding videos in the *Linux Security - For Beginners and Beyond* video course.

## Boot your Linux System

Start up one of your Linux systems now. I'll be demonstrating on a Debian Linux client, but just about any Linux system will do.

## Access the Terminal

Open a terminal. (I'll be using the gnome-terminal.)

- If you are on a proper server (command-line only) then you are already in the terminal (or console if you will). Log in.
- If you are working at a Linux "client" (meaning one with a desktop environment) then do the following:
  - Press the superuser key (the Windows key), or click on "Activities".
  - Type "terminal" into the search field and press `enter`.
- You should see the prompt which is awaiting your command! For example:

```console
user@deb-client:~$
```

---

> Note: to learn more about basic usage of the Linux Terminal and basic Linux commands see these videos on O'Reilly:

- 1.6 (link coming soon)
- 1.7 (link coming soon)

---

## Use the `id` Command

Type the following command: `id`

You should see results similar to the following:

```console
user@deb-client:~$ id
uid=1000(user) gid=1000(user) groups=1000(user),24(cdrom),25(floppy),27(sudo),29(audio),30(dip),44(video),46(plugdev),100(users),106(netdev),111(bluetooth),113(lpadmin),116(scanner)
```

This command shows identifying information for the current user including what groups the user is a member of. For example:

- The user ID is 1000
- The group ID is also 1000

These are set up automatically by Linux when the user is created.

In the example above, we also see `27(sudo)`. This means that this user is part of the sudo group, which gives the user administrative privileges.

> Note: "sudo" is the name used by Debian, Ubuntu, and Debian derivatives. If you are working on a CentOS, RHEL, or Fedora system, the equivalent would be "wheel".

## Using `sudo` to Execute Administrative Commands

If the user has the "sudo" or "wheel" group listed, then that user can issue administrative commands. To do so, precede the command in question with the "sudo" command. For example:

`sudo systemctl status NetworkManager`

By issuing sudo before the command we are allowed to see the journal files (log) for the NetworkManager service. Without it, we would most likely have the journal files omitted. 

Now, if the user account does not show "sudo" or "wheel" when you issue the `id` command, then that account cannot execute any administrative commands at all. We'll show how to give administrative permissions to users later on in this course. 

> Note: If you are logged in as root, then you would see something similar to the following when you issue the `id` command:

```console
root@deb-client:~# id
uid=0(root) gid=0(root) groups=0(root)
```

> Root is considered to be "0" - the superuser. It has access to everything. Be careful when working as root!

## Use `id` to learn about any User

You can issue the `id` command and then the name of any user to find out more information about them. For example:

`id user` or `id user2`, `id root` etc...

This way, you can find out identifying information about other users easily.

---

*That was an easy lab, but don't worry, we're going to raise the complexity level soon!*

👍 **GREAT WORK!!** 👍

---

## 📃 Extra Credit

> Note: All Extra Credit assignments are optional!

Learn more about the `id` command! Issue the following commands in the terminal.

`id --help`

`man id`

---

**Remember, if you have any questions, contact me at:**

- My website: [link](https://prowse.tech)

   or

- My Discord server: [link](https://discord.gg/mggw8VGzUp)

---
