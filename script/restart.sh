#!/bin/bash

BUILD_JAR=$(ls /home/ec2-user/app/*.jar)
JAR_NAME=$(basename $BUILD_JAR)
echo "## Build 파일명: $JAR_NAME"

DEPLOY_PATH=/home/ec2-user/app/
cp $BUILD_JAR $DEPLOY_PATH

CURRENT_PID=$(pgrep -f $JAR_NAME)
echo "## 현재 실행중인 애플리케이션 PID: $CURRENT_PID"

if [ -z $CURRENT_PID ]
then
  echo "## 현재 구동중인 애플리케이션 없음"
else
  echo "## 애플리케이션 종료: kill -15 $CURRENT_PID"
  kill -15 $CURRENT_PID
  sleep 5
fi

DEPLOY_JAR=$DEPLOY_PATH$JAR_NAME
echo "## 배포할 JAR 파일: $DEPLOY_JAR"
nohup java -jar $DEPLOY_JAR > $DEPLOY_PATH/nohup.out 2>&1 &
