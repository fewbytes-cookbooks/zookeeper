default[:zookeeper][:cluster_name] = "default"

# ZK defaults
default[:zookeeper][:tick_time] = 2000
default[:zookeeper][:init_limit] = 10
default[:zookeeper][:sync_limit] = 5
default[:zookeeper][:client_port] = 2181
default[:zookeeper][:peer_port] = 2888
default[:zookeeper][:leader_port] = 3888

default[:zookeeper][:data_dir] = "/var/lib/zookeeper/data"
default[:zookeeper][:version] = "3.3.3"

default[:zookeeper][:ebs_vol_dev] = "/dev/sdp"
default[:zookeeper][:ebs_vol_size] = 10
