# This is a defined resource type for creating a security domain
# Please also see: https://docs.jboss.org/author/display/WFLY9/Security+subsystem+configuration
#
# [*domain_name*]
#  Name of the security domain to be created on the Wildfly server.
#
# [*login_modules*]
#  A hash with a specification of all login-modules to add to the domain.
#  Also see the documentation of `wildfly::security::login_module`
#  Example:
#    { 'login-module-1' => {
#        domain_name => 'my-security-domain',
#        code => 'DirectDomain',
#        flag => 'required',
#        module_options => { realm => 'my-security-realm' }
#      },
#      'login-module-2' => {
#        ...
#      }
#    }
#
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
define wildfly::security::domain(
  Optional[Hash]                                                                                 $login_modules = undef,
  Optional[String]                                                                               $target_profile = undef,
  Optional[Hash[Enum['username','password'], String]]                                            $mgmt_user = undef,
  Optional[Hash[Enum['management-http','management-https','ajp','http','https'], Integer[1024]]] $port_properties = undef,
  Optional[Hash[Enum['management','public'], Stdlib::Compat::Ip_address]]                        $ip_properties = undef,
) {

  include ::wildfly
  $_mgmt_user = pick($mgmt_user, $::wildfly::mgmt_user)
  $_port_properties = pick($port_properties, $::wildfly::port_properties)
  $_ip_properties = pick($ip_properties, $::wildfly::ip_properties)

  $domain_info = split($title, ':')
  $domain = $domain_info[0]
  $catalina_home = $domain_info[1]

  tag(sha1($catalina_home))

  $profile_path = wildfly::profile_path($target_profile)

  wildfly::resource { "/subsystem=security/security-domain=${domain}-${catalina_home}":
    content         => {
      'cache-type' => 'default',
    },
    profile         => $target_profile,
    mgmt_user       => $_mgmt_user,
    port_properties => $_port_properties,
    ip_properties   => $_ip_properties,
  }

  -> wildfly::resource { "/subsystem=security/security-domain=${domain}-${catalina_home}/authentication=classic":
    content         => {},
    profile         => $target_profile,
    mgmt_user       => $_mgmt_user,
    port_properties => $_port_properties,
    ip_properties   => $_ip_properties,
  }

  create_resources('wildfly::security::login_module', $login_modules)

  Wildfly::Resource[ "/subsystem=security/security-domain=${domain}-${catalina_home}/authentication=classic"]
    -> Wildfly::Security::Login_module<|tag == 'wildfly'|>

}
