# vagrant-tutorial-4

This tutorial only demonstrates the meaning of the following line:
```ruby
  config.vm.network "private_network", ip: "192.168.50.4"
```

As expected, the above line creates a private network on the host machine that is visible only to
the host machine and no outside machine.
So you can directly access [http://192.168.50.4/index.html](http://192.168.50.4/index.html) instead of the forwarded port.

A bonus feature here is that **the VM can also access Host machine by replacing the last octet of the static-ip with 1**.

```bash
$ ping 192.168.50.4
# PING 192.168.50.4 (192.168.50.4): 56 data bytes
# 64 bytes from 192.168.50.4: icmp_seq=0 ttl=64 time=0.317 ms
# 64 bytes from 192.168.50.4: icmp_seq=1 ttl=64 time=0.565 ms

$ vagrant ssh
# Welcome to Ubuntu 12.04 LTS (GNU/Linux 3.2.0-23-generic x86_64)

$ ping 192.168.50.1
# PING 192.168.50.1 (192.168.50.1) 56(84) bytes of data.
# 64 bytes from 192.168.50.1: icmp_req=1 ttl=64 time=0.194 ms
# 64 bytes from 192.168.50.1: icmp_req=2 ttl=64 time=0.289 ms
```

Besides private-networking, Vagrant supports public-networking too.

See [https://www.vagrantup.com/docs/networking/](https://www.vagrantup.com/docs/networking/) for more details.


# Run as
```bash
vagrant up
vagrant provision
```
