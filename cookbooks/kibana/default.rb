# nodejs
execute "nodejs_pre_setup" do
  command "curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -"
end

package "nodejs"

execute "install_forever" do
  command "npm install -g forever"
  not_if "npm ls -g forever"
end


# kibana
node.reverse_merge!(
  kibana: {
    filename: "kibana-4.3.0-linux-x64.tar.gz",
    url: "https://download.elastic.co/kibana/kibana",
    install_dir: "/opt/kibana",
    tmp_dir: "/tmp/kibana",
  }
)

directory "#{node[:kibana][:tmp_dir]}" do
  action :create
end

remote_file "#{node[:kibana][:tmp_dir]}/#{node[:kibana][:filename]}"

execute "get_kibana" do
  command "wget #{node[:kibana][:url]}/#{node[:kibana][:filename]}"
  cwd node[:kibana][:tmp_dir]
  not_if "test -f #{node[:kibana][:tmp_dir]}/#{node[:kibana][:filename]}"
end

directory "#{node[:kibana][:install_dir]}"

execute "extract_kibana" do
  command "tar zxf #{node[:kibana][:filename]} -C #{node[:kibana][:install_dir]} --strip-components 1"
  cwd node[:kibana][:tmp_dir]
  only_if "test -d #{node[:kibana][:install_dir]}"
  not_if "test -f #{node[:kibana][:install_dir]}/bin/kibana"
end

execute "install_sense_plugin" do
  command "bin/kibana plugin --install elastic/sense"
  cwd node[:kibana][:install_dir]
  notifies :restart, "service[kibana]"
  not_if "test -d #{node[:kibana][:install_dir]}/installedPlugins/sense"
end

template "/etc/init.d/kibana" do
  mode "755"
  owner "root"
  group "root"
end

template "#{node[:kibana][:install_dir]}/config/kibana.yml" do
  source "templates/kibana.yml.erb"
  notifies :restart, "service[kibana]"
end

service "kibana" do
  action [:enable, :start]
end

