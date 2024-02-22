# Lab 02 - Setting the Password ⚙️

In this lab we will show how to set the password in Linux - first, in the GUI, and later in the CLI.

## Changing the Password in the GUI

To modify the password in a Linux system with a Desktop (GUI) you can use the Settings feature.

> For this section we will demonstrate using the GNOME desktop.

### Open Settings

This can be done in several ways in Gnome. Here are a couple of options.

**From the User Menu:**

- At the top right of the screen you will see a power button icon. This is part of the Gnome Panel which stretches across the top of the screen. The right most area has the User Menu, Indicator Applet, and Notification Area. The power button is part of the User Menu.
- Click the power button icon to display the User Menu drop-down.
- Click the Settings Sprocket ⚙️. That opens the Settings Window

**Using the Search Feature:**

- Press the "Windows" key 🪟, which in Linux is known as the "Superuser" key. That should show all open apps in Gnome and display the Search field at the top of the screen. (If you are on a Mac, use the "Command" key.)
- Type "Settings" to search for the Settings program. Click it or press `enter` top open Settings.

### Modify the Password (in the GUI)

- Scroll down to **Users** and click it.  
- Click on "Password". This brings up the Change Password window.
- Type your current password and then select a new password and confirm it.

> Important: Be sure to select a lengthy and complex password - and remember it!

> Note: If you don't like the new password you can change it back to the old one in the next section!

## Changing the Password in the CLI

This course is designed with servers in mind. Because servers (normally) don't have a GUI, it is important to be able to navigate the system via the command-line interface (CLI).

### Access the Terminal

> I'll be using the gnome-terminal.

- Press the "Superuser" key and in the search field type "terminal". Select it to open.

> **Tech Tip**: You can add a keyboard shortcut to open the terminal in Settings > Keyboard > View and Customize Shortcuts > Custom Shortcuts. Name it "terminal" and use the command "gnome-terminal".I like to use `Ctrl + Alt + t`. It's a standard in Ubuntu, and I set it up on most other Linux distros.

> Note: We'll be using the terminal a **whole lot** so you may as well just keep it open!

### Modify the Password (in the CLI)

Type the following command:

`passwd`

That will access the terminal-based password program for your account. It should look similar to the following:

```console
user@deb-client:~$ passwd
Changing password for user.
Current password: 
```

Go ahead and change your password like we did before.

First, type the current one. Then, choose a new one (or your original password), and confirm it. Once confirmed, the program should end and you will be back at the Bash shell.

> Note: If something goes wrong while in the `passwd` program, press `Ctrl + D` to break out of it. Careful, that keyboard shortcut can also close out your terminal session.

---

That's it! Another lab well done. ❗Great work❗

---

For more information about the `passwd` command check out the following:

`passwd --help`

`man passwd`
