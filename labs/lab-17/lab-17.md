# Lab 17 - Securing GRUB ⚙️

GRUB is the GRand Unified Boot Loader. We use it to manage the boot process in Linux. It is not the only boot loader, but it is the most commonly used one.

In this lab we'll:

- Show how to access the GRUB command line.
- Demonstrate how to configure a secure, hashed password for GRUB.

I'll be using a Debian 12 client to demonstrate during this lab and working as root.

## Accessing the GRUB Command Line

When you first boot Linux, you have the ability to access the GRUB command line by pressing `c`.

Try it now. It should display the GNU GRUB command line with a prompt similar to the following:

`grub>`

From here you can view information, make modifications, and so on. For example, try the following command:

`vbeinfo`

This will display all possible video configurations. You might notice that you can't scroll back. To be able to see older information that was displayed, use the following command:

`set pager=1`

Then try the `vbeinfo` command again. You will see that you now have the "MORE" option so you can use the arrow keys or pgup/pgdn keys to view the information.

Press the `Esc` key to exit GRUB and continue booting the system.

> Note: You can also press `e` to see some of the settings and/or make modifiations. When done, press `Esc` or `Ctrl+x` to escape out and boot.

## Secure GRUB with a Password

Did you notice anything interesting in the last procedure? If you said that there is no password on GRUB, you would be correct. Anyone who can turn on the computer physically can access the GRUB command line. Not quite secure, so let's add a password to GRUB.

- Connect as root.
- Go to the following directory: `cd /etc/grub.d`
- Take a look at the files inside.
- Now, let's modify the *40_custom* file.

  `vim 40_custom`

- At the end of the file, add the following:

  ```sh
  set superusers="<username>"
  password <username> <password>
  ```

  > Note: Modify `<username>` to whatever user account you want, just make sure that it has sudo permissions. Modify `<password>` to the password you would like to use.

  **IMPORTANT** The problem here is that the password is displayed in clear-text. We should avoid this if at all possible. To do so, we wil use PBKDF2 to encrypt and hash the password.

- Open a second terminal.
- Generate a PBKDF2 password:
  
  `grub-mkpasswd-pbkdf2`

- Select a password and confirm it.
- Now, copy the password to the *40_custom* file. It should look something like this when you are done:
  
  ```sh
  #!/bin/sh
  exec tail -n +3 $0
  # This file provides an easy way to add custom menu entries.  Simply type the
  # menu entries you want to add after this comment.  Be careful not to change
  # the 'exec tail' line above.

  set superusers="user" 
  password_pbkdf2 user grub.pbkdf2.sha512.10000.01288E036A79B9376F91FE12FA43BF20E4E2CC5617C80AE1BDC0B8CA06510043CE3B8CF5F88B06F5D9F202F8B51A8A2D00430290B730959E537FE9D7BBA09145.39C484C57818CA34E7B81E8F2BD8DAA35069F655624032E6F2E6EBCD3906A7E58E5151CF30F9B3BC1B03181524A5E904D98029C8B6ABCAAB0C1923A098CDED34
  ```
  
  Now, instead of using `password` we are using `password_pbkdf2`.
  Note the user name *user* after the modified password option `password_pbkdf2`

  > Note: Your encrypted password will look different.

- Update the GRUB configuration:

  `update-grub`

  Make sure that there are no errors.

  > Note: If you were working as a sudo user, you would type `sudo update-grub`.

- Reboot the system and immediately press `c` to access the GRUB terminal. It should now require the username and password of the account you allowed access in the *40_custom* file. Log in!

- Again, to exit GRUB, simply press the `Esc` key.

## GRUB Password for GRUB Menu Only

You might have noticed that the previous configuration requires the GRUB password whether you want to access the GRUB terminal or simply boot the system regularly. Most likely, you don't want the password requirement every time you boot, but only when you need to access the GRUB menu.

This can be accomplished by unrestricting access to the OS from the `/etc/grub.d/10_linux` file.

- Open the `10_linux` file.

  `vim /etc/grub.d/10_linux`

- Find the following line item:

  `CLASS="--class gnu-linux --class gnu --class os"`

  and add `--unrestricted` to it. The result should look like this:

  `CLASS="--class gnu-linux --class gnu --class os --unrestricted"`

- Save the file and update GRUB: `update-grub`
- Reboot, and test it. Make sure that the GRUB password is required to access the GRUB menu, but *is not* required to simply boot the system.

> Note: Remember, this lab is based on Debian 12. Other distros may behave slightly differently!

👍 **There you have it. Secured Grub! Your Way!** 👍

---

## 📃 Extra Credit

Learn more about modifying the resolution of a Debian server's terminal with Grub:

https://prowse.tech/changing-the-resolution-and-font-type-in-debian-server/

And check out the [GNU GRUB Manual](<https://www.gnu.org/software/grub/manual/grub/grub.html>).

---
