solr_version = node['solr']['version']
download_file = "solr-#{solr_version}.tgz"
local_solr_file = "/vagrant/downloads/#{download_file}"
solr_home = "/home/solr-#{solr_version}"
solr_url = "#{node['solr']['urlbase']}/#{solr_version}/#{download_file}"

# Download Solr from the above URL and store locally
remote_file "#{local_solr_file}" do
    puts "Downloading #{solr_url}"
    source solr_url
    not_if { ::File.exists?(local_solr_file) }
end

# Extract the tar file
bash 'install_solr' do
    cwd "/home"
    code <<-EOF
       tar -xzf "#{local_solr_file}"
    EOF
    not_if { ::File.exists?(solr_home) }
end


bash 'run_solr' do
    cwd solr_home
    code "bin/solr start -z localhost:2181 -noprompt"
    not_if 'ps -aef | grep solr | grep start.jar | grep -v grep'
end
