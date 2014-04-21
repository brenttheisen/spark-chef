#
# Cookbook Name:: spark
# Recipe:: default
#

include_recipe 'java'

package 'git'

user node.spark.username do
  username node.spark.username
  comment 'Spark'
  action :create
end

ark 'spark' do
  url node.spark.url
  version node.spark.version
  has_binaries [ 'bin/spark-shell', 'bin/spark-class', 'bin/pyspark' ]
  owner node.spark.username
  group node.spark.username
  action :install
end

assembly_env_vars = []
assembly_env_vars << "SPARK_HADOOP_VERSION=#{node.spark.hadoop_version}" if node.spark.hadoop_version
assembly_env_vars << "SPARK_YARN=true" if node.spark.yarn
bash 'build spark assembly' do
  cwd node.spark.home
  code "#{assembly_env_vars.join(' ')} sbt/sbt assembly"
  user node.spark.username
end

spark_classpath = []
if node.spark.calliope
  calliope_jar = "#{node.spark.home}/lib_managed/jars/calliope.jar"
  remote_file calliope_jar do
    source node.spark.calliope_url
    owner node.spark.username
    group node.spark.username
    action :create_if_missing
  end

  spark_classpath << node.spark.cassandra_classpath
end

java_opts = node.spark.java_opts || []
java_opts = [java_opts] if !java_opts.kind_of(Array)
java_opts += node.spark.properties.collect { |k, v| "-D#{k}=#{v}" }
java_opts = java_opts.join(' ')

template "#{node.spark.home}/conf/spark-env.sh" do
  source "conf-spark-env.sh.erb"
  mode 440
  owner node.spark.username
  group node.spark.username
  variables({
    :spark_classpath => spark_classpath.join(':'),
    :local_ip => node.spark.local_ip,
    :mesos_native_library => node.spark.mesos_native_library,
    :java_opts => java_opts,
    :master_ip => node.spark.master_ip,
    :master_port => node.spark.master_port,
    :master_webui_port => node.spark.master_webui_port,
    :worker_cores => node.spark.worker_cores,
    :worker_memory => node.spark.worker_memory,
    :worker_port => node.spark.worker_port,
    :worker_webui_port => node.spark.worker_webui_port,
    :worker_instances => node.spark.worker_instances,
    :worker_dir => node.spark.worker_dir,
    :properties => node.spark.properties
  })
end

