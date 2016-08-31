# vagrant-tutorial-3

This tutorial will install apache using chef.

Following is the change in Vagrantfile:
```ruby
  # Omnibus plugin is used to ensure that a desired version of Chef is installed.
  config.omnibus.chef_version = '12.10.24'

  # Installs chef-solo and runs the cookbook expected to be present at
  # cookbooks/<cookbook-name>/recipes/default.rb
  config.vm.provision "chef_solo", run_list: ["my_chef_cookbook"]
```

And the omnibus plugin used above needs to be pre-installed on the Host machine with the command:
```bash
vagrant plugin install vagrant-omnibus
```

This example then loads the apache server as described in `cookbooks/my_chef_cookbook/recipes/default.rb`

This recipe uses chef commands to download and install apache.

Then the recipe links `/vagrant` to `/var/www` (Latter is the directory where apache looks for HTML/JS).

Since by default the host machine's CWD is mapped to `/vagrant` in the guest machine, the above linking creates the following:

`Host's CWD` ===> `/vagrant on Guest VM` ===>  `/var/www on Guest VM`

So if you hit [http://localhost:8080/](http://localhost:8080/) on your **Host Machine**'s browser, you will
see the response from apache running in the VM but showing the files from host's CWD
