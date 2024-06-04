# ``myblog``

스위프트 학습과 iOS 개발에 대한 블로그를 Swift-DocC를 이용하여 작성하는 프로젝트 입니다.

@Metadata {
    @DisplayName("debugholic의 Swift")
}

## Overviews

Swift-DocC는 Swift Package나 프로젝트, API, 플러그인 등의 기능 명세를 위한 문서 작성 툴입니다. 하지만 마크다운을 사용하여 Article 문서를 작성할 수 있는 점에 착안하여 블로그 형태로 구성이 가능한지 도전해 볼 생각입니다. DocC가 WWDC21에 처음으로 소개되었기 때문에 추후 어떤 변화가 있을지는 알 수 없고, 그에 따라 이 블로그 형식 또한 크게 바뀔 수 있습니다. 


## Objective

- Swift-DocC 패키지를 플러그인을 통해 Github Page로 호스팅합니다. 
- 마크다운과 Swift-DocC 문서 작성법을 공부하고 블로그 형태로 적용이 가능한지 확인합니다.

## Featured

@Links(visualStyle: detailedGrid) {
    - <doc:Portfolio>
}

@TabNavigator {
    @Tab("탭 1번") {
        텍스트나 이미지를 자유롭게 넣을 수 있습니다.
    }


    @Tab("탭 2번") {
        그래프나 통계 자료를 넣을 때 유용합니다.
    }
}

@Small {
    _작은 글씨를 사용하여 권리 표시를 하거나, 참고 자료를 적을 수도 있습니다. 2024.02.26_
}

## Topics

### WWDC
- <doc:WWDC>

### 코딩 테스트
- <doc:Coding-Test>
