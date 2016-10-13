#!/bin/bash

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

for f in downloaded_cookbooks/*.tar.gz; do tar -xzf $f; done

