# Lab 18 - AppArmor Basics ⚙️

AppArmor is a Linux Security Module that is used primarily in Debian and Ubuntu systems. It is designed to help protect the applications that you run on your server.

In this lab we will:

- Display AppArmor status
- View AppArmor profiles
- Disable and enable AppArmor

Check to see if you have AppArmor (and associated utilities) installed with the following command:

`sudo apt-get list | grep "apparmor"`

If you don't have AppArmor, you can install it, along with additional tools:

```console
sudo apt install apparmor apparmor-utils apparmor-notify apparmor-profiles apparmor-profiles-extra
```

> Note: if you are working in Debian 12 or higher these should be installed automatically.

## Display AppArmor Status

- First, let's check if AppArmor is running:

  `sudo apt policy apparmor`

- Next, let's check the main AppArmor service:

  `sudo systemctl status apparmor`

  It should show as `active (exited)` and `enabled`. If not, run the following command:

  `sudo systemctl --now enable apparmor`

  Verify that it is started with another `sudo systemctl status apparmor` command.

- Next, use an AppArmor command to see if it is enabled:

  `aa-enabled`

  The response should simply be `Yes`.

  These are the most important commands because the most important thing about AppArmor is that it ***runs***. You can configure it as much as you want, but it protects many applications without any configuration at all.

- Now, let's check the status of the AppArmor program:

  `sudo aa-status`

  This command should show you that the AppArmor module is loaded and that a number of profiles and processes are in enforce mode. Take a minute to read through your results.

  > Note: See [this file](profile-list-aa-status.md) for an example from my Debian 12 client system.

  Regardless of whether you are working on a Debian client, Debian server, Ubuntu server, or Ubuntu Workstation, you should see that one of the profiles listed in "enforce mode" is `/usr/bin/man`. This means that the Manual Pages program (`man`) is being protected by AppArmor.

  AppArmor helps to protect this application by disallowing any connections from other applications loaded on the system - that is, except for the ones that need to access it. For example, you should be able to read manual pages by executing the `man <manual_page>` command from the terminal. Therefore, the terminal is allowed to communicate with `/usr/bin/man`. However, other third-party applications should not be allowed to read or write to the `man` program.

## Disable and Enable AppArmor

Sometimes, AppArmor might cause issues with your system. It's not recommended to disable it permanently, but sometimes you might want to stop it temporarily to do some testing.

- To stop AppArmor, run the following command:

  `sudo systemctl stop apparmor`

  That will stop AppArmor from functioning until you reboot the computer.

- To stop and disable it fully (and persistently) use:

  `sudo systemctl --now disable apparmor`

  Then, restart the system.

- Next, issue the `sudo aa-status` command. You should see that the apparmor module is loaded but no other information.

  The service is stopped, and therefore it isn't enforcing any protection. As mentioned, this isn't normally a good idea, so let's start it and enable it once again.

  `sudo systemctl --now enable apparmor`

  And restart the system.

- Check it with `systemctl status apparmor` and make sure that the profiles are loaded and in enforce mode once again.

👍 **This is just the beginning. Enjoy the world of Linux Security!** 👍

---

## 📃 Extra Credit

Learn more about apparmor:

`man apparmor`

[Debian Link to AppArmor](<https://wiki.debian.org/AppArmor/HowToUse>)

---
