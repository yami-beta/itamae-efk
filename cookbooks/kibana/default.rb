execute "kibana_add_repo" do
  command <<-EOS
    wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
    echo "deb http://packages.elastic.co/kibana/4.5/debian stable main" | sudo tee -a /etc/apt/sources.list
    apt-get update
  EOS
end

package "kibana"

execute "kibana_chown" do
  command "chown -R kibana:kibana /opt/kibana"
end

template "/opt/kibana/config/kibana.yml" do
  ownder "kibana"
  group "kibana"
  notifies :restart, "service[kibana]"
end

service "kibana" do
  action [:enable, :start]
end
