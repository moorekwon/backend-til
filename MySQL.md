# MySQL

## 데이터베이스의 개요

DB

- DataBase

- 데이터를 통합 및 관리하는 데이터의 집합



DBMS

- DataBase Management System
- 데이터베이스를 관리하는 미들웨어 시스템



RDBMS

- Relational DataBase Management System
- 데이터의 테이블 사이에 키 값으로 관계를 갖고 있는 데이터베이스
- Oracle, **Mysql**, Postgresql, Sqlite



NoSQL

- 데이터테이블 사이에 관계가 없이 데이터를 저장하는 데이터베이스
- 복잡성이 작고, 많은 데이터를 저장할 수 있음
- Mongodb, Hbase, Cassandra



MySQL

- 특징

  - 오픈소스이며, 다중 사용자와 다중 스레드를 지원

  - 다양한 운영체제에 다양한 프로그래밍 언어를 지원

  - 표준 SQL을 사용

  - 작고 강력하며, 가격이 저렴

- History

  - 1995, MySQL AB 사에 의해 첫 버전 발표
  - 2008, 썬마이크로시스템이 MySQL AB 인수 (5.1 버전)
  - 2009, 오라클이 썬마이크로시스템 인수
  - 2018, MySQL 8.0 버전 발표

- License

  - MySQL을 포함하는 하드웨어나 소프트웨어 기타 장비를 판매하는 경우 필요
  - 배포 시 소스를 공개하면 무료이나, 소스 공개를 원하지 않는 경우 필요
  - 서비스에 이용하는건 무료 가능



## MySQL 설치 및 설정

(20.01.07 기준)

AWS EC2 인스턴스 > Ubuntu OS > MySQL 5.7.x 버전 설치



1. EC2 인스턴스 생성

   - t2.micro
   - Ubuntu 18.04 버전
   - 

2. EC2 인스턴스에 접속

   - pem 파일 400 권한으로 변경

     ```shell
     ssh -i ~/.ssh/rada.pem ubuntu@15.164.231.87
     ```

   - apt-get 업데이트

     ```shell
     sudo apt-get update -y
     sudo apt-get upgrade -y
     ```

   - MySQL Server 설치

     ```shell
     sudo apt-get install mysql-server
     ```

   - MySQL secure 설정

     ```shell
     sudo mysql_secure_installation
     
     Would you like to setup VALIDATE PASSWORD plugin? N
     New password: wps
     Re-enter new password: wps
     Remove anonymous users? Y
     Disallow root login remotely? N
     Remove test database and access to it? Y
     Reload privilege tables now? Y
     ```

   - MySQL 패스워드 설정

     ```shell
     
     ```

   - 설정한 패스워드 입력하여 접속

   - 외부접속 설정

   - bind-address 127.0.0.1을 0.0.0.0으로 변경

   - 외부접속 패스워드 설정

   - 서버 시작, 종료 상태 확인

   - 설정 후 서버 재시작으로 설정 내용 적용

   - 패스워드 변경 (패스워드 'wps' 가정)





## 샘플 데이터 추가

## MySQL Workbench 사용법

## 데이터베이스 모델링

## SQL 문의 종류: DML DDL DCL

## SELECT FROM

## WHERE, IN, LIKE

## ORDER BY

## LIMIT

## GROUP BY, HAVING

## CREATE USE ALTER DROP

## DATA TYPE

## Constraint: 제약 조건

## INSERT

## UPDATE SET

## DELETE TRUNCATE

## Functions 1 (CONCAT, CEIL, ROUND, TRUNCATE, DATE_FORMAT)

## Functions 2 (IF, IFNULL, CASE)

## JOIN

## UNION

## Sub Query

## VIEW

## INDEX