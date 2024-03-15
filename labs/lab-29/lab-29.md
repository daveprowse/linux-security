# Lab 29 - File Permissions ⚙️

File permissions are an example of the balance of security that we spoke of earlier. Permissions that are too weak are a security risk. Permissions that are too strong might cause a lack of accessibility. So we have to find a happy medium.

This lab covers:

- `chmod` basics
- `chmod` permissions and configuration table
- Increased Security with `chmod`

> Note: I'll be working on a Debian client system in the account called `user` for this lab.

## chmod

### chmod Basics

`chmod` stands for “change file mode bits”, but what does that mean?

We use chmod to change the permissions of files. It changes the mode of the a by modifying the file mode bits associated with the file. Let's show how it works.

- In your home directory, create a working directory and access it:

  `mkdir work && cd work`

- Create a basic script:

  `vim test1.sh`

  Add a simple `echo` command to it, for example:

  ```bash
  #!/bin/bash

  echo "This is a test. This is only a test!"
  ```
  
  Save the file and close it.

- Try to run the file:

  `./test1.sh`

  It should not work. In fact, it will say "Permission denied". That is because the execute permission has not been set on it yet. (That's an example of the Principle of Least Privilege.) Let's analyze further.

- Check the default, current permissions on the file:

  `ls -l`

  You should see that the permissions are `-rw-r--r--`. This means that the user (owner) can read and write the file; everyone else can only read the file. But there is no `x` anywhere in that result. That proves it is not executable.

- Now, modify the permissions so that the file to make it executable

  `chmod +x test1.sh`

- Check the permissions again with `ls -l`

  Now, the permissions should be displayed as `-rwxr-xr-x`. The `x` means that the file is now executable. This is the equivalent of the number 755 if you are using octal representation of the permissions.

  > Note: You will also notice that the file is a color (often green) where it had no color before.

- Attempt to run the script once again:

  `./test1.sh`

  This time it should work and you should see the response:
  
  `This is a test. This is only a test!`  
  
  Excellent!

### chmod Permissions

Know that there are three types of permissions: Read, Write, and Execute. (r, w, and x respectively.)

These are applied to the three types of Linux entities: User, Group, and Other. Collectively these entities are known as UGO in Linux.

They can be applied as absolute permissions with built-in options (such as the `+x` option we used) or with the octal format.

Take a look at the following table for the breakdown of how the octal format works.

#### Table 29.1: Permission Values

| User     |  | Group    |  | Other     |  |
| -------- |--| -------- |--| ----------|--|
| Read     |4 | Read     |4 | Read      |4 |
| Write    |2 | Write    |2 | Write     |2 |
| Execute  |1 | Execute  |1 | Execute   |1 |

In our example, we set the test1.sh file to executable. The two main options for this are:

`chmod +x test1.sh`

or

`chmod 755 test1.sh`

Either way, an `ls -l` command would show the permissions for that file as:

`-rwxr-xr-x`

The first character tells you if it is a directory or not. A `d` means directory, and a (`-`) means it is a file. So this is a file.

Then, we have three sets of permissions: `rwx`, `r-x`, and `r-x`. Take a look at the table. These apply to User, Group, and Other, in order.

We can simply add the values to find out our octal permissions.

- `rwx` for User = 7
- `r-x` for Group = 5
- `r-x` for Other = 5

There you have it. 755 is the number.

> Note: for a chmod permissions calculator, see [this link](https://chmod-calculator.com/)

### Increased Security with chmod

You might want to increase the level of security for the file. For example, perhaps you do not want Group or Other to be able to execute the file. Only you, the User (owner) should be able to do so. Easily changed!

Take a look at the table again. The permissions we would want would now be:

`rwxr--r--`

Work out the math!

- `rwx` = 7
- `r--` = 4
- `r--` = 4

So the permissions would be 744. But you could go further. How about we give full access to User, but zero access to Group and Other. Easy, that would be 700.

Try it now. First make a copy of the file:

`cp test1.sh test2.sh`

> Note: You will see that the copied file inherits the same permissions as the source!

Now change the permissions for the second file.

`chmod 700 test2.sh`

Compare the permissions of each file with `ls -l`

Now run the new file: `./test2.sh`

It should function for you. But for other users, it will not. They won't even be able to read the file. Fantastic!

Finally, let's change both files to 744 at the same time:

`chmod 744 *`

And check it with `ls -l`. 

**Question**: What permissions are being handed out to the three entities of UGO?

**Answer**: User = rwx, Group = r, Other = r

👍 **Great Work! Continue!** 👍

---

## 📃 Extra Credit

Learn more about the `chmod` command:

`man chmod`

---

## 🎚️ Take it to the Next Level!

Question: You want to set relative permissions that will add the write permission for the group owner of a directory named `/test`. What command should you issue?

Answer can be found [here](../../z-more-stuff/next-level-answers.md#lab-29).