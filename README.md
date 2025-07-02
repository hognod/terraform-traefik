# Terraform Traefik 인프라 구축

이 프로젝트는 Terraform을 사용하여 AWS에서 Traefik 프록시 서버를 자동으로 배포하는 Infrastructure as Code(IaC) 솔루션입니다.

## 📋 개요

이 Terraform 구성은 다음을 자동으로 구축합니다:
- AWS VPC 및 네트워킹 인프라
- EC2 인스턴스
- Traefik 프록시 서버 (Docker 기반)
- Route53 DNS 설정
- Let's Encrypt 자동 SSL 인증서

## 🏗️ 인프라 구성 요소

### AWS 리소스
- **VPC**: 격리된 네트워크 환경
- **Subnet**: 퍼블릭 서브넷
- **Internet Gateway**: 인터넷 연결
- **Route Table**: 라우팅 규칙
- **Security Group**: 보안 규칙 (HTTP, HTTPS, SSH)
- **EC2 Instance**: Traefik 서버 호스팅
- **Route53**: DNS 관리

### 소프트웨어 스택
- **Docker**: 컨테이너 런타임
- **Traefik**: 리버스 프록시 및 로드 밸런서
- **Let's Encrypt**: 자동 SSL 인증서

## 📁 프로젝트 구조

```
.
├── 1_vpc.tf                    # VPC 설정
├── 2_subnet.tf                 # 서브넷 구성
├── 3_igw.tf                    # 인터넷 게이트웨이
├── 4_route_table.tf            # 라우팅 테이블
├── 5_route_table_association.tf # 라우팅 테이블 연결
├── 6_security_group.tf         # 보안 그룹 규칙
├── 7_key_pair.tf               # SSH 키 페어
├── 8_instance.tf               # EC2 인스턴스
├── 9_route53.tf                # Route53 DNS 설정
├── 10_terraform_data.tf        # 프로비저닝 스크립트
├── providers.tf                # Terraform 프로바이더 설정
├── variables.tf                # 변수 정의
├── outputs.tf                  # 출력 값
├── scripts/
│   └── docker_install.sh       # Docker 설치 스크립트
└── traefik/
    ├── docker-compose.yml      # Traefik Docker Compose 설정
    └── traefik/
        └── traefik.yml         # Traefik 구성 파일
```

## 🚀 사용법

### 사전 요구사항

1. **Terraform 설치** (v1.0 이상)
2. **AWS CLI 구성** 또는 IAM 자격 증명
3. **소유한 도메인** (Route53에서 관리되는 도메인)

### 배포 단계

1. **저장소 클론**
   ```bash
   git clone https://github.com/hognod/terraform-traefik.git
   cd terraform-traefik
   ```

2. **변수 설정**
   `terraform.tfvars` 파일을 생성하고 다음 변수들을 설정하세요:
   ```hcl
   # AWS 자격 증명
   access_key = "your-aws-access-key"
   secret_key = "your-aws-secret-key"
   region     = "ap-northeast-2"
   
   # 인스턴스 설정
   ami_id        = "ami-05d2438ca665949116"  # Ubuntu 22.04
   instance_type = "t3.micro"
   volume_size   = "20"
   
   # 도메인 및 인증서 설정
   domain_name = "example.com"
   email       = "admin@example.com"
   ```

3. **Terraform 초기화**
   ```bash
   terraform init
   ```

4. **계획 확인**
   ```bash
   terraform plan
   ```

5. **인프라 배포**
   ```bash
   terraform apply
   ```

6. **결과 확인**
   배포가 완료되면 다음 정보가 출력됩니다:
   - 퍼블릭 IP 주소
   - SSH 개인키

## 🔧 설정 변수

| 변수명 | 설명 | 기본값 | 필수 |
|--------|------|--------|------|
| `access_key` | AWS Access Key | - | ✅ |
| `secret_key` | AWS Secret Key | - | ✅ |
| `region` | AWS 리전 | - | ✅ |
| `ami_id` | EC2 AMI ID (Ubuntu) | - | ✅ |
| `instance_type` | EC2 인스턴스 타입 | - | ✅ |
| `volume_size` | EBS 볼륨 크기 (GB) | - | ✅ |
| `domain_name` | 도메인 이름 | - | ✅ |
| `email` | Let's Encrypt 인증서용 이메일 | - | ✅ |
| `os_user` | OS 사용자명 | `ubuntu` | ❌ |

## 🔍 배포 후 확인

1. **Traefik 대시보드 접속**
   - URL: `https://traefik.{your-domain}`
   - Traefik 관리 인터페이스에 접속하여 서비스 상태 확인

2. **SSL 인증서 확인**
   - 브라우저에서 사이트 접속 시 Let's Encrypt 인증서 자동 적용 확인

3. **SSH 접속**
   ```bash
   ssh -i private_key.pem ubuntu@{public-ip}
   ```

## 🛡️ 보안 고려사항

- SSH 키는 Terraform에서 자동 생성됩니다
- 보안 그룹은 필요한 포트만 열어둡니다 (22, 80, 443, 8080)
- Let's Encrypt를 통한 자동 SSL 인증서 관리
- 개인키 정보는 민감한 정보로 처리됩니다

## 🔄 업데이트 및 관리

- 설정 변경 후 `terraform apply`로 인프라 업데이트
- `terraform destroy`로 전체 인프라 삭제 가능
- Traefik 설정은 `traefik/` 디렉토리에서 관리

## 📝 라이선스

이 프로젝트는 MIT 라이선스 하에 제공됩니다.

## 🤝 기여

이슈나 개선 사항이 있다면 언제든지 GitHub Issues나 Pull Request를 통해 기여해 주세요!

---

⭐ 이 프로젝트가 도움이 되었다면 스타를 눌러주세요!
