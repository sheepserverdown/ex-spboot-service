#!/usr/bin/env bash

# 쉬고 있는 profile을 검색 : real1이 사용 중이면 real2는 쉬고 있고, 반대일 경우엔 real1이 쉬는 상태

function find_idle_profile() {
  # nginx가 바라보고 있는 스프링부트가 정상 실행중인지 확인 - httpStatus로 응답을 받음
  # 정상 = 200 / 그이외의 에러는 400 이상의 모든값
  # real2를 현재 프로파일로 사용
  RESPONSE_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/profile)

  if [ ${RESPONSE_CODE} -ge 400 ] # 400 보다 크면(40X / 50X 에러 전부 포함하는 조건)

  then
    CURRENT_PROFILE=real2
  else
    CURRENT_PROFILE=$(curl -s http://localhost/profile)
  fi

  if [ ${CURRENT_PROFILE} == real1 ]
  then
    IDLE_PROFILE=real2 # nginx와 연결되지않은 profile // 스프링부트 프로젝트를 이 profile로 연결하기위해 반환
  else
    IDLE_PROFILE=real1
  fi

  # bash 스크립트는 값을 반환하는 기능이 없음
  # 그래서 제일 마지막줄에 echo로 결과를 출력 후 클라이언트에서 그 값을 잡아 ($(find_idle_profile)) 사용
  # 도중에 echo를 사용하면 안됨!!
  echo "${IDLE_PROFILE}"
}

# 쉬고 있는 profile의 port 찾기
function find_idle_port() {
  IDLE_PROFILE=$(find_idle_profile)

  if [ ${IDLE_PROFILE} == real1 ]
  then
    echo "8081"
  else
    echo "8082"
  fi
}