require 'spec_helper'
describe 'mcollective', :type => :class do

  on_supported_os.sort.each do |os, facts|
    context "when on #{os} with default values for all parameters" do
      let(:facts) do
        facts
      end
      it { is_expected.to compile }
      it { is_expected.to contain_class('mcollective') }
      it { is_expected.to contain_class('mcollective::params') }
      it { is_expected.to contain_class('mcollective::plugins') }
      it { is_expected.to contain_class('mcollective::facts') }
      it { is_expected.to contain_class('mcollective::server') }
      it { is_expected.not_to contain_class('mcollective::client') }
      it { is_expected.to contain_file('server_cfg').
        with_content(/^plugin.rabbitmq.use_reply_exchange = true$/)
      }
      it { is_expected.to contain_service('mcollective').with({
        'ensure' => 'running',
        'enable' => true,
        })
      }
      end
  end

  on_supported_os.sort.each do |os, facts|
    context "when on #{os} with client enabled" do
      let(:facts) do
        facts
      end
      let(:params) {
        {
          'use_server' => true,
          'use_client' => true,
        }
      }
      it { is_expected.to compile }
      it { is_expected.to contain_class('mcollective') }
      it { is_expected.to contain_class('mcollective::params') }
      it { is_expected.to contain_class('mcollective::plugins') }
      it { is_expected.to contain_class('mcollective::facts') }
      it { is_expected.to contain_class('mcollective::server') }
      it { is_expected.to contain_class('mcollective::client') }
      it { is_expected.to contain_class('mcollective::server') }
      it { is_expected.to contain_class('mcollective::client') }
      it { is_expected.to contain_cron('run_facter') }
      it { is_expected.to contain_file('/etc/puppetlabs/mcollective/ssl') }
      it { is_expected.to contain_file('/etc/puppetlabs/mcollective/ssl/clients') }
      it { is_expected.to contain_file('/etc/puppetlabs/mcollective/plugins') }
      it { is_expected.to contain_file('client_cfg') }
      it { is_expected.to contain_file('client_key_default') }
      it { is_expected.to contain_file('client_public_default') }
      it { is_expected.to contain_file('server_crt') }
      it { is_expected.to contain_file('server_key') }
      it { is_expected.to contain_file('mcollective_plugins') }
      it { is_expected.to contain_file('server_cfg').
        with_content(/^plugin.rabbitmq.use_reply_exchange = true$/)
      }
      it { is_expected.to contain_service('mcollective').with({
        'ensure' => 'running',
        'enable' => true,
        })
      }
      end
  end

  on_supported_os.sort.each do |os, facts|
    context "when on #{os} with pair of RabbitMQ hosts" do
      let(:facts) do
        facts
      end
      let(:params) {
        { :broker_pool_hosts => ['host01', 'host02'] }
      }
      it { is_expected.to compile }
      it { is_expected.to contain_file('server_cfg').
        with_content(/^plugin.rabbitmq.pool.size = 2$/).
        with_content(/^plugin.rabbitmq.pool.1.host = host01$/).
        with_content(/^plugin.rabbitmq.pool.2.host = host02$/)
      }
    end
  end

  on_supported_os.sort.each do |os, facts|
    context "when on #{os} with three ActiveMQ hosts" do
      let(:facts) do
        facts
      end
      let(:params) {
        {
          :broker_pool_hosts => ['host03', 'host04', 'host05'],
          :broker_type => 'activemq'
        }
      }
      it { is_expected.to compile }
      it { is_expected.to contain_file('server_cfg').
        with_content(/^plugin.activemq.pool.size = 3$/).
        with_content(/^plugin.activemq.pool.1.host = host03$/).
        with_content(/^plugin.activemq.pool.2.host = host04$/).
        with_content(/^plugin.activemq.pool.3.host = host05$/).
        without_content(/^plugin.rabbitmq.use_reply_exchange = true$/)
      }
      it { is_expected.to contain_class('mcollective::server') }
      end
  end

end
