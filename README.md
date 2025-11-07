**Simple WEB&WAS Service Platform by Terraform**
===========================
<span style="font-size: 12px">ver 2025.11.07</span>
<br>


***
### 아키텍처
<img src="./archi.jpg", height="100x", width="100px">


<br>

### 변경 현황
|날짜|변경 내용|
|------|---|
|2025.11.06|RG, VNET, VM, APPGW 추가|
|2025.11.07|NATGW,Recovery Vault,LA&DCR,Network 설정 추가|

<br>

***

### 주요 내용
* 리소스의 이름 , 설정 등은 terraform.tfvars 에서 설정합니다.
* 배포 후 Log Analytics 의 Classic - VirtualMachine 에서 등록된 VM 을 연결시켜줍니다.
* VM 접속은 .key 에 저장된 SSH Key 를 통해 접속합니다. 
* WAF 사용자 지정 정책에서 접속 허용할 IP 를 지정해줍니다.
<br>

***

### 사전작업 
* <span style="font-size: 15px"> az login --tenant [Tenant ID] 를 입력해 배포할 구독의 Tenant 에 로그인 합니다. </span>
* <span style="font-size: 15px"> az account set --subscription [ subscription ID ] 를 입력해 배포할 구독의 ID 를 설정합니다. </span>
* <span style="font-size: 15px"> \$env:ARM_TENANT_ID = "Tenant ID" , \$env:ARM_SUBSCRIPTION_ID = "Subscription ID" 를 입력해 Terraform이 읽을 환경 변수를 등록합니다.</span>
<br>

***

### 사용방법
* <span style="font-size: 15px">배포 후 VM 접근 시 .Key 의 SSH 인증서 파일 사용.</span>
<br>

***