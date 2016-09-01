# vagrant-tutorial-6

This `Vagrantfile` sets up:
1. MySQL server on vm1 and
2. MySQL client on vm2

It also sets up a private network on these machines so that they can access each other like a remote machine.

```ruby
Vagrant.configure(2) do |config|

  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  # Setup MySQL-server on vm1
  config.vm.define "vm1" do |vm1|
    vm1.vm.box = "vm1"
    vm1.vm.provision :shell, path: "bootstrap_db.sh"
    vm1.vm.network "private_network", ip: "192.168.50.4"
  end

  # Setup MySQL-client on vm2
  config.vm.define "vm2" do |vm2|
    vm2.vm.box = "vm2"
    vm2.vm.network "forwarded_port", guest: 80, host: 8080
    vm2.vm.provision :shell, inline: "apt-get -qq update; apt-get -y install mysql-client"
    vm2.vm.network "private_network", ip: "192.168.50.5"
  end

end
```


The file `bootstrap_db.sh` is as follows:
```bash
export DEBIAN_FRONTEND=noninteractive
apt-get -qq update
apt-get install -y mysql-server
# Bind address from loopback to 0.0.0.0, which means all interfaces.
# This is necessary to enable connections from remote machines.
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mysql/my.cnf
restart mysql
mysql -uroot mysql <<< "GRANT ALL ON *.* TO 'root'@'%'; FLUSH PRIVILEGES;"
```

You can see the file `/etc/mysql/my.cnf` that by default MySQL server runs on port 3306.


On running with `vagrant up --provision`, you can see that the MySQL server can be accessed from Host as well as both the VMs:
```bash
vagrant up --provision

######### Host ##########
mysql -uroot -h192.168.50.4
# Welcome to the MySQL monitor.  Commands end with ; or \g.
# Your MySQL connection id is 44
# Server version: 5.5.50-0ubuntu0.12.04.1 (Ubuntu)


######### VM2 (MySQL client only) ##########
vagrant ssh vm2
mysql -uroot -h192.168.50.4
# Welcome to the MySQL monitor.  Commands end with ; or \g.
# Your MySQL connection id is 44
# Server version: 5.5.50-0ubuntu0.12.04.1 (Ubuntu)
exit


######### VM1 (MySQL client and server) ##########
vagrant ssh vm1
mysql -uroot
# Welcome to the MySQL monitor.  Commands end with ; or \g.
# Your MySQL connection id is 46
# Server version: 5.5.50-0ubuntu0.12.04.1 (Ubuntu)
exit
```
