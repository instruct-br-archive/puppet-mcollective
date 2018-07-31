# Internal.
#
# @summary Installs a periodic task to generate nodes facts
#
# @example
#   include mcollective::facts
class mcollective::facts {

  include ::mcollective::params

  case $::kernel {
    'windows': {

      $start_time = fqdn_rand(30)

      scheduled_task { 'run_facter':
        ensure    => present,
        enabled   => true,
        command   => 'c:\Windows\System32\cmd.exe',
        arguments => "/S /C \"\"${::env_windows_installdir}\\bin\\facter.bat\" -p --show-legacy -y > ${mcollective::params::facts_yaml_path}\"", #lint:ignore:140chars
        trigger   => {
          schedule         => 'daily',
          start_time       => "00:${start_time}",
          minutes_interval => '30',
        },
      }
    }
    'Linux': {
      cron { 'run_facter':
        command  => "export LC_ALL='en_US.UTF-8' && /opt/puppetlabs/bin/facter -p --show-legacy -y > /etc/puppetlabs/mcollective/facts.yaml", #lint:ignore:140chars
        user     => 'root',
        month    => '*',
        monthday => '*',
        hour     => '*',
        minute   => '*/30',
      }
    }
    default: {
      fail("Operating System ${::kernel} is not supported")
    }
  }
}
