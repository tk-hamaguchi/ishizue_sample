require 'fileutils'

local_ruby_block "greeting" do
  block do
    ssh_keys_path = File.expand_path('../../../../ssh_keys/*',__FILE__)
    ssh_keys      = Dir.glob(ssh_keys_path).inject([]) { |ary, path|
                      ary << File.read(path).strip
                      ary
                    }.join("\n")
    FileUtils.mkdir_p(File.expand_path('../files/root/.ssh', __FILE__))
    open(File.expand_path('../files/root/.ssh/authorized_keys', __FILE__), 'w') {|dest|
      dest.write(ssh_keys)
    }
  end
end


directory '/root/.ssh' do
  owner 'root'
  group 'root'
  mode  '700'
end

remote_file '/root/.ssh/authorized_keys' do
  owner 'root'
  group 'root'
  mode  '600'
end

