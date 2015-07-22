#
# Cookbook Name:: spark
# Recipe:: master
#

include_recipe 'spark'

data = data_bag_item('spark', 'ssh_keys')
raise 'Could not find spark ssh_key data bag' if data.nil?

private_ssh_key = data['private']
raise 'Could not find spark ssh_key private data bag item' if private_ssh_key.nil?

file "#{node.spark.home}/.ssh/id_rsa" do
  owner node.spark.username
  group node.spark.username
  mode '0600'
  content private_ssh_key.join("\n")
end

file "#{node.spark.home}/conf/slaves" do
  mode 440
  owner node.spark.username
  group node.spark.username
  content node.spark.slaves.join("\n")
  only_if { !node.spark.slaves.nil? && !node.spark.slaves.empty? }
end

if !node.spark.slaves.nil?
  ohai "reload_passwd" do
      plugin "passwd"
  end

  node.spark.slaves.each do |slave_ip|
    ssh_known_hosts slave_ip do
      user node.spark.username
    end
  end

  template "/etc/init.d/spark" do
    source "init.erb"
    mode "755"
    variables({
      "prog" => "spark",
      "description" => "Spark cluster daemon",
      "runlevels" => "2345",
      "username" => node.spark.username,
      "start_priority" => "70",
      "stop_priority" => "75",
      "start_command" => "#{node.spark.home}/sbin/start-all.sh",
      "stop_command" => "#{node.spark.home}/sbin/stop-all.sh",
      "restart_command" => "#{node.spark.home}/sbin/stop-all.sh ; #{node.spark.home}/sbin/start-all.sh"
    })
  end
end

service "spark" do
  action [:enable, :restart]
end

