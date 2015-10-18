if node[:platform_family] == 'rhel' && node[:platform_version].to_i == 7
  execute 'timedatectl set-timezone Asia/Tokyo'
else
  file '/etc/sysconfig/clock' do
    action :edit
    block do |content|
      content.concat <<-"EOS".gsub(/^ +\|/,'')
        |ZONE="Asia/Tokyo"
        |UTC="false"
      EOS
    end
  end
  execute 'cp -pf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime'
end

package 'ntp'

if node[:platform_family] == 'rhel' && node[:platform_version].to_i == 7
  service 'ntpd' do
    action :stop
  end
end

execute 'ntpdate ntp.nict.jp'

remote_file '/etc/ntp.conf'

service 'ntpd' do
  action %i(start enable)
end
