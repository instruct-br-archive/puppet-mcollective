class mcollective::params {

  case $::kernel {
    'Linux': {
      $file_owner = 'root'
      $file_group = 'root'
      $cfg_rootdir = '/etc/puppetlabs'
      $puppet_cfgdir = "${cfg_rootdir}/puppet"
      $mco_cfgdir = "${cfg_rootdir}/mcollective"
      $mco_logfile = '/var/log/puppetlabs/mcollective.log'
      $mco_classesfile_path = '/opt/puppetlabs/puppet/cache/state/classes.txt'
      $mco_facts_yaml_path = "${mco_cfgdir}/facts.yaml"
      $puppet_command = '/opt/puppetlabs/puppet/bin/puppet agent'
    }
    'windows': {
      case $::operatingsystemrelease {
        '2003', '2003 R2': {
          $cfg_rootdir = 'c:/Documents and Settings/All Users/Application Data/PuppetLabs'
          $mco_facts_yaml_path = "\"${cfg_rootdir}/mcollective/etc/facts.yaml\""

        }
        '2008', '2008 R2', '2012', '2012 R2', '2016': {
          $cfg_rootdir = 'c:/programdata/PuppetLabs'
          $mco_facts_yaml_path = "${cfg_rootdir}/mcollective/etc/facts.yaml"
        }
        default: {
          fail("Windows ${::operatingsystemrelease} on ${::architecture} is not supported")
        }
      }

      $file_owner = 'Administrator'
      $file_group = 'Administrators'
      $puppet_cfgdir = "${cfg_rootdir}/puppet/etc"
      $mco_cfgdir = "${cfg_rootdir}/mcollective/etc"
      $mco_logfile = "${cfg_rootdir}/mcollective/var/log/mcollective.log"
      $mco_classesfile_path = "${cfg_rootdir}/puppet/cache/state/classes.txt"
      $puppet_command = "\"${::env_windows_installdir}/bin/puppet.bat\" agent"
    }
    default: {
      fail("Kernel ${::kernel} is not supported")
    }
  }

  $mco_loglevel = 'info'
  $mco_identity = $::trusted['certname']
  $mco_libdir = "${mco_cfgdir}/plugins"
  $mco_ssl_client_cert_dir = "${mco_cfgdir}/ssl/clients"
  $mco_ssl_client_private = "${mco_cfgdir}/ssl/clients/client-private.pem"
  $mco_ssl_client_public = "${mco_cfgdir}/ssl/clients/client-public.pem"
  $mco_ssl_server_private = "${mco_cfgdir}/ssl/server.key"
  $mco_ssl_server_public = "${mco_cfgdir}/ssl/server.crt"

  $broker_pool_port = '61614'
  $broker_pool_user = 'mcollective'
  $broker_pool_password = 'marionette'
  $broker_pool_ssl_ca = "${puppet_cfgdir}/ssl/certs/ca.pem"
  $broker_pool_ssl_key = "${puppet_cfgdir}/ssl/private_keys/${::trusted['certname']}.pem"
  $broker_pool_ssl_cert = "${puppet_cfgdir}/ssl/certs/${::trusted['certname']}.pem"

}
