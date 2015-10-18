require 'spec_helper'

if os[:family] == 'redhat'
  describe package('nginx') do
    it { should be_installed }
  end

  describe service('nginx') do
    it { should be_enabled }
    it { should be_running }
  end

  describe file('/etc/nginx/conf.d/server_status.conf') do
    it { should be_file }
  end

  describe file('/var/log/nginx') do
    it { should be_directory }
  end

  describe port(80) do
    it { should be_listening }
  end

  describe port(8080) do
    it { should be_listening }
  end
end
