#!/bin/sh

error_exit() {
  echo "$1" 1>&2

  exit 1
}

# https://serverfault.com/a/163493/267530.
is_little_endian() {
  is_little_endian_result="$(
    printf 'I'\
      | hexdump -o\
      | awk '{ print substr($2, 6, 1); exit; }'
  )"
  readonly is_little_endian_result

  [ "$is_little_endian_result" -eq '1' ]
}

cpu="$( uname -m )"
case "$cpu"
in
('armv7l' | 'armv8l')
  cpu='armhf'
  ;;
('aarch64' | 'arm64')
  cpu='aarch64'
  ;;
('mips')
  if is_little_endian
  then
    cpu='mipsel'
  else
    error_exit "미지원 CPU: $cpu"
  fi
  ;;
(*)
  error_exit "미지원 CPU: $cpu"
  ;;
esac

url="https://github.com/veilRedeemer/udhcp/releases/download/0.9.9-pre/udhcpc_${cpu}.gz"
iface=`ls /var/run | sed -n 's/.*dhclient\.\([a-z0-9]*\).*/\1/p'`
if echo "$iface" | grep -q '[\W]'; then
  error_exit "여러 개의 WAN 인터페이스로 인해 실패: $iface"
fi

wget -O /tmp/dhclient.gz $url || error_exit "다운로드에 실패"
gzip -d /tmp/dhclient.gz
chmod 755 /tmp/dhclient

service network/interface/wan1/suspend || error_exit "DHCP 클라이언트를 중지할 인터페이스를 찾지 못함"

/tmp/dhclient -s /sbin/dhcpc.sh -i $iface -p /var/run/dhclient.$iface -V KT_PR_HH_A_A
