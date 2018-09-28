# wildfly

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with wildfly](#setup)
    * [What wildfly affects](#what-wildfly-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with wildfly](#beginning-with-wildfly)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

This Wildfly module lets you use Puppet to install, deploy and configure multiple WildFly's  (standalone only).

The module is based/uses code from the following modules:

* biemond-wildfly: https://github.com/biemond/biemond-wildfly
* puppetlabs-tomcat: https://github.com/puppetlabs/puppetlabs-tomcat

The best scenario would have been incorporating this code in the biemond-wildfly module, it is an issue: https://github.com/biemond/biemond-wildfly/issues/149

But we decided to give it our own twist and release this module, it is in NO WAY a real alternative to the biemond-wildfly module, it lacks a lot of features we would like to add, by releasing it to the public we hope to get movement on this module and improve the quality.  Be free to test this release and make (major) PR's available for us.

## Setup

### What wildfly affects

It will install a WildFly version by your choice in a given directory.

### Setup Requirements

This module requires the following modules:
- [puppet-puppetlabs-stdlib](https://github.com/puppetlabs/puppetlabs-stdlib)
- [puppet-voxpupuli-archive](https://github.com/voxpupuli/puppet-archive)

### Beginning with wildfly

This module is multi-based, it is not possible to just include the module and be done with it.
It requires at least these lines of code to get a working installation.

## Usage

The most basic usage would be the following:

```
wildfly::install { 'wildfly8':
  catalina_home => '/opt/wildfly8',
  source        => 'http://download.jboss.org/wildfly/8.2.1.Final/wildfly-8.2.1.Final.tar.gz',
}
wildfly::instance { 'wildfly8':
  catalina_home  => '/opt/wildfly8',
  manage_service => true,
  port_properties => { "management-http" => 19990, "management-https" => 19993, "ajp" => 18009, "http" => 18080, "https" => 18443, },
}
```

This will install WildFly version 8 in /opt/wildfly8 with custom portnumbers. Note that the 'catalina_home' variable is the leading variable which determines which WildFly instance is configured.

### Parameters wildfly class

#### catalina_home
Type: Path\
Default: `/opt/wildfly`\
Values: Any valid path\
Description: Specifies the path to install WildFly

#### user
Type: string\
Default: `wildfly`\
Values: a string value\
Description: Specifies the user under which the WildFly instance should run,  when `manage_user` is set to true the user will be created

#### group
Type: string\
Default: `wildfly`\
Values: a string value\
Description: Specifies the group under which the WildFly instance should run, when `manage_group` is set to true the group will be created

#### manage_user
Type: boolean\
Default: true\
Values: true/false\
Description: Specifies whenever to create or not the user defined in `user`

#### manage_group
Type: boolean\
Default: true\
Values: true/false\
Description: Specifies whenever to create or not the group defined in `group`

#### manage_base
Type: boolean\
Default: true\
Values: true/false\
Description: Specifies whenever to create or not the directory defined in `catalina_home`

#### mgmt_user
Type: hash\
Default: { 'username' => 'puppet', 'password' => fqdn_rand_string(30) }\
Values: hash with username and password as a string\
Description: Specifies the managment user and password

#### port_properties
Type: hash\
Default: { 'management-http' => 9990, 'management-https' => 9993, 'ajp' => 8009, 'http' => 8080, 'https' => 8443 }\
Values: hash with numeric values for port nummers\
Description: Specifies portnumbers for management-http, management-https, ajp, http and https

#### ip_properties
Type: hash\
Default: { 'management' => '127.0.0.1',  'public'     => '127.0.0.1' }\
Values: hash with ipaddresses for management and public as a ip4 ip address\
Description: Specifies the managment and public ipaddress as a ip4 ip address

### Parameters wildfly::install define

#### catalina_home
Type: Path\
Default: `title of this define`\
Values: Any valid path\
Description: Specifies the path to install WildFly must be unique for multiple instances

#### install_from_source
Type: boolean\
Default: true\
Values: true/false\
Description: Specifies to install WildFly from a tar.gz file when true or from a package when false

#### source
Type: string\
Default: undef\
Values: an url to the instalation file for a WildFly or JDBC-driver\
Description: Specifies the url for an installation of WildFly (which should be a tar.gz file) or a JDBCD-driver (which should be a jar-file)

#### checksum
Type: string\
Default: undef\
Values: a sha256 value\
Description: Specifies the checksum_type checksum of the source specified

#### checksum_type
Type: list\
Default: sha256\
Values: sha1, sha256, sha512\
Description: Specifies the checksumtype to use for calculating the checksum

#### source_strip_first_dir
Type: boolean\
Default: true\
Values: true/false\
Description: Specifies that the first directory from the archive is stripped, most archives require this

#### proxy_type
Type: string\
Default: undef\
Values: undef, http, https, ftp\
Description: Specifies the proxy server type used by proxy_server. Normally this defaults to the protocol specified in the proxy_server URI

#### proxy_server
Type: string\
Default: undef\
Values: proxy-server\
Description: Specifies a proxy server to use when downloading WildFly binaries

#### allow_insecure
Type: boolean\
Default: false\
Values: true/false\
Description: Specifies if a https-url needs to secure (certificate check ok)

#### user
Type: string\
Default: `$::wildfly::user`\
Values: a string value\
Description: Specifies the user under which the WildFly instance should run, when `manage_user` is set to true the user will be created

#### group
Type: string\
Default: `$::wildfly::group`\
Values: a string value\
Description: Specifies the group under which the WildFly instance should run, when `manage_group` is set to true the group will be created

#### manage_user
Type: boolean\
Default: `$::wildfly::manage_user`\
Values: true/false\
Description: Specifies whenever to create or not the user defined in `user`

#### manage_group
Type: boolean\
Default: `$::wildfly::manage_group`\
Values: true/false\
Description: Specifies whenever to create or not the group defined in `group`

#### manage_base
Type: boolean\
Default: `$::wildfly::manage_base`\
Values: true/false\
Description: Specifies whenever to create or not the directory defined in `catalina_home`


#### package_ensure
Type: string\
Default: undef\
Values: present/absent\
Description: Specifies if the package should be present or absent, only valid when `install_from_source` is set to false

#### package_name
Type: string\
Default: undef\
Values: package name\
Description: Specifies the name of the package to install, only valid when `install_from_source` is set to false

#### package_options
Type: string\
Default: undef\
Values: options\
Description: Specifies options for when installing a package

### Parameters wildfly::instance define

#### catalina_home
Type: Path\
Default: `$::wildfly::catalina_home`\
Values: Any valid path\
Description: Specifies the path to install WildFly

#### user
Type: string\
Default: `$::wildfly::user`\
Values: a string value\
Description: Specifies the user under which the WildFly instance should run, when `manage_user` is set to true the user will be created

#### group
Type: string\
Default: `$::wildfly::group`\
Values: a string value\
Description: Specifies the group under which the WildFly instance should run, when `manage_group` is set to true the group will be created

#### manage_user
Type: boolean\
Default: `$::wildfly::manage_user`\
Values: true/false\
Description: Specifies whenever to create or not the user defined in `user`

#### manage_group
Type: boolean\
Default: `$::wildfly::group`\
Values: true/false\
Description: Specifies whenever to create or not the group defined in `group`

#### manage_service
Type: boolean\
Default: true\
Values: true/false\
Description: Specifies whenever to enable the WildFly instance

#### port_properties
Type: hash\
Default: `$::wildfly::port_properties`\
Values: hash with numeric values for port nummers\
Description: Specifies portnumbers for management-http, management-https, ajp, http and https

#### ip_properties
Type: hash\
Default: `$::wildfly::ip_properties`\
Values: hash with ipaddresses for management and public as a ip4 ip address\
Description: Specifies the managment and public ipaddress as a ip4 ip address

#### java_home
Type: path\
Default: undef\
Values: none\
Description: Specifies the path for the Java installation to use

#### java_opts
Type: string\
Default: undef\
Values: none\
Description: Specifies the options for Java

#### java_xms
Type: string\
Default: `256m`\
Values: any\
Description: Specifies the xms setting for Java

#### java_xmx
Type: string\
Default: `512m`\
Values: any\
Description: Specifies the xmx setting for Java

#### remote_debug
Type: boolean\
Default: false\
Values: any\
Description: Specifies whenever to enable a debug port

#### remote_debug_port
Type: integer\
Default: 8787\
Values: port-number\
Description: Specifies the portnumber for the debug port

### Parameters wildfly::resource define

#### mgmt_user
Type: hash\
Default: `$::wildfly::mgmt_user`\
Values: hash with username and password as a string
Description: Specifies the managment user and password

#### port_properties
Type: hash\
Default: `$::wildfly::port_properties`\
Values: hash with numeric values for port nummers\
Description: Specifies portnumbers for management-http, management-https, ajp, http and https

#### ip_properties
Type: hash\
Default: `$::wildfly::ip_properties`\
Values: hash with ipaddresses for management and public as a ip4 ip address\
Description: Specifies the managment and public ipaddress as a ip4 ip address

#### ensure
Type: Enum[String]\
Default: `present`\
Values: |present/absent\
Description: Specifies wheter the resource should be present or absent

#### recursive
Type: boolean\
Default: false\
Values: true / false\
Description: Specifies whether it should manage the resource recursively or not

#### undefine_attributes
Type: boolean\
Default: false\
Values: true / false\
Description: Specifies Whether it should undefine attributes with undef value

#### content
Type: hash\
Default: `empty`\
Values: hash with content/state\
Description: Specifies Sets the content/state of the target resource

#### operation_headers
Type: hash\
Default: `empty`\
Values: hash with operation headers\
Description: Specifies Sets [operation-headers](https://docs.jboss.org/author/display/WFLY9/Admin+Guide#AdminGuide-OperationHeaders)
    (e.g. `{ 'allow-resource-service-restart' => true, 'rollback-on-runtime-failure' => false, 'blocking-timeout' => 600}`)
    to be used when creating/destroying this resource.

#### profile
Type: string\
Default: undef\
Values: name of the target profile\
Description: Specifies Sets the target profile to prefix resource name. Requires domain mode

### Parameters wildfly::service define

#### service_ensure
Type: Enum[String]\
Default: `running`\
Values: running /  stopped\
Description: Specifies wheter the service should be running or stopped

#### service_enable
Type: boolean\
Default: true\
Values: true / false\
Description: Specifies whether the service should be started after a reboot

#### service_name
Type: string\
Default: $title\
Values: valid string with the name of the service\
Description: Specifies the name of the service

### Parameters wildfly::cli define

#### command
Type: string\
Default: $title\
Values: valid command to execute\
Description: Specifies The actual command to execute

#### unless
Type: string\
Default: cmd to check status\
Values: valid command to execute\
Description: If this parameter is set, then this `cli` will only run if this command condition is met

#### onlyif
Type: string\
Default: cmd to check status\
Values: valid command to execute\
Description: If this parameter is set, then this `cli` will run unless this command condition is met

#### mgmt_user
Type: hash\
Default: { 'username' => 'puppet', 'password' => fqdn_rand_string(30) }\
Values: hash with username and password as a string\
Description: Specifies the managment user and password

#### port_properties
Type: hash\
Default: { 'management-http' => 9990, 'management-https' => 9993, 'ajp' => 8009, 'http' => 8080, 'https' => 8443 }\
Values: hash with numeric values for port nummers\
Description: Specifies portnumbers for management-http, management-https, ajp, http and https

#### ip_properties
Type: hash\
Default: { 'management' => '127.0.0.1',  'public'     => '127.0.0.1' }\
Values: hash with ipaddresses for management and public as a ip4 ip address\
Description: Specifies the managment and public ipaddress as a ip4 ip address

### Parameters wildfly::datasource::driver define
#### dependencies
Type: array\
Default: undef\
Values: array os strings\
Description: Specifies the dependencies for a module in WildFly

#### driver_name
Type: string\
Default: undef\
Values: name of the driver\
Description: Specifies the name of the driver

#### driver_module_name
Type: string\
Default: undef\
Values: name of the module driver\
Description: Specifies the name of the module driver

## Example

### Add datasource

````
wildfly::config::module { 'org.postgresql:/opt/wildfly10':
  source       => 'https://jdbc.postgresql.org/download/postgresql-42.1.4.jar',
  checksum     => '4523ed32e9245e762e1df9f0942a147bece06561770a9195db093d9802297735',
  dependencies => ['javax.api',
                   'javax.transaction.api'],
}
wildfly::datasources::driver { 'Driver postgresql:/opt/wildfly10':
  driver_name                     => 'postgresql',
  driver_module_name              => 'org.postgresql',
  driver_xa_datasource_class_name => 'org.postgresql.xa.PGXADataSource',
  port_properties                 => { 'management-http' => 39990, 'management-https' => 39993, 'ajp' => 38009, 'http' => 38080, 'https' => 38443, },
}
wildfly::datasources::datasource { 'DemoDS:/opt/wildfly10':
  config          => {
    'driver-name'    => 'postgresql',
    'connection-url' => 'jdbc:postgresql://localhost/postgres',
    'jndi-name'      => 'java:jboss/datasources/DemoDS',
  },
  port_properties => { 'management-http' => 39990, 'management-https' => 39993, 'ajp' => 38009, 'http' => 38080, 'https' => 38443, },
}
````

## Reference

Here, include a complete list of your module's classes, types, providers,
facts, along with the parameters for each. Users refer to this section (thus
the name "Reference") to find specific details; most users don't read it per
se.

## Limitations

This is where you list OS compatibility, version compatibility, etc. If there
are Known Issues, you might want to include them under their own heading here.

## Development

Since your module is awesome, other users will want to play with it. Let them
know what the ground rules for contributing are.

## Release Notes/Contributors/Etc. **Optional**

If you aren't using changelog, put your release notes here (though you should
consider using changelog). You can also add any additional sections you feel
are necessary or important to include here. Please use the `## ` header.


## Reference

Here, include a complete list of your module's classes, types, providers,
facts, along with the parameters for each. Users refer to this section (thus
the name "Reference") to find specific details; most users don't read it per
se.

## Limitations

This module only works on RedHat 6 and 7, this is due to the limitations of WildFly (V11 and higher)
and it's support for Java 1.7

## Development
You can contribute by submitting issues, providing feedback and joining the discussions.

Go to: `https://github.com/kpn-puppet/puppet-kpn-wildfly`

If you want to fix bugs, add new features etc:
- Fork it
- Create a feature branch ( git checkout -b my-new-feature )
- Apply your changes and update rspec tests
- Run rspec tests ( bundle exec rake spec )
- Commit your changes ( git commit -am 'Added some feature' )
- Push to the branch ( git push origin my-new-feature )
- Create new Pull Request
