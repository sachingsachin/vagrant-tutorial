# vagrant-tutorial-2

The Vagrantfile builds upon the ../tutorial-1 and demonstrates another function call in `config.vm` as:

```ruby
config.vm.network "forwarded_port", guest: 80, host: 8080
```

Main change is in the `bootstrap_vm.sh` file that now downloads apache web-server and installs it.

Since by default the host machine's CWD is mapped to `/vagrant` in the guest machine, it uses that
setting and also links `/vagrant` to `/var/www`. Latter is the directory where apache looks for HTML/JS
resources and by virtue of this linking, the files in the host's CWD become available to the apache
running in the VM.

`Host's CWD` ===> `/vagrant on Guest VM` ===>  `/var/www on Guest VM`

So if you hit [http://localhost:8080/](http://localhost:8080/) on your **Host Machine**'s browser, you will
see the response from apache running in the VM but showing the files from host's CWD


# Run as
```bash
vagrant up
vagrant provision
```
