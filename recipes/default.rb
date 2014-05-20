#
# Cookbook Name:: zookeeper
# Recipe:: default
#
# Copyright 2010, GoTime Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
include_recipe "java"
include_recipe "runit"

ark "zookeeper" do
  url node[:zookeeper][:download_url]
  checksum node[:zookeeper][:checksum] if node[:zookeeper][:checksum]
  version node[:zookeeper][:version]
  action :install
end

user "zookeeper" do
  uid 61001
  gid "nogroup"
end

directory node[:zookeeper][:var_dir] do
  owner true
  owner "zookeeper"
  group "nogroup"
  mode 00755
end

if node[:ec2]
  directory "/mnt/zookeeper" do
    owner "zookeeper"
    group "nogroup"
    mode 0755
  end

  # put lib dir on /mnt
  mount node[:zookeeper][:var_dir] do
    device "/mnt/zookeeper"
    fstype "none"
    options "bind,rw"
    action :mount
  end
end

directory node[:zookeeper][:conf_dir] do
  owner "root"
  group "root"
  mode 0755
end

[node[:zookeeper][:log_dir], node[:zookeeper][:data_dir]].each do |dir|
  directory dir do
    recursive true
    owner "zookeeper"
    group "nogroup"
    mode 0755
  end
end

template ::File.join(node[:zookeeper][:conf_dir], "log4j.properties") do
  source "log4j.properties.erb"
  mode 0644
end

if Chef::Config[:solo]
  zk_servers = [node.to_hash] + node['zookeeper']['nodes']
else
  zk_servers = node.role?(node["zookeeper"]["server_role"]) ? [node.to_hash] : []
  zk_servers += partial_search(:node, "role:#{node["zookeeper"]["server_role"]} AND zookeeper_cluster_name:#{node[:zookeeper][:cluster_name]} NOT name:#{node.name}",
    :keys => {'name' => ["name"], "ipaddress" => ["ipaddress"], "zookeeper" => ["zookeeper"]}) # don't include this one, since it's already in the list
  zk_servers.sort! { |a, b| a["name"] <=> b["name"] }
end

if zk_servers.count > node["zookeeper"]["quorum_size"]
  ::Chef::Application.fatal!("Found more zookeeper servers then the expected size of the quorum. Cowardly refusing to proceed. Zookeeper nodes: #{zk_servers}")
elsif zk_servers.count < node["zookeeper"]["quorum_size"]
  ::Chef::Log.warn("Not enough zookeeper servers found (expected #{node["zookeeper"]["quorum_size"]}), skipping zookeeper configuration")
else
  template "/etc/zookeeper/zoo.cfg" do
    source "zoo.cfg.erb"
    mode 0644
    variables(:servers => zk_servers)
    notifies :restart, "runit_service[zookeeper]"
  end

  #include_recipe "zookeeper::ebs_volume"
  unless node["zookeeper"]["myid"]
    node.set["zookeeper"]["myid"] = zk_servers.collect { |n| n["ipaddress"] }.index(node["ipaddress"])
  end

  template "#{node[:zookeeper][:data_dir]}/myid" do
    source "myid.erb"
    owner "zookeeper"
    group "nogroup"
    variables(:myid => node["zookeeper"]["myid"])
  end

  runit_service "zookeeper"  
end  

