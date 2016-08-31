# vagrant-tutorial-5

```ruby
Vagrant.configure(2) do |config|

  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  #config.omnibus.chef_version = '12.10.24'
  #config.vm.network "private_network", ip: "192.168.50.4"
  #config.vm.provision "chef_solo", run_list: ["my_chef_cookbook"]

  puts "Running 1"
  config.vm.define "vm1" do |vm1|
    vm1.vm.box = "vm1"
    vm1.vm.network "private_network", ip: "192.168.50.4"
    puts "Running 2"
  end

  puts "Running 3"
  config.vm.define "vm2" do |vm2|
    vm2.vm.box = "vm2"
    vm2.vm.network "private_network", ip: "192.168.50.5"
    puts "Running 4"
  end

  puts "Running 5"

end
```

The Vagrantfile above adds two vms - vm1 and vm2.

This is done due to the `config.vm.define` construct that behaves exactly like the `Vagrant.configure` construct.
It takes the name of the VM as an argument and a ruby-block (anonymous function for non-ruby devs) in which the
properties of the VM can be specified in exactly the same way as a `Vagrant.configure` does.


In the above example, we assign a private IP to each of the VMs.
Due to this, the Host and the VMs all know about each other's IP addresses.

```bash
vagrant up
# Running 1
# Running 3
# Running 5
# Running 2
# Running 4

vagrant status
# Current machine states:
# vm1                       running (virtualbox)
# vm2                       running (virtualbox)

ping 192.168.50.4
# PING 192.168.50.4 (192.168.50.4): 56 data bytes
# 64 bytes from 192.168.50.4: icmp_seq=0 ttl=64 time=0.315 ms
# 64 bytes from 192.168.50.4: icmp_seq=1 ttl=64 time=0.275 ms

ping 192.168.50.5
# PING 192.168.50.5 (192.168.50.5): 56 data bytes
# 64 bytes from 192.168.50.5: icmp_seq=0 ttl=64 time=5.114 ms
# 64 bytes from 192.168.50.5: icmp_seq=1 ttl=64 time=0.226 ms

vagrant ssh vm1
ping 192.168.50.5
# PING 192.168.50.5 (192.168.50.5) 56(84) bytes of data.
# 64 bytes from 192.168.50.5: icmp_req=1 ttl=64 time=0.460 ms
# 64 bytes from 192.168.50.5: icmp_req=2 ttl=64 time=0.232 ms

ping 192.168.50.1
# PING 192.168.50.1 (192.168.50.1) 56(84) bytes of data.
# 64 bytes from 192.168.50.1: icmp_req=1 ttl=64 time=0.235 ms
# 64 bytes from 192.168.50.1: icmp_req=2 ttl=64 time=1.87 ms
```


# Order of execution in the Vagrantfile

The blocks in the Vagrantfile are executed from the outside to the inside.

(See the puts commands above and their output).



# Inheritance

Another important aspect of the multi-VM Vagrantfile is that the inner blocks inherit values from
the outside blocks. So properties common to all VMs can be declared in the outside block once
and all the inner blocks will have them accessible. In the above case, any property define on `config.vm`
will be available on `vm1.vm` and `vm2.vm`
