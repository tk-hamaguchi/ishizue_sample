require 'spec_helper'

if os[:family] == 'redhat'
  describe package('redis') do
    it { should be_installed }
  end

  describe service('redis') do
    it { should be_enabled }
    it { should be_running }
  end

  describe file('/var/log/redis') do
    it { should be_directory }
  end

  describe port(6379) do
    it { should be_listening }
  end
end
