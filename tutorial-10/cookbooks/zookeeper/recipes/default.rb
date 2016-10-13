zk_version = node['zookeeper']['version']
download_file = "zookeeper-#{zk_version}.tar.gz"
local_file = "/vagrant/downloads/#{download_file}"
zk_home = "/home/zookeeper-#{zk_version}"
zk_url = "#{node['zookeeper']['urlbase']}/#{download_file}"

# Download Zookeeper from the above URL and store locally
remote_file "#{local_file}" do
    puts "Downloading #{zk_url}"
    source zk_url
    not_if { ::File.exists?(local_file) }
end

# Extract the tar file
bash 'install_zk' do
    cwd "/home"
    code <<-EOF
       tar -xzf "#{local_file}" ;
       chmod -R  777 "zookeeper-#{zk_version}"
    EOF
    not_if { ::File.exists?(zk_home) }
end

directory '/home/zookeeper_dataDir' do
  owner 'root'
  group 'root'
  mode '0777'
  action :create
end

# server_list is populated by the Vagrantfile
server_list = node['vagrant_zk']['server_list']
network = node['network'].to_hash.to_s
my_id = 1
server_list.each do |server|
  puts "Looking for #{server} in #{network}"
  if network.index(server) != nil
    puts "Found my_id = #{my_id}!"
    break;
  end
  my_id = my_id + 1
end


file '/home/zookeeper_dataDir/myid' do
  content my_id.to_s
  #node['vagrant_zk']['my_id'].to_s
  owner 'root'
  group 'root'
  mode '0666'
end


template "#{zk_home}/conf/zoo.cfg" do
  source 'zoo_sample.cfg.erb'
  owner 'root'
  group 'root'
  mode '0666'
end

bash 'run_zk' do
    cwd zk_home
    code "bin/zkServer.sh start"
    not_if 'ps -aef | grep zookeeper.log.dir | grep -v grep'
end
