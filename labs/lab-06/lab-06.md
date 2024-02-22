# Lab 06 - Locking the System ⚙️

In this lab we will:

- Show how to lock the system
- Set screensaver and suspend timeouts

## 🔒 Using the Keyboard to Lock the System

As a security precaution, users should lock their systems if they walk away from them for any length of time. To do so, issue the following keyboard shortcut:

`Windows + L`

Try that now.

> Note: remember that the Windows key on a PC-based keyboard is known as the "superuser" key when working in Linux. Also, if you have Linux running as a virtual machine on macOS, the Windows/superuser key is the Command key.

This locks the system. If the user wants to use the system again, the user account password will have to be issued.

> Note: You might have to press the `Esc` key to reactivate the display if you are working in a virtual machine.

This increases user security in that other people will not be able to log in to the system unless they know a user password. I say "a" user password because it is possible to login as *other* users when the system is locked. This can be done by clicking the multi-user icon at the bottom-right of the screen ( in GNOME).

> Note: If another user account is logged in, the original one that was locked will still be running in memory, and can be returned to as long as the system is not restarted (or that user is not logged off remotely).

## Locking  the System in the GUI

- Click on the Power Button icon in the User Menu in the upper-right of the screen (in GNOME)
- Click the padlock
- When finished, unlock as shown previously

## Power Options

You can also set Linux to use a screen saver or to suspend after a certain period of inactivity. Both of these will lock the system.

### Screen Saver

The screen saver will disable the display (thus "saving" your monitor). It also locks the computer. You can set it to 1 minute or more in the GNOME desktop.

Try setting it to 1 minute now!

- Open GNOME Settings
- Go to **Power**
- Click on **Screen Blank**
- Select **1 minute**

Make sure that the Linux system is inactive and wait 1 minute. The screensaver should turn on and the system should lock.

To exit the screen saver, press any key or click the mouse. At this point the user is required to type the password to regain access to the computer.

> **IMPORTANT!** Train your users to use setup an automatic screensaver/lock to a reasonable amount of time - for example, no more than 10 minutes. Also educate your users to lock their computer at any time when they will be away from the system. User awareness and user education are extremely important when it comes to computer security.

### Automatic Suspend

Suspend mode is when the computer is paused. It is also known as Sleep, Standby, or hibernation. In this mode, the current state of the system is saved to RAM and power is cut to all other devices. This reduces power usage and locks the computer as well.

> Note: This feature will only work if the underlying hardware supports it. In addition, virtual machines may have some issues with this, but it is not usually necessary to set a VM to suspend.

If you have a physical system running Linux try setting Automatic Suspend now. It can be found in the same location as Screen Blank within **Settings > Power**.

---
Ω That completes the lab! When you are done remember to change all settings back to normal. This is especially for virtual machines in a lab/learning environment as Screen Blank and Automatic Suspend can be more frustrating than useful.

👍 **Feeling Sleepy? Take a quick break, then come back for more!** 👍

---

## 📃 Extra Credit

There are several system sleep states that are defined in more depth [here](<https://www.kernel.org/doc/html/v4.18/admin-guide/pm/sleep-states.html>).

Take some time reading through them!

---

## 🎚️ Take it to the Next Level!

You can also select different power modes in **Settings > Power**.

Question: What is the difference between "Balanced" and "Power Saver" mode?

Answer can be found [here](../../z-more-stuff/next-level-answers.md#lab-06).