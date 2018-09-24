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
