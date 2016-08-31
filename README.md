# vagrant-tutorial

To get a base Vagrant file, run:
```bash
vagrant init precise64 http://files.vagrantup.com/precise64.box
```

This will create a file called `Vagrantfile` which looks similar to:
```ruby
Vagrant.configure(2) do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
end
```

This file is in **Ruby** language and you can add Ruby statements to it like the following:
```ruby
puts "Hello World"
Vagrant.configure(2) do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
end
```

