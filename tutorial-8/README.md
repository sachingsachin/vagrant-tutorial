# vagrant-chef-tutorial-8


## Installing ruby and chef

If you haven't already setup chef on your machine, this is the way to do it.
It also downloads `knife` on your machine which we will need to download cookbook for java.
```bash
curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
rvm install 2.3.1
gem install chef
```

## Download existing cookbook(s) for java 

See [download\_java\_cookbook.sh](./download_java_cookbook.sh).

Unfortunately, I could not find any way where chef automatically downloads dependency-cookbooks.
Hence you run chef, look at the error and then proceed to download the next cookbook-dependency in your run script.
It would have been a lot more easy, if this was somehow automated (like maven or gradle).

```bash
mkdir site-cookbooks
cd site-cookbooks

mkdir downloaded_cookbooks
cd downloaded_cookbooks
knife cookbook site download java
knife cookbook site download apt
knife cookbook site download compat_resource
knife cookbook site download homebrew
knife cookbook site download build-essential
knife cookbook site download mingw
knife cookbook site download seven_zip
knife cookbook site download windows
cd ..

# All the above commands download tar.gz files and we need to unzip them.
for f in downloaded_cookbooks/*.tar.gz; do tar -xzf $f; done
```

# Run

As always,
```bash
vagrant up --provision
```
