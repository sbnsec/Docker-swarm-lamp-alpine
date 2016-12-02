
https://docs.docker.com/engine/swarm/swarm-tutorial/

Install of docker : 
https://docs.docker.com/engine/installation/linux/debian/



#######################################################

Create virtual ip interface on docker-1 :

# The primary network virtual interface
auto eth0:1
iface eth0:1 inet static
        address 192.168.99.100 
        netmask 255.255.255.0

Rename hostname docker 1 (debian-docker-1) :
/etc/hostname
/etc/hosts
/etc/init.d/hostname.sh


Create virtual ip interface on docker-2 :

# The primary network virtual interface
auto eth0:1
iface eth0:1 inet static
        address 192.168.99.102 
        netmask 255.255.255.0

Rename hostname docker 2 (debian-docker-2) :
/etc/hostname
/etc/hosts
/etc/init.d/hostname.sh


Create virtual ip interface on docker-3 :

# The primary network virtual interface
auto eth0:1
iface eth0:1 inet static
        address 192.168.99.103
        netmask 255.255.255.0

Rename hostname docker 3 (debian-docker-3) :
/etc/hostname
/etc/hosts
/etc/init.d/hostname.sh


#######################################################

Create swarm :

sur debian-docker-1, on créer le manager :

docker swarm init --advertise-addr 192.168.99.100

on peut vérifier avec :
docker info
docker node ls

Pour réobtenir le token pour rejoindre le manager :
docker swarm join-token worker


Sur debian-docker-2 et debian-docker-3 :

docker swarm join \
    --token SWMTKN-1-17wj6jvlb082fj7hw9ue6cswualqja0re3xpq3dwe9z34x66gx-0q7vs5vj1f191qf77amubqioa \
    192.168.99.100:2377



Sur le manager, créer des labels :
	docker node update --label-add city=Paris --label-add shortname=dock-01 debian-docker-1
	docker node update --label-add city=Bordeaux --label-add shortname=dock-02 debian-docker-2
	docker node update --label-add city=Lyon --label-add shortname=dock-03 debian-docker-3
	
Pour supprimer label :
	docker node update --label-rm city debian-docker-2

#######################################################

Lancer un service avec un label spécifié :
	docker service create --replicas 5 --name helloworldLyon  --constraint node.labels.city==Lyon alpine ping docker.com
	

#############################################################

Création du registry privé : (vm009)

Générer les certificats :
sudo mkdir -p /docker/certs && sudo openssl req -newkey rsa:4096 -nodes -sha256 -keyout /docker/certs/domain.key -x509 -days 365 -out /docker/certs/domain.crt
	Country Name (2 letter code) [AU]:FR
	State or Province Name (full name) [Some-State]:Paris
	Locality Name (eg, city) []:Paris
	Organization Name (eg, company) [Internet Widgits Pty Ltd]:ETNA
	Organizational Unit Name (eg, section) []:
	Common Name (e.g. server FQDN or YOUR name) []:myregistrydomain.com
	Email Address []:

sudo mkdir /docker/data

docker run -d -p 5000:5000 --restart=always --name registry \
  -v `pwd`/docker/data:/var/lib/registry \
  -v `pwd`/docker/certs:/certs \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt \
  -e REGISTRY_HTTP_TLS_KEY=/certs/domain.key \
  registry:2


# Sur chaque clients : #
sudo nano /etc/hosts
	192.168.54.9	myregistrydomain.com

copying the domain.crt file to /etc/docker/certs.d/myregistrydomain.com:5000/ca.crt.
	
sudo service docker reload

Pour le supprimer :
docker stop registry && docker rm -v registry



##########################################################
Création des réseau :    (!!! les deux premières addresses d'un réseau sont réservées par l'host !!!)
docker network create \
  --driver overlay \
  --subnet 10.0.9.0/29 \
  network_01

docker network create \
  --driver overlay \
  --subnet 10.0.9.8/29 \
  network_02
  
docker network create \
  --driver overlay \
  --subnet 10.0.9.16/29 \
  network_03

docker service create --name test --network network_02 alpine ping google.fr


##########################################################
Création des containers et push sur le registry :

cd apache
docker build -t "alpine_apache" .
docker tag alpine_apache myregistrydomain.com:5000/alpine_apache
docker push myregistrydomain.com:5000/alpine_apache

cd ../mysql
docker build -t "alpine_mysql" .
docker tag alpine_mysql myregistrydomain.com:5000/alpine_mysql
docker push myregistrydomain.com:5000/alpine_mysql

cd ../wordpress
docker build -t "alpine_wordpress" .
docker tag alpine_wordpress myregistrydomain.com:5000/alpine_wordpress
docker push myregistrydomain.com:5000/alpine_wordpress



##########################################################
Start of the services :

docker service create	--name alpine_mysql \
						--network network_01 \
						-p 3306:3306 \
						--constraint node.labels.city==Paris \
						--mount type=bind,source=/docker/mysql,target=/app \
						--limit-cpu 20 \
						--limit-memory 100000000 \
						myregistrydomain.com:5000/alpine_mysql

docker service create	--name alpine_wordpress \
						--network network_02 \
						-p 80:80 \
						--limit-cpu 20 \
						--limit-memory 100000000 \
						myregistrydomain.com:5000/alpine_wordpress

docker service create	--name alpine_apache \
						--network network_03 \
						--constraint node.labels.city!=Paris \
						-p 8080:80 \
						--limit-cpu 20 \
						--limit-memory 100000000 \
						myregistrydomain.com:5000/alpine_apache

#debug
#docker run -p 3306:3306 -t -i -v /docker/mysql:/app alpine_mysql /bin/sh
## Les mounts possible
#--mount type=volume,source=mysql_data,target=/app/mysql \ # necessite : docker volume create --name mysql_data
#--mount type=bind,source=/docker/mysql,target=/app/mysql \
###########################################################
###########################################################
###########################################################

Commandes utiles :
docker start -t -i 684d38a7de51 /bin/sh
run -dit -p 80:80 alpine_apache

docker images
docker rmi c54a2cc56cbb
docker ps -a
docker attach 684d38a7de51

docker node ls
docker info

Démarer un service dans le swarm :
docker service create --replicas 5 --name spam_docker myregistrydomain.com:5000/alpine ping docker.com

docker service ls
docker service inspect --pretty [service_name]
docker service ps [service_name]
docker service rm [service_name]

lister toutes les instance de tous les service actifs :
docker service ls | grep "/" | cut -f3 -d$' ' | while read ligne ; do docker service ps $ligne | grep -v 'ID'; done

Changer le nombre d'instance :
docker service scale [service_name]=5


Gérer l'état des serveur du cluster :
docker node update --availability drain worker1
docker node update --availability active worker1
docker node inspect --pretty worker1

Gérer le role des nodes :
docker node promote node-3
docker node demote node-3


Enlever un noeud du swarm :
docker swarm leave			(sur le node)
docker node rm node-2		(Sue un manager)

Faire le ménage :
docker rm -v $(docker ps -a -q -f status=exited)
docker rm -v $(docker ps -a -q -f status=created)
docker rmi $(docker images | grep "^<none>" | awk "{print $3}")


Registry :
docker pull alpine
docker tag alpine myregistrydomain.com:5000/alpine
docker push myregistrydomain.com:5000/alpine
docker pull myregistrydomain.com:5000/alpine


Network :
docker network ls 
docker network inspect bridge

docker network create \
  --driver overlay \
  --subnet 10.0.9.0/24 \
  network_01

docker network rm docker_gwbridge




##############################################
##############################################
#################################################################
#################################################################
echo "[i] Installation of openssh"
apk update
apk add openssh
echo -e "root\nroot" | passwd root
rm -rf /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_dsa_key
if [ ! -f "/etc/ssh/ssh_host_rsa_key" ]; then
	# generate fresh rsa key
	ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
fi
if [ ! -f "/etc/ssh/ssh_host_dsa_key" ]; then
	# generate fresh dsa key
	ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa
fi
#prepare run dir
if [ ! -d "/var/run/sshd" ]; then
  mkdir -p /var/run/sshd
fi

timeout 2 /usr/sbin/sshd -D
sed -i 's#\#PermitRootLogin prohibit-password#PermitRootLogin yes#' /etc/ssh/sshd_config
/usr/sbin/sshd -D &

#################################################################
#################################################################

