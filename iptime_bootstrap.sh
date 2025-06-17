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

# Function to check if an IP address belongs to a CIDR
cidr_contains() {
  local ip=$1
  local cidr=$2
  local ip_long=$(printf "%d\n" $(echo "$ip" | awk -F. '{print ($1*256*256*256)+($2*256*256)+($3*256)+$4}'))
  local cidr_ip=$(echo "$cidr" | cut -d/ -f1)
  local cidr_mask=$(echo "$cidr" | cut -d/ -f2)
  local cidr_ip_long=$(printf "%d\n" $(echo "$cidr_ip" | awk -F. '{print ($1*256*256*256)+($2*256*256)+($3*256)+$4}'))
  local network_address=$((cidr_ip_long & ~((1 << (32 - cidr_mask)) - 1)))
  local broadcast_address=$((network_address + ((1 << (32 - cidr_mask)) - 1)))

  if [[ "$ip_long" -ge "$network_address" ]] && [[ "$ip_long" -le "$broadcast_address" ]]; then
    return 0  # IP is in CIDR
  else
    return 1  # IP is not in CIDR
  fi
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

ips=`ip a | sed -n 's/.*inet\W*\([0-9\.]*\).*/\1/p'`

# Check if IP is in private ranges
is_private=1
for ip in $ips; do
	if cidr_contains "$ip" "192.168.0.0/16"; then
	  :
	elif cidr_contains "$ip" "10.0.0.0/8"; then
	  :
	elif cidr_contains "$ip" "172.16.0.0/12"; then
	  :
	elif cidr_contains "$ip" "100.64.0.0/10"; then
	  :
	elif cidr_contains "$ip" "127.0.0.0/8"; then
	  :
	elif cidr_contains "$ip" "0.0.0.0/8"; then
	  :
	elif cidr_contains "$ip" "169.254.0.0/16"; then
	  :
	elif cidr_contains "$ip" "224.0.0.0/4"; then
	  :
	elif cidr_contains "$ip" "240.0.0.0/4"; then
	  :
	else
	  is_private=0
	fi
done

url="https://github.com/veilRedeemer/udhcp/releases/download/0.9.9-pre/udhcpc_${cpu}.gz"
iface=`ls /var/run | sed -n 's/.*dhclient\.\([a-z0-9]*\).*/\1/p'`
if echo "$iface" | grep -q '[\W]'; then
  error_exit "여러 개의 WAN 인터페이스로 인해 실패: $iface"
fi

wget -O /tmp/dhclient.gz $url || error_exit "다운로드에 실패"
gzip -d /tmp/dhclient.gz
chmod 755 /tmp/dhclient

# Check the Global IP availability
if [[ "$is_private" -eq 1 ]]; then
  error_exit "공인 IP를 감지하지 못했으므로 실패"
else
  echo "공인 IP가 확인됨"
fi

service network/interface/wan1/suspend || service network/interface/wan2/suspend || service network/interface/wan3/suspend || error_exit "DHCP 클라이언트를 중지할 인터페이스를 찾지 못함"

/tmp/dhclient -s /sbin/dhcpc.sh -i $iface -p /var/run/dhclient.$iface -V KT_PR_HH_A_A

newips=`ip a | sed -n 's/.*inet\W*\([0-9\.]*\).*/\1/p'`
if [ "$ips" = "$newips" ]; then
  echo "이미 적용되었거나, 미지원 통신망이거나, Super-DMZ(Twin IP) 구성으로 인해 프리미엄 IP를 요청할 수 없는 환경입니다"
fi
