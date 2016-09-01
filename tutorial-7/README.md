# vagrant-tutorial-7

This example uses chef to install the following:
1. Java 8
2. Solr (Single Server)


# Testing cookbooks

The recipes in `cookbooks` are tested directly on the vagrant VM by using the command:
```bash
sudo chef-client --local-mode --runlist 'recipe[java]'
```

Once ready, they can be added to the `Vagrantfile`

# Running the example

```bash
vagrant up --provision
vagrant ssh
# Welcome to Ubuntu 12.04 LTS (GNU/Linux 3.2.0-23-generic x86_64)

wget localhost:8983/solr
# -- 21:43:11--  http://localhost:8983/solr
# Resolving localhost (localhost)... 127.0.0.1`
# Connecting to localhost (localhost)|127.0.0.1|:8983... connected.
# HTTP request sent, awaiting response... 302 Found
# Location: http://localhost:8983/solr/ [following]
# -- 21:43:11--  http://localhost:8983/solr/
# Reusing existing connection to localhost:8983.
# HTTP request sent, awaiting response... 200 OK
# Length: 13349 (13K) [text/html]
# Saving to: `solr'

100%[=============>] 13,349      --.-K/s   in 0s

# 21:43:11 (351 MB/s) - `solr' saved [13349/13349]`
```

Somehow the private network between the Host and the VM is not established. Needs some debugging to fix the same.
