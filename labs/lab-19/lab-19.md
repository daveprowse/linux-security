# Lab 19 - AppArmor Profiles ⚙️

In this lab we will:

- Create an AppArmor profile
- Analyze the profile
- Show Enforce and Complain modes
- Disable and remove an AppArmor profile

> Note: For this lab I will be working on a Debian 12 client system as root. If you decide to work as another user, make sure that the user account has sudo permissions and use the `sudo` command before any administrative commands.

## Install Required Applications

To create profiles with AppArmor you need to make sure that the AppArmor Utilities and the auditd programs are installed.

- Issue the following command:

  `apt install apparmor-utils auditd`

- Verify that everything is up and running:

  `systemctl status appamror`

  `systemctl status auditd`

## Copy an Application

For this exercise I'll be copying the Manual Pages binary (`man`) to another location and renaming it. We'll create an AppArmor profile based on that new program.

- Copy the `man` program

  `cp /usr/bin/man /usr/local/bin/human`

  So we copied the `man` program to the `/usr/local/bin` path and renamed the program `human`.

- Access that path:

  `cd /usr/local/bin`

> Note: Consider running two terminals (or split your current terminal). Have both set to work in the `/usr/local/bin` directory.

- In a second terminal, make sure you can use the new application.

  `human ls`

  This should bring up the man page for the `ls` command. Press `q` to quit.

## Create an AppArmor Profile

- In the first terminal, type the following command:

  `aa-genprof human`

  That should begin the generation process.

- In the second terminal, access the `human` program:

  `human ping`

  That brings up the manual page for the `ping` command. Press `q` to quit. We are simply trying to have the system log the process of using the `human` program and allow AppArmor to see that logged information.

- In the first terminal press `S` to begin scanning the log for events.

  You will be presented with a lot of log entries that you must answer.

  - For the first set, press capital `I` for inherit to inherit profile information from AppArmor for each one. There may be eight or so.
  - For the second set, press capital `A` to allow access for each one. There can be more than a dozen
  
  > Note: There are several ways to approach this, and often you would deny one or more options, or use Globbing. However, for this lab we will simply accept everything.

- Press `S` to save the configuration.
- Press `F` to finish. That should return you to the Bash shell.

## Verify Application Functionality

In the second terminal, see if you can still use the application:

`human ping`

It should still function, but as you can see from the lab, there are a lot of ways that it could be blocked - not only from a user-perspective, but from a machine-perspective.

## Analyze the AppArmor Profile

- Check the status of the AppArmor profiles:

  `aa-status | less`

  You should see the line item: `/usr/local/bin/human` in the list of "enforced" profiles.

- View the actual profiles:

  `cd /etc/apparmor.d` and `ls`

  You should see the list of profiles, including the one that we just created `usr.local.bin.human`

  View the details of one: `vim usr.local.bin.human`

## Modify a Profile's Mode

You can change a profile's mode from complain to enforce, or vice versa with the `aa-enforce` and `aa-complain` commands respectively.

To do this, you need to know the actual name of the profile, which is listed in `/etc/apparmor.d/<profile_name>`

For example, to change a profile to "enforce" mode:

`aa-enforce usr.local.bin.human`

Or, to set it to complain so you can track what the application is doing:

`aa-complain usr.local.bin.human`

> Note: You can see that the slashes (`/`) are replaced with dots `(.)`

Run `aa-status` to see which are in enforce mode and which are in complain mode.

## Disable and Remove Profiles

To disable a profile, use the `aa-disable` command. For example:

`aa-disable usr.local.bin.human`

Check it with `aa-status`. It should not be listed as a profile in either the enforce or complain categories.

However, the profile still exists. It is still listed in `/etc/apparmor.d` and now within `/etc/apparmor.d/disable` To re-enable it, use one of the following:

`aa-enforce usr.local.bin.human`

or

`aa-complain usr.local.bin.human`

To remove a profile altogether, first disable it, then delete the file from the `/etc/apparmor.d` directory.

`aa-disable usr.local.bin.human`

and

`rm /etc/apparmor.d/usr.local.bin.human`

> Note: You can also remove the entry from the `disable` directory.

There is plenty more that we can accomplish with AppArmor. Keep in mind that there are lots of documented profiles on the Internet. Check out the "Extra Credit" below for more information.

👍 **Fantastic work! You are doing great!** 👍

---

## 📃 Extra Credit

Learn more about apparmor commands. For example:

`man aa-status`

To see a list of all AppArmor commands, type `aa-` and press the tab key (perhaps twice). Check the manual page for each of them!

[AppArmor.net](<https://apparmor.net/>)

[Download AppArmor Profiles](<https://pkgs.org/download/apparmor-profiles>)

---
