package "software-properties-common"

execute "openjdk_repo" do
  command <<-EOS
    add-apt-repository -y ppa:openjdk-r/ppa
    apt-get update
  EOS
end

package "openjdk-8-jdk"

execute "elasticsearch_apt-key_add" do
  command <<-EOS
    wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | apt-key add -
    echo 'deb http://packages.elastic.co/elasticsearch/2.x/debian stable main' | tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list
    apt-get update
  EOS
  cwd '/tmp'
  not_if "test -f /etc/apt/sources.list.d/elasticsearch-2.x.list"
end

package "elasticsearch"

service "elasticsearch" do
  action [:enable, :start]
end
