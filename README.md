# bypassQoSKoreatelecomISP
인터넷 속도제한 qos 풀기 해제 기가인터넷 KT GiGA 인터넷의 일일 150GB QoS제한 우회 팁

Glacier/backblaze 백업, 스팀/Steam/에픽스토어/Epic Store 게임 다운로드와 같이 일정한 대역폭을 계속 유지해야 하는 경우 KT 기가 인터넷의 일일 150GB QoS 제한이 방해될 수 있는데요, 아래 방법으로 우회해봅시다

단, 사용중인 WiFi 공유기별로 지원 여부와 구성 방법이 다르므로 주의해주세요:

KT GiGA WiFi 2025년 5월 1일 시점에서 지원

ASUSWRT/OpenWrt/넷기어/시놀로지RT/기업용 브랜드 지원

iptime/netis/티피링크/머큐시스/D-Link/링크시스/기타 듣보잡 미지원

​또한 적용 후, 프리미엄 IP 대역은 원래 일반적인 컴퓨터/스마트 기기로부터의 트래픽이 거의 없었던 특성 상 몇몇 사이트에서 VPN 환경과 같이 Captcha 등을 요구하거나 액세스를 거부당할 가능성이 약간 높아집니다.

ASUSWRT(아수스 공유기, 이중 NAT 구성에서 사용할 수 없음) - http://www.asusrouter.com 에서 초기 설정 시 입력한 관리자 계정과 암호를 입력 후
 1. 아래 링크의 자동 IP - c단락을 참고하거나,
 2. 아래 스크린샷을 참고하여

클래스 식별자 (Option 60)를 KT_PR_HH_A_A 로 입력 후 적용:
https://www.asus.com/kr/support/faq/1011715/
![asuswrt](https://github.com/user-attachments/assets/1dd991c0-67c9-41f3-ad7b-2b6197f0f0fb)

--------------------------------
​

KT GiGA WiFi (통신사 공유기, 기본값 설정인 KT 모드가 필요) - 제한에서 벗어날 각 기기(이중 NAT 구성의 사제 공유기 포함)에 대해 수동IP설정* 또는 GiGA WiFi의 사용자 설정 페이지에서 '수동 IP 할당 설정'(DHCP 정적 할당) 설정을 마치세요

이중 NAT 구성의 사제 공유기(KT GiGA WiFi의 컴퓨터/LAN 포트와 사제 공유기의 WAN/인터넷 포트를 연결한 경우)는 해당 공유기의 수동IP설정\* 또는 '수동 IP 할당 설정'을 통해 사제 공유기와 연결한 기기의 인터넷 연결이 영향을 받도록 할 수 있습니다.

\*수동IP설정과 '수동 IP 할당 설정'은 서로 다르므로 혼동하지 마세요

하나의 GiGA WiFi(메시 단말기를 통해 연결하는 경우 또한 GiGA WiFi에 연결하는 것으로 취급)에 대해 연결할 각 기기(컴퓨터, 스마트폰, 이중 NAT 구성의 사제 공유기)마다 다른 IP주소를 설정하세요, 172.30.1.149부터 172.30.1.252까지가 권장되는 사용 가능한 범위입니다

IPTV 서비스에 가입되어 있지 않을 경우 프리미엄 IP를 할당받지 못할 가능성이 있습니다, KT GiGA WiFi의 사용자 설정 페이지 - 상태정보에서 Premium IP를 할당받았다는 로그를 확인하지 못했을 경우 Issues 또는 메일주소 3570kgen@naver.com 에 제보해주세요

아래 표를 확인하여 현재 사용중인 모델에서 사용 가능여부(추측 포함)를 확인하기\:

|＼|KM15-103H<br>또는 머큐리|DV02-012H<br>또는 다보링크|HR08-407H<br>또는 H1Radio|AR06-012H<br>또는 올래디오|
|:---------|:--------|:---------|:--------|:--------|
|수동IP설정|〇|〇|〇|〇|
|수동 IP 할당 설정|〇|〇|✕|？|
|업그레이드,TR069 차단|〇|✕|〇|？|

__표에서 확인할 수 없는 모델의 각 기능 사용 가능여부를 여러분의 제보(Issues, 메일주소 3570kgen@naver.com , 기여자에 대한 기록을 남기고 싶을경우 Pull Request 등)를 통해 보충할 수 있게 해주세요!__

__수동IP설정, '수동 IP 할당 설정'의 성공 여부,__
__KT GiGA WiFi 사용자 설정 페이지 - 상태정보의 로그('Update' 또는 'Upgrade' 등의 문자열을 포함하는 로그 확인, 부팅 후 많은 시간이 지나면 다른 로그에 의해 확인할 수 없는 경우가 있음)를 확인한 후, 'Update' 또는 'Upgrade' 등의 문자열을 포함하는 로그가 아래의 4가지 규칙 추가 & 재부팅 후 2-5분 후에 기록되는 로그와 비교해 차이점이 있는지 확인하고 알려주셨으면 합니다.__

--------------------------------
수동 IP 설정

수동 IP 설정(GiGA WiFi의 사용자 설정 페이지에서 설정한 경우 제외)은 다른 WiFi 연결 또는 다른 공유기와 연결 시 네트워크/인터넷에 연결할 수 없으므로 이 때 해당 설정을 원래대로(자동/DHCP) 되돌리세요. 각 기기마다 설정 방법이 다를 수 있습니다
서브넷 접두사 길이가 아닌 서브넷 마스크를 요구하는 경우 255.255.255.0을 입력하세요.

![W10manualIP_0](https://github.com/user-attachments/assets/77e57272-64f5-4cae-bf86-23bc7e9bcff2)

Windows 11에서는 UI에 차이가 있습니다\:

![w11SettingApp](https://github.com/user-attachments/assets/53cc5dc3-22ab-41e2-93dd-a4bc4c3d7fbd)

![W10manualIP_1](https://github.com/user-attachments/assets/fa07bd17-579b-467c-97c7-40bcc43d4ec2)

또는(분기 시작)

KT GiGA WiFi와 연결된 기기에서 http://172.30.1.254:8899 , 구성되지 않은 경우 ID는 ktuser , 비번은 megaap 또는 homehub 로 로그인 후 새로운 사용자 이름과 비번을 설정하여 사용자 설정 페이지에 접근할 수 있습니다\:

장치설정 - 네트워크 관리 - LAN 연결 설정

![StaticLeasePremiumIP_KTGiGAWiFi](https://github.com/user-attachments/assets/9d7bda7f-f1a5-4663-8435-f91347cf6cbf)

GiGA WiFi의 사용자 설정 페이지에서 '수동 IP 할당 설정'(H1Radio 미지원)을 필요에 따라 완료하세요. 당연히 이 경우 각 기기가 '자동(DHCP)'로 구성된 경우에만 위의 설정이 적용되며,
__변경 사항은 다음에 유선 또는 무선으로 연결될 때 적용되므로 KT GiGA WiFi를 재시동하거나 각 기기의 네트워크 연결을 끊었다가 다시 연결해야 할 수 있습니다.__

분기 끝

변경 사항이 적용된 후, https://icanhazip.com 와 같은 외부 서비스를 사용하여 외부 IP주소를 확인하면 기존과 다른 '프리미엄 IP'가 할당된 것을 확인할 수 있으며, 프리미엄 IP에서도 포트 포워딩을 사용할 수 있습니다.
<img width="1080" alt="GiGAWifi_premiumip" src="https://github.com/user-attachments/assets/280c972c-cc1d-4ca3-bf41-ac8a4e77b74c" />

--------------------------------

마무리로서, 해당 방법의 사용을 저지하려는 시도 중 일부를 방지하기 위해 GiGA WiFi의 자동 펌웨어 업그레이드와 TR-069 통신을 차단합시다

단, 다보링크 기기는 제외

먼저 허용 규칙부터 추가해야 GiGA WiFi에 연결된 IPTV 등의 기기에서의 오작동을 방지할 수 있습니다

4개의 규칙을 모두 추가한 후, 허용 규칙이 차단 규칙보다 밑에(머큐리) 또는 위에(H1Radio) 있으면 됩니다.

<img width="497" alt="FWUpgradeBlocking_2" src="https://github.com/user-attachments/assets/05a0f3bb-f7c1-4724-9ba3-203dc0093c36" />


--------------------------------

넷기어 (예시로서 나이트호크 RAX80) -

<img width="1424" alt="Nighthawk_RAX80" src="https://github.com/user-attachments/assets/c5c1ba09-4d63-4d28-8e2b-3f1344e36719" />

--------------------------------

시놀로지RT (예시로서 RT1900ac) - 

![RT1900ac](https://github.com/user-attachments/assets/5ea5243e-821a-42c5-a18d-e3f2dcd5319e)

--------------------------------

OpenWrt - 

https://archive.md/VRZIO

--------------------------------

//!!!!!!!!경고!!!!!!!!

//특정 이익집단 또는 영리/비영리 단체에 의해 해당 정보를 검열/은폐하려는 시도가 지속적으로 포착되고 있습니다.

//그러나 이것은 본질적으로 현대의 네트워크 유/무선공유기에서 대부분 구성 가능한 WAN포트의 'MAC 주소 클론'

//기능(추가단말/추가IP서비스 가입 유도 등을 목적으로 가입자가 임의로 구매한 유/무선공유기와 같은 기기를 

//사용하지 못하도록 차단하려는 시도를 우회)과 동일합니다.

//DHCP Option 60(Vendor Class Identifier)는 RFC 3925( https://www.rfc-editor.org/rfc/rfc3925 )에 정의된

// 표준이며, 특정 이익집단 또는 영리/비영리 단체에 의해 이용이 독점될 수 없으며, 암호화되어 있지도, 일련번호

// 등의 방법을 통해 임의 사용을 저지하려 시도하지도 않았으므로 저작권 또는 관련 법령의 침해라 보기 어려우며,

// 또한 위의 표준에 따라 평범하고 짧은 아홉-이십몇자리 ASCII 문자열을 송신하는 것에 불과하므로 본래 목적을

// 벗어나 임의의 동작을 유도하는 해킹/크래킹이라 볼 수 없습니다.
