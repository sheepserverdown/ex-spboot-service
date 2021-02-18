#!/usr/bin/env bash

ABSPATH=$(readlink -f $0)
ABSDIR=$(dirname $ABSPATH) # stop.sh와 profile.sh 의 경로를 찾음
source ${ABSDIR}/profile.sh # java에서 import 같은 구문. stop.sh에서도 profile.sh의 여러 function 사용가능

IDLE_PORT=$(find_idle_port)

echo "> $IDOL_PORT 에서 구동 중인 애플리케이션 PID 확인"
IDLE_PID=$(lsof -ti tcp:${IDLE_PORT})

if [ -z ${IDLE_PID} ]
then
  echo "> 현재 구동 중인 애플리케이션이 없으므로 종료하지 않습니다."
else
  echo "> kill -15 $IDLE_PID"
  kill -15 ${IDLE_PID}
  sleep 5
fi
