# vagrant-chef-tutorial-10

This example uses chef to install the following:

1. Java 8
2. Zookeeper


# Running the example

```bash
./run_me.sh
```

# Prerequisites

1. [Java, Zookeeper, Solr installation in tutorial-7](../tutorial-7)
2. [Using Java-8 cookbook from supermarket in tutorial-8](../tutorial-8)

The READMEs of both the above tutorials have some very important information.

Do read that before you try to understand this one.


# Zookeeper does not work

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

