# vagrant-chef-tutorial-9


## Installing ruby and chef

If you haven't already setup chef on your machine, this is the way to do it.
It also downloads `knife` on your machine which we will need to download cookbook for java.
```bash
sudo su -
apt-get install curl

# Install rvm
curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
# or
source /etc/profile.d/rvm.sh

# Install ruby
rvm install 2.3.1
rvm --default use 2.3.1

# Install chef
gem install chef
```


# Run

As always,
```bash
vagrant up --provision
```



# Installing Java, influx-DB, grafana and telegraf

Java is installed following the same procedure as described in [../tutorial-8](tutorial-8).

[influx-grafana-telegraf.sh](./influx-grafana-telegraf.sh) is a provisioning script that installs
influx-DB, grafana and telegraf on the VM.

It also generates a configuration file for telegraf and starts telegraf for the same.



# How to see the graphs in grafana

Follow [http://www.netinstructions.com/how-to-monitor-your-linux-machine/](http://www.netinstructions.com/how-to-monitor-your-linux-machine/)

Your localhost URLs:

1. [http://localhost:8083/](http://localhost:8083/)
2. [http://localhost:3000/](http://localhost:3000/)
