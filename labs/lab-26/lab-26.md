# Lab 26 - Using Keys to Connect via SSH ⚙️

SSH is a heavily used tool. However, it is vulnerable (like everything else). This section describes how to secure an SSH connection with cryptographic keys.

I'll be working on the following:

- SSH Server - Debian Server - 10.0.2.51
- SSH Client - Debian Client - 10.0.2.52

## SSH Key Basics

In this lab we'll build an SSH key on a Debian client (as a typical user), distribute it to a Debian server, and then SSH into that server from the client using the key we just made.

To SSH into a system using a key, you actually need to create a key *pair*. The first key is called a private key and it resides at the computer where the key pair is built. The second key is called a public key, and it resides at the SSH server, meaning the remote computer that will be connected to.

When you attempt to SSH into the remote system, that system presents its public key. If it matches the private key stored at the local computer, then the connection is allowed. If it doesn't match (for example, a rogue or malicious system) then the connection will be denied.

## Create a strong RSA-based key pair

To create an SSH key pair, login to the client as a typical user, and type the following:

`ssh-keygen -b 8192`

> Note: As of the writing of this lab, omitting the `-b 8192` option would result in a default 3072-bit RSA key. We are going for something stronger here!

When it prompts you, press enter to save the key pair to the default location. It's also highly recommended to select and confirm a complex passphrase to protect the key pair.  

**DANGER** 

Pressing enter for a blank passphrase is insecure. For added security, use a passphrase. The more length and complexity the better. This protects the key pair that you have created. Think about it: If someone was to gain access to your computer (internally or externally), and more importantly to your user account, then that person could potentially gain access to all the systems that you would normally access via SSH.

### View the SSH key pair

The key pair is saved in a hidden directory. Type `ls -a` to see it. The directory name is .ssh. Access that directory: `cd .ssh`. Then type `ls` to view the contents. The procedure should be similar to the following:

```console
user@deb52:~$ cd .ssh
user@deb52:~/.ssh$ ls
id_rsa  id_rsa.pub  known_hosts
user@deb52:~/.ssh$ 
```

You can see three files inside of .ssh: id_rsa (which is the private key), id_rsa.pub (which is the public key to be copied to remote hosts), and known_hosts, which contains the list of known hosts that you have connected to in the past.

> Note: Remember to use different names/directories when creating subsequent keys.

## Create an ed25519-based key pair

If I can, I will use ed-25519 key pairs. This can be done by using the `-t` option:

`ssh-keygen -t ed25519`

Try it now. Use the default location and no passphrase. It should store a key pair in your ~/.ssh directory based on the `id_ed25519` name. Now you have an RSA key pair and an ed25519 key pair.

Let's use the ed25519 key for our connection to the server.

## Copy the public key to a remote host

Now that our key pair is created, we can copy the public key of our key pair to a remote host. In this lab the key will be copied to a Debian server, making use of the user account that exists there. We will do a couple of things in this command:

- Use the `ssh-copy-id` command
- Specify the location and name of the key, which is `~/.ssh/id_ed25519`, using the `-i` option.
- Tell SSH the name of the user and computer we want to copy the key to.

`ssh-copy-id -i "~/.ssh/id_ed25519" user@10.0.2.51`

You will be required to type the password of the user account at the remote computer, but otherwise, that's it. You don't have to specify a directory, it will copy it to the default .ssh directory in the user accounts home directory. Just make sure that the results show that 1 key was added.

> Note: If we had not specified the name of the key, then the command would copy **all** keys from the .ssh directory to the remote host. That would mean it would copy the RSA and the ed25519 keys. which we do not want.

### SSH into the remote host

Now, we can SSH into the remote host to take control of it using the ed25519 SSH key.

> Note: In this case, we have to specify the exact key. If the ed25519 key was the only key in the directory, the `-i` parameter below would not be necessary.

`ssh -i "~/.ssh/id_ed25519" user@10.0.2.51`

That's it. Now we are logged in using SSH keys. This way, we don't have to send a user's password over the network, and instead rely on the much more secure SSH key process.

To make things easier, let's remove the RSA key with the following command:

`rm ~/.ssh/id_r*`

That should remove the RSA key pair. Now, to connect in the future, we can omit the `-i` option.

👍 **Excellent ^** 👍

---

## 📃 Extra Credit

For more information, consider the following sources:

`man ed25519`

`man RSA`

---
