# debugholic의 Swift

Swift-DocC로 만든 개발 블로그이자 포트폴리오입니다.

**[📄 포트폴리오](https://debugholic.github.io/swift-docc-blog/documentation/portfolio/)** ·
**[📝 블로그](https://debugholic.github.io/swift-docc-blog/documentation/blog/)**

## 왜 Swift-DocC 인가

Swift-DocC는 Swift 패키지와 API의 기능 명세를 위한 문서 작성 도구입니다.
다만 마크다운으로 Article 문서를 작성할 수 있다는 점에 착안해, 이것만으로 블로그를
구성할 수 있는지 시험해 보는 것이 이 저장소의 출발점이었습니다.

일반적인 정적 사이트 생성기 대신 DocC를 택했을 때 얻는 것과 잃는 것이 있습니다.

- `@Row` / `@Column`, `@TabNavigator`, `@Links` 같은 디렉티브로 문서 레이아웃을 구성할 수 있습니다
- `<doc:>` 링크가 빌드 시점에 검증되어, 끊어진 링크가 있으면 경고로 잡힙니다
- 반면 글마다 작성일을 붙이거나 시간순으로 나열하는 등 블로그다운 기능은 직접 구성해야 합니다

## 구성

```
Sources/blog/blog.docc/
├── Home.md              루트 페이지
├── Portfolio/           포트폴리오 (@TechnologyRoot)
├── WWDC/                WWDC 세션 정리 — 연도별 인덱스 + 세션 문서
├── Testing/             『Unit Testing Principles, Practices, and Patterns』 학습 정리 (1~11장)
├── Coding Test/         알고리즘 문제 풀이
└── Resources/           이미지 리소스
```

## 로컬에서 보기

```bash
swift package --disable-sandbox preview-documentation --target blog
```

정적 사이트를 그대로 만들어 보려면 배포와 동일한 명령을 씁니다.

```bash
swift package --allow-writing-to-directory ./docs \
  generate-documentation --target blog --disable-indexing \
  --output-path ./docs \
  --transform-for-static-hosting \
  --hosting-base-path swift-docc-blog
```

> `--disable-indexing` 을 빼면 플러그인이 현재 docc에 없는 옵션을 넘겨 빌드가 실패합니다.

## 배포

`main` 브랜치에 푸시하면 GitHub Actions가 문서를 빌드해 GitHub Pages로 배포합니다.
워크플로는 [`.github/workflows/build-and-deployment.yml`](.github/workflows/build-and-deployment.yml)에 있습니다.

## 만든 사람

김영훈 · iOS 개발자
[GitHub](https://github.com/debugholic) · cwaaw195@gmail.com
