# Created by following the instructions at:
#    http://tecadmin.net/install-java-8-on-debian/
#    https://gist.github.com/tinkerware/cf0c47bb69bf42c2d740#file-vagrant-provision-block
#    http://unix.stackexchange.com/questions/106552/apt-get-install-without-debconf-prompt

Chef::Log.info('Setting up java-8-debian.list')
template '/etc/apt/sources.list.d/java-8-debian.list' do
  source 'java-8-debian.list.erb'
  owner 'root'
  group 'root'
  mode '0755'
end


Chef::Log.info('Installing Java 8 using apt-get')
bash 'install_java' do
  code <<-EOF

    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
    sudo apt-get -y -qq update

    # Following two commands select 'OK' for the oracle's license prompts
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections

    sudo apt-get -y install oracle-java8-installer
    sudo apt-get -y install oracle-java8-set-default
  EOF
end
