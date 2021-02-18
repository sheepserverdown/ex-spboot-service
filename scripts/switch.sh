#!/usr/bin/env bash

ABSPATH=$(readlink -f $0)
ABSDIR=$(dirname $ABSPATH)
source ${ABSDIR}/profile.sh

function switch_proxy() {
  IDLE_PORT=$(find_idle_port)

  echo "> 전환할 Port: $IDLE_PORT"
  echo "> Port 전환"
  # 하나의 문장을 만들어 파이프라인(|)으로 넘겨주기 위해 echo를 사용 / nginx가 사용할 프록시 주소를 생성
  # 쌍따옴표 (") 를 사용해야하며 그렇지 않으면 $service_url을 인식하지 못하고 그대로 변수를 찾게됨
  # 뒤의 sudo tee~ 는 앞에서 넘겨준 문장을 service-url.inc에 덮어씀
  echo "set \$service_url http://127.0.0.1:${IDLE_PORT}" | sudo tee /etc/nginx/conf.d/service-url.inc

  echo "> Nginx Reload"
  # nginx의 설정을 다시 불러오는 문구. restart와는 다르다!! -> restart: 잠간 끊김 // reload는 끊김 없이 다시 불러옴
  # 다만 reload는 중요한 설정 몇몇은 반영되지 않음 / 외부의 설정 파일인 service-url을 불러오는거라 reload로 충분
  udo service nginx reload
}