# Chapter 10 데이터베이스 테스팅

## 요약

이 장에서는 데이터베이스 테스트를 시작하기 전에 취해야 할 예비 단계와 스키마 추적을 다룹니다.

상태 기반 데이터베이스 제공 방식과 마이그레이션 기반 데이터베이스 전달 접근 방식의 차이점을 설명하고, 전자보다 후자를 선택해야 하는 이유를 보여줍니다.


### 10.1 데이터베이스 테스트를 위한 전제 조건

관리되는 종속성(managed dependencies)은 통합 테스트에 있는 그대로 포함되어야 하므로, 테스트를 시작하기 전에 준비 단계를 거쳐야 합니다.

* 데이터베이스를 소스 제어 시스템에 유지 
* 개발자별 별도 인스턴스 사용 
* 데이터베이스 전송에 마이그레이션 기반 접근 방식 적용하기 

##### 10.1.1 데이터베이스를 소스 제어 시스템에 유지

데이터베이스를 테스트하는 첫 번째 단계는 데이터베이스 스키마를 정규 코드로 취급하는 것입니다. 

일반 코드와 마찬가지로 데이터베이스 스키마는 에  

데이터베이스 스키마는 전용 '모델 데이터베이스' 인스턴스를 유지하는 대신 Git과 같은 소스 제어 시스템 에 저장하는 것이 가장 좋습니다.

다음과 같은 이유 때문입니다.

* 변경 내역 없음:
  - 데이터베이스 스키마를 과거의 어느 시점으로 거슬러 올라갈 수 없습니다. 
  - 이는 프로덕션에서 버그를 재현할 때 중요할 수 있습니다.

* 단일 진실 공급원이 없음: 
  - 모델 데이터베이스는 개발 상태에 대한 경쟁 진실 공급원이 된다.
  - 그러한 두 가지 소스(Git 및 모델 데이터베이스)를 유지하는 것은 추가적인 부담을 야기한다.

반면에 소스 제어 시스템에 모든 데이터베이스 스키마 업데이트를 유지하면 단일 진실 공급원을 유지하고 일반 코드의 변경 사항과 함께 데이터베이스 변경 사항을 추적하는 데 도움이 됩니다.

##### 10.1.2 참조 데이터는 데이터베이스 스키마의 일부

데이터베이스 스키마는 테이블, 뷰, 인덱스, 저장 프로시저 및 데이터베이스가 어떻게 구성되는지에 대한 청사진을 형성하는 모든 것입니다.

스키마 자체는 SQL 스크립트의 형태로 표현됩니다.

이러한 스크립트를 사용하여 언제든지 완전한 기능을 갖춘 최신 데이터베이스 인스턴스를 만들 수 있어야 합니다.

참조 데이터는 데이터베이스 스키마에 속하지만 그렇게 보이지 않는 부분입니다.

> 정의: 참조 데이터란 어플리케이션는 적절하게 동작하기 위해 미리 채워져야 하는 데이터.

예를 들어 고객 관계 관리(CRM) 시스템에서 참조 데이터는 사용자는 고객 유형 또는 직원 유형일 수 있습니다. 

> Tip: 참조 데이터를 일반 데이터와 구별하는 간단한 방법이 있습니다. 
>
> 응용 프로그램이 데이터를 수정할 수 있다면 일반 데이터입니다.
>
> 그렇지 않으면 참조 데이터입니다.

참조 데이터는 SQL INSERT 문 형태로 테이블, 뷰 및 데이터베이스 스키마의 다른 부분과 함께 소스 제어 시스템에 보관해야 합니다.

또한  일반 데이터와 분리하여 저장하는 것이 좋지만, 같은 테이블에 공존할 경우 수정 가능 여부를 구분하는 플래그를 도입해야 합니다.

##### 10.1.3 개발자별 별도 인스턴스 분리

데이터베이스를 실제 환경에서 테스트하는 것은 어렵고 다른 개발자들과 공유해야 한다면 더욱 어려워 집니다.

* 서로 다른 개발자가 실행하는 테스트는 서로 간섭합니다.
* 이전 버전과 호환되지 않는 변경 사항은 다른 개발자의 작업을 방해할 수 있습니다.

개발 프로세스에 방해받지 않도록 모든 개발자는 별도의 데이터베이스 인스턴스를 유지해야 하며, 테스트 실행 속도를 최대화하기 위해 가급적 개발자 자신의 머신에 호스팅해야 합니다. 

##### 10.1.4 상태 기반 vs. 마이그레이션 기반 데이터베이스 전달

데이터베이스 전송에는 상태 기반과 마이그레이션 기반이라는 두 가지 주요 접근 방식이 있습니다.

마이그레이션 기반 접근 방식은 처음에는 구현하고 유지하기가 더 어렵지만 장기적으로는 상태 기반 접근 방식보다 훨씬 잘 작동합니다.

* 상태 기반 접근 방식
  - 모델 데이터베이스를 유지하며 개발을 진행합니다.
  - 배포 시 비교 도구(comparison tool) 가 프로덕션 DB를 모델 DB와 동기화할 스크립트를 자동으로 생성합니다.
  - 실제 물리적인 모델 DB 대신, 해당 DB를 만들 수 있는 SQL 스크립트를 소스 컨트롤에 저장합니다.
  - 비교 도구가 모든 작업(불필요한 테이블 삭제, 새 테이블 생성, 컬럼 이름 변경 등)을 처리합니다.

* 마이그레이션 접근방식
  - 데이터베이스를 한 버전에서 다른 버전으로 전환하는 명시적 마이그레이션을 작성하고 관리합니다.
  - 개발/프로덕션 DB를 자동 동기화하는 도구 대신 직접 업그레이드 스크립트를 만듭니다.
  - 프로덕션 DB 스키마의 문서화되지 않은 변경 사항 탐지에는 비교 도구가 여전히 유용합니다.
  - DB 상태가 아니라 마이그레이션 자체가 소스 컨트롤에 저장되는 아티팩트가 됩니다.
  - 마이그레이션은 보통 SQL 스크립트로 작성하지만, DSL로 작성해 SQL로 변환할 수도 있습니다.

```
import Fluent

struct CreateUserTable: Migration {
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    return database.schema("Users")
      .id()
      .create()
  }

  func revert(on database: Database) -> EventLoopFuture<Void> {
    return database.schema("Users").delete()
  }
}
```

상태 기반 접근 방식보다 마이그레이션 기반 접근 방식을 선호합니다. 

* 상태 기반 접근 방식은 상태를 명시적으로 만들고 비교 도구가 암시적으로 마이그레이션을 제어할 수 있도록 합니다. 
* 마이그레이션 기반 접근 방식은 마이그레이션을 명시적으로 만들지만, 데이터베이스 상태를 암시적으로 만들어 직접 보는 것은 불가능하고 마이그레이션에서 조립해야 합니다.

| | 데이터베이스 상태 | 마이그레이션 매커니즘 |
|:--|:--:|:--:|
| 상태 기반 접근 방식 | 명시적 | 암시적 |
| 마이그레이션 기반 접근 방식 | 암시적 | 명시적 | 

이러한 구별은 상충 관계가 있습니다.

데이터베이스 상태의 명시성은 병합 충돌을 더 쉽게 처리할 수 있게 해주며, 명시적 마이그레이션은 데이터 모션을 해결하는 데 도움이 됩니다.

> 정의: 데이터 모션은 기존 데이터의 모양을 새로운 데이터베이스 스키마에 맞게 변경하는 프로세스입니다.

병합 충돌의 완화와 데이터 모션의 용이성은 똑같은 이점처럼 보일 수 있지만, 대다수의 프로젝트에서 데이터 모션은 병합 충돌보다 훨씬 더 중요합니다.

예를 들어, `Name` 열을 `FirstName`과 `LastName`으로 분할할 때, `Name` 열을 삭제하고 새로운 `FirstName` 및 `LastName` 열을 만들어야 할 뿐만 아니라, 기존의 모든 이름을 두 부분으로 나누는 스크립트를 작성해야 합니다. 

상태 기반 접근 방식을 사용하여 이 변경을 구현하는 쉬운 방법은 없습니다.

첫 번째 버전을 출시한 이후라면 데이터 모션을 적절하게 처리하기 위해 마이그레이션 기반 접근 방식으로 전환해야 합니다.

### 10.2 데이터베이스 트랜잭션 관리

데이터베이스 트랜잭션 관리는 프로덕션 및 테스트 코드 모두에서 중요한 주제입니다.

프로덕션 코드의 적절한 트랜잭션 관리는 **데이터 불일치(data inconsistencies)** 를 피하는 데 도움이 됩니다.

테스트에서는 프로덕션에 가까운 환경에서 통합을 확인하는 데 중요합니다.

##### 10.2.1 프로덕션 코드에서의 트랜잭션 관리

샘플 CRM 프로젝트는 데이터베이스 클래스를 사용하여 `User` 및 `Company`와 협력합니다. 

데이터베이스는 각 메소드 호출에 별도의 SQL 연결을 만듭니다. 

```
import Foundation
import SQLite3

public final class Database {
  private let connectionString: String

  public init(connectionString: String) {
    self.connectionString = connectionString
  }

  public func saveUser(_ user: inout User) {
    let isNewUser: Bool = user.userId == 0
    if sqlite3_open(connectionString, &db) == SQLITE_OK {
      /* isNewUser에 따라 사용자를 삽입하거나 업데이트합니다 */
    }
  }

  public func saveCompany(_ company: Company) {
    if sqlite3_open(connectionString, &db) == SQLITE_OK {
      /* 회사는 업데이트 전용으로 처리합니다 (필요시 UPSERT로 변경하세요) */
    }
  }
}
```
결과적으로 사용자 컨트롤러는 다음 목록과 같이 단일 비즈니스 작업 중에 총 4개의 데이터베이스 트랜잭션을 생성합니다.
```
public func changeEmail(userId: Int, newEmail: String) -> String {
  let userData: [Any] = _database.getUserById(userId)
  var user = UserFactory.create(from: userData)
  if let error = user.canChangeEmail() {
    return error
  }

  let companyData: [Any] = _database.getCompany()
  var company = CompanyFactory.create(from: companyData)

  user.changeEmail(to: newEmail, company: &company)
  _database.saveCompany(company)
  _database.saveUser(&user)
  _eventDispatcher.dispatch(user.domainEvents)

  return "OK"
}
```

@Row {
  @Column {
    @Image(source: 10-1.png)  
  }
  @Column
}


읽기 전용 작업 중에는 여러 트랜잭션을 열어도 괜찮습니다.

그러나 비즈니스 운영에 데이터 돌연변이가 포함된 경우, 불일치를 피하기 위해 해당 운영 중에 발생하는 모든 업데이트는 원자적이어야 합니다.

예를 들어, `Controller`는 `Company`를 성공적으로 유지하지만 데이터베이스 연결 문제로 인해 `User`를 저장할 때 실패할 수 있습니다.

결과적으로 `NumberOfEmployees`가 데이터베이스의 총 `Employee` 수와 일치하지 않을 수 있습니다.

> 정의: 원자(Atomic) 업데이트는 all-or-nothing 방식으로 실행됩니다. 
>
> 원자 업데이트 세트의 각 업데이트는 전체적으로 완료되거나 전혀 영향을 미치지 않아야 합니다.

**데이터베이스 연결과 트랜잭션 분리하기**

SEPARATING DATABASE CONNECTIONS FROM DATABASE TRANSACTIONS
잠재적인 불일치를 피하기 위해, 데이터베이스 관련 결정 중 다음 두 가지는 분리되어야 합니다.

* 어떤 데이터를 업데이트할지
* 업데이트를 유지할지 롤백할지

컨트롤러는 비즈니스 운영의 모든 단계가 성공했을 때만 업데이트를 유지할 수 있는지 여부를 알 수 있습니다.

또한, 업데이트를 시도하기 위해서는 데이터베이스에 액세스해야만 이 단계들을 수행할 수 있습니다. 

따라서 컨트롤러가 이 두 가지 결정을 동시에 내릴 수 없기 때문에 이러한 분리가 중요합니다.

데이터베이스 클래스를 저장소와 트랜잭션으로 분할하여 이러한 책임 간의 분리를 구현할 수 있습니다. 

* 저장소(Repositories):
  - 데이터베이스의 데이터에 대한 액세스 및 수정을 가능하게 하는 클래스입니다.
  - 샘플 프로젝트에서는 `User`를 위한 저장소와 `Company`를 위한 저장소 두 가지가 있을 수 있습니다.

* 트랜잭션(Transaction):
  - 데이터 업데이트를 완전히 커밋하거나 롤백하는 클래스입니다.
  - 이것은 데이터 수정의 원자성을 제공하기 위해 기본 데이터베이스의 트랜잭션에 의존하는 사용자 지정 클래스가 될 것입니다.

저장소와 트랜잭션은 책임이 다를 뿐만 아니라 수명도 다릅니다. 

트랜잭션은 전체 비즈니스 수행 중에 발생하며 마지막에 폐기됩니다. 

반면에 저장소는 데이터베이스 호출이 완료되는 즉시 폐기합니다. 

결과적으로 저장소는 항상 현재 트랜잭션 위에서 작동합니다.

@Row {
  @Column {
    @Image(source: 10-2.png)  
  }
  @Column
}

```
public class UserController {
  private let transaction: Transaction
  private let userRepository: UserRepository
  private let companyRepository: CompanyRepository
  private let eventDispatcher: EventDispatcher

  public init(
    transaction: Transaction,
    messageBus: MessageBus,
    domainLogger: IDomainLogger
  ) {
    self.transaction = transaction
    self.userRepository = UserRepository(transaction: transaction)
    self.companyRepository = CompanyRepository(transaction: transaction)
    self.eventDispatcher = EventDispatcher(messageBus: messageBus, domainLogger: domainLogger)
  }

  public func changeEmail(userId: Int, newEmail: String) -> String {
    let userData: [Any] = userRepository.getUserById(userId)
    let user = UserFactory.create(from: userData)
    if let error = user.canChangeEmail() {
      return error
    }
    let companyData: [Any] = companyRepository.getCompany()
    var company = CompanyFactory.create(from: companyData)
    user.changeEmail(to: newEmail, company: &company)
    companyRepository.saveCompany(company)
    userRepository.saveUser(user)
    eventDispatcher.dispatch(user.domainEvents)
    transaction.commit()
    return "OK"
  }
}

public class UserRepository {
  private let transaction: Transaction

  public init(transaction: Transaction) {
    self.transaction = transaction
  }
  /* ... */
}

public class Transaction {
  public func commit() { /* ... */ }
  public func dispose() { /* ... */ }
}
```

트랜잭션에는 일반적으로 두 가지 핵심 메서드가 있습니다.
* `Commit()`
  - 트랜잭션을 성공으로 표시합니다. 
  - 비즈니스 수행 자체가 성공하고 모든 데이터 수정이 지속될 준비가 되었을 때만 호출됩니다. 
* `Dispose()`
  - 트랜잭션을 종료합니다. 
  - 비즈니스 수행이 끝날 때 무조건적으로 호출됩니다.
  - `Commit()`이 이전에 호출된 경우, `Dispose()`는 모든 데이터 업데이트를 유지하고 그렇지 않으면, 롤백합니다.

이러한 `Commit()`과 `Dispose()`의 조합은 데이터베이스가 해피 패스(비즈니스 시나리오의 성공적인 실행) 동안에만 변경되도록 보장합니다. 

그렇기 때문에 `Commit()`은 `ChangeEmail()` 메서드의 맨 끝에 있습니다.

유효성 오류가 발생하면 실행 흐름이 일찍 반환되어 트랜잭션이 커밋되는 것을 방지합니다. 

의사 결정이 필요하기 때문에 Commit()는 컨트롤러에 의해 호출됩니다.

하지만 Dispose()를 호출하는 데는 의사 결정이 포함되지 않으므로 해당 메서드 호출을 인프라 계층의 클래스에 위임할 수 있습니다. 

`UserRepository`가 생성자 매개 변수로 `Transaction`을 요구하는 것이 저장소가 항상 트랜잭션 위에서 작동한다는 것을 명시적으로 보여줍니다.

저장소는 데이터베이스를 자체적으로 호출할 수 없습니다.

**트랜잭션을 작업 단위로 업그레이드하기**

Transaction 클래스를 **작업 단위(unit of work)** 로 업그레이드할 수 있습니다.

> 정의: 작업 단위는 비즈니스 수행의 영향권에 있는 개체 목록을 유지합니다. 
>
> 작업이 완료되면 작업 단위는 데이터베이스를 변경하기 위해 수행해야 하는 모든 업데이트를 파악하고 해당 업데이트를 단일 단위로 실행합니다.

트랜잭션과 달리 작업 단위는 비즈니스 운영이 끝날 때 모든 업데이트를 실행하므로 기본 데이터베이스 트랜잭션의 기간을 최소화하고 데이터 혼잡을 줄입니다. 

@Row {
  @Column {
    @Image(source: 10-3.png)  
  }
  @Column
}

수정된 객체 목록을 유지한 다음 생성할 SQL 스크립트를 파악하는 것은 많은 작업처럼 보일 수 있습니다. 

하지만 실제로, 당신은 그 일을 스스로 할 필요가 없습니다. 대부분의 ORM(객체 관계 매핑) 라이브러리는 작업 단위 패턴을 구현합니다. 

```
public final class UserController {
  private let context: CrmContext
  private let userRepository: UserRepository
  private let companyRepository: CompanyRepository
  private let eventDispatcher: EventDispatcher

  public init(
    context: CrmContext,
    messageBus: MessageBus,
    domainLogger: IDomainLogger
  ) {
    self.context = context
    self.userRepository = UserRepository(context: context)
    self.companyRepository = CompanyRepository(context: context)
    self.eventDispatcher = EventDispatcher(messageBus: messageBus, domainLogger: domainLogger)
  }

  public func changeEmail(userId: Int, newEmail: String) -> String {
    var user = userRepository.getUserById(userId)
    if let error = user.canChangeEmail() {
      return error
    }

    var company = companyRepository.getCompany()
    user.changeEmail(to: newEmail, company: &company)
    companyRepository.saveCompany(company)
    userRepository.saveUser(&user)
    eventDispatcher.dispatch(user.domainEvents)
    context.saveChanges()
    return "OK"
  }
}
```

`CrmContext`는 도메인 모델과 데이터베이스 간의 매핑을 포함하는 사용자 지정 클래스입니다.

컨트롤러는 트랜잭션 대신 `CrmContext`를 사용합니다. 

* 두 저장소 모두 이전 버전의 `Transaction` 위에서 작동했던 것처럼 이제 `CrmContext` 위에서 작동합니다.

* 컨트롤러는 `transaction.commit()` 대신 `context.saveChanges()`를 통해 데이터베이스에 변경 사항을 커밋합니다. 

엔티티 프레임워크가 이제 원시 데이터베이스 데이터와 도메인 객체 사이의 매퍼 역할을 하기 때문에 더 이상 `UserFactory`와 `CompanyFactory`가 필요하지 않습니다.

##### 10.2.2 통합테스트에서 데이터베이스 트랜잭션 관리

통합 테스트에서 트랜잭션이나 작업 단위를 테스트의 각 섹션(Arrange, Act, Assert) 간에 재사용해서는 안 됩니다.

다음은 해당 테스트를 Entity Framework로 전환한 후 통합 테스트에서 `CrmContext`를 재사용하는 예를 보여줍니다.

```
import XCTest

final class UserControllerTests: XCTestCase {
  func testChangingEmailFromCorporateToNonCorporate() {
    // Arrange
    let context = CrmContext(connectionString: ConnectionString)
    defer { context.dispose() } // 필요하면 리소스 정리

    let userRepository = UserRepository(context: context)
    let companyRepository = CompanyRepository(context: context)

    var user = User(userId: 0, email: "user@mycorp.com", type: .employee, isConfirmed: false)
    userRepository.saveUser(&user)

    let company = Company(domain: "mycorp.com", numberOfEmployees: 1)
    companyRepository.saveCompany(company)

    context.saveChanges()

    let busSpy = BusSpy()
    let messageBus = MessageBus(bus: busSpy)
    let loggerMock = DomainLoggerMock() // 프로젝트에 맞는 목/스파이 사용

    let sut = UserController(context: context, messageBus: messageBus, domainLogger: loggerMock)

    // Act
    let result = sut.changeEmail(userId: user.userId, newEmail: "new@gmail.com")

    // Assert
    XCTAssertEqual("OK", result)

    let userFromDb = userRepository.getUserById(user.userId)
    XCTAssertEqual("new@gmail.com", userFromDb.email)
    XCTAssertEqual(UserType.customer, userFromDb.type)

    let companyFromDb = companyRepository.getCompany()
    XCTAssertEqual(0, companyFromDb.numberOfEmployees)

    // BusSpy / LoggerMock에 제공된 검증 API를 사용
    XCTAssertEqual(1, busSpy.sentMessageCount)
    XCTAssertTrue(busSpy.containsEmailChangedMessage(userId: user.userId, email: "new@gmail.com"))

    XCTAssertTrue(loggerMock.verifyUserTypeHasChangedCalled(userId: user.userId, from: .employee, to: .customer))
  }
}
```

프로덕션에서 각 비즈니스 수행에는 `CrmContext`의 독점 인스턴스가 있고, 컨트롤러 메서드 호출 직전에 생성되고 직후에 폐기됩니다.

일관성 없는 동작의 위험을 피하기 위해 통합 테스트는 프로덕션 환경을 최대한 가깝게 복제해야 합니다. 

즉, 행위 섹션은 `CrmContext`를 공유해서는 안 됩니다.

> Tip: 최소한 Arrange, Act, Assert 각 섹션별로 별도의 작업단위를 사용해야 합니다. 

### 10.3 테스트 데이터 생명주기

통합 테스트가 서로 격리되도록 하려면

* 통합 테스트를 순차적으로 실행해야 합니다.
* 테스트 실행 사이에 남은 데이터를 제거합니다. 

전반적으로, 테스트는 데이터베이스의 상태에 의존해서는 안 되고, 스스로 필요한 상태로 가져와야 합니다.

##### 10.3.1 병렬 vs. 순차 테스트 실행

통합 테스트의 병렬 실행에는 상당한 노력이 필요합니다.

데이터베이스 제약이 위반되지 않고 테스트가 서로 입력 데이터를 우연히 포착하지 않도록 모든 테스트 데이터가 고유한지 확인해야 합니다.

추가 성능을 짜내기 위해 시간을 소비하는 것보다 통합 테스트를 순차적으로 실행하는 것이 더 실용적입니다.

대안으로, 컨테이너를 사용하여 테스트를 병렬화할 수 있습니다. 

예를 들어, 도커 이미지에 모델 데이터베이스를 배치하고 각 통합 테스트를 위해 해당 이미지에서 새 컨테이너를 인스턴스화할 수 있습니다. 

##### 10.3.2 테스트 실행 사이에 데이터 지우기

테스트 실행 사이에 남은 데이터를 정리하는 네 가지 옵션이 있습니다. 
* 각 테스트 전에 데이터베이스 백업 복원
  - 이 접근 방식은 데이터 정리 문제를 해결하지만 다른 세 가지 옵션보다 훨씬 느립니다. 
  - 컨테이너의 경우에도 컨테이너 인스턴스를 제거하고 새 인스턴스를 생성하는 데는 보통 몇 초가 소요되며, 총 테스트 제품군 실행 시간이 빠르게 늘어납니다.
* 테스트가 끝날 때 데이터 정리하기
  — 이 방법은 빠르지만 정리 단계를 건너뛰기 쉽습니다. 
  - 테스트 중간에 빌드 서버가 충돌하거나 디버거에서 테스트를 종료하면 입력 데이터가 데이터베이스에 남아 추가 테스트 실행에 영향을 미칩니다.
* 데이터베이스 트랜잭션에서 각 테스트를 래핑하고 절대 커밋하지 않기
  - 이 경우 테스트와 SUT에 의해 이루어진 모든 변경 사항은 자동으로 롤백됩니다.
  - 포괄적인 트랜잭션의 도입은 프로덕션 환경과 테스트 환경 간의 일관성 없는 동작으로 이어질 수 있습니다. 
  - 추가 트랜잭션은 프로덕션과 다른 설정을 만듭니다. 
* 테스트 시작 시 데이터 정리
  — 이것이 가장 좋은 옵션입니다. 
  - 빠르게 작동하고, 일관성 없는 행동을 초래하지 않으며, 실수로 정리 단계를 건너뛰는 경향이 없습니다.

> TIP:  별도의 해체(teardown) 단계가 필요하지 않습니다. 
>
> 준비(arrange) 섹션의 일부로 구현하십시오.

데이터 제거 자체는 데이터베이스의 외래 키 제약 조건을 준수하기 위해 특정 순서로 이루어져야 합니다. 

모든 통합 테스트에 대한 기본 클래스를 소개하고 삭제 스크립트를 거기에 넣으십시오. 

이러한 기본 클래스를 사용하면 다음과 같이 각 테스트가 시작될 때 스크립트가 자동으로 실행됩니다.

```
import Foundation

open class IntegrationTests {
  private let connectionString: String = "..."

  public init() {
    clearDatabase()
  }

  private func clearDatabase() {
    let query = "DELETE FROM dbo.[User];" +
                "DELETE FROM dbo.Company;"
    let connection = SqlConnection(connectionString)
    let command = SqlCommand(query, connection)
    command.commandType = .text
    connection.open()
    command.executeNonQuery()
    connection.close()
  }
}
```

##### 10.3.3 인메모리 데이터베이스 피하기

통합 테스트를 서로 분리하는 또 다른 방법은 데이터베이스를 SQLite와 같은 인메모리 아날로그로 대체하는 것입니다. 

* 테스트 데이터를 제거할 필요가 없음 
* 더 빠른 작업
* 각 테스트 실행에 대해 인스턴스화 가능 

인메모리 데이터베이스는 공유 종속성이 아니기 때문에 통합 테스트는 사실상 단위 테스트가 됩니다(데이터베이스가 프로젝트에서 유일하게 관리되는 종속성이라고 가정).

이러한 모든 이점에도 불구하고, 인 메모리 데이터베이스는 일반 데이터베이스와 기능 면에서 일관성이 없기 때문에 사용하지 않는 것이 좋습니다.

이것은 프로덕션과 테스트 환경 간의 불일치의 문제입니다. 

> TIP 테스트에서 프로덕션과 동일한 데이터베이스 관리 시스템(DBMS)을 사용하십시오.
>
> 일반적으로 버전이나 에디션이 달라도 괜찮지만 공급사는 동일하게 유지되어야 합니다.

### 10.4 테스트 섹션에서 코드 재사용

통합 테스트는 너무 빠르게 커질 수 있으며 따라서 유지 보수성 지표에서 근거를 잃을 수 있습니다.

통합 테스트를 가능한 한 짧게 유지하되 서로 결합하거나 가독성에 영향을 미치지 않는 것이 중요합니다. 

가장 좋은 방법은 기술적이고 비즈니스와 관련 없는 코드를 비공개 메서드나 헬퍼 클래스로 추출하는 것입니다.

##### 10.4.1 준비(Arrange) 섹션에서 코드 재사용

```
import XCTest

final class UserControllerTests: XCTestCase {
  func testChangingEmailFromCorporateToNonCorporate() {
    // Arrange (데이터 준비)
    var seededUser: User!
    do {
      let context = CrmContext(connectionString: ConnectionString)
      let userRepository = UserRepository(context: context)
      let companyRepository = CompanyRepository(context: context)

      var user = User(userId: 0, email: "user@mycorp.com", type: .employee, isConfirmed: false)
      userRepository.saveUser(&user)

      let company = Company(domain: "mycorp.com", numberOfEmployees: 1)
      companyRepository.saveCompany(company)

      context.saveChanges()
      seededUser = user
      // context는 범위를 벗어나면 해제되도록 가정
    }

    let busSpy = BusSpy()
    let messageBus = MessageBus(bus: busSpy)
    let loggerMock = DomainLoggerMock() // 프로젝트에 맞게 구현

    // Act (비즈니스 동작, 별도 컨텍스트 사용)
    var result: String!
    do {
      let context = CrmContext(connectionString: ConnectionString)
      let sut = UserController(context: context, messageBus: messageBus, domainLogger: loggerMock)
      result = sut.changeEmail(userId: seededUser.userId, newEmail: "new@gmail.com")
    }

    // Assert (검증, 또 다른 별도 컨텍스트)
    do {
      let context = CrmContext(connectionString: ConnectionString)
      let userRepository = UserRepository(context: context)
      let companyRepository = CompanyRepository(context: context)

      let userFromDb = userRepository.getUserById(seededUser.userId)
      XCTAssertEqual("OK", result)
      XCTAssertEqual("new@gmail.com", userFromDb.email)
      XCTAssertEqual(UserType.customer, userFromDb.type)

      let companyFromDb = companyRepository.getCompany()
      XCTAssertEqual(0, companyFromDb.numberOfEmployees)

      // BusSpy / LoggerMock 검증 (프로젝트의 검증 API에 맞게 조정)
      XCTAssertEqual(1, busSpy.sentMessageCount)
      XCTAssertTrue(busSpy.containsEmailChangedMessage(userId: seededUser.userId, email: "new@gmail.com"))
      XCTAssertTrue(loggerMock.verifyUserTypeHasChangedCalled(userId: seededUser.userId, from: .employee, to: .customer))
    }
  }
}
```

기본값을 사용하면 인수를 선택적으로 지정하여 테스트를 더욱 단축할 수 있습니다. 


```
func createUser(
  email: String = "user@mycorp.com",
  type: UserType = .employee,
  isEmailConfirmed: Bool = false
) -> User {
  let context = CrmContext(connectionString: ConnectionString)
  defer { context.dispose() } // 필요시 리소스 정리

  var user = User(userId: 0, email: email, type: type, isEmailConfirmed: isEmailConfirmed)
  let repository = UserRepository(context: context)
  repository.saveUser(&user)
  context.saveChanges()
  return user
}
```

**팩토리 메서드를 어디에 둘지**

테스트의 필수 요소를 추출하고 팩토리 메서드로 옮기기 시작할 때, 어디에 둘지에 대한 질문에 직면하게 됩니다. 

기본적으로 테스트 클래스에 팩토리 메서드를 배치합니다. 

코드 복제가 중요한 문제가 될 때만 별도의 헬퍼 클래스로 이동하십시오.

팩토리 메서드를 기본 클래스에는 넣지 마십시오. 

데이터 정리와 같은 모든 테스트에서 실행해야 하는 코드를 위해서만 기본 클래스를 사용하세요.

##### 10.4.2 행위(Act) 섹션에서 코드 재사용

통합 테스트의 모든 행위 섹션은 데이터베이스 트랜잭션 또는 작업 단위의 생성을 포함합니다.

**데코레이터 메서드(decorator methods)**를 도입하여 컨트롤러 함수 호출을 데이터베이스 컨텍스트 생성과 같은 기술적인 부분으로 감쌉니다.

```
private func execute(_ action: (UserController) -> String,
                     messageBus: MessageBus,
                     logger: IDomainLogger) -> String {
  let context = CrmContext(connectionString: ConnectionString)
  defer { context.dispose() }
  let controller = UserController(context: context, messageBus: messageBus, domainLogger: logger)
  return action(controller)
}
```

##### 10.4.3 검증(Assert) 섹션에서 코드 재사용

마지막으로, 검증 섹션도 단축할 수 있습니다.

이를 수행하는 가장 쉬운 방법은 다음과 같이 `CreateUser` 및 `CreateCompany`와 유사한 헬퍼 메서드를 도입하는 것입니다.

```
swift
import XCTest

extension Optional where Wrapped == User {
  func shouldExist(file: StaticString = #file, line: UInt = #line) -> User {
    XCTAssertNotNil(self, "Expected user to exist", file: file, line: line)
    return self!
  }
}

extension User {
  @discardableResult
  func withEmail(_ email: String, file: StaticString = #file, line: UInt = #line) -> User {
    XCTAssertEqual(self.email, email, file: file, line: line)
    return self
  }
}
```

##### 10.4.4 테스트가 너무 많은 데이터베이스 트랜잭션을 생성한다면?

모든 단순화 이후, 통합 테스트는 더 읽기 가능해졌고, 따라서 더 유지보수가 쉬워졌습니다. 

하지만 3개만 사용하던 작업 단위에서 5개를 사용하게 되었습니다.

```
import XCTest

final class UserControllerTests: IntegrationTests {
  func testChangingEmailFromCorporateToNonCorporate() {
    // Arrange
    let user = createUser(email: "user@mycorp.com", type: .employee)
    createCompany(domain: "mycorp.com", numberOfEmployees: 1)
    let busSpy = BusSpy()
    let messageBus = MessageBus(bus: busSpy)
    let loggerMock = DomainLoggerMock()

    // Act
    let result = execute({ controller in
      controller.changeEmail(userId: user.userId, newEmail: "new@gmail.com")
    }, messageBus: messageBus, logger: loggerMock)

    // Assert
    XCTAssertEqual("OK", result)

    let userFromDb = queryUser(user.userId)
    userFromDb
      .shouldExist()
      .withEmail("new@gmail.com")
      .withType(.customer)

    let companyFromDb = queryCompany()
    companyFromDb
      .shouldExist()
      .withNumberOfEmployees(0)

    busSpy
      .shouldSendNumberOfMessages(1)
      .withEmailChangedMessage(user.userId, "new@gmail.com")

    XCTAssertTrue(loggerMock.verifyUserTypeHasChangedCalled(userId: user.userId, from: .employee, to: .customer))
  }
}
```

코드 재사용을 위해 데이터베이스 컨텍스트 인스턴스가 증가하더라도 이는 유지보수성 향상을 위한 가치 있는 트레이드 오프입니다.

특히 데이터베이스가 개발자의 컴퓨터에 위치할 때 성능 저하가 크지 않습니다. 반면, 유지보수성이 크게 상승합니다.

### 10.5 일반적인 데이터베이스 테스트 질문

##### 10.5.1 읽기 작업을 테스트해야 하나요?

애플리케이션은 일반적으로 쓰기(write) 작업과 읽기(read) 작업을 모두 포함하지만, 이 두 가지 유형의 작업에 대한 테스트 접근 방식은 다릅니다.

쓰기 작업(데이터를 변경하는 작업)에 대한 실수가 **데이터 손상(data corruption)** 으로 이어지는 경우가 많으며, 이는 데이터베이스뿐만 아니라 외부 애플리케이션에도 영향을 미칠 수 있으므로 위험도가 높습니다. 

따라서 쓰기 작업을 다루는 테스트는 이러한 실수로부터 보호하는 데 매우 귀중합니다.

읽기 작업에서 발생하는 버그는 쓰기 작업에서 발생하는 버그만큼 치명적인 결과를 초래하지는 않습니다.

따라서 읽기 작업에 대한 테스트 임계값은 쓰기 작업보다 더 높아야 합니다.

가장 복잡하거나 중요한 읽기 작업만 테스트해야 하며, 나머지는 무시해도 됩니다.

##### 10.5.2 저장소를 테스트해야 하는가?

저장소는 데이터베이스의 데이터에 대한 접근 및 수정을 가능하게 하는 클래스입니다.

저장소를 별도로 테스트하는 것은 일반적으로 권장되지 않습니다.

* 높은 유지 관리 비용 (High Maintenance Costs)
  - 저장소는 복잡성이 거의 없으며, 데이터베이스라는 외부 프로세스 종속성과 통신합니다.
  - 따라서 저장소는 코드 유형 다이어그램에서 **'컨트롤러(controllers) 사분면'** 에 속합니다.
  - 프로세스 외부 종속성이 있기 때문에 저장소 테스트는 일반 통합 테스트와 동일한 부담을 가지며, 테스트의 유지 관리 비용이 증가합니다.

* 낮은 회귀 방지 효과 (Inferior Protection against Regressions)
  - 저장소는 복잡성이 낮고, 회귀 방지 측면에서 얻는 이점의 상당 부분이 일반적인 통합 테스트와 중복됩니다.
  - 따라서 저장소에 대한 테스트는 충분한 가치를 추가하지 못합니다.

### 10.6 결론

관리되는 종속성과 직접 작업하는 통합 테스트는 소프트웨어의 올바른 작동에 대한 최대의 확신을 얻기 위해 필수적입니다.

통합 테스트는 저장소와 컨트롤러를 포함하여 관리되는 종속성과 상호 작용하는 모든 계층을 거칩니다.

관리되는 종속성으로 직접 작동하는 통합 테스트는 대규모 리팩토링으로 인한 버그로부터 보호하는 가장 효율적인 방법입니다.
