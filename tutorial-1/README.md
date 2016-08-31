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
puts "Hello World 1"
Vagrant.configure(2) do |config|
  puts "Hello World 2"
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
end
```

# What does the above mean?

In Ruby parlance, this means:

1. The code between `do` and `end` keywords is a block and `config` is an argument for that block.
2. We are calling the function `Vagrant.configure` with an argument of `2` and also passing the
block to that function.
3. `Vagrant.configure` will have a `yield config` statement inside it to execute that block inline.

For non-Ruby developers, a rough analogy is:

1. The code between `do` and `end` keywords is an anonymous function that takes `config` as an argument.
2. The function `Vagrant.configure` gets two arguments - `2` and `the anonymous function`
3. `Vagrant.configure` executes the anonymous function somewhere inside it by passing the `config` object.

Inside the block/anonymous-function, we are just assigning some values to the `config.vm's` attributes.

If you run it as `vagrant up`, you will see both the puts statements being executed.

`config.vm` also has functions that we can execute.


# Calling functions on config.vm

Example:
```ruby
Vagrant.configure(2) do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  # Map current-directory in the host to the "/vagrant_data" directory in the guest VM
  config.vm.synced_folder ".", "/vagrant_data", owner: "root", group: "root"

  # Run the given shell script when provisioned
  config.vm.provision "shell", path:"bootstrap_vm.sh"
end
```

And then create a file `bootstrap_vm.sh` in the same folder where Vagrantfile is present.
Example bootstrap\_vm.sh file:
```bash
#!/bin/sh

echo Hey, I am in `pwd`
```

On running `vagrant up` followed by `vagrant provision`, it will print:
```
==> default: Hey, I am in /home/vagrant
```


Note the use of `config.vm.synced_folder` and `config.vm.provision` above.
Both of these are functions defined by `config.vm` and we are just calling them here.
```ruby
  config.vm.synced_folder ".", "/vagrant_data", owner: "root", group: "root"
```

The way arguments are passed here may seem odd to non-ruby developers.
That is so because Ruby allows the mixing of positional arguments with named arguments.
So in the above, first two arguments are matched positionally and the rest two are
matched by their names. This kind of mixing is useful when some arguments are mandatory
while the rest are optional and have reasoable defaults in the function definition.

A little Ruby example to explain the same:
```ruby
def myfunc(a, b: 2, c: 3)
  puts a
  puts b
  puts c
end

myfunc 1, c: 5
1
2
5

myfunc 1, b: 7
1
7
3
```
