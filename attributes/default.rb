default["zookeeper"]["cluster_name"] = "default"

# ZK defaults
default["zookeeper"]["tick_time"] = 2000
default["zookeeper"]["init_limit"] = 10
default["zookeeper"]["sync_limit"] = 5
default["zookeeper"]["client_port"] = 2181
default["zookeeper"]["peer_port"] = 2888
default["zookeeper"]["leader_port"] = 3888

default["zookeeper"]["log_dir"] = "/var/log/zookeeper"
default["zookeeper"]["var_dir"] = "/var/lib/zookeeper"
default["zookeeper"]["data_dir"] = ::File.join(zookeeper['var_dir'], "data")
default["zookeeper"]["conf_dir"] = "/etc/zookeeper"
default["zookeeper"]["version"] = "3.3.0"

default["zookeeper"]["ebs_vol_dev"] = "/dev/sdp"
default["zookeeper"]["ebs_vol_size"] = 10

# For chef solo, fill in the nessecary data for remote zookeeper nodes:
# default["zookeeper"]["nodes"] = [ {:ipaddress => "192.168.1.23", :zookeeper => {:peer_port => 2888, :leader_port => 3888}} ]
default["zookeeper"]["nodes"] = []

default["zookeeper"]["checksum"] = nil