# Snapshot Cleanup
# for more info, see: http://zookeeper.apache.org/doc/current/zookeeperAdmin.html
cron "zookeeper_data_cleanup" do
    user "zookeeper"
    time node["zookeeper"]["maint_cron_time"].to_sym
    shell "/bin/bash"
    path "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
    command "java -cp #{node["zookeeper"]["conf_dir"]}:/usr/local/zookeeper/*:/usr/local/zookeeper/lib/* org.apache.zookeeper.server.PurgeTxnLog #{node["zookeeper"]["data_dir"]} #{node["zookeeper"]["data_dir"]} -n #{node["zookeeper"]["snapshots_to_keep"]}"
end
