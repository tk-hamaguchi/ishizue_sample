package 'wget'

execute 'wget https://raw.github.com/bpineau/redis-munin/master/redis_' do
  cwd '/usr/share/munin/plugins/'
  not_if 'ls /usr/share/munin/plugins/redis_'
end

file '/usr/share/munin/plugins/redis_' do
  mode '0755'
end

link '/etc/munin/plugins/redis_127.0.0.1_6379' do
  to '/usr/share/munin/plugins/redis_'
end

file '/etc/munin/plugin-conf.d/munin-node' do
  action :edit
  block do |content|
    content.concat <<-"EOS".gsub(/^ +\|/,'')
      |
      |[redis_*]
      |#env.password ''
    EOS
  end
  not_if 'grep "redis_" /etc/munin/plugin-conf.d/munin-node'
end


