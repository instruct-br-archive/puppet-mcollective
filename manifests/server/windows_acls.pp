#
class mcollective::server::windows_acls {

  $paths = [
    $mcollective::params::mco_cfgdir,
    "${mcollective::params::mco_cfgdir}/server.cfg",
    "${mcollective::params::mco_cfgdir}/ssl",
    "${mcollective::params::mco_cfgdir}/ssl/clients",
    "${mcollective::params::mco_cfgdir}/ssl/server.crt",
    "${mcollective::params::mco_cfgdir}/ssl/clients/client-public.pem",
  ]

  acl { $paths:
    notify      => Service['mcollective'],
    permissions => [
      {
        identity => 'Administrators',
        rights   => ['full'],
      },
      {
        identity  => 'Users',
        rights    => ['full'],
        perm_type => 'deny',
      }
    ],
  }

}
