# Lab 30 - Ownership ⚙️

Now we'll get into the ownership side of things using the `chown` and `chgrp` commands.

This lab covers:

- Ownership basics
- `chown` and `chgrp` usage and fundamentals

> Note: I'll be working on a Debian client system in the account called `user` for the start of this lab (in `/home/user/work`). Later I will escalate to `root` and will work in a separate terminal for each account.

## Ownership Basics

We talked about assigning permissions to files. We mentioned how they can be assigned to the User, Group, or Other entities. The question is: Who (or what) is the owner?

Well, in Linux the answer is twofold. There is User Ownership and Group Ownership. Take a look at our file once again:

`ls -l`

You should see results similar to the following:

```console
-rw-r--r--  1 user user    0 Feb 22 10:19 test1.sh
```

In this case, the owner is `user`. That is obvious. But why? Well, when I created the account, I was logged in as `user`. Makes sense!

Now, why two sets of ownership? By default, a file created in Linux will have User ownership and Group ownership assigned to it - in that order. This allows groups of users to get access to a file or directory, with one user getting ownership that takes precedence over the group. If we were to run the `id` command, we would see something similar to the following:

```console
user@deb-client:~$ id
uid=1000(user) gid=1000(user) groups=1000(user),24(cdrom),25(floppy),27(sudo),29(audio),30(dip),44(video),46(plugdev),100(users),106(netdev),111(bluetooth),113(lpadmin),116(scanner)
```

The first two items: `uid=1000(user) gid=1000(user)` are the userID and the groupID for the user account. These are what are assigned to the User Owner and Group Owner settings by default when we create files or directories. That's why we see:

```console
-rw-r--r--  1 user user    0 Feb 22 10:19 test2.sh
```

The first `user` is for the User ownership. The second `user` is for the Group ownership. Is it always like this? No. Read on!

## chgrp and chown Usage

> Note: At this point we will start working as root. To stay in the same working environment (path, etc...) use the `su` command instead of `su -`.

Often, the ownership settings are the same, but they can be different if need be. For example, what if `user` was also a member of the group `ops`, along with several other users?  This is commonplace, so let's demonstrate the example:

- As root, create a new group named `ops`:

  `addgroup ops`

  In my system, the group was created with the Group ID 1001. So far so good!

- Add the `user` account to the group `ops`:

  `usermod -aG ops user`

- Now check the user account with `id user`. It should show the new group at the end: `1001(ops)` or a similar Group ID.

- Restart the computer and log back in as the user account. (This will ensure that the user is assigned the appropriate permissions.)

- Open two terminals: one as root and the other as the user account. Place both in the `/home/user/work` directory.
  
- In the root terminal, change the group ownership for the file `test1.sh`:

  `chgrp ops test1.sh`

  Check it with `ls -l`. You should see that the User ownership is still `user` but the Group ownership is now `ops`. At this point, other members of the `ops` group will be able to run the script (or will they?)

- Now, in the second terminal (as user). attempt to run the file once again:

  `./test1.sh`

  It should still work. That's because our `user` account has User ownership. And User was given `rwx` permissions in the previous lab.

- Next, in the root terminal, change User ownership to root for the test1.sh file.

  `chown root test1.sh`

  View it: `ls -l`. You should see the ownership listed as root (User) and ops (Group).

- Return to the user terminal and attempt to run the script. It should say `Permission denied`.

  Why? The user account no longer has User ownership. However, the user is part of the `ops` group which currently has group ownership. But... if you remember from the previous lab, the Group and Other permissions were set to 4. That means read access only. Let's change that!

- In the root terminal, modify the test1.sh permissions so that: User gets full permissions, Group gets execute permission, and Other gets no permissions. (Note, to give execute permissions, you must also give read permissions.) This would equate to 750, so the command would be:

  `chmod 750 test1.sh`

  Now access the user terminal and attempt to run the script. It should work! However, any other members will not be able to run the script, unless one of two things happens:

  - The script is run by a user who has been added to the `ops` group.
  - The script is run by root (who can run anything under the sun, regardless of the set permissions).

- Let's change ownership back to `user` for both the User and Group ownership. Instead of doing this with the `chown` and `chgrp` commands separately, it can be done at once with `chown` and utilizing a color `:`. Do this in the root terminal:

  `chown user:user test1.sh`

  Check it with `ls -l`

- Let's change the permissions back to something more normal:

  `chmod +x test1.sh`

  Remember, that gives the execute permission for all three entities of UGO.

  > Note: As you will see, this is not the same as `chmod 755`. The last command simply adds the execute permission. For even more "normal" permissions, use the actual command `chmod 755 test1.sh`. 

We could go on for days with this! Practice it!

👍 **Amazing!** 👍

---

## 📃 Extra Credit

Learn more about the `chown` and `chgrp` commands:

`man chown`

`man chgrp`

---

## 🎚️ Take it to the Next Level!

Practice the lab but add in two more users:

- user2 (who is added as a member of the `ops` group)
- user3 (who is not a member of the `ops` group, but is added to the `hackers` group.)

Play around with `chmod`, `chown`, and `chgrp`. Remember, that if you lock a user out of a file or directory, the root account has access to EVERYTHING and can always modify permissions and ownership settings. Good luck!
