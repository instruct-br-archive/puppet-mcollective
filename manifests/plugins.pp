class mcollective::plugins {

  include ::mcollective::params

  if $::kernel == 'windows' {
    $mode = undef

    acl { $mcollective::params::mco_libdir:
      purge       => true,
      notify      => Service['mcollective'],
      permissions => [
        {
          identity => 'Administrators',
          rights   => ['full'],
        },
        {
          identity => 'Users',
          rights   => ['read','execute'],
        }
      ],
    }

  } else {
    $mode = '0644'
  }

  file { $mcollective::params::mco_libdir:
    ensure => directory,
    mode   => $mode,
  }

  file { 'mcollective_plugins':
    ensure             => directory,
    path               => "${mcollective::params::mco_libdir}/mcollective",
    source             => 'puppet:///modules/mcollective/plugins/mcollective',
    owner              => $mcollective::params::file_owner,
    group              => $mcollective::params::file_group,
    source_permissions => ignore,
    recurse            => true,
    purge              => true,
    mode               => $mode,
  }

}
