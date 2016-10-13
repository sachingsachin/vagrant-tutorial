# vagrant-tutorial-7

This example uses chef to install the following:

1. Java 8
2. Zookeeper
3. Solr-6 Cloud-Mode


# Running the example

```bash
vagrant up --provision

# Run this command
wget 192.168.50.11:8983/solr

# Or these two commands
vagrant ssh vm1
wget localhost:8983/solr

# You will get the same output as shown below:

# Reusing existing connection to localhost:8983.
# HTTP request sent, awaiting response... 200 OK
# Length: 13349 (13K) [text/html]
# Saving to: `solr'

100%[=============>] 13,349      --.-K/s   in 0s

# 21:43:11 (351 MB/s) - `solr' saved [13349/13349]`
```

# Documentation for the code

This example is the hardest to understand among all the previous examples.

There are several concepts which are very hard to get by, especially if you are not a ruby developer.

But I will try to make it easy for other developers and will explain all the problems I went through.


# Tip 1: Avoid using same variable-name.

[https://www.vagrantup.com/docs/vagrantfile/tips.html](https://www.vagrantup.com/docs/vagrantfile/tips.html) 
gives a small hint about this but this can be the hardest thing to understand.

Consider the following piece of Vagrantfile
```ruby
    for j in 1..num_of_vms do
        last_octet = j + 10
        json_attribs["vagrant_zk"]["server_list"].push("192.168.50.#{last_octet}")
    end

    # Define all the VMs
    (1..num_of_vms).each do |i|

        # VM configuration variables
        last_octet2 = i + 10

        # Define a VM. Each one will have all the recipes listed above
        config.vm.define "vm#{i}" do |vm|
            vm.vm.box = "vm#{i}"
            vm.vm.network "private_network", ip: "192.168.50.#{last_octet2}"
        end
    end
```

If you have the same loop variable in the two loops above, only the last of your VMs will have
a usable IP address and AFAIK, there is no warning/error message printed in the gigantic log
messages printed on the screen.

This would be a big surprise to folks new to chef but that is how it is.

Bottom-line: Make sure you do not re-use any variable-names at all.


# Tip 2: Debugging the node-attributes

The value you pass to chef.json remains the same for all the nodes !!

It does not matter what you do but that cannot change.

So how do you determine in the recipes what node you are working on?

To figure that out, you need to be able to print out the entire node's attributes.

[This discussion on StackOverflow](http://stackoverflow.com/questions/27441190/how-print-or-debug-chef-attributes) provides some hints on how to do the same.

This example uses:
```ruby
output="#{Chef::JSONCompat.to_json_pretty(node.to_hash)}"
file '/home/node.java.json' do
  content output
end
```

Looking at the node's attributes, it becomes easier to know what is going
wrong, especially for chef beginners.


# Tip 3: Caching downloads

Another very annoying problem is that for a multi-VM setup, chef downloads same resources
again and again for every VM. That makes it very time consuming.

To avoid this, there is a plugin called [vagrant-cachier](https://github.com/fgrehm/vagrant-cachier) 

Install it as:
```bash
vagrant plugin install vagrant-cachier
```

And then use it in your Vagrantfile as:
```ruby
   if Vagrant.has_plugin?("vagrant-cachier")
        # Configure cached packages to be shared between instances of the same base box.
        # More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
        config.cache.scope = :box
    end
```

It still doesn't prevent the downloads done by chef, but atleast the Vagrant ones are not duplicated.


# Tip 4: Zookeeper in replicated mode

As described [here](https://zookeeper.apache.org/doc/r3.1.2/zookeeperStarted.html#sc_RunningReplicatedZooKeeper),
this needs the following tasks:

1. Add server.`number`=`host`:2888:3888 entries to zoo.cfg.
   Example:
   
   ```
   server.1=zoo1:2888:3888
   server.2=zoo2:2888:3888
   server.3=zoo3:2888:3888
   ```
   
2. For each ZK-server, add `data-dir`/myid file which should correspond to the number in #1 above.

While the first one is easy to get because it is the same for all ZK nodes, second one is not so easy.
It is different for each ZK node and hence we get this by looking for the IP address present in `node[network].to_hash.to_s` in the list of ZK-servers populated by `Vagrantfile`. (Details in zookeeper/recipes/default.rb)


# Tip 5: Is Zookeeper up?

Try the following commands from the Host machine:
```bash
echo ruok | nc 192.168.50.11 2181
# imok
echo ruok | nc 192.168.50.12 2181
# imok
```
If you do not see `imok` returned by each one of the VMs, then it means something is wrong, even though you will see `Starting zookeeper ... STARTED` in the chef logs! How misleading!

To debug zookeeper failure to start up, login to the VM and edit the bin/zkServer.sh file.

Just before the STARTED echo, there is a java command that runs.

Echo that entire command before execution and you will have much more details on why ZK did not start.



# Tip 6: Does Zookeeper work even if you see imok?

`imok` only tells that the zookeeper node is running.

It does not inform whether the zookeeper has joined a cluster or not.

To do that, use the srvr command:
```bash
echo srvr | nc 192.168.50.11 2181
```

If it does not return a valid output, then:

```bash
vagrant ssh vm1
cd /home/zookeeper-3.4.9/
cat zookeeper.out
```

And you will see the following exception occuring every minute:
```
2016-10-13 05:07:29,310 [myid:1] - INFO  [QuorumPeer[myid=1]/0:0:0:0:0:0:0:0:2181:QuorumPeer$QuorumServer@149] - Resolved hostname: 192.168.50.12 to address: /192.168.50.12
2016-10-13 05:07:29,310 [myid:1] - INFO  [QuorumPeer[myid=1]/0:0:0:0:0:0:0:0:2181:FastLeaderElection@852] - Notification time out: 60000
2016-10-13 05:08:29,312 [myid:1] - WARN  [QuorumPeer[myid=1]/0:0:0:0:0:0:0:0:2181:QuorumCnxManager@400] - Cannot open channel to 2 at election address /192.168.50.12:3888
java.net.ConnectException: Connection refused
	at java.net.PlainSocketImpl.socketConnect(Native Method)
	at java.net.AbstractPlainSocketImpl.doConnect(AbstractPlainSocketImpl.java:350)
	at java.net.AbstractPlainSocketImpl.connectToAddress(AbstractPlainSocketImpl.java:206)
	at java.net.AbstractPlainSocketImpl.connect(AbstractPlainSocketImpl.java:188)
	at java.net.SocksSocketImpl.connect(SocksSocketImpl.java:392)
	at java.net.Socket.connect(Socket.java:589)
	at org.apache.zookeeper.server.quorum.QuorumCnxManager.connectOne(QuorumCnxManager.java:381)
	at org.apache.zookeeper.server.quorum.QuorumCnxManager.connectAll(QuorumCnxManager.java:426)
	at org.apache.zookeeper.server.quorum.FastLeaderElection.lookForLeader(FastLeaderElection.java:843)
	at org.apache.zookeeper.server.quorum.QuorumPeer.run(QuorumPeer.java:822)
```

This is a bit of surprising because the two machines can ping each other:
```bash
vagrant ssh vm1
ping 192.168.50.12
# PING 192.168.50.12 (192.168.50.12) 56(84) bytes of data.
# 64 bytes from 192.168.50.12: icmp_req=1 ttl=64 time=0.275 ms
# 64 bytes from 192.168.50.12: icmp_req=2 ttl=64 time=0.413 ms

ping 192.168.50.11
# PING 192.168.50.11 (192.168.50.11) 56(84) bytes of data.
# 64 bytes from 192.168.50.11: icmp_req=1 ttl=64 time=0.016 ms
# 64 bytes from 192.168.50.11: icmp_req=2 ttl=64 time=0.029 ms
```

You can even set up a chat server between the two VMs:

|         vm1          |           vm2          |
| -------------------- | ---------------------- |
| vagrant ssh vm1      | vagrant ssh vm2        |
| nc -l 2020           | nc 192.168.50.11 2020  |
| > hello vm2          | > hello vm2            |

And you can send `ruok` commands to each VM's ZK:
```bash
echo ruok | nc 192.168.50.11 2181
# imok
echo ruok | nc 192.168.50.12 2181
# imok
```

The problem is that ZK's guide does not do a good job of documenting what is required for a networked zookeeper!!

Apart from the above two requirements, there is another one mentioned in the following [SO question](http://stackoverflow.com/questions/30940981/zookeeper-error-cannot-open-channel-to-x-at-election-address)

So, we will need to change the `cookbooks/zookeeper/templates/zoo_sample.cfg.erb` file and
ensure that we do not add our own IP address to the `zoo.cfg` file. Instead of the VM's own IP
address, it requires `0.0.0.0` to be put in. After doing that, zookeeper finally responds to
the `srvr` command too.


# Tip 7: Installing Java

We use a self-made Java cookbook in this example.

But chef already has one in its supermarket (a place where standard cookbooks are shared).

So it is better to use that one as it may be better tested and more widely used.

See [tutorial-8](../tutorial-8) for using the same.



# Tip 8: Zookeeper logs directory

This has an answer on [this StackOverflow question](http://stackoverflow.com/questions/28691341/zookeeper-log-file-not-created-inside-logs-directory) but it is probably not required.


