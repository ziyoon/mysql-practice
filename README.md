# MySQL with Docker

Docker를 활용하여 데이터베이스 컨테이너를 생성한 뒤 SQL 실습을 진행했다.  

실습은 MySQLWorkbench 툴을 이용, 실습 내용은 다음 링크를 참고 [🔗](www.boostcourse.org/ds102)

## Getting Started

컨테이너 빌드는 Mac M1 칩 환경에서 이루어졌으며, [MySQLWorkbench](https://dev.mysql.com/downloads/workbench/)는 여기에서 다운받을 수 있다.


### Prerequisites
Docker image 다운
```bash
docker pull --platform linux/amd64 mysql:8.0.28
```

디렉토리 구성은 다음과 같다.  
여기서 **./db/data** 파일은 반드시 비워두어야한다.

```
pract-mysql
├── .env
├── data
├── db
│   ├── conf.d
│   │   └── my.cnf
│   ├── data
│   └── initdb.d
│       ├── create_table.sql
│       └── load_data.sql
├── docker-compose.yml
└── script
```
#### .env

DB에 대한 계정 정보를 보안상 .env 파일에 적어두었다.  
.env.sample 파일을 참고하여 작성.

#### ./data

테이블에 들어갈 데이터 저장 디렉토리  
여기 실습에서는 csv 파일을 저장했다.

#### db/conf.d/my.cnf

한글 깨짐을 방지하고 쿼리문으로 추출된 데이터를 파일로 추출하기 위한 설정값 정의

#### db/initdb.d

컨테이너가 생성될 때 실행될 스크립트를 넣어준다.  
이번 실습에서는 컨테이너가 생성될 때 분석에 필요한 테이블을 생성하였다.

#### docker-compose.yml

```yml
version: '3'

services:
  db:
    image: mysql/mysql-server:8.0.29-aarch64
    container_name: local-mysql
    restart: always
    ports:
      - 3306:3306
    volumes:
      - ./db/conf.d/my.cnf:/etc/mysql/my.cnf
      - ./db/data:/var/lib/mysql
      - ./db/initdb.d:/docker-entrypoint-initdb.d
      - ./data:/data
    env_file: .env
    environment:
      TZ: Asia/Seoul
```

### Container build
Create and start containers
```
docker-compose up
```

### Connection (MySQLWorkbench)

<img width="794" alt="스크린샷" src="https://user-images.githubusercontent.com/33509018/185645760-ae0f7a68-a416-4cfa-bfee-e915060879d7.png">

Hostname : .env의 MYSQL_ROOT_HOST 값 입력

Username : .env의 MYSQL_USER 값 입력



## Acknowledgments

* docker compose
* SQL


