# Install InfluxDB
wget https://s3.amazonaws.com/influxdb/influxdb_0.10.0-1_amd64.deb
sudo dpkg -i influxdb_0.10.0-1_amd64.deb
sudo service influxdb start
#influx
curl localhost:8083

# Install Grafana
wget https://grafanarel.s3.amazonaws.com/builds/grafana_2.6.0_amd64.deb
sudo apt-get update
sudo apt-get install -y adduser libfontconfig
sudo dpkg -i grafana_2.6.0_amd64.deb
sudo service grafana-server start
curl localhost:3000

# Install and start Telegraf
wget http://get.influxdb.org/telegraf/telegraf_0.10.2-1_amd64.deb
sudo dpkg -i telegraf_0.10.2-1_amd64.deb
telegraf -sample-config -input-filter cpu:mem:swap -output-filter influxdb > telegraf.conf
#telegraf -config telegraf.conf
sudo service telegraf start -config telegraf.conf
