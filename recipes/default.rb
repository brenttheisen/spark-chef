#
# Cookbook Name:: spark
# Recipe:: default
#

include_recipe 'java'

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
  code '#{assembly_env_vars.join(' ')} sbt/sbt assembly'
  user node.spark.username
end

