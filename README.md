# smb-over-ssh
Smb-over-ssh is an option if you wish to spin up a relatively secure and functional by default Samba share over SSH.  

Why on earth would you want to do this?  Well one of the things that can be accomplished with this is remote Time Machine backups if you follow [this pdf](/docs/TimeMachine-to-smb/12aP37Bo5ShsTeuxhVdN.html) to a degree you can get this working with some SSH tunnel magic.

## Instructions

#### Step 0
Prerequisites this guide assumes you know what docker-compose, docker, and git are and that you're planning on running this from a OSX client to any target that can host Docker on it with an x64 based CPU.

Understand that I tried this to see if it would be a viable option for my needs and it turns out to be slower than I need so I likely won't be continuing the project, however due to the nature of Docker itself this should work consistently into the future and I did test and get it running.

#### Step 1: Git clone [Target Server Side]
On your target Docker & docker-compose equipped server run the following git clone command.
```BASH
cd ~/ && git clone https://github.com/Leopere/smb-over-ssh.git
```


#### Step 2: prepare your local ssh client [OS X Client Side]

Run the following on your local OS X machine.

```BASH
echo -e 'y/n' |ssh-keygen -t ed25519 -C "computer@smb-over-ssh" -q -f ~/.ssh/smb-over-ssh -N "" && cat ~/.ssh/smb-over-ssh.pub |pbcopy && ssh-add ~/.ssh/smb-over-ssh
```
on your mac and paste the public key that you will have had automagically copied into your clipboard somewhere easily accessible for a moment.

#### Step 3: paste your generated SSH key into your server [Target Server Side]

Paste your key into the target server pasting your key into the target.  I took the liberty to add `pbcopy` into the last step so your key should be already in your clipboard.  If you lost it you can run `open ~/.ssh/smb-over-ssh.pub` and copy it from there.
```BASH
echo "YOURKEY HERE" >> ~/smb-over-ssh/ssh/authorized_keys
```

#### Step 4: finish configuring ssh [OS X Client Side]
Run `open ~/.ssh/config` and add while also replacing `www.REPLACEME.com` with the IP address or domain name of your target server.  If you don't know what this IP address is this guide won't tell you how.

```BASH
##################
## Time Machine ##
##################
Host www.REPLACEME.com
        user root
        IdentityFile ~/.ssh/smb-over-ssh
        LocalForward 60445 localhost:445
        Port 22445
```

#### Step 5: start your ssh connection [OS X Client Side]
`ssh www.REPLACEME.com sleep 60` This opens up the tunnel to the target server and remains open for 60 seconds of inactivity.  If you don't use the connection it will just die off and go away.  Feel free to remove the `sleep 60` if you want different behavior.

#### Step 6: Run through the suggestions in the included PDF [OS X Client Side]
[This guide](/docs/TimeMachine-to-smb/12aP37Bo5ShsTeuxhVdN.html) is not specifically for this but it will get you to a destination where you can time machine backup to your target server.  

Otherwise theres really no restriction to what you can do with this guest user access with read/write permissions Samba share.  You'd imagine guest access with read write would sound dangerous however you cannot access this Samba share without using SSH keys so that's been proven as pretty bullet resistant so I figured keep it simple.
