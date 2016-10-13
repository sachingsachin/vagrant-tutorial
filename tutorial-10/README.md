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


# Running vagrant in stages

If you had an error in your zookeeper cookbook, you would find that out after setting up the VM, installing chef and java.

The ability to iterate quickly is missing in such a case because you would have to do all the steps again to test the zookeeper cookbook.

Hence the file [run_me.sh](run_me.sh) provisions the vagrant in stages.
```bash
vagrant up --no-provision

RECIPE_LIST=oracle_java8::default vagrant provision

RECIPE_LIST=zookeeper vagrant provision
```

And the environment variable RECIPE_LIST is used inside the Vagrantfile as:
```ruby
    recipe_list = ENV.fetch("RECIPE_LIST", "oracle_java8::default,zookeeper").split(",")
    ...
    vm.vm.provision "chef_solo" do |chef|
       chef.cookbooks_path = ['cookbooks', 'site-cookbooks']
       recipe_list.each do |recipe_name|
           chef.add_recipe recipe_name
       ...
```

Thus, we can just say `RECIPE_LIST=zookeeper vagrant provision` to play only with the zookeeper cookbook while all the other stuff like setting-up-of-VM, installing-chef and java have already been done once.
