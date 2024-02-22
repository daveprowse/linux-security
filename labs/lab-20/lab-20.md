# Lab 20 - AppArmor and Apache Example ⚙️

Creating profiles is great but it is also wise to harness the power of others as well. You can find lots of well-written AppArmor profiles on the Internet and even tested ones that are available from the `apt` or `apt-get` package managers. The purpose of this lab is to use AppArmor to further protect Apache Web Server.

In this lab we will:

- Install Apache web server.
- Download and install an AppArmor profile for Apache.
- Install, enable, and enforce the profile.
- Analyze the Profile and the Apache web server.
- Disable and remove the profile.

> Note: For this lab I will be working on a Debian 12 server system as root.

## Install the Apache Web Server

Debian does not have this installed by default, so we will need to install it first.

`apt install apache2`

Now, we'll check if it is running:

`systemctl status apache2`

Finally, check the built-in website:

`curl http://127.0.0.1:80 | less`

You should see that it shows the Apache information at the beginning of the HTML.

> Note: Install the `curl` command if necessary: `apt install curl`.

## Install, Enable, and Enforce an AppArmor Profile for Apache

Install a "safe" Apache module (AppArmor profile):

`apt install libapache2-mod-apparmor`

Enable the Apache module:

`a2enmod apparmor`

Restart the Apache service:

`systemctl restart apache2`

Set the profile to enforce mode:

`aa-enforce usr.sbin.apache2`

## Analyze the Profile and Apache

Check that the new profile is being :

`aa-status`

You should see three line items for the Apache web server profile, similar to the following:

```console
apache2
apache2//DEFAULT_URI
apache2//HANDLING_UNTRUSTED_INPUT
```

The last line is the key. The module we installed for Apache has instructions on how to handle untrusted input. This can help to reduce injection attacks, cross-scripting attacks, and lateral attacks from other applications.

> Note: That is just one example of an AppArmor profile for Apache. There are lots of others available on the Internet. See the links in [Lab 19](../lab-19/lab-19.md#📃-extra-credit). Or, you could write your own!

Now, verify that you can still connect to the web server:

`curl http://127.0.0.1:80 | less`

You should be able to.

Next, note the location of the actual profile:

`/etc/apparmor.d/usr.sbin.apache2`

That is what we enabled and set to enforce mode previously.

## Disable and Remove the Profile

After you are done experimenting with the AppArmor profile, go ahead and disable it and remove it. We'll reverse engineer everything we did here so that nothing conflicts with future labs.

- Disable the AppArmor profile:

  `aa-disable usr.sbin.apache2`

  Check that the Apache profile items are removed with `aa-status`.

- Remove the profile:

  `rm /etc/apparmor.d/usr.sbin.apache2`

- Uninstall the Apache module:

  `apt purge libapache2-mod-apparmor`

  > Note: If you check `/etc/apparmor.d` you will see that the `apache.d` directory has now been removed as well. 

- Uninstall the Apache web server:

  `apt remove apache2`  (or `purge` if you wish)

That's it. At this point everything should be back to how it was before we started the lab.

👍 **Excellent!** 👍

---
