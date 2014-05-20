include_recipe "django"
include_recipe "git"

git "/usr/local/zookeeper_dashboard" do
  repository "git://github.com/phunt/zookeeper_dashboard.git"
  user "root"
  action :sync
end

zk_servers = partial_search(:node, 
	"role:#{node["zookeeper"]["server_role"]} AND zookeeper_cluster_name:#{node[:zookeeper][:cluster_name]}",
	:keys => {"name" => ["name"], "ipaddress" => ["ipaddress"], "hostname" => ["hostname"], "zookeeper" => ["zookeeper"]}
	).first

template "/usr/local/zookeeper_dashboard/settings.py" do
  source "dashboard/settings.py.erb"
  mode 0644
  variables(:zk_servers => zk_servers)
end

runit_server "zookeeper_dashboard"
