[초보를 위한 도커 안내서](https://subicura.com/2017/01/19/docker-guide-for-beginners-1.html) 정리본

# Docker

## 서버를 관리한다는 것

서버는 최대한 건드리지 않고 그대로 두는게 좋음

회사에서 사용하는 (리눅스, 오라클 등) 버전은 정해져 있기 때문에 버전을 업데이트 하는 건 엄청난 리스크



서버 관리의 어려움

- 리눅스 배포판이 바뀌거나 환경이 달라지는 경우
- 하나의 서버에 여러 개의 프로그램을 설치하는 경우
  - 서로 사용하는 라이브러리의 버전이 다른 경우
  - 동일한 포트를 사용하는 경우
  - 서로 다른 서버에 설치하면 조립 PC가 늘어나 자원 낭비
- 시간이 흐르면서 서버 환경이 계속 바뀜
  - 예: CentOS -> Ubuntu, AWS -> Azure, Chef의 cookbook -> Ansible의 playbook
  - DevOps의 등장
    - 개발 주기가 짧아지면서 배포가 더 자주 이루어짐
  - 마이크로서비스 아키텍쳐의 유행
    - 프로그램을 더 잘게 쪼개어 관리



새로운 툴은 계속해서 나오고, 클라우드의 발전으로 설치해야 할 서버가 엄청나게 많아짐

- *도커(Docker)의 등장으로 서버관리 방식이 완전히 바뀌게 됨*



## 도커의 역사

2016년 한 설문조사에 따르면,

- 90%가 개발에 사용 중
- 80%가 DevOps에 사용할 예정
- 58%가 운영환경에서 사용 중



## 도커란?

컨테이너 기반의 오픈소스 가상화 플랫폼

완전히 새로운 기술이 아니며, 이미 존재하는 기술을 잘 포장한 것

컨테이너, 오버레이 네트워크(overlay network), 유니온 파일 시스템(union file systems), 등 이미 존재하는 기술을 잘 조합하고 사용하기 쉽게 만듦

사용자가 원하는 기능을 간단하지만 획기적인 아이디어로 구현



컨테이너

- 배에 실는 네모난 화물 수송용 박스
- 각각의 컨테이너 안에 옷, 신발, 전자제품, 술, 과일 등 다양한 화물을 넣을 수 있음
- 규격화되어 선이나 트레일러 등 다양한 운송수단으로 쉽게 옮길 수 있음

서버에서 컨테이너

- 다양한 프로그램, 실행환경을 컨테이너로 추상화
  - 프로그램: 백엔드 프로그램, 데이터베이스 서버, 메시지 큐, 등
  - 실행환경: 조립 PC, AWS, Azure, Google Cloud, 등
- 동일한 인터페이스를 제공하여 프로그램의 배포 및 관리를 단순하게 해줌
- (컨테이너를 가장 잘 사용하고 있는 기업인) 구글의 경우, 모든 서비스들이 컨테이너로 동작하고 매주 20억 개의 컨테이너를 구동 (2014년 발표)



### 컨테이너(Container)

격리된 공간에서 프로세스가 동작하는 기술

가상화 기술의 하나

도커가 처음 만든 것은 아님

- 리눅스의 LXC(Linux container): cgroups(control groups)와 namespace를 이용
  - 도커는 LXC를 기반으로 시작
- FreeBSD의 Jail
- Solaris의 Solaris Zones
- 구글의 Imctfy(Let Me Contain That For You): 직접 오픈소스 컨테이너 기술 개발 (성공하지는 못했음)

이미지를 실행한 상태

추가되거나 변하는 값은 컨테이너에 저장됨

종료되어도 삭제되지 않고 남아있음

- 종료된 건 다시 시작할 수 있고, 컨테이너의 읽기/쓰기 레이어는 그대로 존재
- 명시적인 삭제로 컨테이너 제거



가상머신(VM)

- OS를 가상화 (기존 가상화 방식)
- 호스트 OS 위에 게스트 OS 전체를 가상화하여 사용
- (리눅스에서 윈도우를 돌리는 등) 여러가지 OS를 가상화할 수 있고, 비교적 사용법이 간단함
- 무겁고 느려서 운영환경에선 사용할 수 없음
- 이를 개선하기 위해 KVM과 Xen 등장
  - KVM: Kernel-based Virtual Machine, CPU의 가상화 기술(HVM)을 이용
  - Xen: 반가상화(Paravirtualization) 방식
  - 게스트 OS가 필요하긴 하지만, 전체 OS를 가상화하는 방식이 아니였기 때문에 호스트형 가상화 방식에 비해 성능 향상
  - OpenStack이나 AWS, Rackspace 같은 클라우드 서비스에서 가상 컴퓨팅 기술의 기반

도커(Docker)

- 추가적인 OS를 설치하여 가상화하는 방법(전가상화, 반가상화)은 성능 문제가 있음
- 이를 개선하기 위해 프로세스를 격리하는 방식 등장

  - 리눅스에서는 리눅스 컨테이너라고 함

  - 단순히 프로세스를 격리시키기 때문에 가볍고 빠르게 동작
- CPU나 메모리는 딱 프로세스가 필요한 만큼만 추가로 사용하기 때문에 성능 손실이 거의 없음
  - 기본 네트워크 모드는 `Brige` 모드로 약간의 성능 손실이 있음
  - 네트워크 성능이 중요한 프로그램의 경우 `-net=host` 옵션 고려
- 하나의 서버에 여러 개의 컨테이너를 실행하면 서로 영향을 미치지 않고 독립적으로 실행되어 가벼운 VM을 사용하는 느낌을 줌
- 실행 중인 컨테이너에 접속

  - 명령어 입력
  - 패키지 설치 (`apt-get`이나 `yum`으로)
  - 사용자 추가
  - 여러 개의 프로세스를 백그라운드로 실행
  - CPU나 메모리 사용량 제한
  - 호스트의 특정 포트와 연결하거나 호스트의 특정 디렉토리를 내부 디렉토리인 것처럼 사용
- 새로운 컨테이너를 만드는 데 걸리는 시간은 1~2초로, 가상머신과 비교도 할 수 없이 빠름
- 0.9 버전에서 자체적인 libcontainer 기술을 사용, 추후 runC 기술에 합쳐짐



### 이미지(Image)

컨테이너 실행에 필요한 파일과 설정값 등을 포함하고 있는 것

상태값을 가지지 않고 변하지 않음(immutable)

같은 이미지에서 여러 개의 컨테이너를 생성할 수 있음

- 한 서버든 수천 대의 서버든 컨테이너를 실행하는데 문제 없음

컨테이너의 상태가 바뀌거나 컨테이너가 삭제되어도 이미지는 변하지 않고 그대로 남아있음

컨테이너를 실행하기 위한 모든 정보를 갖고 있음

- ubuntu 이미지는 ubuntu를 실행하기 위한 모든 파일을 갖고 있음

- MySQL 이미지는 debian 기반으로 MySQL을 실행하는데 필요한 파일과 실행 명령어, 포트 정보 등을 갖고 있음

- Gitlab 이미지는 centos 기반으로 ruby, go, database, redis, gitlab source, nginx 등을 갖고 있음
- 더이상 의존성 파일을 컴파일하고 이것저것 설치가 필요 없음
- 새로운 서버가 추가되면 미리 만들어 놓은 이미지를 다운받고 컨테이너를 생성하기만 하면 됨



도커 이미지

- Docker hub에 등록하거나 Docker Registry 저장소를 직접 만들어 관리할 수 있음
- 누구나 쉽게 이미지를 만들고 배포할 수 있음



## 레이어 저장방식

도커 이미지는 컨테이너를 실행하기 위한 모든 정보를 갖고 있기 때문에 보통 용량이 수백MB에 이름

기존 이미지에 파일 하나를 추가했다고 수백MB를 다시 다운받는 것은 매우 비효율적

이를 해결하기 위해 **레이어(layer)** 라는 개념을 사용

- 유니온 파일 시스템을 이용
- 여러 개의 레이어를 하나의 파일 시스템으로 사용할 수 있게 해줌
- 이미지는 여러 개의 읽기 전용 레이어로 구성되고, 파일이 추가되거나 수정되면 새로운 레이어가 생성
  - ubuntu 이미지가 `A` + `B` + `C`의 집합이라면, ubuntu 이미지를 베이스로 만든 nginx의 이미지는 `A` + `B` + `C` + `nginx`
  - webapp 이미지를 nginx 이미지 기반으로 만들었다면, `A` + `B` + `C` + `nginx` + `source` 레이어로 구성
  - webapp 소스를 수정하면 `A` + `B` + `C` + `nginx` 레이어를 제외한 새로운 `source(v2)` 레이어만 다운받으면 됨
- 컨테이너를 생성할 때도 레이어 방식을 사용
  - 기존의 이미지 레이어 위에 읽기/쓰기 레이어를 추가
  - 이미지 레이어를 그대로 사용하면서 컨테이너가 실행 중에 생성하는 파일이나 변경된 내용은 읽기/쓰기 레이어에 저장
  - 여러 개의 컨테이너를 생성해도 최소한의 용량만 사용



## 이미지 경로

이미지

- url 방식으로 관리하며 태그를 붙일 수 있음
- ubuntu 14.04 이미지는 `docker.io/library/ubuntu:14.04` 또는 `docker.io/library/ubuntu:trusty`
- `docker.io/library`는 생략 가능하여 `ubuntu:14.04`로 사용할 수 있음
- 태그 기능을 잘 이용하면 테스트나 롤백도 쉽게 할 수 있음



## Dockerfile

`Dockerfile`

- 도커는 이미지를 만들기 위해 `Dockerfile` 이라는 파일에 자체 DSL(Domain-specific language) 언어를 이용하여 이미지 생성 과정을 적음
- 소스와 함께 버전 관리가 되며, 누구나 이미지 생성과정을 보고 수정할 수 있음



## Docker Hub

도커 이미지의 용량은 보통 수백 MB 이상

- Docker Hub를 통해 큰 용량의 공개 이미지를 무료로 서버에 저장하고 관리해 줌



## Command와 API

도커 클라이언트의 커맨드 명령어는 정말 잘 만들어져 있음

- 직관적이고 사용하기 쉬우며, 컨테이너의 복잡한 시스템 구성을 이해하지 못해도 편하게 사용 가능

- http 기반의 Rest API 지원
  - 확장성이 좋으며, 훌륭한 3rd party 툴이 나오기 좋은 환경



## 유용한 새로운 기능들

도커는 발전 속도가 아주 빠른 오픈 소스

- 부족하다고 느꼈던 부분은 빠르게 개선

- 새로운 버전이 나오면 유용한 기능이 대폭 추가

- 1.13 버전

  - Docker stacks 라는 여러 개의 컨테이너를 한번에 관리하는 기능이 정식으로 릴리즈

  - system 커맨드가 추가되어 이미지, 컨테이너 관리가 더 편해짐
  - Secrets Management 라는 비밀 정보를 관리하는 기능도 추가



## 훌륭한 생태계

도커는 굉장히 큰 생태계를 갖고 있음

- 커다란 기업과 협력하여 사실상 클라우드 컨테이너 세계의 de facto
- 로깅, 모니터링, 스토리지, 네트워크, 컨테이너 관리, 배포 등 다양한 분야에서 다양한 툴들이 존재
  - 도커를 위한 OS도 존재: coreos -> container linux
- 도커를 기반으로 한 오픈 소스 프로젝트는 10만 개 이상



## moby dock

로고는 고래



## 도커 설치

도커는 리눅스 컨테이너 기술

- macOS나 windows에 설치할 경우, 가상머신에 설치됨



### Linux

자동 설치 스크립트 이용

`curl -fsSL https://get.docker.com/ | sudo sh`

`sudo docker version`



#### sudo 없이 사용

도커는 기본적으로 root 권한이 필요

root가 아닌 사용자가 sudo 없이 사용하려면, 해당 사용자를 `docker` 그룹에 추가

`sudo usermod -aG docker $USER`: 현재 접속 중인 사용자에게 권한 주기

`sudo usermod -aG docker your-user`: your-user 사용자에게 권한 주기



### 가상머신에 설치

Docker machine

- Docker for ... 을 사용하지 못하는 경우

- 처음부터 사용하면 환경이 혼란스러울 수 있음

- Virtual Box나 VMware 같은 가상머신에 리눅스를 설치하고, 리눅스에 접속하여 도커를 사용하는 것을 권장



### 설치 확인

`docker version`: client와 server 정보가 정상적으로 출력되었다면 설치 완료



도커

- 하나의 실행파일이지만, 실제로 client와 server 역할을 각각 할 수 있음
- 도커 커맨드를 입력하면 도커 client가 도커 server로 명령을 전송하고 결과를 받아 터미널에 출력
- 기본값이 도커 server의 소켓을 바라보고 있음
  - 사용자는 바로 명령을 내리는 것 같은 느낌을 받음
- mac이나 windows의 터미널에서 명령어를 입력했을 때 가상 서버에 설치된 도커가 동작하는 이유



## 컨테이너 실행

- ubuntu 16.04 container
- redis container
- MySQL 5.7 container
- WordPress container
- tensorflow



도커를 실행하는 명령어

`docker run [OPTIONS] IMAGE[:TAG|@DIGEST] [COMMAND] [ARG...]`

옵션

- `-d`: detached mode, 백그라운드 모드
- `-p`: 호스트와 컨테이너의 포트를 연결 (포워딩)
- `-v`: 호스트와 컨테이너의 디렉토리를 연결 (마운트)
- `-e`: 컨테이너 내에서 사용할 환경변수 설정
- `--name`: 컨테이너 이름 설정
- `--rm`: 프로세스 종료 시 컨테이너 자동 제거
- `-it`: `-i` + `-t`, 터미널 입력을 위한 옵션
- `--link`: 컨테이너 연결 [컨테이너명:별칭]



### ubuntu 16.04 container

ubuntu 16.04 컨테이너를 생성하고, 컨테이너 내부에 들어가기

`docker run ubuntu:16.04`

- `run`

  - 컨테이너를 실행하는 명령어

  - 사용할 이미지가 저장되어 있는지 확인
  - 없으면 다운로드(`pull`)한 후 컨테이너 생성(`create`) 및 시작(`start`)

- `ubuntu:16.04` 이미지를 다운받은 적이 없기 때문에, 이미지를 다운로드한 후 컨테이너가 실행

- 컨테이너는 정상적으로 실행됐지만, 명령어를 전달하지 않았기 때문에 생성되자마자 종료

  - 실행 중인 프로세스가 없으면 컨테이너는 종료



`docker run --rm -it ubuntu:16.04 /bin/bash`

- `--rm`: 프로세스가 종료되면 컨테이너가 자동으로 삭제
- `-it`: 키보드 입력

- `/bin/bash`: 컨테이너 내부에 들어가기 위해 bash 쉘 실행
- 이전에 이미지를 다운받았기 때문에, 이미지를 다운로드하는 화면 없이 바로 실행

`root@~:/# ls`, `root@~:/# cat /etc/issue`

- ubuntu 리눅스 확인

`root@~:/# exit`

- bash 쉘 종료와 함께 컨테이너도 같이 종료



## 도커 기본 명령어

컨테이너의 상태를 살펴보고, 어떤 이미지가 설치되어 있는지 확인하기



### 컨테이너 목록 확인 (ps)

`docker ps [OPTIONS]`

- `ps`
  - 실행 중인 컨테이너 목록을 보여줌
  - detached mode로 실행 중인 컨테이너들을 보여줌
  - 어떤 이미지를 기반으로 만들었고, 어떤 포트와 연결되어 있는지 등 간단한 내용을 보여줌
- 옵션
  - `-a`: 종료된 컨테이너까지 보여줌 (Exited (O))



### 컨테이너 중지 (stop)

`docker stop [OPTIONS] CONTAINER [CONTAINER...]`

- 옵션
  - 특별한 것 없이, 실행 중인 컨테이너를 하나 또는 여러 개(띄어쓰기로 구분) 중지할 수 있음
- 컨테이너의 ID 또는 이름을 입력



(실행했었던) tensorflow 컨테이너 중지하기

`docker ps`: 컨테이너 ID 얻음

`docker stop ${TENSORFLOW_CONTAINER_ID}`

- 도커 ID의 전체 길이는 64자리
- 명령어의 인자로 전달할 때는 전부 입력하지 않아도 됨
- 앞부분이 겹치지 않으면 1~2자만 입력해도 됨

`docker ps -a`: 모든 컨테이너를 봄으로써 종료 확인



### 컨테이너 제거 (rm)

종료된 컨테이너 완전히 제거

`docker rm [OPTIONS] CONTAINER [CONTAINER...]`

- 옵션
  - 특별한 것 없이, 종료된 컨테이너를 하나 또는 여러 개 삭제할 수 있음
- 호스트 OS는 아무런 흔적도 남지 않고, 컨테이너만 격리된 상태로 실행되었다가 삭제



종료된 ubuntu 컨테이너와 tensorflow 컨테이너 삭제하기

`docker pos -a`: 컨테이너 ID 얻음

`docker rm ${UBUNTU_CONTAINER_ID} ${TENSORFLOW_CONTAINER_ID}`

`docker ps -a`: 종료 확인



중지된 컨테이너의 ID를 가져와 한번에 삭제

`docker rm -v $(docker ps -a -q -f status=exited)`

- 중지된 컨테이너를 일일이 삭제하기 귀찮은 경우



### 이미지 목록 확인 (images)

도커가 다운로드한 이미지 목록 보기

`docker images [OPTIONS] [REPOSITORY[:TAG]]`

- 이미지 주소, 태그, ID, 생성 시점, 용량이 보임
- 이미지가 쌓일수록 용량을 차지하기 때문에 사용하지 않는 이미지는 지우는 것이 좋음



### 이미지 다운로드 (pull)

`docker pull [OPTIONS] NAME[:TAG|@DIGEST]`



`ubuntu:14.04` 다운받기

`docker pull ubuntu:14.04`

- `pull`
  - 최신 버전으로 다시 다운받음
  - 같은 태그지만 이미지가 업데이트된 경우 새로 다운받음



### 이미지 삭제 (rmi)

`docker rmi [OPTIONS] IMAGE [IMAGE...]`

- `images` 명령어를 통해 얻은 이미지 목록에서 이미지 ID를 입력
- 컨테이너가 실행 중인 이미지는 삭제되지 않음
- 컨테이너는 이미지들의 레이어를 기반으로 실행중이기 때문에 당연히 삭제할 수 없음



더이상 사용하지 않는 tensorflow의 이미지 제거하기

`docker images`: 이미지 ID 얻음

`docker rmi ${TENSORFLOW_IMAGE_ID}`

- 여러 개의 레이어로 구성된 이미지가 삭제됨으로써, 모든 레이어 삭제



## 컨테이너 둘러보기

`log`, `exec` 명령어



### 컨테이너 로그 보기 (logs)

로그를 통하여 컨테이너가 정상적으로 동작하는지 확인

`docker logs [OPTIONS] CONTAINER`

- 기본 옵션
  - `docker logs ${WORDPRESS_CONTAINER_ID}`
    - 기존에 생성해놓은 워드프레스 컨테이너 로그 확인
    - 전체 로그를 전부 다 출력
- `-f` 옵션
  - `docker logs --tail 10 ${WORDPRESS_CONTAINER_ID}`
    - 마지막 10줄만 출력
- `--tail` 옵션
  - `docker logs -f ${WORDPRESS_CONTAINER_ID}`
    - 실시간으로 로그가 생성되는 것을 확인
    - 로그를 켜놓은 상태에서 워드프레스 페이지를 새로고침하면 브라우저 접속 로그가 실시간으로 보임
    - 로그 보기를 중지하려면 `ctral` + `c` 입력



#### 로그에 대해 좀 더 자세히

도커는 표준 스트림(Standard streams) 중 `stdout`, `stderr`을 수집

- 로그 파일을 자동으로 알아채는 것이 아님

- 컨테이터에서 실행되는 프로그램의 로그 설정을 (파일이 아닌) 표준 출력으로 바꾸어야 함

- 출력 방식만 바꾸는 것으로 모든 컨테이너는 로그에 대해 같은 방식으로 관리할 수 있게 됨



컨테이너의 로그 파일은 json 방식으로 (어딘가에) 저장됨

- 도커는 다양한 플러그인을 지원하여 json이 아닌 특정 로그 서비스에 스트림을 전달
- 앱의 규모가 커지면 기본적인 방식 대신 로그 서비스 이용을 고려
- 로그가 많으면 은근히 파일이 차지하는 용량이 커지므로 주의



### 컨테이너 명령어 실행 (exec)

실행 중인 컨테이너에 들어가 보거나 컨테이너 파일을 실행하고 싶은 경우

- docker의 `exec` 명령어 실행 (예전에는 'nsenter' 프로그램 이용)

- 컨테이너에 `SSH`를 설치하는 것은 권장하지 않음



`docker exec [OPTIONS] CONTAINER COMMAND [ARG...]`

- `run` 명령어와의 차이
  - `run`: 새로 컨테이너를 만들어서 실행
  - `exec`: 실행 중인 컨테이너에 명령어를 내림



실행 중인 `MySQL` 컨테이너에 접속

```bash
# 키보드 입력이 필요하여 -it 옵션을 줌
# bash shell로 접속
docker exec -it mysql /bin/bash
# MySQL 테스트
mysql -uroot
```

```mysql
mysql> show databases;
mysql> quit
```

```bash
exit
```

바로 `mysql` 명령어 실행

```bash
docker exec -it mysql -uroot
```

- 호스트 OS에 mysql을 설치하지 않아도 mysql 클라이언트를 사용할 수 있음
- 복잡한 작업이 필요없는 경우, `-it` 옵션 없이 단순하게 명령을 실행하고 종료



## 컨테이너 업데이트

컨테이너를 새로운 버전으로 업데이트 하기



도커에서 컨테이너를 업데이트

- 새 버전의 이미지를 다운(`pull`)받고 기존 컨테이너를 삭제(`stop`, `rm`)
- 새 이미지를 기반으로 새 컨테이너를 실행(`run`)

컨테이너를 삭제

- 컨테이너에서 생성된 파일이 사라짐

  - 데이터베이스라면, 그동안 쌓였던 데이터가 모두 사라짐
  - 웹 애플리케이션이라면, 그동안 사용자가 업로드한 이미지가 모두 사라짐

- 유지해야 하는 데이터는 반드시 컨테이너 (내부가 아닌) 외부 스토리지에 저장해야 함

  - AWS S3와 같은 클라우드 서비스 이용 (가장 좋은 방법)

  - 데이터 볼륨(Data volumes)을 컨테이너에 추가해 사용

    - 해당 디렉토리는 컨테이너와 별도로 저장

    - 호스트의 디렉토리를 마운트해서 사용하는 방법

      - MySQL의 경우, `/var/lib/mysql` 디렉토리에 모든 데이터베이스 정보가 담기므로, 호스트의 특정 디렉토리를 연결해줌

      ```bash
      docker run -d -p 3306:3306 \
      	-e MYSQL_ALLOW_EMPTY_PASSWORD=true \
      	--name mysql \
      	# -v 옵션 사용 -> 볼륨 마운트
      	# /my/own/datadir 디렉토리를 컨테이너의 /var/lib/mysql 디렉토리로 마운트
      	-v /my/own/datadir:/var/lib/mysql \
      	mysql:5.7
      ```

      - 데이터베이스 파일은 호스트의 `/my/own/datadir` 디렉토리에 저장됨
      - 컨테이너를 삭제해도 데이터는 사라지지 않음
      - 최신 버전의 MySQL 이미지를 다운받고 다시 컨테이너를 실행할 때, 동일한 디렉토리를 마운트하면 그대로 데이터를 사용할 수 있음



## Docker Compose

컨테이너 조합이 많아지고 여러가지 설정이 추가되면 명령어가 금방 복잡해짐

도커는 **Docker Compose** 툴을 제공

- 복잡한 설정을 쉽게 관리
- YAML 방식의 설정파일을 이용



### 설치

설치 파일 하나 다운받으면 됨(리눅스)

```shell
curl -L "https://github.com/docker/compose/releases/download/1.9.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
docker-compose version
```



### wordpress 만들기

compose를 이용하여 wordpress 만들기

- 기존에는 명령어로 만들었음
- 명령어를 설정파일로 바꾸어 가독성과 편리성 향상



1. 빈 디렉토리를 하나 만들고, `docker-compose.yml` 파일을 만들어 설정 입력

   ```
   version: '2'
   
   services:
   	db:
   		image: mysql:5.7
   		volumes:
   			- db_data:/var/lib/mysql
   		restart: always
   		environment:
   			MYSQL_ROOT_PASSWORD: wordpress
   			MYSQL_DATABASE: wordpress
   			MYSQL_USER: wordpress
   			MYSQL_PASSWORD: wordpress
   			
   	wordpress:
   		depends_on:
   			- db
   		image: wordpress:latest
   		volumes:
   			- wp_data:/var/www/html
   		ports:
   			- "8000:80"
   		restart: always
   		environment:
   			WORDPRESS_DB_HOST: db:3306
   			WORDPRESS_DB_PASSWORD: wordpress
   volumes:
   	db_data:
   	wp_data:
   ```

2. 실행

   ```bash
   docker-compose up
   ```



## 도커 이미지 만들기

도커는 이미지를 만들기 위해 컨테이너의 상태를 그대로 이미지로 저장

- 어떤 앱을 이미지로 만든다면 리눅스만 설치된 컨테이너에 앱을 설치하고 그 상태를 그대로 이미지로 저장
- 가상머신의 스냅샷과 비슷한 방식

컨테이너의 가벼운 특성과 레이어 개념을 이용해 생성과 테스트를 빠르게 수행 가능



### Sinatra 웹 애플리케이션 샘플

Ruby로 만들어진 간단한 웹 앱을 도커라이징(도커 이미지 만듦)

- Gemfile: 패키지 관리
- app.rb: 호스트명을 출력하는 웹 서버 생성



패키지 설치하고 서버 실행

```shell
bundle install # 패키지 설치
bundle exec ruby app.rb # sinatra 실행
```



ruby가 설치돼 있지 않아도 도커만 있으면 됨

```shell
docker run --rm \
-p 4567:4567 \
-v $PWD:/usr/src/app \
-w /usr/src/app \
ruby \
bash -c 'bundle install && bundle exec ruby app.rb -o 0.0.0.0'
```

- 호스트의 디렉토리를 ruby가 설치된 컨테이너의 디렉토리에 마운트한 후 그대로 명령어 실행
- 로컬에 개발 환경을 구축하지 않고 도커 컨테이너를 개발환경으로 사용 가능
- 도커를 개발환경으로 사용하면 개발=테스트=운영이 동일한 환경에서 실행



서버가 정상적으로 실행됐으면 웹 브라우저에서 테스트

- `http://localhost:4567`

- 도커 컨테이너의 호스트명이 보임



### Ruby Application Dockerfile

도커 이미지 만들기

- 도커는 이미지를 만들기 위해 **Dockerfile** 이미지 빌드용 DSL(Domain Specific Language) 파일 사용
- 일단 리눅스 서버에서 테스트로 설치해보고 안되면 될 때까지 최적의 과정을 Dockerfile로 작성 필요



Ruby 웹 앱을 ubuntu에 배포

1. ubuntu 설치
2. ruby 설치
3. 소스 복사
4. Gem 패키지 설치
5. Sinatra 서버 실행



쉘 스크립트로 옮김

```sh
# ubuntu 설치 (패키지 업데이트)
apt-get update

# ruby 설치
apt-get install ruby
gem install bundler

# 소스 복사
mkdir -p /usr/src/app
scp Gemfile app.rb root@ubuntu:/usr/src/app # 호스트에서

# Gem 패키지 설치
bundle install

# Sinatra 서버 실행
bundle exec ruby app.rb
```



이 과정을 Dockerfile로 빌드 파일 만듦

```dockerfile
# ubuntu 설치 (패키지 업데이트 + 만든사람 표시)
FROM 			ubuntu:16.04
MAINTAINER 		subicura@subicura.com
# -y 옵션: 도커 빌드 중엔 키보드를 입력할 수 없으므로 (y/n)을 물어보는 걸 방지
RUN 			apt-get -y update

# ruby 설치
RUN 			apt-get -y install ruby
RUN 			gem install bundler

# 소스 복사
COPY 			. /usr/src/app

# Gem 패키지 설치 (실행 디렉토리 설정)
WORKDIR 		/usr/src/app
RUN 			bundle install

# Sinatra 서버 실행 (Listen 포트 정의)
EXPOSE 			4567
CMD 			bundle exec ruby app.rb -o 0.0.0.0
```



### Docker build

이미지 만들기

- 이미지 빌드 명령어: `docker build [OPTIONS] PATH | URL | -`
- `-t(--tag)` 옵션: 생성할 이미지 이름 지정



Dockerfile 만든 디렉토리로 이동해 명령어 입력

- `docker build -t app .`

- Dockerfile에 정의한 내용이 한 줄 한 줄 실행
- 실제로 명령어를 실행하므로 빌드 시간이 꽤 걸림
- 최종적은 `Successfully built xxxxxxxx` 메시지 -> 정상적으로 이미지 생성



이미지가 잘 생성됐는지 확인

- `docker images`



잘 동작하는지 컨테이너 실행

- `docker run -d -p 8000:4567 app`
- `docker run -d -p 8001:4567 app`
- `docker run -d -p 8002:4567 app`
- 호스트 네임 출력하는 웹 서버 3개 생성



### Dockerfile 기본 명령어

이미지를 만드는 데 사용한 Dockerfile의 기본적인 명령어

- FROM
  - `FROM <image>:<tag>` ex) `FROM ubuntu:16.04`
  - 베이스 이미지 (반드시) 지정
  - tag: 될 수 있으면 latest(기본값)보다 구체적인 버전 지정 권장
  - 이미 만들어진 다양한 베이스 이미지는 Docker hub에서 확인 가능
- MAINTAINER
  - `MAINTAINER <name>` ex) `MAINTAINER subicura@subicura.com`
  - Dockerfile을 관리하는 사람 이름 또는 이메일 정보
  - 빌드에 딱히 영향 없음
- COPY
  - `COPY <src> ... <dest>` ex) `COPY . /usr/src/app`
  - 파일이나 디렉토리를 이미지로 복사
  - 일반적으로 소스 복사에 사용
  - `target` 디렉토리가 없으면 자동으로 생성
- ADD
  - `ADD <src> ... <dest>` ex) `ADD . /usr/src/app`
  - `COPY` 명령어와 매우 유사하나 몇가지 추가 기능 존재
  - `src`에 파일 대신 URL 입력 가능
  - `src`에 압축 파일을 입력하는 경우 자동으로 압축 해제하면서 복사
- RUN
  - `RUN <command>`, `RUN ["executable", "param1", "param2"]` ex) `RUN bundle install`
  - 명령어를 그대로 실행
  - 내부적으로 `/bin/sh -c` 뒤에 명령어를 실행하는 방식
- CMD
  - `CMD ["executable", "param1", "param2"]`, `CMD command param1 param2` ex) `CMD bundle exec ruby app.rb`
  - 도커 컨테이너가 실행됐을 때 실행되는 명령어를 정의
  - 빌드할 때는 실행되지 않고, 여러 개의 `CMD`가 존재할 경우 가장 마지막 `CMD`만 실행
  - 한꺼번에 여러 개의 프로그램을 실행하고 싶은 경우 `run.sh` 파일을 작성해 데몬으로 실행하거나 supervisord나 forego 등 여러 개의 프로그램을 실행하는 프로그램을 사용
- WORKDIR
  - `WORKDIR /path/to/workdir`
  - RUN, CMD, ADD, COPY 등이 이루어질 기본 디렉토리 설정
  - 각 명령어의 현재 디렉토리는 한 줄 한 줄마다 초기화
  - `RUN cd /path` 하더라도 다음 명령어에선 다시 위치가 초기화
  - 같은 디렉토리에서 계속 작업하기 위해 사용
- EXPOSE
  - `EXPOSE <port> [<port> ...]` ex) `EXPOSE 4567`
  - 도커 컨테이너가 실행됐을 때 요청을 기다리고 있는(Listen) 포트를 지정
  - 여러 개의 포트 지정 가능
- VOLUME
  - `VOLUME ["/data"]`
  - 컨테이너 외부에 파일시스템을 마운트할 때 사용
  - 반드시 지정하지 않아도 마운트할 수 있찌만, 기본적으로 지정 권장
- ENV
  - `ENV <key> <value>`, `ENV <key>=<value> ...` ex) `ENV DB_URL mysql`
  - 컨테이너에서 사용할 환경변수 지정
  - 컨테이너 실행할 때 `-e` 옵션 사용하면 기본값을 오버라이딩



### Build 분석

빌드 하면서 도커가 Dockerfile을 갖고 무슨 일을 하는지 build 로그를 보면서 분석

```shell
# build context: 빌드 명령어를 실행한 디렉토리의 파일들
# 이 파일들을 도커 서버(daemon)로 전송
# 도커는 서버-클라이언트 구조이므로 도커 서버가 작업하려면 미리 파일을 전송해야 함
Sending build context to Docker daemon  5.12 kB

# Dockerfile을 한 줄 한 줄 수행
# 첫 번째로 FROM 명령어 수행
# ubuntu:16.04 이미지 다운
Step 1/10 : FROM ubuntu:16.04

# 명령어 수행 결과를 이미지로 저장
# ubuntu:16.04를 사용하기로 했으므로 ubuntu 이미지의 ID가 표시
 ---> f49eec89601e
 
# Dockerfile의 두 번째 명령어 MAINTAINER 명령어 수행
Step 2/10 : MAINTAINER subicura@subicura.com

# 명령어를 수행하기 위해 바로 이전에 생성된 이미지 기반으로 그 컨테이너를 임시로 생성해 실행
 ---> Running in f4de0c750abb
 
 # 명령어 수행 결과를 이미지로 저장
 ---> 4a400609ff73          
 
# 명령어를 수행하기 위해 임시로 만들었던 컨테이너 제거
Removing intermediate container f4de0c750abb

# Dockerfile의 세 번째 명령어 수행
# 바로 전에 만들어진 이미지 기반으로 임시 컨테이너를 만들어 명령어 실행하고 그 결과 상태를 이미지로 생성
# 마지막 줄까지 무한 반복
Step 3/10 : RUN apt-get -y update  
...
...

# 최종 성공한 이미지 ID 출력
Successfully built 20369cef9829
```

- 도커 빌드는 `임시 컨테이너 생성` -> `명령어 수행` -> `이미지로 저장` -> `임시 컨테이너 삭제` -> `새로 만든 이미지 기반 임시 컨테이너 생성` -> `명령어 수행` -> `이미지로 저장` -> `임시 컨테이너 삭제` -> ... 과정을 계속 반복
- 명령어를 실행할 때마다 이미지 레이어를 저장하고 다시 빌드할 때 Dockerfile이 변경되지 않았다면 기존에 저장된 이미지를 그대로 캐시처럼 사용



### 도커 이미지 리팩토링

앞에서 만든 이미지의 몇 가지 최적화 문제

- Base Image

  - 위에서 만든 Ruby 앱 이미지는 `ubuntu` 베이스로 만들었지만 사실 훨씬 간단한 `ruby` 베이스 이미지 존재
  - 기존에 ruby를 설치했던 명령어는 ruby 이미지를 사용하는 것으로 간단히 생략

  ```dockerfile
  # before
  FROM 			ubuntu:16.04
  MAINTAINER 		subicura@subicura.com
  RUN 			apt-get -y update
  RUN 			apt-get -y install ruby
  RUN 			gem install bundler
  
  # after
  FROM 			ruby:2.3
  MAINTAINER 		subicura@subicura.com
  ```

  - ruby, nodejs, python, java, go 등 다양한 베이스 이미지가 이미 존재하므로 세부적인 설정이 필요하지 않으면 그대로 사용하는게 간편

- Build Cache

  - 한 번 빌드한 이미지를 다시 빌드하면 굉장히 빠르게 완료

  - 이미지를 빌드라는 과정에서 각 단계를 이미지 레이어로 저장하고 다음 빌드에서 캐시로 사용

  - 도커는 빌드할 때 Dockerfile 명령어가 수정됐거나 추가하는 파일이 변경됐을 때 캐시가 깨지고 그 이후 작업은 새로 이미지를 생성

  - ruby gem 패키지를 설치하는 과정을 꽤 많은 시간이 소요되므로 최대한 캐시를 이용해 빌드 시간 단축

  - 기존 소스에서 소스파일이 수정되면서 캐시가 깨지는 부분

    ```dockerfile
    COPY 		. /usr/src/app # 소스파일이 변경되면 캐시가 깨짐
    WORKDIR 	/usr/src/app
    RUN 		bundel install # 패키지를 추가하지 않았는데 또 인스톨
    ```

    - 복사하는 파일이 이전과 다르면 캐시 사용하지 않고 그 이후 명령어는 다시 실행
    - ruby gem 패키지를 관리하는 파일은 Gemfile이고, 이 파일은 잘 수정되지 않음

  - 순서 변경

    ```dockerfile
    COPY 		Gemfile* /usr/src/app/ # Gemfile 먼저 복사
    WORKDIR 	/usr/src/app
    RUN 		bundle install # 패키지 인스톨
    COPY 		. /usr/src/app # 소스가 바꼈을 때 캐시가 깨지는 시점
    ```

    - gen 설치 부분을 소스 복사 이전으로 이동
    - 소스가 수정돼도 매번 gem을 설치하지 않아 더욱 빠르게 빌드
    - 요즘 언어들은 대부분 패키지 매니저를 사용하므로 비슷하게 작성하면 됨

- 명령어 최적화

  - 이미지를 빌드할 때 불필요한 로그는 무시하는게 좋고 패키지 설치 시 문서 파일 생성할 필요도 없음

    ```dockerfile
    # before
    RUN apt-get -y update
    
    # after
    RUN apt-get -y -qq update
    ```

    - `-qq` 옵션: 로그를 출력하지 않게 함
      - 각종 리눅스 명령어는 보통 `quite` 옵션이 있으므로 적절히 적용

    ```dockerfile
    # before
    RUN bundle install
    
    # after
    RUN bundle install --no-rdoc --no-ri
    ```

    - `--no-doc`, `--no-ri` 옵션: 필요없는 문서를 생성하지 않아 이미지 용량도 줄이고 빌드 속도도 빨라짐

- 이쁘게

  - 명령어는 비슷한 것끼리 묶어주는 게 더 보기 좋고 레이어 수 줄이는 데 도움
  - 도커 이미지는 스토리지 엔진에 따라 레이어 개수가 127개로 제한되어 있는 경우도 있으므로 너무 많은 명령어는 좋지 않음

  ```dockerfile
  # before
  RUN apt-get -y -qq update
  RUN apt-get -y -qq install ruby
  
  # after
  RUN apt-get -y -qq update && \
      apt-get -y -qq install ruby
  ```

- 최종

  ```dockerfile
  FROM 			ruby:2.3
  MAINTAINER 		subicura@subicura.com
  COPY 			Gemfile* /usr/src/app/
  WORKDIR 		/usr/src/app
  RUN 			bundle install --no-rdoc --no-ri
  COPY 			. /usr/src/app
  EXPOSE 			4567
  CMD 			bundle exec ruby app.rb -o 0.0.0.0
  ```

  

## 이미지 저장소

도커는 빌드한 이미지를 서버에 배포하기 위해 (직접 파일을 복사하는 방법 대신) **Docker Registry** 이미지 저장소 사용





### Docker Hub

### Private Docker Registry



## 배포

### 컨테이너 배포 방식

### 컨테이너 업데이트

### 배포에 대해 더 알아보기



## 마무리