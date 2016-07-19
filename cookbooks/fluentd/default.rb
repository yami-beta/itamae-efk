execute "install_td-agent" do
  command <<-EOS
    curl -L https://toolbelt.treasuredata.com/sh/install-ubuntu-trusty-td-agent2.sh | sh
    /usr/sbin/td-agent-gem install fluent-plugin-elasticsearch
  EOS
  notifies :restart, "service[td-agent]"
end

execute "td-agent_chown" do
  command "chown -R td-agent:td-agent /etc/td-agent"
end

file "/etc/td-agent/td-agent.conf" do
  owner "td-agent"
  group "td-agent"
end

service "td-agent" do
  action [:enable, :start]
end

