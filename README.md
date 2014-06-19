Spark Chef Cookbook
===================

Installs and configures [Apache Spark](http://spark.apache.org/).

Requirements
------------

Java needs to be installed. Although this cookbook does not have a dependency
on it you are encouraged to use the [Java cookbook](http://community.opscode.com/cookbooks/java). 

Attributes
----------

#### spark::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['spark']['version']</tt></td>
    <td>String</td>
    <td>Apache Spark version</td>
    <td><tt>1.0.0</tt></td>
  </tr>
  <tr>
    <td><tt>['spark']['url']</tt></td>
    <td>String</td>
    <td>URL to download the tarball from</td>
    <td><tt>n/a</tt></td>
  </tr>
  <tr>
    <td><tt>['spark']['home']</tt></td>
    <td>String</td>
    <td>Directory to install Spark in</td>
    <td><tt>/usr/local/spark</tt></td>
  </tr>
  <tr>
    <td><tt>['spark']['username']</tt></td>
    <td>String</td>
    <td>User that all Spark daemons will run as</td>
    <td><tt>spark</tt></td>
  </tr>
  <tr>
    <td><tt>['spark']['local_dirs']</tt></td>
    <td>String</td>
    <td>Comma separated list of directories Spark will use to persist shuffles</td>
    <td><tt>"/usr/local/spark/local_dir"</tt></td>
  </tr>

</table>

Usage
-----

Just include `spark` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[spark]"
  ]
}
```

