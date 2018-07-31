class mcollective::server (
  $broker_pool_hosts,
  $broker_pool_port     = $mcollective::params::broker_pool_port,
  $broker_pool_user     = $mcollective::params::broker_pool_user,
  $broker_pool_password = $mcollective::params::broker_pool_password,
  $mco_loglevel         = $mcollective::params::mco_loglevel,
  Enum['activemq', 'rabbitmq'] $broker_type           = 'rabbitmq',
) inherits mcollective::params {

  if $::kernel == 'windows' {
    include ::mcollective::server::windows_acls
    $mode = undef
  } else {
    $mode = '0600'
  }

  File {
    source_permissions => ignore,
    mode               => $mode,
  }

  file { 'server_cfg':
    ensure  => file,
    path    => "${mcollective::params::mco_cfgdir}/server.cfg",
    content => template('mcollective/common.cfg.erb',
      'mcollective/server.cfg.erb'),
  }

  file { "${mcollective::params::mco_cfgdir}/ssl":
    ensure => directory,
  }

  file { "${mcollective::params::mco_cfgdir}/ssl/clients":
    ensure => directory,
  }

  file { 'server_crt':
    ensure => file,
    path   => "${mcollective::params::mco_cfgdir}/ssl/server.crt",
    source => 'puppet:///modules/mcollective/ssl/server.crt',
  }

  file { 'server_key':
    ensure => file,
    path   => "${mcollective::params::mco_cfgdir}/ssl/server.key",
    source => 'puppet:///modules/mcollective/ssl/server.key',
  }

  file { 'client_public_default':
    ensure => file,
    path   => "${mcollective::params::mco_cfgdir}/ssl/clients/client-public.pem",
    source => 'puppet:///modules/mcollective/ssl/client-public.pem',
  }

  service { 'mcollective':
    ensure    => running,
    enable    => true,
    subscribe => [
      File['server_crt'],
      File['server_key'],
      File['server_cfg'],
    ],
  }
}
