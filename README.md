# M300_LB2

NextCloud mit mysql
----------
Vagrantfile:
```
Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/xenial64"

  # Create a public network, which generally matched to bridged network.
  #config.vm.network "public_network"
  config.vm.network "private_network", ip:"192.168.60.101" 
  config.vm.network "forwarded_port", guest:8080, host:8080, auto_correct: true
  
  # Share an additional folder to the guest VM.
  # config.vm.synced_folder "../data", "/vagrant_data"

  config.vm.provider "virtualbox" do |vb|
     vb.memory = "2048"
  end

  # Docker Provisioner
  config.vm.provision "docker" do |d|
   d.pull_images "mysql"
   d.pull_images "nextcloud"
   d.run "nextcloud_mysql", image: "mysql", args: "-e MYSQL_ROOT_PASSWORD=secret -e MYSQL_USER=nextcloud -e MYSQL_PASSWORD=secret -e MYSQL_DATABASE=nextcloud --restart=always"
   d.run "nextcloud", image: "nextcloud", args: "--link nextcloud_mysql:mysql -p 8080:80 --restart=always"
  end
end

```
Ich habe 2 Images verwendet. Das erste Image ist mysql und das 2. Image ist nextcloud.
Anschliessend wird mysql ausgeführt. Es werden folgende Paramter verwendet:
* MYSQL_ROOT_PASSWORD=secret
* MYSQL_USER=nextcloud
* MYSQL_PASSWORD=secret
* MYSQL_DATABASE=nextcloud

Für den nextcloud Container habe ich folgende Paramter verwendet:
* --link nextcloud_mysql:mysql
* -p 8080:80
* --restart=always


Webmin
---------
Webmin ist eine webbasierte Schnittstelle zur Systemadministration für Unix. Mit jedem modernen Webbrowser können Sie Benutzerkonten, Apache, DNS, File Sharing und vieles mehr einrichten. Webmin macht es überflüssig, Unix-Konfigurationsdateien wie /etc/passwd manuell zu bearbeiten, und lässt Sie ein System von der Konsole aus oder aus der Ferne verwalten. 

### Dockerfile
```
FROM ubuntu:16.04
MAINTAINER Tim Rhomberg <timrhomberg@hotmail.com>
```
Als erstes wird ein Update der Paketquellen durchgeführt und das Webmin Repository in die Datei /etc/apt/sources.list.
```
RUN apt-get -qq update
RUN apt-get -y -qq install wget
RUN sed -i '$adeb https://download.webmin.com/download/repository sarge contrib' /etc/apt/sources.list
RUN cd /root
```
Danach wird der Key des Repository heruntergeladen und hinzugefügt.
```
RUN wget http://www.webmin.com/jcameron-key.asc
RUN apt-key add jcameron-key.asc
```
Anschliessend wird das Paket apt-transport-https installiert um ein HTTPS Repository hinzuzufügen.
```
RUN apt-get -y -qq install apt-transport-https
```
Installation von Webmin.
```
RUN apt-get -qq update
RUN apt-get -y install apt-utils
RUN rm /etc/apt/apt.conf.d/docker-gzip-indexes
RUN apt-get purge apt-show-versions
RUN rm /var/lib/apt/lists/*lz4
RUN apt-get -o Acquire::GzipIndexes=false update
RUN apt-get -y install apt-show-versions
RUN apt-get -y install webmin
```
Healthcheck alle 5 Minuten auf die Webmin Oberfläche.
```
HEALTHCHECK --interval=5m --timeout=3s CMD curl -f https://localhost:10000 || exit 1
```
Der Port 10000 sollte freigegeben werden.
```
EXPOSE 10000
```
Beim Starten des Container sollte folgendes ausgeführt werden.
```
CMD /usr/bin/touch /var/webmin/miniserv.log && /usr/sbin/service webmin restart && /usr/bin/tail -f /var/webmin/miniserv.log
```

### Container starten
```
docker build -t webmin .
docker run -d -p 1000:443  --name webmin webmin
```
