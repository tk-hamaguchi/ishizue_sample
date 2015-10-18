require 'spec_helper'

if os[:family] == 'redhat'
  describe selinux do
    it { should be_disabled }
  end
end
