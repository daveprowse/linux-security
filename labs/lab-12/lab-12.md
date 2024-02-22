# Lab 12 - More apt and Repositories ⚙️

In this lab we'll work more with the `apt` command and demonstrate how to access and modify repositories in a Debian-based system.

## Clean Up

This is fairly easy. First, delete extra files in the /var directory with this command:

`apt clean`

Next, remove any unused or unnecessary packages:

`apt autoremove`

This will most likely remove a lot of unused packages. When it is finished, run an `apt udpate` to make sure that there are no additional updates that are required.

Lastly, you should know how to update the OS from one point release to the next and from one version to the next.

## Update the System

- To update the point release, first check the current version and point release. Here's an example in Debian:

```console
dpro@nw1:~$ cat /etc/debian_version 
12.4
```

The file "debian_version" simply tells us the version and release. But it is important because it shows that point release number (or minor release), whereas commands such as `hostnamectl` will only show the main version number.

`apt update && apt upgrade` will normally update the system to the latest point release (for example, from 12.4 to 12.5). it will also install any and all security updates (which is what we are really interested in).

- To update from one version to another, the command `apt full-upgrade` can be used. But use caution, this is a major upgrade, and as such, it could cause system instability based on your hardware and software. It is best to run this on a test system first and document the results carefully. You will also want to backup your data, and so several checks before starting a full upgrade. For an example of a complete step-by-step procedure, see [this link](<https://www.debian.org/releases/bookworm/amd64/release-notes/ch-upgrading.en.html>).

## Working with Repositories

Repositories are the hyperlinked locations that Linux will look to for updatable files and programs.

Take a look at the standard repository list in Debian with the following command:

`cat /etc/apt/sources.list`

You will see several line items that start with "deb" and continue with a hyperlink and then other options. For example:

```console
dpro@nw1:~$ cat /etc/apt/sources.list
#deb cdrom:[Debian GNU/Linux 12.4.0 _Bookworm_ - Official amd64 NETINST with firmware 20231210-17:56]/ bookworm main non-free-firmware

deb http://deb.debian.org/debian/ bookworm main non-free-firmware contrib non-free
deb-src http://deb.debian.org/debian/ bookworm main non-free-firmware contrib non-free

deb http://security.debian.org/debian-security bookworm-security main non-free-firmware contrib non-free
deb-src http://security.debian.org/debian-security bookworm-security main non-free-firmware contrib non-free

# bookworm-updates, to get updates before a point release is made;
# see https://www.debian.org/doc/manuals/debian-reference/ch02.en.html#_updates_and_backports
deb http://deb.debian.org/debian/ bookworm-updates main non-free-firmware contrib non-free
deb-src http://deb.debian.org/debian/ bookworm-updates main non-free-firmware contrib non-free

# This system was installed using small removable media
# (e.g. netinst, live or single CD). The matching "deb cdrom"
# entries were disabled at the end of the installation process.
# For information about how to configure apt package sources,
# see the sources.list(5) manual.
```

Each line item that starts with "deb" is a link to a repository location. Debian will search each of those links for any available updates when you run the `apt update` command.

> Note: The above example shows one of my Debian client systems. In this scenario we have added "non-free" options. In some cases this can be a security risk. For servers especially, it is not recommended to add: contrib and non-free, as these extra repositories could contain software that might have vulnerabilities or could cause a server to malfunction.

You can add repositories if you wish, but `/etc/apt/sources.list` is the not the recommended location for third-party repositories. 

Instead, use the supplied `sources.list.d` directory within `/etc/apt`. There you can add repositories as `<repository_name>.list`. In fact, that is what third-party programs will do automatically to be able to install their software. (That is, if you allow it!)

## Repository Tools

While you can modify the repository sources list manually, a better way is to use external tools. Here are two examples:

- Use the `apt edit-sources` command to edit the main apt repository file directly.
- Use the `add-apt-repository` command to add additional repositories.
  - Example 1: `add-apt-repository deb <hyperlink>`
  - Example 2: `add-apt-repository ppa:<user>/<ppa_name>`

Try these on your system!

👍 **Good job. Keep going!** 👍

---

## 📃 Extra Credit

Learn more about the `sources.list` file:

`man sources.list`

---
