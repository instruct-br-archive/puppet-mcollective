# Configura um cliente do MCollective
class mcollective::client (
  $broker_pool_hosts,
  $broker_pool_port     = $mcollective::params::broker_pool_port,
  $broker_pool_user     = $mcollective::params::broker_pool_user,
  $broker_pool_password = $mcollective::params::broker_pool_password,
  $mco_loglevel         = $mcollective::params::mco_loglevel,
  Enum['activemq', 'rabbitmq'] $broker_type           = 'rabbitmq',
) inherits mcollective::params {

  if $::kernel != 'Linux' {
    fail('The mcollective client is supported only on Linux')
  }

  File {
    owner => $mcollective::params::file_owner,
    group => $mcollective::params::file_group,
    mode  => '0600',
  }

  file { 'client_cfg':
    ensure  => file,
    path    => "${mcollective::params::mco_cfgdir}/client.cfg",
    content => template('mcollective/common.cfg.erb',
      'mcollective/client.cfg.erb'),
  }

  file { 'client_key_default':
    ensure => file,
    path   => "${mcollective::params::mco_cfgdir}/ssl/clients/client-private.pem",
    source => 'puppet:///modules/mcollective/ssl/client-private.pem',
  }
}
