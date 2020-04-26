[A Docker Tutorial for Beginners](https://docker-curriculum.com/#dockerfile)  문서 정리본



```shell
# <컴퓨터 설정>
# 도커 설치 테스트
docker run hello-world

# <Busybox로 재생>
# 시스템에서 busybox 컨테이너 실행
# 도커 레지스트리에서 busybox 이미지를 가져와 시스템에 저장
docker pull busybox
# 시스템의 모든 이미지 목록 보기
docker images

# <docker run>
# 이미지 기반으로 도커 컨테이너 실행
docker run busybox
# Docker 클라이언트가 busybox 컨테이너에서 echo 명령을 실행한 후 종료
docker run busybox echo 'hello from busybox'
# 현재 실행중인 모든 컨테이너 보기
docker ps
# 실행한 모든 컨테이너 목록
# 실행하여 종료한 후에도 컨테이너의 잔재를 볼 수 있음
docker ps -a

# 컨테이너의 대화식 tty에 연결
docker run -it busybox sh
/ # ls
/ # uptime

# 컨테이너를 다 사용한 후 컨테이너 정리
docker rm 305297d7a235 ff0a5c3750b9

# 종료 상태인 모든 컨테이너 삭제
# -q: 제공된 조건에 따라 숫자 ID와 -f 필터 출력만 반환
docker rm $(docker ps -a -q -f status=exited)
# 동일한 효과
docker container prune

# <정적 사이트>
# (데모를 위해 미리 만들어 단일 레지스트리(prakhar1989/static-site)에서 호스팅한) 단일 페이지 웹사이트 이미지
# 한번에 이미지를 직접 다운로드하고 실행
# --rm: 컨테이너가 종료될 때 컨테이너를 자동으로 제거
docker run --rm prakhar1989/static-site

# -d: 터미널 분리
# -P: 노출된 모든 포트를 임의의 포트에 게시
# --name: 제공하려는 이름
docker run -d -P --name static-site prakhar1989/static-site

# 포트 보기
docker port static-site
# 클라이언트가 컨테이너로 연결을 전달할 사용자정의 포트 지정
docker run -p 8888:80 prakhar1989/static-site
# 분리된 컨테이너 중지
docker stop static-site

# <도커 이미지>
# 로컬로 사용 가능한 이미지 목록 보기
docker images
# 특정 버전의 우분투 이미지 가져오기
docker pull ubuntu:18.04

# <첫 이미지>
# 간단한 Flask 응용 프로그램을 샌드 박스로 만드는 이미지 만들기
# 저장소를 로컬로 복제
git clone https://github.com/prakhar1989/docker-curriculum.gi
cd docker-curriculum/flask-app
```

```dockerfile
# <Dockerfile>
# 이미지를 생성하는 동안 Docker 클라이언트가 호출하는 명령 목록이 포함된 간단한 텍스트 파일
# FROM: 기본 이미지 지정
FROM python:3

# 앱의 디렉토리 설정
WORKDIR /user/src/app

# 모든 파일을 컨테이너에 복사
COPY . .

# 의존성 설치
RUN pip install --no-cache-dir -r requirements.txt

# 컨테이너가 노출해야하는 포트 번호 정의
EXPOSE 5000

# 명령 실행
CMD ["python", "./app.py"]
```

```shell
# 이미지 빌드
# -t: 선택적인 태그 이름과 Dockerfile을 포함하는 디렉토리의 위치를 사용
docker build -t yourusername/catnip .
# 이미지를 실행하고 실제로 작동하는지 확인
docker run -p 8888:5000 yourusername/catnip

# <AWS의 도커>
# 응용 프로그램을 클라우드에 배포하여 공유
# 몇 번의 클릭만으로 AWS Elastic Beanstalk를 사용하여 애플리케이션을 시작하고 실행

# <Docker push>
# 앱을 AWS에 배포하기 전, AWS에서 액세스할 수 있는 레지스트리 Docker Hub에 이미지를 게시
# 처음으로 이미지를 푸시하는 경우 클라이언트가 로그인을 요청
docker login
# 클라이언트가 게시 위치를 알 수 있도록 yourusername/image_name 형식
docker push yourusername/catnip
# 온라인 상태의 이미지에서 앱 사용
docker run -p 8888:5000 yourusername/catnip
```

```shell
# <Beanstalk>
# AWS에서 제공하는 PaaS (Platform as a Service)
# 2014 년 4월, EB는 단일 컨테이너 Docker 배포를 실행하기 위한 지원을 추가

# <SF Food Trucks 앱 Dockerize>
# Flask 백엔드 서버와 Elasticsearch 서비스로 구성
# Flask 프로세스를 실행하는 컨테이너와 Elasticsearch(ES) 프로세스를 실행하는 컨테이너 두개를 사용
# 리포지토리를 로컬로 복제
git clone https://github.com/prakhar1989/FoodTrucks
cd FoodTrucks
tree -L 2

# 이미 이전 섹션에서 자체 Flask 컨테이너를 만듦
# Elasticsearch의 경우 허브에서 무엇을 찾을 수 있는지 살펴보기
docker search elasticsearch
# 이미지 pull
docker pull docker.elastic.co/elasticsearch/elasticsearch:6.3.2

# 포트 지정, Elasticsearch 클러스터를 단일 노드로 실행하도록 구성하는 환경변수 설정, 개발 모드에서 실행
# --name: 컨테이너에 이름을 지정해 후속 명령에서 쉽게 사용
docker run -d --name es -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:6.3.2

# 컨테이너가 시작되면 로그를 검사해 로그 보기
docker container ls
docker container logs es

# Elasticsearch 컨테이너에 요청을 보낼 수 있는지 살펴보기
# 컨테이너에 cURL 요청을 보내기 위해 9200 포트 사용
curl 0.0.0.0:9200
```

```dockerfile
# 애플리케이션에서 프로덕션을 위해 축소된 Javascript 파일을 생성하기를 원하고, 이를 위해서는 Nodejs가 필요
# 커스텀 빌드 단계가 필요하기 때문에, 우분투 기본 이미지부터 Dockerfile을 처음부터 빌드
# 우분투 LTS 기본 이미지로 시작
FROM ubuntu:lastest

MAINTAINER Prakhar Srivastav <prakhar@prakhar.me>

# 패키지 관리자 apt-get을 사용해 의존성(Python과 Node) 설치
# 파이썬과 노드를 위한 시스템 차원의 dep 설치
# -yqq: 출력을 억제하는 데 사용, 모든 프롬프트에 "예"라고 가정
RUN apt-get -yqq update
RUN apt-get -yqq install python-pip python-dev curl gnupg
RUN crul -sL https://deb.nodesource.com/setup_10.x | bash
RUN apt-get install -yq nodejs

# 응용 프로그램 코드 복사
# ADD: /opt/flask-app 컨테이너의 새 볼륨에 응용 프로그램을 복사(코드가 있는 곳)
ADD flask-app /opt/flask-app
# 작업 디렉토리로 설정해 이 위치의 컨텍스트에서 다음 명령이 실행되도록 함
WORKDIR /opt/flask-app

# 시스템 전체의 종속성이 설치되었고, 이제 앱별 종속성 설치
# 앱 특정 dep 가져오기
# npm에서 패키지 설치하고 package.json 파일에 정의된대로 빌드 명령을 실행해 노드 해결
RUN npm install
RUN npm run build
RUN pip install -r requirements.txt

# 포트 노출
EXPOSE 5000

# DMD 정의하여 앱 실행 
CMD ["python", "./app.py"]
```

```shell
# 이미지 만들고 컨테이너 실행
docker build -t yourusername/foodtrucks-web .

# 앱 실행
# 플라스크 앱이 Elasticsearch에 연결할 수 없어서 실행할 수 없음
docker run -P --rm yourusername/foodtrucks-web

# <Docker Network>
# 한 컨테이너에 다른 컨테이너에 대해 알리고 서로 대화하도록 설정
# docker ps와 동일
docker container ls
```

```python
# Flask 컨테이너에 ES 컨테이너가 0.0.0.0 호스트(기본포트는 9200)에서 실행중이고 작동해야 한다고 알려줘야 함
es = Elasticsearch(host='es')
```

```shell
# 도커에서 네트워킹 탐색
# 도커가 설치되면 3개의 네트워크가 자동으로 생성
docker network ls

# bridge 네트워크 검사
# bridge: 기본적으로 컨테이너가 실행되는 네트워크
# ES 컨테이너를 실행할 때 실행되고 있던 곳
docker network inspect bridge

# Flask 컨테이너를 실행하고 IP에 액세스
# bash: 대화식 모드에서 컨테이너 시작
# --rm: 작업이 완료되면 컨테이너가 정리되므로 일회용 명령을 실행하기 위한 플래그
docker run -it --rm prakhar1989/foodtrucks-web bash
# 컬을 시도하지만 먼저 설치해야 함
root@35180ccc206a:/opt/flask-app# curl 172.17.0.2:9200
root@35180ccc206a:/opt/flask-app# exit

# 네트워크 만들기
# 격리된 상태로 유지하면서 자체 네트워크를 정의할 수 있음
docker network create foodtrucks-net
docker network ls

# 브리지 (기본) 네트워크에서 실행중인 ES 컨테이너를 중지하고 제거
docker container stop es
docker container rm es

# --net: 해당 네트워크 내에서 컨테이너 시작
docker run -d --name es --net foodtrucks-net -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:6.3.2
# ES 컨테이너가 foodtrucks-net bridge 네트워크 내부에서 실행중
docker network inspect foodtrucks-net

# foddtrucks-net 네트워크에서 런칭
docker run -it --rm --net foodtrucks-net prakhar1989/foodtrucks-web bash
root@9d2722cf282c:/opt/flask-app# curl es:9200
root@9d2722cf282c:/opt/flask-app# ls
root@9d2722cf282c:/opt/flask-app# python app.py
root@9d2722cf282c:/opt/flask-app# exit

# Flask 컨테이너 출시
docker run -d --net foodtrucks-net -p 5000:5000 --name foodtrucks-web prakhar1989/foodtrucks-web
docker container ls
curl -I 0.0.0.0:5000
```

```sh
# bash 스크립트에서 명령 대조
#!/bin/bash

# Flask 컨테이너 빌드
docker build -t prakhar1989/foodtrucks-web .

# 네트워크 만들기
docker network create foodtrucks-net

# ES 컨테이너 시작
docker run -d --name es --net foodtrucks-net -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:6.3.2

# Flask 앱 컨테이너 시작
docker run -d --net foodtrucks-net -p 5000:5000 --name foodtrucks-web prkhar1989/foodtrucks-web
```

```shell
# 전체 앱 실행
git clone https://github.com/prakhar1989/FoodTrucks
cd FoodTrucks
./setup-docker.sh

# <Docker Compose>
# Docker와 매우 잘 작동하는 오픈소스 도구 중 하나
# 다중 컨테이너 Docker 애플리케이션 정의 및 실행
# 설치 테스트
docker-compose --version
```

```yml
# Docker Compose 파일 docker-compose.yml
version: "3"
services:
	# 부모 수준에서 서비스 이름(es, web) 정의
	es:
		# Docker를 실행해야하는 각 서비스에 대해 필요한 image에서 추가 매개변수 추가
		# Elastic registry에서 사용가능한 elasticsearch 이미지만 참조
		image: docker.elastic.co/elasticsearch/elasticsearch:6.3.2
		container_name: es
		environment:
			- discovery.type=single-node
		ports:
			- 9200:9200
		# 웹 컨테이너에서 코드가 상주할 마운트 포인트 지정
		# 선택 사항, 로그 등에 액세스 해야하는 경우 유용
		volumes:
			- esdata1:/user/share/elasticsearch/data
	web:
		image: prakhar1989/foodtrucks-web
		command: python app.py
		# 도커가 웹보다 먼저 es 컨테이너를 시작하도록 지시
		depends_on:
			- es
		ports:
			- 5000:5000
		volumes:
			- ./flask-app:/opt/flask-app
volumes:
	esdata1:
		driver: local
```

```shell
# docker-compose가 작동하는 것을 보기 전 포트와 이름이 비어 있는지 확인
# Flask 및 ES 컨테이너가 실행 중이면 해제
docker stop es foodtrucks-web
docker rm es foodtrucks-web

# food trucks 디렉토리로 이동해 docker-compose 실행
docker-compose up
# 분리 모드에서 다시 실행
docker-compose up -d
docker-compose ps

# 클러스터와 데이터 볼륨 제거
# 데이터 볼륨이 유지되므로 docker-compose up을 사용해 동일한 데이터로 클러스터를 다시 시작 가능
docker-compose down -v

# foodtrucks 네트워크 제거
docker network rm foodtrucks-net
docker network ls

# 서비스 다시 실행
docker-compose up -d
docker container ls
# 네트워크 생성되었는지 확인
# foodtrucks_default라는 새 네트워크 생성
docker network ls

# 해당 네트워크에 새 서비스가 모두 첨부되어 각 서비스가 서로 검색 가능하다는 것을 확인
docker ps
docker network inspect foodtrucks_default
```
