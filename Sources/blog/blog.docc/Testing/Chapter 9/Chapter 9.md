# 9장 목 모범 사례

## 요약

목의 일반적인 사용법과 단점, 이러한 단점을 극복할 수 있는 방법을 알아봅니다.

### 9.1 목의 가치 극대화

목의 사용을 비관리형 의존성으로 제한하는 것이 중요하지만, 이는 목의 가치를 극대화하기 위한 첫 단계에 불과합니다.

이 주제는 예제로 가장 잘 설명되므로 이전 장의 CRM 시스템을 통해서 목을 통해 어떻게 개선될 수 있는지 보게 될 것입니다.

```
final class UserController {
  private let database: Database
  private let eventDispatcher: EventDispatcher

  init(database: Database, messageBus: MessageBus, domainLogger: DomainLogger) {
    self.database = database
    self.eventDispatcher = EventDispatcher(messageBus: messageBus, domainLogger: domainLogger)
  }

  func changeEmail(userId: Int, newEmail: String) -> String {
    guard let userData = database.getUserById(userId) else {
      return "UserNotFound"
    }

    let user = UserFactory.create(from: userData)

    if let error = user.canChangeEmail() {
      return error
    }

    guard let companyData = database.getCompany() else {
      return "CompanyNotFound"
    }

    let company = CompanyFactory.create(from: companyData)

    user.changeEmail(newEmail, company: company)

    database.saveCompany(company)
    database.saveUser(user)

    eventDispatcher.dispatch(user.domainEvents)

    return "OK"
  }
}
```

더 이상 진단 로깅은 없지만 지원 로깅(IDomain-Logger 인터페이스)은 여전히 제자리에 있습니다.

또한 새로운 클래스인 `EventDispatcher`가 도입됩니다.

`EventDispatcher`는 도메인 이벤트를 받아서 외부 시스템 호출로 바꿔주는 역할입니다.

```
final class EventDispatcher {
  private let messageBus: MessageBus
  private let domainLogger: DomainLogger

  init(messageBus: MessageBus, domainLogger: DomainLogger) {
    self.messageBus = messageBus
    self.domainLogger = domainLogger
  }

  func dispatch(_ events: [DomainEvent]) {
    for ev in events {
      dispatch(ev)
    }
  }

  private func dispatch(_ ev: DomainEvent) {
    switch ev {
    case let e as EmailChangedEvent:
      messageBus.sendEmailChangedMessage(userId: e.userId, newEmail: e.newEmail)
    case let e as UserTypeChangedEvent:
      domainLogger.userTypeHasChanged(userId: e.userId, oldType: e.oldType, newType: e.newType)
    default:
      break
    }
  }
}
```

마지막으로, 다음 통합 테스트는 모든 외부 프로세스 의존성(관리형 및 비관리형 모두)을 거치게 됩니다.

```
func changing_email_from_corporate_to_non_corporate() {
  // Arrange
  let db = InMemoryDatabase()
  db.insertUser(userId: 1, email: "user@mycorp.com", typeRaw: UserType.employee.rawValue)
  db.insertCompany(domain: "mycorp.com", numberOfEmployees: 1)

  let messageBusMock = MessageBusMock()
  let loggerMock = DomainLoggerMock()
  let sut = UserController(database: db, messageBus: messageBusMock, domainLogger: loggerMock)

  // Act
  let result = sut.changeEmail(userId: 1, newEmail: "new@gmail.com")

  // Assert
  XCTAssertEqual("OK", result)

  guard let userData = db.getUserById(1) else {
    XCTFail("User not found in DB")
    return
  }
  let userFromDb = UserFactory.create(from: userData)
  XCTAssertEqual("new@gmail.com", userFromDb.email)
  XCTAssertEqual(UserType.customer, userFromDb.type)

  guard let companyData = db.getCompany() else {
    XCTFail("Company not found in DB")
    return
  }
  let companyFromDb = CompanyFactory.create(from: companyData)
  XCTAssertEqual(0, companyFromDb.numberOfEmployees)

  XCTAssertEqual(1, messageBusMock.sendEmailCalls.count)
  XCTAssertEqual((1, "new@gmail.com"), messageBusMock.sendEmailCalls.first)
}
```

이 테스트는 관리되지 않는 두 개의 의존성인 `MessageBus`과 `DomainLogger`를 목으로 대체합니다.

먼저 `MessageBus`에 초점을 맞추겠습니다. 

이 장의 뒷부분에서 `DomainLogger`에 대해 논의할 것입니다.

##### 9.1.1 시스템 가장자리에서 상호작용 검증

다음 예시의 통합 테스트에서 사용하는 목이 회귀 및 리팩토링 저항에 대한 보호 측면에서 이상적이지 않은 이유와 이를 어떻게 해결할 수 있는지 논의해 봅시다.

> 목을 사용할 때는 항상 시스템의 가장자리에서 비관리형 의존성과의 상호작용을 검증해야 합니다.

예시의 `messageBusMock`의 문제는 `MessageBus` 인터페이스가 시스템의 가장자리에 위치하지 않는다는 것입니다.

```
protocol MessageBus {
  func sendEmailChangedMessage(userId: Int, newEmail: String)
}

protocol Bus {
  func send(_ message: String)
}

final class MessageBusImpl: MessageBus {
  private let bus: Bus

  init(bus: Bus) {
    self.bus = bus
  }

  func sendEmailChangedMessage(userId: Int, newEmail: String) {
    let message = "Type: USER EMAIL CHANGED; Id: \(userId); NewEmail: \(newEmail)"
    bus.send(message)
  }
}
```

`Bus`는 메시지 버스 SDK 라이브러리 위에 있는 래퍼이고, `MessageBus`는 `Bus` 위에 있는 도메인 특정 메시지를 정의하는 래퍼입니다.

`MessageBus`가 아닌 `Bus`를 목으로 대체하는 것이 회귀 방지를 최대화합니다.

왜냐하면 테스트가 더 많은 코드를 통과하게 되므로 검증되는 코드의 양이 증가하기 때문입니다.

시스템의 가장자리에 있는 가장 마지막 타입을 목으로 대체하면 통합 테스트가 통과하는 클래스 수가 증가하여 회귀 방지 기능이 향상됩니다.

@Image(source: 9-1.png)

`MessageBus`를 더 이상 모의화하지 않기 때문에, 이 인터페이스는 삭제될 수 있으며 그 사용은 `MessageBus` 구현체로 대체될 수 있습니다.

```
func changing_email_from_corporate_to_non_corporate() {
  let busMock = BusMock()
  let messageBus = MessageBus(busMock)
  let loggerMock = LoggerMock()
  let sut = UserController(db: db, messageBus: messageBus, logger: loggerMock)

  /* ... */
  
  XCTAssertEqual(busMock.sentMessages.count, 1)
  XCTAssertEqual(busMock.sentMessages.first, "Type: USER EMAIL CHANGED; Id: 42; NewEmail: new@gmail.com")
}
```

`MessageBus` 같은 클래스의 호출 여부를 확인하는 것보다, 외부 시스템에 실제로 전달되는 텍스트 메시지를 검증하는 게 훨씬 중요합니다.

외부 시스템 입장에서 보면, 어떤 클래스가 호출됐는지는 상관없고 오직 전달받은 메시지 문자열만 의미가 있습니다.

따라서 테스트도 클래스 호출이 아니라 최종 메시지 문자열을 검증해야 합니다.

이렇게 하면 리팩터링을 해도 메시지 포맷이 같다면 테스트는 실패하지 않으므로, 거짓 양성을 줄이고 안정성을 높일 수 있습니다.

##### 9.1.2 목을 스파이로 교체

**스파이(spy)**는 목과 동일한 목적을 가진 테스트 더블의 일종입니다. 

유일한 차이점은 스파이는 수동으로 작성되고, 목은 프레임워크의 도움을 받아 생성된다는 것입니다. 

스파이는 수기 목(handwritten mocks)이라고도 불립니다.

시스템 가장자리에 있는 클래스의 경우 스파이가 목보다 우수합니다.

```
protocol Bus {
  func send(_ message: String)
}

class BusSpy: Bus {
  private var sentMessages: [String] = []

  func send(_ message: String) {
    sentMessages.append(message)
  }

  func shouldSendNumberOfMessages(_ number: Int) -> BusSpy {
    XCTAssertEqual(number, sentMessages.count)
    return self
  }

  func withEmailChangedMessage(userId: Int, newEmail: String) -> BusSpy {
    let message = "Type: USER EMAIL CHANGED; " +
      "Id: \(userId); " +
      "NewEmail: \(newEmail)"
    XCTAssertTrue(sentMessages.contains { $0 == message })
    return self
  }
}
```

다음은 통합 테스트의 새 버전입니다.

```
func changing_email_from_corporate_to_non_corporate() {
  let busSpy = BusSpy()
  let messageBus = MessageBus(busSpy)
  let loggerMock = LoggerMock()
  let sut = UserController(db: db, messageBus: messageBus, logger: loggerMock)

  /* ... */
  busSpy.shouldSendNumberOfMessages(1)
    .withEmailChangedMessage(userId: user.userId, newEmail: "new@gmail.com")
}
```

스파이는 검증 단계에서 코드를 재사용하여 테스트 크기를 줄이고 가독성을 높이는 데 도움을 줍니다.

`BusSpy`의 `shouldSendNumberOfMessages()`나 `withEmailChangedMessage()`와 같은 **유창한 인터페이스(fluent interface)** 를 통해 간결하고 표현력 있는 검증을 작성할 수 있습니다.

> `BusSpy`의 이름을 `BusMock`으로 바꿀 수 있습니다. 
>
> 모의와 스파이의 차이점은 구현 세부 사항입니다.
>
> 대부분의 개발자들은 스파이라는 용어에 친숙하지 않으므로 `BusMock`을 사용하는 것이 혼란을 피할 수 있습니다.

`BusSpy`와 `MessageBus` 모두 `Bus` 위에 있는 래퍼이기 때문에 유사한 형태를 갖습니다.

하지만 결정적인 차이는 **`BusSpy`는 테스트 코드**의 일부이고 **`MessageBus`는 프로덕션 코드**에 속한다는 것입니다.

테스트는 프로덕션 코드에 의존하여 검증을 만들어서는 안 되므로, `BusSpy`는 메시지 구조 변경 시 실제 코드(`MessageBus`)는 그대로 두면서 독립적인 검증 지점을 제공합니다.

##### 9.1.3 DomainLogger는 어떠한가?

`MessageBus`가 `Bus`의 래퍼인 것처럼, `DomainLogger`는 `Logger`의 래퍼이니, 리타겟팅(retargeting)할 필요가 없을까요?

대부분의 프로젝트에서 그러한 리타겟팅은 필요하지 않습니다. 

`Logger`와 `MessageBus`는 관리되지 않는 의존성이므로 둘 다 호환성을 유지해야 합니다.

하지만 그 호환성의 정확성은 반드시 같을 필요는 없습니다.

* 메시지 버스의 경우, 외부 시스템이 메시지 구조에 의존할 수 있으므로 메시지 구조는 절대 변경해서는 안됩니다.
* 반면 로그의 정확한 구조는 대상 사용자에게는 그렇게 중요하지 않고, 로그가 존재한다는 것과 그 로그가 필요한 정보를 담고 있다는 것이 중요합니다.

따라서 `DomainLogger`을 목으로 만드는 것만으로 충분한 보호 수준을 제공합니다.

### 9.2 목 모범 사례

지금까지 두 가지 주요 모의화 모범 사례를 배웠습니다.
* 목을 비관리형 의존성에만 적용합니다.
* 시스템의 가장자리에서 해당 의존성과의 상호작용을 검증합니다.

이 섹션에서는 나머지 모범 사례를 설명합니다

##### 9.2.1 목은 통합 테스트 전용

목은 통합 테스트에만 사용되어야 하며 단위 테스트에는 사용되어서는 안 된다는 지침은 비즈니스 로직과 오케스트레이션의 분리라는 근본적인 원칙에서 비롯됩니다.

이 원칙은 **도메인 모델(복잡성 처리)과 컨트롤러(통신 처리)** 라는 두 개의 서로 다른 계층으로 자연스럽게 이어집니다.

컨트롤러는 비관리형 의존성과 상호작용하는 유일한 코드이므로, 목은 컨트롤러를 테스트할 때만 적용되어야 합니다. 

즉, 통합 테스트에서만 사용해야 합니다.

##### 9.2.2 테스트당 목이 하나만 있는 것은 아니다

때때로 시험당 하나의 모의만 가지고 있다는 지침을 들을 수 있습니다. 

이 지침에 따르면, 만약 하나 이상의 모의를 가지고 있다면, 한 번에 여러 가지를 테스트하고 있을 가능성이 높습니다.

이 문제는 2장에서 설명한 근본적인 오해에서 기인합니다.

단위 테스트에서 **단위(unit)** 라는 용어는 코드의 단위가 아니라 **행동의 단위(unit of behavior)** 를 의미합니다.

이러한 행동의 단위를 구현하는 데 필요한 코드의 양은 중요하지 않습니다.

마찬가지로, 행동의 단위를 검증하는 데 필요한 목의 수는 중요하지 않습니다. 

목의 수는 오직 해당 작업에 참여하는 비관리형 의존성의 수에만 의존합니다.

##### 9.2.3 호출 횟수 검증
관리되지 않는 의존성과의 커뮤니케이션에 관해서는 다음 두 가지를 모두 보장하는 것이 중요합니다. 
* 예상되는 호출의 발생
* 예상치 못한 호출의 부재

이는 비관리형 의존성과의 역방향 호환성을 유지해야 하는 필요성에서 비롯됩니다.

호환성은 양방향으로 진행되어야 합니다. 

애플리케이션은 외부 시스템이 기대하는 메시지를 생략해서는 안 되며 예상치 못한 메시지를 생성해서는 안 됩니다. 

테스트 중인 시스템이 다음과 같은 메시지를 보내는지 확인하는 것만으로는 충분하지 않습니다.

```
XCTAssertTrue(messageBusMock.sentMessages.contains("Type: USER EMAIL CHANGED; Id: \(user.userId); NewEmail: new@gmail.com"))
🔹```

이 메시지가 정확히 한 번 전송되었는지 또한 확인해야 합니다.

대부분의 라이브러리에서는 목에서 다른 호출이 수행되지 않는지 명시적으로 확인할 수도 있습니다. 

```
XCTAssertEqual(messageBusMock.sentMessages.count, 1) 
```

BusSpy를 사용하면 다음과 같이 더 간결하게 작성할 수 있습니다.

```
busSpy.shouldSendNumberOfMessages(1)
  .withEmailChangedMessage(userId: user.userId, newEmail: "new@gmail.com")
```

##### 9.2.4 소유한 타입만 목으로 대체

마지막 지침은 당신이 소유한 유형만 목으로 대체하는 것입니다. 

즉, 서드파티 라이브러리 위에 자신만의 어댑터(adapter)를 작성하고 해당 어댑터를 목으로 대체해야 합니다.

이는 다음과 같은 이유 때문입니다.
* 서드파티 코드의 작동 방식을 깊이 이해하지 못하는 경우가 많습니다.
* 내장 인터페이스가 있더라도, 목으로 대체하는 동작이 실제 라이브러리가 하는 일과 일치하는지 확신하기 어렵습니다.
* 어댑터는 외부 라이브러리의 복잡한 내부 구현을 감추고, 우리 애플리케이션에서 이해할 수 있는 의미 있는 방식으로 라이브러리 기능을 연결해주는 역할을 합니다.

어댑터는 코드와 외부 세계 사이에 **안티-커럽션 계층(anti-corruption layer)** 역할을 하여 라이브러리 업그레이드 시 발생할 수 있는 파급 효과를 제한합니다.
* 기본 라이브러리의 복잡성을 추상화하는 데 도움이 됩니다. 
* 라이브러리에서 필요한 기능만 노출합니다.
* 프로젝트의 도메인 언어를 사용하여 이를 표현합니다.  

예제 CRM 프로젝트의 `Bus` 인터페이스는 정확히 그 목적을 수행합니다.

기본 메시지 버스의 라이브러리가 `Bus`만큼 멋지고 깨끗한 인터페이스를 제공하더라도, 그 위에 자신만의 래퍼를 도입하는 것이 좋습니다. 

라이브러리를 업그레이드할 때 타사 코드가 어떻게 변할지 알 수 없고 전체 코드 기반에 파급 효과를 일으킬 수 있습니다.

추가 추상화 계층은 그 파급 효과를 단 하나의 클래스, 즉 어댑터 자체로 제한합니다. 

이 지침은 프로세스 내 의존성에 적용되지 않습니다.

목은 관리되지 않는 의존성에만 해당되므로, 인메모리(in-memory) 또는 관리되는 의존성을 추상화할 필요는 없습니다.

예를 들어, 라이브러리가 날짜 및 시간 API를 제공하는 경우, 관리되지 않는 종속성에 도달하지 않기 때문에 해당 API를 있는 그대로 사용할 수 있습니다.
