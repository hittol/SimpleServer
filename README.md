**Simple WEB&WAS Service Platform by Terraform**
===========================
<span style="font-size: 12px">ver 2025.11.06</span>
<br>


***

### 변경 현황
|날짜|변경 내용|
|------|---|
|2025.11.06|RG, VNET, VM, APPGW 추가|

<br>

***

### 주요 내용
* 리소스의 이름 , 설정 등은 terraform.tfvars 에서 설정합니다. 
<br>

***

### 사전작업 
* <span style="font-size: 15px"> az login --tenant [Tenant ID] 를 입력해 배포할 구독의 Tenant 에 로그인 합니다. </span>
* <span style="font-size: 15px"> az account set --subscription [ subscription ID ] 를 입력해 배포할 구독의 ID 를 설정합니다. </span>
* <span style="font-size: 15px"> \$env:ARM_TENANT_ID = "Tenant ID" , \$env:ARM_SUBSCRIPTION_ID = "Subscription ID" 를 입력해 Terraform이 읽을 환경 변수를 등록합니다.</span>
<br>

***

### 사용방법
* <span style="font-size: 15px">terraform apply 시 Enter a value: 에 배포될 VM 의 Password 입력 .</span>
<br>

***