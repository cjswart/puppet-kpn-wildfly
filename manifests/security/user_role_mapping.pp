#
define wildfly::security::user_role_mapping(
  $role,
  $username = $title,
  $realm = undef,
  Optional[String]                                                                               $target_profile = undef,
  Optional[Hash[Enum['username','password'], String]]                                            $mgmt_user = undef,
  Optional[Hash[Enum['management-http','management-https','ajp','http','https'], Integer[1024]]] $port_properties = undef,
  Optional[Hash[Enum['management','public'], Stdlib::Compat::Ip_address]]                        $ip_properties = undef,
) {

  include ::wildfly
  $_mgmt_user = pick($mgmt_user, $::wildfly::mgmt_user)
  $_port_properties = pick($port_properties, $::wildfly::port_properties)
  $_ip_properties = pick($ip_properties, $::wildfly::ip_properties)

  $_username = upcase($username)

  wildfly::resource { "/core-service=management/access=authorization/role-mapping=${role}/include=user-${_username}":
    content         => {
      'name'  => $username,
      'realm' => $realm,
      'type'  => 'USER',
    },
    profile         => $target_profile,
    mgmt_user       => $_mgmt_user,
    port_properties => $_port_properties,
    ip_properties   => $_ip_properties,
  }
}
