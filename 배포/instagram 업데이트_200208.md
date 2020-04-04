200208 instagram 업데이트



deploy.sh

```sh
#!/usr/bin/env sh
IDENTITY_FILE="$HOME/.ssh/review.pem"
HOST="ubuntu@54.180.85.133"
ORIGIN_SOURCE="$HOME/projects/wps12th/instagram/"
DEST_SOURCE="/home/ubuntu/projects"
SSH_CMD="ssh -i ${IDENTITY_FILE} ${HOST}"

echo "== runserver 배포 =="

# 숙제
# 다시 실행되는 서버 만들기
# > HOST만 바꾸고 이 스크립트를 실행하면 전체 서버가 세팅되고 runserver된 화면 볼 수 있도록 하기

# 서버 초기설정
echo "apt update & upgrade & autoremove"
${SSH_CMD} -C 'sudo apt update && sudo DEBIAN_FRONTEND=noninteractive apt dist-upgrade -y && apt -y autoremove'
echo "apt install python3-pip"
${SSH_CMD} -C 'sudo apt -y install python3-pip'

# pip freeze
echo "pip freeze"
"$HOME"/.pyenv/versions/3.7.5/envs/wps-instagram-env/bin/pip freeze >"$HOME"/projects/wps12th/instagram/requirements.txt

# 기존 폴더 삭제
echo "1. 기존 폴더 삭제"
${SSH_CMD} sudo rm -rf ${DEST_SOURCE}
#ssh -i ~/.ssh/wps12th.pem ubuntu@13.125.213.68 rm -rf /home/ubuntu/projects/instagram

# 로컬에 있는 파일 업로드
echo "2. 로컬 파일 업로드"
${SSH_CMD} mkdir -p ${DEST_SOURCE}
scp -i "${IDENTITY_FILE}" -r "${ORIGIN_SOURCE}" ${HOST}:${DEST_SOURCE}
#scp -i ~/.ssh/wps12th.pem -r ~/projects/wps12th/instagram ubuntu@13.125.213.68:/home/ubuntu/projects/

# pip install
echo "pip install"
${SSH_CMD} sudo apt-get install python3-pip
${SSH_CMD} pip3 install -q -r /home/ubuntu/projects/instagram/requirements.txt

echo "3. Screen 실행"
# 실행중이던 screen 세션 종료
${SSH_CMD} -C 'screen -X -S runserver quit'
#ssh -i ~/.ssh/wps12th.pem ubuntu@13.125.213.68 -C 'screen -X -S runserver quit'

# screen 실행
${SSH_CMD} -C 'screen -S runserver -d -m'
#ssh -i ~/.ssh/wps12th.pem ubuntu@13.125.213.68 -C 'screen -S runserver -d -m'

# 실행중인 세션에 명령어 전달
${SSH_CMD} -C "screen -r runserver -X stuff 'sudo python3 /home/ubuntu/projects/instagram/app/manage.py runserver 0:80\n'"
#ssh -i ~/.ssh/wps12th.pem ubuntu@13.125.213.68 -C "screen -r runserver -X stuff $'sudo python3 /home/ubuntu/projects/instagram/app/manage.py runserver 0:80\n'"

echo "== 배포 완료 =="
```



deploy-docker.sh

```sh
#!/usr/bin/env sh
IDENTITY_FILE="$HOME/.ssh/nuna.pem"
USER="ubuntu"
HOST="15.164.95.164"
TARGET=${USER}@${HOST}
ORIGIN_SOURCE="$HOME/projects/wps12th/instagram/"
DOCKER_REPO="raccoonhj33/200128-instagram"
SSH_CMD="ssh -i ${IDENTITY_FILE} ${TARGET}"

echo "== Docker 배포 =="

# 서버 초기설정
echo "apt update & upgrade & autoremove"
${SSH_CMD} -C 'sudo apt update && sudo DEBIAN_FRONTED=noninteractive apt dist-upgrade -y && apt -y autoremove'

echo "apt install docker.io"
${SSH_CMD} -C 'sudo apt -y install docker.io'

# pip freeze
echo "pip freeze"
"$HOME"/.pyenv/versions/wps-instagram-env/bin/pip freeze >"${ORIGIN_SOURCE}"requirements.txt

# docker build
# 1. poetry export를 사용해서 requirements.txt를 생성
#   > dev 패키지는 설치하지 않도록 함 (공식문서 또는 사용법 참고)
echo "poetry export"
poetry export -f requirements.txt >requirements.txt

echo "docker build"
docker build -q -t ${DOCKER_REPO} -f Dockerfile "${ORIGIN_SOURCE}"

# docker push
echo "docker push"
docker push ${DOCKER_REPO}

echo "docker stop"
${SSH_CMD} -C 'sudo docker stop instagram'

echo "docker pull"
${SSH_CMD} -C "sudo docker pull ${DOCKER_REPO}"

# 로컬의 aws profile 전달
scp -q -i "${IDENTITY_FILE}" -r "$HOME/.aws/" ${TARGET}:/home/ubuntu/

# screen에서 docker run
echo "screen settings"
# 실행 중이던 screen 세션 종료
${SSH_CMD} -C 'screen -X -S docker quit'
# screen 실행
${SSH_CMD} -C 'screen -S docker -d -m'
# 실행 중인 screen에서 docker container을 사용해서 bash 실행
${SSH_CMD} -C "screen -r docker -X stuff 'sudo docker run --rm -it -p 80:8000 --name=instagram ${DOCKER_REPO} /bin/bash\n'"
# bash를 실행 중인 container에 HOST의 ~/.aws 폴더를 복사
${SSH_CMD} -C "sudo docker cp ~/.aws/ instagram:/root"
# container에서 bash를 실행 중인 screen에 runserver 명령어를 전달
${SSH_CMD} -C "screen -r docker -X stuff 'python manage.py runserver 0:8000\n'"

echo "== Docker 배포 완료 =="
```



docker-run.py

```sh
#!/usr/bin/env python
import subprocess
import boto3

# # 외부 shell에서 실행할 결과를 변수에 할당
# access_key = subprocess.run(
#     'aws configure get aws_access_key_id --profile wps-secrets-manager',
#     stdout=subprocess.PIPE,
#     shell=True
# ).stdout.decode('utf-8').strip()
#
# secret_key = subprocess.run(
#     'aws configure get aws_secret_access_key --profile wps-secrets-manager',
#     stdout=subprocess.PIPE,
#     shell=True
# ).stdout.decode('utf-8').strip()
#
# print('access_key >>> ', access_key)
# print('secret_key >>> ', secret_key)

# boto3 사용
# session = boto3.session.Session(profile_name='wps-secrets-manager')
# credentials = session.get_credentials()
# access_key = credentials.access_key
# secret_key = credentials.secret_key

DOCKER_OPTIONS = [
    ('--rm', ''),
    ('-it', ''),
    ('-p', '8001:8000'),
    ('--name', 'instagram'),
    # ('--env', f'AWS_SECRETS_MANAGER_ACCESS_KEY_ID={access_key}'),
    # ('--env', f'AWS_SECRETS_MANAGER_SECRET_ACCESS_KEY={secret_key}'),
]

DOCKER_IMAGE_TAG = 'raccoonhj33/200128-instagram'

subprocess.run(f'docker build -t {DOCKER_IMAGE_TAG} -f Dockerfile .', shell=True)
subprocess.run('docker stop instagram', shell=True)

subprocess.run(
    'docker run {options} {tag}'.format(
        options=' '.join([
            f'{key} {value}' for key, value in DOCKER_OPTIONS
        ]),
        tag=DOCKER_IMAGE_TAG
    ), shell=True
)
```



instagram.nginx

```nginx
server {
    # 80번 포트로 온 요청에 응답할 block
    listen 80;

    # http 요청의 host 값(url에 입력한 도메인)
    server_name localhost;

    # 인코딩 utf-8 설정
    charset utf-8;

    # root로부터 요청에 대해 응답할 block
    # http://localhost
    location / {
        # /run/gunicorn.sock 파일을 사용해서 Gunicorn과 소켓 통신하는 proxy 구성
        proxy_pass http://unix:/run/instagram.sock;
    }

    # http://localhost/abc/def/
    location /abc {

    }
}
```

