#!/bin/ash
## Example base code from: https://docs.docker.com/config/containers/multi-service_container/

# generate host keys if not present
ssh-keygen -A
/usr/sbin/sshd -e
smbd --no-process-group --foreground --log-stdout
