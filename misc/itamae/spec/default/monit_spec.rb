require 'spec_helper'

if os[:family] == 'redhat'
  describe package('monit') do
    it { should be_installed }
  end

  describe service('monit') do
    it { should be_enabled }
    it { should be_running }
  end

  describe file('/etc/monitrc') do
    it { should be_file }
  end

  describe file('/etc/monit.d') do
    it { should be_directory }
  end

  describe port(2812) do
    it { should be_listening }
  end

  describe service('sshd') do
    it { should be_monitored_by('monit') }
  end

  describe service('redis') do
    it { should be_monitored_by('monit') }
  end

  describe service('nginx') do
    it { should be_monitored_by('monit') }
  end

  describe service('mariadb') do
    it { should be_monitored_by('monit') }
  end
end
