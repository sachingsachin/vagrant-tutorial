storm_version = node['storm']['version']
download_file = "apache-storm-#{storm_version}.zip"
local_storm_file = "/vagrant/downloads/#{download_file}"
storm_home = "/home/apache-storm-#{storm_version}"
storm_url = "#{node['storm']['urlbase']}/apache-storm-#{storm_version}/#{download_file}"

Chef::Log.info('Updating with apt-get')
bash 'upgrade-apt-get-utils' do
  code <<-EOF

    sudo apt-get -y -qq update
    sudo apt-get -y -qq install unzip
    sudo apt-get -y -qq install vim
  EOF
  not_if { ::File.exists?("/usr/bin/unzip") }
end

# Download storm from the above URL and store locally
remote_file "#{local_storm_file}" do
    puts "Downloading #{storm_url}"
    source storm_url
    not_if { ::File.exists?(local_storm_file) }
end

# Extract the tar file
bash 'install_storm' do
    cwd "/home"
    code <<-EOF
       unzip "#{local_storm_file}"
    EOF
    not_if { ::File.exists?(storm_home) }
end


template "#{storm_home}/conf/storm.yaml" do
    source 'storm.yaml.erb'
    owner 'root'
    group 'root'
    mode '0666'
end

#service "storm_service" do
  #supports :status => true, :restart => true
  #start_command "#{storm_home}/bin/storm nimbus"
  #restart_command "/usr/lib/myapp/bin/myapp restart"
  #status_command "/usr/lib/myapp/bin/myapp status"
  #action [ :enable, :start ]
#end


bash 'run_storm' do
    cwd storm_home
    code "nohup bin/storm nimbus > /dev/null &"
    not_if 'ps -aef | grep storm | grep nimbus | grep -v grep'
end

bash 'run_storm_ui' do
    cwd storm_home
    code "nohup bin/storm ui > /dev/null &"
    not_if 'ps -aef | grep storm | grep ui | grep -v grep'
end

bash 'run_supervisor' do
    cwd storm_home
    code "nohup bin/storm supervisor > /dev/null &"
    not_if 'ps -aef | grep storm | grep supervisor | grep -v grep'
end

