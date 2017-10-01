# Tunnel Broker IPv6 service
This directory contains an OpenRC service script for the tunnel broker IPv6 service, as well as the source code and Alpine binary build of `tb_userspace`.

## Tunnel Broker Userland Program
To run the service in "user" mode, you will need to build `tb_userspace`, which is a tiny program that uses TUN to provide IPv6 tunnel. To build, strip and then install the program:

```sh
# Build program
cc -O3 -o tb_userspace tb_userspace.c -lpthread
strip tb_userspace
# Install program
install tb_userspace /usr/local/bin
```

## Install Service Script and Configuration
To install the service script and configuration, run the following command:

```sh
# Install service script
install tb-ipv6.sh /etc/init.d/tb-ipv6
# Install service configuration
install tb-ipv6.conf /etc/conf.d/tb-ipv6
```

## License
[GNU GPLv3](LICENSE)
