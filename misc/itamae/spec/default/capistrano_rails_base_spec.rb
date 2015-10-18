require 'spec_helper'

if os[:family] == 'redhat'
  describe group('rails') do
    it { should exist }
    it { should have_gid 3000 }
  end

  describe user('rails') do
    it { should exist }
    it { should belong_to_group 'rails' }
    it { should have_uid 3000 }
    it { should have_home_directory '/var/rails' }
  end

  describe user('deploy') do
    it { should exist }
    it { should belong_to_group 'rails' }
    it { should have_uid 3001 }
    it { should have_home_directory '/home/deploy' }
    it { should have_authorized_key Dir.glob(File.expand_path('../../ssh_keys/*',__FILE__)).inject([]) { |ary, path| ary << File.read(path).strip ; ary }.join("\n") }
  end
end
