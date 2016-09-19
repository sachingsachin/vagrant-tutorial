include_recipe 'java'

# Overriding attributes here does not work.
# Need to put it in attributes/default.rb
# node.override['java']['oracle']['accept_oracle_download_terms'] = true
# node.override['java']['accept_license_agreement'] = true
# node.override['java']['install_flavor'] = 'oracle'
# node.override['java']['jdk_version'] = '8'
