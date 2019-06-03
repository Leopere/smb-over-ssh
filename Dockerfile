FROM alpine:latest

LABEL MAINTAINER="leopere [at] nixc [dot] us"

RUN apk add --no-cache --no-progress --update openssh \
        samba-common-tools \
        samba-client \
        samba-server \
        screen \
        nano htop && \
    echo "root:root" |chpasswd && \
    sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/'; \
      's/UsePAM yes/# UsePAM yes/g'; \
      's/^#?PasswordAuthentication\s+.*/PasswordAuthentication no/g'; \
      's/^#?AllowTcpForwarding\s+.*/AllowTcpForwarding yes/g'; \
      's/^#?GatewayPorts\s+.*/GatewayPorts yes/g'; \
      's/^#?PermitTunnel\s+.*/PermitTunnel yes/g' /etc/ssh/sshd_config && \
    mkdir /root/.ssh

## Copy insecure samba config into container.
COPY smb.conf /etc/samba/smb.conf
COPY start.sh /usr/bin/start

EXPOSE 445/tcp 22

CMD ["/usr/bin/start"]
