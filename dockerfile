# MySQL dockerfile

FROM mysql/mysql-server:8.0.28-1.2.7-server

WORKDIR /var/lib/mysql




#### run commend

# docker pull mysql:8.0.17
# docker run --name=mysql --restart on-failure -v $(pwd):/mysql -d mysql/mysql-server:8.0.28-1.2.7-server