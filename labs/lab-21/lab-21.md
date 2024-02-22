# Lab 21 - SELinux Basics ⚙️

Security-Enhanced Linux (or SELinux for short) is a security architecture for Linux systems that allows administrators to have more control over what and who can access the system. It works directly with the Linux kernel using Linux Security Modules (LSM).

In this lab we will:

- Analyze SELinux on a CentOS system.
- Manage SELinux with a new SSH Configuration.
- Modify the Enabled SELinux mode.

> Note: For this lab I will be working on a CentOS 9 server system as root.

## Analyze SELinux on a CentOS System

First, let's see if SELinux is running:

`sestatus`

Here are example results. Take a minute to review them:

```console
[root@centos-9-server ~]# sestatus
SELinux status:                 enabled
SELinuxfs mount:                /sys/fs/selinux
SELinux root directory:         /etc/selinux
Loaded policy name:             targeted
Current mode:                   enforcing
Mode from config file:          enforcing
Policy MLS status:              enabled
Policy deny_unknown status:     allowed
Memory protection checking:     actual (secure)
Max kernel policy version:      33
```

You will note that SELinux is *enabled* and is *enforcing*. This means that it is running and enforcing its security policies. This is the default for Fedora, RHEL, and CentOS.

> **IMPORTANT!** In most cases you want to have SELinux enabled and enforcing! Software or services that ask you to disable it should be approached with caution.

You can also check if the system is enforcing policies with this command:

`getenforce`

Take note of the SELinux file system mount and SELinux root directory. These locations allow for configuration to SELinux.

## Manage SELinux with a new SSH Configuration

If you make changes to an SELinux-protected system, then you need to notify SELinux of those changes. Here we will modify the default inbound SSH port and notify SELinux of the new port assignment.

Let's take a look at our SSH server configuration:

`vim /etc/ssh/sshd_config`

Now, let's go ahead and change the default port number line item.

From this: `#Port 22`

To this: `Port 2222` and save the file.

This change won't have any meaning unless we do three things:

1. Restart the SSH server.
2. Use the `semanage` command to tell SELinux of the new port assignment.
3. Open the port on the firewall.

Let's perform those actions now:

**Restart the SSH server**

`systemctl restart sshd`

**Use `semanage` to tell SELinux about the change**

`semanage port -a -t ssh_port_t -p tcp 2222`

**Open port 2222 on the firewall**

`firewall-cmd --add-port=2222/tcp --permanent`

`firewall-cmd --reload`

> Note: This assumes that the system is running firewalld (which is the default for CentOS server). Check it with `systemctl status firewalld`. 

Try connecting via SSH from another system. For example:

`ssh user@10.0.2.63 -p 2222`

It should work!

## Modify the Enabled SELinux Mode

In some rare cases, you might need to reduce the SELinux restrictions - perhaps temporarily. To do so, issue one of the following commands:

`setenforce permissive`

`setenforce 0`

Now, issue the `getenforce` command. This should show that SELinux is running in Permissive mode. SELinux isn't really "disabled" so to speak. It is still running, but not blocking anything. This works well for testing and for educational purposes.

However, if you restart the system, SELinux will go back to Enforcing mode automatically.

To enable enforcing mode again issue one of the following commands:

`setenforce enforcing`

or

`setenforce 1`

> Note: In the rare case that you need to *actually* disable SELinux you can do it by accessing `/etc/sysconfig/selinux` and change `SELINUX=enforcing` to `SELINUX=disabled`. It's important to know that this is not normally recommended, and could cause damage to the Linux system which might not be recoverable if you wish to use SELinux in the future.

👍 **We're just getting warmed up! Keep going!** 👍

---

## 📃 Extra Credit

Learn more about SELinux:

`man selinux`

[CentOS Wiki](<https://wiki.centos.org/HowTos(2f)SELinux.html>)

[Mastering SELinux Video Course](<https://learning.oreilly.com/course/mastering-security-enhanced-linux/9780138282691/>)
