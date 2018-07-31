# Configura o MCollective
class mcollective (
  Array[String]                $broker_pool_hosts,
  String                       $broker_pool_port, #FIXME corrigir o tipo
  String                       $broker_pool_user,
  String                       $broker_pool_password,
  String                       $mco_loglevel,
  Boolean                      $use_server            = true,
  Boolean                      $use_client            = false,
  Enum['activemq', 'rabbitmq'] $broker_type           = 'rabbitmq',
) inherits mcollective::params {

  include ::mcollective::plugins

  if $use_server == true {
    class { '::mcollective::server':
      broker_pool_hosts    => $broker_pool_hosts,
      broker_pool_port     => $broker_pool_port,
      broker_pool_user     => $broker_pool_user,
      broker_pool_password => $broker_pool_password,
      mco_loglevel         => $mco_loglevel,
      broker_type          => $broker_type,
      require              => Class['::mcollective::plugins'],
    }
    include ::mcollective::facts
    # FIXME manter binario do 'mco' disponivel se nao tem cliente?
    # FIXME manter arquivo client.cfg se nao tem cliente?
  }

  if $use_client == true {
    class { '::mcollective::client':
      broker_pool_hosts    => $broker_pool_hosts,
      broker_pool_port     => $broker_pool_port,
      broker_pool_user     => $broker_pool_user,
      broker_pool_password => $broker_pool_password,
      mco_loglevel         => $mco_loglevel,
      broker_type          => $broker_type,
      require              => Class['::mcollective::plugins'],
    }
  }
}
