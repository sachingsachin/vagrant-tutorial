# vagrant and chef tutorial for non-ruby developers

See the individual tutorials in their respective folders.

The tutorials have Ruby titbits explained too for non-ruby developers.


# Testing chef cookbooks

For each tutorial, the recipes in `cookbooks` can be tested directly on the vagrant VM by using the command:
```bash
vagrant ssh
sudo chef-client --local-mode --runlist 'recipe[java]'
```

Once ready, they can be added to the `Vagrantfile`


# Tutorials

1. [tutorial-1](./tutorial-1):
   Setup Vagrant. Meaning of a Vagrantfile.
2. [tutorial-2](./tutorial-2):
   Setup an apache web-server.
3. [tutorial-3](./tutorial-3):
   Use chef cookbooks to provision VM's software deployments.
4. [tutorial-4](./tutorial-4):
   Creating a private network between Host and the VM.
5. [tutorial-5](./tutorial-5):
   Set up multiple VMs in a single Vagrant file.
6. [tutorial-6](./tutorial-6):
   Set up MySQL server in one VM and access from other VM
7. [tutorial-7](./tutorial-7):
   Installs Java-8, Zookeeper and Solr-6.
8. [tutorial-8](./tutorial-8):
   Uses the java cookbook available in chef's supermarket to install java.
9. [tutorial-9](./tutorial-9):
   Installs influx-DB, grafana and telegraf. Also ues two provisioners in the same Vagrant file.


See [https://www.vagrantup.com/docs/vagrantfile/](https://www.vagrantup.com/docs/vagrantfile/) for a reference on the options available to you in `Vagrantfile`.
