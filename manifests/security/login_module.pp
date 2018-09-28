# This is the login-module configuration for a security domain
# Multiple login-modules can be specified for a single security domain.
#
# [*domain_name*]
#  Name of the security domain to be created on the Wildfly server.
#
# [*code*]
#  Login module code to use. See: https://docs.jboss.org/author/display/WFLY9/Authentication+Modules
#
# [*flag*]
#  The flag controls how the module participates in the overall procedure. Allowed values are:
#  `requisite`, `required`, `sufficient` or `optional`. Default: `required`.
#
# [*module_options*]
#  A hash of module options containing name/value pairs. E.g.:
#  `{ 'name1' => 'value1', 'name2' => 'value2' }`
#  or in Hiera:
#  ```
#   module_options:
#    name1: value1
#    name2: value2
#  ```
#[*target_profile*]
# String wich Sets the target profile to prefix resource name. Requires domain mode.
#
#[*mgmt_user*]
# A hash with username and password as a string
# Example
# { 'username' => 'puppet', 'password' => fqdn_rand_string(30) }
#
#[*port_properties*]
#  A hash with numeric values for all port nummers
# Example
#  { 'management-http' => 9990,
#    'management-https' => 9993,
#    'ajp' => 8009,
#    'http' => 8080,
#    'https' => 8443 }
#
#[*ip_properties*]
# A hash with ipaddresses for management and public as a ip4 ip address
# Example
# { 'management' => '127.0.0.1',  'public'     => '127.0.0.1' }
#

define wildfly::security::login_module(
  $domain,
  $code,
  $flag,
  $module_options={},
  Optional[String]                                                                               $target_profile = undef,
  Optional[Hash[Enum['username','password'], String]]                                            $mgmt_user = undef,
  Optional[Hash[Enum['management-http','management-https','ajp','http','https'], Integer[1024]]] $port_properties = undef,
  Optional[Hash[Enum['management','public'], Stdlib::Compat::Ip_address]]                        $ip_properties = undef,
) {

  include ::wildfly
  $_mgmt_user = pick($mgmt_user, $::wildfly::mgmt_user)
  $_port_properties = pick($port_properties, $::wildfly::port_properties)
  $_ip_properties = pick($ip_properties, $::wildfly::ip_properties)

  wildfly::resource { "/subsystem=security/security-domain=${domain}/authentication=classic/login-module=${code}":
    content         => {
      'code'           => $code,
      'flag'           => $flag,
      'module-options' => $module_options,
    },
    profile         => $target_profile,
    mgmt_user       => $_mgmt_user,
    port_properties => $_port_properties,
    ip_properties   => $_ip_properties,
  }
}
