cd /etc
# Para instalações anteriores
sudo rm -rf elasticsearch/
sudo rm -rf kibana/
sudo rm -rf logstash/

# Config Elasticsearch
sudo wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.4.0.tar.gz
sudo tar -zxvf elasticsearch-6.4.0.tar.gz
sudo rm -rf elasticsearch-6.4.0.tar.gz
sudo ln -s elasticsearch-6.4.0/ elasticsearch
sudo chown -R hduser:hadoopgroup elasticsearch
sudo chown -R hduser:hadoopgroup elasticsearch-6.4.0/

# Config Kibana
sudo wget https://artifacts.elastic.co/downloads/kibana/kibana-6.4.0-linux-x86_64.tar.gz
sudo tar -zxvf kibana-6.4.0-linux-x86_64.tar.gz
sudo rm -rf kibana-6.4.0-linux-x86_64.tar.gz
sudo ln -s kibana-6.4.0-linux-x86_64/ kibana
sudo chown -R hduser:hadoopgroup kibana
sudo chown -R hduser:hadoopgroup kibana-6.4.0-linux-x86_64/

sed -i 's/#server\.name/server\.name/g' /etc/kibana/config/kibana.yml
sed -i 's/your-hostname/localhost/g' /etc/kibana/config/kibana.yml
sed -i 's/#elasticsearch\.url/elasticsearch\.url/g' /etc/kibana/config/kibana.yml

# Config Logstash
sudo wget https://artifacts.elastic.co/downloads/logstash/logstash-6.4.0.zip
sudo unzip logstash-6.4.0.zip
sudo rm -rf logstash-6.4.0.zip
sudo ln -s logstash-6.4.0/ logstash
sudo chown -R hduser:hadoopgroup logstash
sudo chown -R hduser:hadoopgroup logstash-6.4.0/

# Volta para o diretório corrente
cd ~

echo "\n" >> .bashrc
echo "#Some helpful aliases" >> .bashrc
echo "alias start-logstash=/etc/logstash/bin/logstash" >> .bashrc
echo "alias start-kibana=/etc/kibana/bin/kibana" >> .bashrc
echo "alias start-elasticsearch=/etc/elasticsearch/bin/elasticsearch" >> .bashrc

source .bashrc

# Mensagem para o usuário
echo "Após a instalação, reabra o terminal antes de prosseguir."
echo "Ou execute o comando abaixo:"
echo "source ."
