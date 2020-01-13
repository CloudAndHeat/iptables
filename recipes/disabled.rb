#
# Cookbook:: iptables
# Recipe:: default
#
# Copyright:: 2008-2019, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'iptables::_package'

service 'netfilter-persistent' do
  action [:disable, :stop]
  delayed_action :stop
end if platform_family?('debian')

%w(iptables ip6tables).each do |ipt|
  service ipt do
    action [:disable, :stop]
    delayed_action :stop
    supports status: true, start: true, stop: true, restart: true
  end if platform_family?('rhel', 'fedora', 'amazon')

  execute "flush #{ipt}" do
    command "#{ipt} -F"
    action :nothing
  end

  file node['iptables']["persisted_rules_#{ipt}"] do
    content '# iptables rules files cleared by chef via iptables::disabled'
    notifies :run, "execute[flush #{ipt}]", :immediately
  end
end
