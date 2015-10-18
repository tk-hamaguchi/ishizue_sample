local_ruby_block 'generate authorized_keys for deploy user' do
  block do
    ssh_keys_path = File.expand_path('../../../../ssh_keys/*',__FILE__)
    ssh_keys      = Dir.glob(ssh_keys_path).inject([]) { |ary, path|
                      ary << File.read(path).strip
                      ary
                    }.join("\n")
    FileUtils.mkdir_p(File.expand_path('../files/home/deploy/.ssh', __FILE__))
    open(File.expand_path('../files/home/deploy/.ssh/authorized_keys', __FILE__), 'w') {|dest|
      dest.write(ssh_keys)
    }
  end
end

group 'rails' do
  gid 3000
end

user 'rails' do
  uid 3000
  gid 3000
  # gem install unix-crypt --no-ri --no-rdoc
  # mkunixcrypt -s `uuidgen | md5 | cut -c 10-25`
  password '$6$d9b839e7d17b72cd$8dBnadwj2wU/tcKQF1COImEgNtCGjrtNxPJWNYiwGvnQyCwb3gYelZgSyMUEid7yX6/igcc6b9lNqJmKvxXsw.'
  home '/var/rails'
end

user 'deploy' do
  uid 3001
  gid 3000
  # gem install unix-crypt --no-ri --no-rdoc
  # mkunixcrypt -s `uuidgen | md5 | cut -c 10-25`
  password '$6$d9b839e7d17b72cd$8dBnadwj2wU/tcKQF1COImEgNtCGjrtNxPJWNYiwGvnQyCwb3gYelZgSyMUEid7yX6/igcc6b9lNqJmKvxXsw.'
end

directory '/home/deploy/.ssh' do
  owner 'deploy'
  group 'rails'
  mode  '700'
end

remote_file '/home/deploy/.ssh/authorized_keys' do
  owner 'deploy'
  group 'rails'
  mode  '600'
end


directory '/home/deploy/.ssh' do
  owner 'deploy'
  group 'rails'
  mode  '700'
end

remote_file '/home/deploy/.ssh/authorized_keys' do
  owner 'deploy'
  group 'rails'
  mode  '600'
end

file '/home/deploy/.bash_profile' do
  action :edit
  block do |content|
    content.concat <<-"EOS".gsub(/^ +\|/,'')
      |umask 002
    EOS
  end
  not_if 'grep "^umask " /home/deploy/.bash_profile'
end

file '/var/rails/.bash_profile' do
  action :edit
  block do |content|
    content.concat <<-"EOS".gsub(/^ +\|/,'')
      |umask 002
    EOS
  end
  not_if 'grep "^umask " /var/rails/.bash_profile'
end

directory '/var/rails' do
  mode '775'
end

execute 'usermod -G rvm rails'
execute 'usermod -G rvm deploy'

