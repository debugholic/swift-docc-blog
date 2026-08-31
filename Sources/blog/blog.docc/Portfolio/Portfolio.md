# 포트폴리오

@Metadata {
    @TechnologyRoot
}

오디오 기기 펌웨어부터 교육 서비스 앱까지, 플랫폼을 가리지 않고 만들어 온 iOS 개발자 김영훈입니다.

## Overview

안녕하세요. iOS 개발자 김영훈입니다.

아이리버 R&D연구소에서 Astell&Kern 오디오 기기의 컴패니언 앱과 Android 기반 펌웨어를 개발하며 커리어를 시작했습니다. DLNA(UPnP) 스펙 구현, FFmpeg 포팅, Android Media Framework처럼 저수준 미디어와 프로토콜을 직접 다루는 일이 많았습니다.

2019년부터는 해커스 모바일개발팀에서 교육 서비스 iOS 앱을 담당하고 있습니다. 레거시 Objective-C 앱의 Swift 전면 전환과 다수 앱의 리뉴얼 출시를 진행했고, 이후에는 공통 기능을 Swift Package로 모듈화하고 Tuist 기반 Micro Feature Architecture와 GitHub Actions CI/CD를 도입하며 앱 하나가 아니라 팀의 개발 환경 전체를 다루는 쪽으로 범위를 넓혀 왔습니다. 현재는 모바일개발1팀 팀장으로 일하고 있습니다.

## 핵심 역량

- **레거시 코드 현대화** — Objective-C로 작성된 앱을 Swift로 전면 리팩토링하고 Auto Layout으로 전환, 다수의 앱을 리뉴얼하여 앱스토어에 재출시했습니다.
- **공통 모듈 설계와 재사용** — 로그인, 학습 알람, Push 알림 등 여러 앱에 반복되던 기능을 Swift Package로 분리하고, Micro Feature Architecture 기반으로 고도화했습니다.
- **미디어 · 오디오 도메인** — DLNA(UPnP) 컨트롤러 구현, FFmpeg 포팅과 libavfilter 기반 EQ, 동영상 플레이어 SDK 연동 등 미디어 재생 전반을 다뤘습니다.
- **플랫폼 경계를 넘는 개발** — iOS 네이티브뿐 아니라 Android 앱과 Android Framework 펌웨어, React Native 앱에 붙는 네이티브 모듈까지 필요한 쪽을 직접 구현했습니다.
- **개발 환경과 프로세스 정비** — Tuist 기반 모듈 구조와 GitHub Actions CI/CD를 구축해 빌드와 배포 과정을 정리했습니다.
- **팀 리딩** — iOS 파트장(2021.11~)을 거쳐 모바일개발1팀 팀장(2022.11~)으로 팀의 기술 방향과 일정을 함께 책임지고 있습니다.

## Profile

* 김영훈
* 1988.11.04
* cwaaw195@gmail.com
* [debugholic의 Github](https://github.com/debugholic)
* [Swift-DocC 블로그](https://debugholic.github.io/swift-docc-blog/documentation/blog/)

## Careers

* **해커스 기획본부 모바일개발1팀 팀장** (2022.11 ~ 재직 중)
    - 모바일 개발 조직 리딩 및 iOS 앱 개발
* **해커스 기획본부 모바일개발1팀 iOS 파트장** (2021.11 ~ 2022.11)
    - iOS 파트 리딩 및 앱 리뉴얼 프로젝트 담당
* **해커스 기획본부 모바일개발팀 iOS 파트 프로** (2019.09 ~ 2021.11)
    - 교육 서비스 iOS 앱 개발 및 리팩토링
* **아이리버 R&D연구소 SW팀 사원** (2016.05 ~ 2019.02)
    - Astell&Kern 컴패니언 앱 및 Android 기반 펌웨어 개발
* **아이리버 R&D연구소 SW팀 인턴** (2016.02 ~ 2016.04)

## Skills

@Row {
    @Column {
        **Languages**
        - Swift, Objective-C
        - Java, C, C++

        **iOS**
        - UIKit, SwiftUI
        - CoreData, CoreAudio
        - App Extension (Widget)
        - StoreKit 2, 인앱 결제
    }
    @Column {
        **아키텍처 · 도구**
        - Swift Package Manager
        - Tuist, Micro Feature Architecture
        - GitHub Actions (CI/CD)

        **Android · 미디어**
        - Android 앱 및 Framework 개발
        - 펌웨어 OTA 배포
        - DLNA(UPnP), FFmpeg (libavfilter)
        - TIDAL / Deezer SDK 연동

        **기타**
        - 데이터베이스 및 웹 API 연동
        - React Native 네이티브 모듈 연동
    }
}

## Educations

* 성균관대학교 컴퓨터공학과 (2012.03 ~ 2016.08) 졸업 (*편입)
* 한국철도대학교 경영정보학과 (2007.03 ~ 2009.02) 졸업
* 서울 경신고등학교 (2004.03 ~ 2007.02) 졸업

## Projects

### 해커스 — 앱 개발 · 리뉴얼

@Row {
    @Column {
        * **해커스 그림보카 앱 리뉴얼 개발**
            - 앱스토어 출시
            - 리뉴얼 앱 개발
            - Swift 및 UIKit
            - 서버 및 로컬 데이터 기반
            - 인앱 결제
    }
    @Column { ![그림보카](GrimVoca.png) }
}

@Row {
    @Column {
        * **해커스 기출보카 앱 리뉴얼 개발**
            - 앱스토어 출시
            - 리뉴얼 앱 개발
            - Swift 및 UIKit
            - 서버 및 로컬 데이터 기반
            - 인앱 결제
    }
    @Column { ![기출보카](GichulVoca.png) }
}

@Row {
    @Column {
        * **해커스 일본어 앱 개발**
            - 앱스토어 출시
            - 신규 앱 개발
            - Swift 및 UIKit
            - 서버 및 로컬 데이터 기반
    }
    @Column { ![일본어](Japanese.png) }
}

@Row {
    @Column {
        * **해커스 빅플 앱 리뉴얼 개발**
            - 앱스토어 출시
            - 리뉴얼 앱 개발
            - Swift 및 UIKit
            - 서버 및 로컬 데이터 기반
            - 인앱 결제
    }
    @Column { ![빅플](BigPle.png) }
}

@Row {
    @Column {
        * **해커스 보카 2nd 앱 리뉴얼 개발**
            - 앱스토어 출시
            - 리뉴얼 앱 개발
            - Swift 및 UIKit
            - 로컬 데이터 기반
    }
    @Column { ![보카2nd](Voca2nd.png) }
}

@Row {
    @Column {
        * **해커스 텝스 기출 보카 어드밴스드 앱 리팩토링 개발**
            - 앱스토어 출시
            - Objective-C 소스코드를 Swift로 전체 리팩토링 작업
            - UIKit Auto Layout 적용
    }
    @Column { ![어드밴스드](TepsAdvanced.png) }
}

@Row {
    @Column {
        * **해커스 텝스 기출 보카 인터미디엇 앱 리팩토링 개발**
            - 앱스토어 출시
            - Objective-C 소스코드를 Swift로 전체 리팩토링 작업
            - UIKit Auto Layout 적용
    }
    @Column { ![인터미디엇](TepsIntermediate.png) }
}

* **해커스 어학원 앱 리뉴얼 개발**
    - Tuist, Micro Feature Architecture
    - Swift 및 SwiftUI

* **해커스 매일국어 앱 리팩토링 개발**
    - Tuist, Micro Feature Architecture
    - Swift 및 SwiftUI

* **기타 해커스 iOS 전체 앱에 대한 유지보수**

### 해커스 — 플랫폼 · 공통 모듈 · 인프라

* **해커스 앱 공통 기능 모듈화 작업**
    - Swift Package Manager 배포
    - 로그인, 해커스에 바란다, 학습 알람, Push 알림 등의 기능 모듈화

* **해커스 공통 모듈 SPM 고도화**
    - Micro Feature Architecture
    - StoreKit 2.0
    - Swift 및 SwiftUI

* **해커스 One 앱 동영상 플레이어 모듈 개발**
    - Swift Package Manager 배포
    - React Native 앱의 Export Module로 적용
    - 액시스소프트 사의 스타플레이어 iOS SDK 사용

* **해커스 ONE 영상 플레이어 모듈 리뉴얼 개발**
    - Tuist, Micro Feature Architecture
    - Swift 및 UIKit

* **해커스 One 앱 위젯 개발**
    - Native 익스텐션 구현
    - Swift 및 SwiftUI

* **CI/CD 구축**
    - GitHub Actions, Relay Repository
    - YAML (with Claude Code)

### 아이리버

@Row {
    @Column {
        * **AKRecorder 어플리케이션 개발, 앱스토어 출시 (iOS)**
            - DLNA(UPnP) 서비스 네트워킹 앱
            - Astell&Kern Recorder 제품을 원격으로 조작 가능
            - 최대 4개의 기기까지 링크 가능
            - 당사에서 개발한 UPnP Recorder Specification을 사용
    }
    @Column { ![AK Recorder](AKRecorder.png) }
}

@Row {
    @Column {
        * **AKConnect 2.0 어플리케이션 개발, 앱스토어 출시 (iOS)**
            - 외주 AK Connect 앱에 대한 리뉴얼 작업
            - DLNA(UPnP) 서비스 네트워킹 앱
            - Astell&Kern DAP 제품을 원격으로 조작 가능
            - 서버와 렌더러를 선택하여 DLNA 컨트롤러 역할
            - TIDAL API를 통한 TIDAL 음원 제공
            - FFmpeg를 포팅하여 다양한 포맷에 대한 재생 지원
            - 높은 수준의 DLNA 기능 제공
    }
    @Column { ![AK Connect 2.0](AKConnect.png) }
}

@Row {
    @Column {
        * **ACTIVO 펌웨어 EQ 개발**
            - 펌웨어 OTA 배포 (Android Framework)
            - Android Media Framework 개발
            - 하드웨어 EQ를 사용하지 않는 제품의 펌웨어에 적용
            - FFmpeg libavfilter 사용
    }
    @Column { ![EQ](EQ.png) }
}

@Row {
    @Column {
        * **Deezer 스토어 어플리케이션 개발**
            - 펌웨어 OTA 배포 (Android Framework)
            - Android 앱 개발
            - 스트리밍 서비스 Deezer의 Android SDK 사용
            - Astell&Kern 스토어 전용 앱
    }
    @Column { ![AKDeezer](AKDeezer.png) }
}

* **AMP 제품 펌웨어 개발**
    - 펌웨어 OTA 배포 (Android Framework)
    - Android Framework 개발
    - AMP 연결 시 Astell&Kern 제품의 펌웨어 부분 구현

## 학습과 기록

새 API를 쓰는 법보다 왜 그렇게 설계되었는지가 오래 남는다고 생각해서, WWDC 세션과 서적을 읽고 정리해 두고 있습니다. Swift-DocC로 블로그를 구성할 수 있는지 실험하는 것 자체도 이 저장소의 목적 중 하나입니다.

- <doc:WWDC-Analysis> — 2007년 이후 WWDC 세션을 연도별로 정리합니다.
- <doc:Testing> — *Unit Testing Principles, Practices, and Patterns* 학습 정리입니다.
- <doc:Coding-Test> — 알고리즘 문제 풀이 기록입니다.

@Small {
    _본 문서는 Swift-DocC로 작성되었으며, 내용은 계속 갱신됩니다. 최종 수정: 2026.08_
}
