require 'spec_helper'

if os[:family] == 'redhat'
  if @node['mariadb'] && @node['mariadb']['version'] && @node['mariadb']['version'].to_f >= 10.0
    describe package('MariaDB-client') do
      it { should be_installed }
    end

    describe package('MariaDB-server') do
      it { should be_installed }
    end

    describe package('MariaDB-devel') do
      it { should be_installed }
    end

    describe service('mysql') do
      it { should be_enabled }
      it { should be_running }
    end
  else

    describe package('mariadb') do
      it { should be_installed }
    end

    describe package('mariadb-server') do
      it { should be_installed }
    end

    describe package('mariadb-devel') do
      it { should be_installed }
    end

    describe service('mariadb') do
      it { should be_enabled }
      it { should be_running }
    end

    describe port(3306) do
      it { should be_listening }
    end
  end

  describe file('/etc/my.cnf') do
    it { should be_file }
  end

  describe file('/var/lib/mariadb') do
    it { should be_directory }
  end

  describe file('/var/run/mariadb') do
    it { should be_directory }
  end

  describe file('/var/log/mariadb') do
    it { should be_directory }
  end
end
