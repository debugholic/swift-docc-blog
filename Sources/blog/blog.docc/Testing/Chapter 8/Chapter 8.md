# 8장 통합 테스트는 왜 필요한가?

## 요약

통합 테스트의 역할과 테스트 피라미드의 개념, 가치 있는 통합 테스트에 대해 알아봅니다.

### 8.1 통합 테스트란 무엇인가?

통합 테스트는 테스트 스위트에서 중요한 역할을 하며, 단위 테스트와의 균형을 유지하는 것이 중요합니다.

먼저 통합 테스트와 단위 테스트의 차이점에 대해 다시 알아봅시다.

##### 8.1.1 통합 테스트의 역할

2장에서 알아본 단위 테스트의 세 가지 요건은 다음과 같았습니다.
* 단일 동작 단위를 검증 
* 빠른 실행
* 다른 테스트와 격리되어 실행

이 중 최소 하나를 충족하지 못하는 모든 테스트는 통합 테스트로 분류됩니다.

실제적으로 통합 테스트는 시스템이 외부 프로세스 의존성과 어떻게 통합되는지 검증합니다.

이는 7장에서 논의된 코드 사분면에서 컨트롤러 영역의 코드를 커버하는 것을 의미합니다.

@Row {
  @Column {
    @Image(source: 8-1.png)  
  }
  @Column
}

때로는 컨트롤러 영역의 테스트도 단위 테스트가 될 수 있습니다. 

모든 외부 프로세스 의존성을 목으로 대체하면, 테스트 간에 공유되는 의존성이 없으므로 테스트는 여전히 빠르고 격리된 상태를 유지할 수 있습니다.

그러나 대부분의 애플리케이션은 목 객체로 대체할 수 없는 외부 프로세스 의존성(일반적으로 데이터베이스)을 가지고 있습니다.

7장에서 언급했듯이, 사소한 코드와 너무 복잡한 코드는 테스트할 가치가 없습니다. 

사소한 코드는 노력할 가치가 없으며, 너무 복잡한 코드는 리팩토링하여 알고리즘과 컨트롤러로 분리해야 합니다.

따라서 모든 테스트는 도메인 모델과 컨트롤러 영역에만 집중해야 합니다.

##### 8.1.2 테스트 피라미드의 재검토

단위 테스트와 통합 테스트 간의 균형을 유지하는 것이 중요합니다.
    
외부 프로세스 의존성과 직접 작업하는 통합 테스트는 느리고 유지보수 비용이 더 많이 듭니다. 

유지보수 증가에는 다음과 같은 요인이 있습니다.

* 외부 프로세스 의존성 운영의 필요성  
* 더 많은 수의 협력자가 관련된 테스트 규모

반면에 통합 테스트는 더 많은 양의 코드를 거치기 때문에 회귀 방지에서 단위 테스트보다 더 좋습니다.

또한 생산 코드와 더 분리되어 있기 때문에 리팩토링에 대한 저항력이 더 좋습니다. 

단위 테스트와 통합 테스트의 비율은 프로젝트의 세부 사항에 따라 다를 수 있지만 일반적인 경험 법칙은 다음과 같습니다. 

단위 테스트를 사용하여 비즈니스 시나리오의 에지 케이스를 가능한 많이 확인하고, 통합 테스트를 사용하여 하나의 해피 패스와 단위 테스트에서 다룰 수 없는 에지 케이스를 다룹니다.

> 정의: 해피 패스(happy path)는 비즈니스 시나리오의 성공적인 실행을 의미하며, 
>
> 에지 케이스(edge case)는 비즈니스 시나리오 실행 시 오류가 발생하는 경우를 의미합니다.

대부분의 작업 부하를 단위 테스트로 전환하면 유지보수 비용을 낮출 수 있습니다.

각 비즈니스 시나리오당 하나 또는 두 개의 포괄적인 통합 테스트를 통해 시스템 전체의 정확성을 보장할 수 있습니다. 

이 지침이 단위 테스트와 통합 테스트 간의 피라미드 형태 비율을 형성합니다.

@Image(source: 8-2.png)

테스트 피라미드의 모양은 프로젝트의 복잡성에 따라 달라집니다.
* 간단한 애플리케이션은 도메인 모델이나 알고리즘 영역에 코드가 거의 없습니다. 
  - 이 경우 테스트는 피라미드 대신 직사각형 형태를 가지며, 단위 테스트와 통합 테스트의 수가 비슷할 수 있습니다.

* 매우 사소한 경우에는 단위 테스트가 전혀 없을 수도 있습니다.

* 통합 테스트는 간단한 애플리케이션에서도 가치를 유지합니다. 
  - 코드의 복잡성과 관계없이, 다른 서브시스템과의 통합 작동 방식을 검증하는 것은 중요합니다.

##### 8.1.3 통합 테스트 vs. 실패 우선(failing fast)

통합 테스트는 비즈니스 시나리오당 가장 긴 해피 패스와 단위 테스트로 커버할 수 없는 모든 에지 케이스를 커버하는 데 사용됩니다.

통합 테스트의 경우, 모든 외부 프로세스 의존성과 상호작용하는 가장 긴 해피 패스를 선택해야 합니다. 

만약 하나의 경로가 모든 상호작용을 포괄하지 못하면, 모든 외부 시스템과의 통신을 포괄하는 데 필요한 만큼 추가 통합 테스트를 작성해야 합니다.

단위 테스트에서 모든 에지 케이스를 다룰 수 없는 것처럼 통합 테스트에도 예외가 있습니다.

잘못된 실행이 즉시 전체 응용 프로그램을 실패하면 굳이 엣지 케이스를 테스트할 필요가 없습니다. 

```
func changeEmail(_ newEmail: String, company: Company) {
  precondition(canChangeEmail() == nil)
  /* the rest of the method */
}
```
```
func changeEmail(userId: Int, newEmail: String) -> String {
  let userData = database.getUserById(userId)
  let user = UserFactory.create(userData)

  if let error = user.canChangeEmail() {
    return error  // Edge case
  }
}
```

컨트롤러가 canChangeEmail()과 먼저 상의하지 않고 이메일을 변경하려고 하면 응용 프로그램이 충돌합니다. 

이 버그는 첫 번째 실행에서 스스로 드러나기 때문에 쉽게 알아차리고 수정할 수 있습니다.

이런 테스트는 충분히 중요한 가치를 제공하지 않습니다.

> "나쁜 테스트를 작성하느니 차라리 테스트를 작성하지 않는 것이 낫습니다."
> 
> 중대한 가치가 없는 테스트는 나쁜 테스트입니다.

버그를 빠르게 드러내는 것을 실패 우선(Fail Fast) 원칙이라고 하며, 통합 테스트에 대한 대안입니다.

> 실패 우선 원칙:
예상치 못한 오류가 발생하면 현재 작업을 즉시 중단하는 것을 의미합니다. 
> * 피드백 루프 단축
>   - 버그를 빨리 감지할수록 수정하기 쉽습니다. 
>   - 운영 환경에서 발견된 버그는 개발 중에 발견된 버그보다 수정 비용이 훨씬 높습니다.
>
> * 영구 상태 보호
>    - 버그는 애플리케이션 상태를 손상시킬 수 있습니다. 
>    - 손상된 상태가 데이터베이스에 침투하면 수정하기가 훨씬 어려워집니다. 
>    - 실패 우선은 손상 확산을 방지하는 데 도움이 됩니다.
>
> 작업 중단은 일반적으로 예외를 발생시켜 이루어집니다. 
>
> 예외는 프로그램 흐름을 중단하고 실행 스택의 최상위 수준으로 올라가서 로깅 및 작업 종료/재시작에 사용될 수 있기 때문에 실패 우선 원칙에 완벽하게 부합합니다.
>
> 선행 조건(precondition)은 실패 우선 원칙의 한 예입니다.

### 8.2 어떤 외부 프로세스 의존성을 직접 테스트할 것인가

통합 테스트는 시스템이 외부 프로세스 의존성과 어떻게 통합되는지 검증합니다. 

이러한 검증을 구현하는 두 가지 방법은 실제 외부 프로세스 의존성을 사용하거나, 해당 의존성을 목 객체로 대체하는 것입니다.

##### 8.2.1 두 가지 유형의 외부 프로세스 의존성

모든 외부 프로세스 의존성은 두 가지 범주로 나뉩니다.
* 관리되는 의존성(Managed dependencies)
  - 애플리케이션이 완전히 제어하는 외부 프로세스 의존성입니다.
  - 이들과의 상호작용은 외부 세계에 보이지 않습니다.
  - 일반적인 예는 데이터베이스입니다. 
  - 외부 시스템은 보통 애플리케이션이 제공하는 API를 통해 데이터베이스에 접근합니다.
  - 관리되는 의존성과의 통신은 구현 세부 사항입니다.

* 관리되지 않는 의존성(Unmanaged dependencies)
  - 애플리케이션이 완전히 제어하지 못하는 외부 프로세스 의존성입니다.
  - 이들과의 상호작용은 외부에서 관찰 가능합니다.
  - 예로는 SMTP 서버 및 메시지 버스가 있습니다. 
  - 둘 다 다른 애플리케이션에 보이는 부작용을 발생시킵니다.
  - 관리되지 않는 의존성과의 통신은 시스템의 관찰 가능한 동작의 일부입니다.

> 중요: 관리되는 의존성은 실제 인스턴스를 사용하고, 관리되지 않는 의존성은 모의 객체로 대체해야 합니다.

5장에서 논의된 바와 같이, 관리되지 않는 의존성으로 커뮤니케이션 패턴을 바꿀 수 없을 때는 **하위 호환성(backward compatibility)** 을 유지해야 합니다.

목은 이러한 작업에 완벽하며, 리팩토링 시에도 커뮤니케이션 패턴의 영구성을 보장할 수 있습니다.

그러나 관리되는  의존성과의 통신에서 이전 버전과의 호환성을 유지할 필요는 없습니다. 

왜냐하면 당신의 애플리케이션이 그들과 대화하는 유일한 애플리케이션이기 때문입니다. 

외부 클라이언트는 당신이 데이터베이스를 어떻게 구성하는지 관심 없고 시스템의 최종 상태만 중요합니다. 

통합 테스트에서 관리되는 의존성의 실제 인스턴스를 사용하면 외부 클라이언트의 관점에서 최종 상태를 확인하는 데 도움이 됩니다.

##### 8.2.2 관리되는 의존성과 관리되지 않는 의존성 모두와 작업하기

때로는 관리되는 의존성과 관리되지 않는 의존성 속성을 모두 가진 외부 프로세스 의존성을 만날 수 있습니다.

예를 들어, 다른 애플리케이션도 접근하는 데이터베이스가 있습니다. 

이 데이터베이스는 여전히 애플리케이션만 볼 수 있는 부분을 포함하지만, 다른 애플리케이션도 접근할 수 있는 테이블도 가지고 있습니다.

이러한 경우, 데이터베이스의 관찰 가능한 부분은 관리되지 않는 의존성으로 취급하여, 해당 부분과의 통신 패턴이 변경되지 않도록 목을 사용해야 합니다.

동시에, 데이터베이스의 나머지 부분은 관리되는 의존성으로 취급하고, 상호작용이 아닌 최종 상태를 검증해야 합니다.

이 방식의 데이터베이스의 사용은 시스템을 서로 결합하고 추가 개발을 복잡하게 하기 때문에 좋지 않은 방법입니다. 

통합을 수행하는 더 나은 방법은 API(동기 통신용) 또는 메시지 버스(비동기 통신용)를 이용하는 것입니다.

@Image(source: 8-3.png)

##### 8.2.3 통합 테스트에서 실제 데이터베이스를 사용할 수 없는 경우

어떤 이유로든 실제 데이터베이스를 통합 테스트에서 사용할 수 없다면, 통합 테스트를 아예 작성하지 않고 도메인 모델의 단위 테스트에만 집중해야 합니다.

관리되는 의존성을 목으로 대체하는 것은 리팩토링에 대한 통합 테스트의 저항을 손상시키기 때문입니다.

게다가 이러한 테스트는 회귀 방지에 있어서도 잘 기능하지 않습니다.

모든 테스트는 면밀히 검토해야 하고 충분히 높은 가치를 제공하지 않는 테스트는 테스트 스위트에 포함되어서는 안 됩니다.

### 8.3 통합 테스트: 예시

7장의 CRM 시스템 예시로 돌아가, 이를 통합 테스트로 어떻게 커버할 수 있는지 살펴봅니다.

이 시스템은 사용자 이메일 변경 기능을 구현합니다.

```
final class UserController {
  private let database = Database()
  private let messageBus = MessageBus()

  func changeEmail(userId: Int, newEmail: String) -> String {
    let userData = database.getUserById(userId)
    let user = UserFactory.create(userData)

    if let error = user.canChangeEmail() {
      return error
    }

    let companyData = database.getCompany()
    let company = CompanyFactory.create(companyData)

    user.changeEmail(newEmail, company: company)

    database.saveCompany(company)
    database.saveUser(user)

    for ev in user.emailChangedEvents {
      messageBus.sendEmailChangedMessage(userId: ev.userId, newEmail: ev.newEmail)
    }

    return "OK"
  }
}
```

##### 8.3.1 어떤 시나리오를 테스트할 것인가?

통합 테스트에 대한 일반적인 지침은 **가장 긴 해피 패스**와 **단위 테스트로는 다룰 수 없는 에지 케이스**를 커버하는 것입니다.

* 가장 긴 해피 패스
  - CRM 프로젝트에서는 회사 이메일을 외부 이메일로 변경하는 것입니다. 
  - 이러한 변경은 가장 많은 부수 효과를 초래합니다.

    + 데이터베이스에서는 사용자 및 회사가 업데이트됩니다. (사용자 유형 및 이메일 변경, 회사 직원 수 변경)
    + 메시지 버스로 메시지가 전송됩니다.

* 단위 테스트로 다룰 수 없는 에지 케이스
  - 이메일을 변경할 수 없는 시나리오가 유일합니다. 
  - 하지만 이 시나리오는 애플리케이션이 빠르게 실패하므로 테스트할 필요가 없습니다.

따라서 통합 테스트는 "기업 이메일에서 비기업 이메일로 이메일 변경" 시나리오에 집중합니다

##### 8.3.2 데이터베이스와 메시지 버스 분류

통합 테스트를 작성하기 전에 두 가지 외부 프로세스 의존성을 분류해야 합니다.
        
* 애플리케이션 데이터베이스는 다른 시스템이 접근할 수 없는 관리되는 의존성이므로, 실제 인스턴스를 사용해야 합니다.
  - 통합 테스트는 사용자 및 회사를 데이터베이스에 삽입합니다.
  - 이메일 변경 시나리오를 데이터베이스에서 실행합니다.
  - 데이터베이스 상태를 검증합니다.

* 메시지 버스는 상호작용이 외부에서 관찰 가능한 관리되지 않는 의존성이므로, 목으로 대체해야 합니다.

##### 8.3.3 종단 간 테스트(End-to-end testing)는 어떠한가?

종단 간 테스트를 사용할지 여부는 판단이 필요합니다.

관리되는 의존성을 통합 테스트 범위에 포함하고 관리되지 않는 의존성만 목으로 대체할 경우, 통합 테스트는 종단 간 테스트에 가까운 수준의 보호를 제공하므로 종단 간 테스트를 생략할 수 있습니다.

@Image(source: 8-4.png)  

종단 간 테스트는 외부 클라이언트를 에뮬레이트하여 테스트 범위의 모든 외부 프로세스 의존성으로 애플리케이션의 배포 버전을 테스트합니다.

종단 간 테스트는 관리되는 의존성(예: 데이터베이스)을 직접 확인하는 것이 아니라 응용 프로그램을 통해 간접적으로만 확인해야 합니다.

@Image(source: 8-5.png)

통합 테스트는 동일한 프로세스 내에서 응용 프로그램을 호스팅합니다.

종단 간 테스트와 달리 통합 테스트는 관리되지 않는 의존성을 목으로 대체합니다.

통합 테스트의 유일한 외부 프로세스 구성 요소는 관리되는  의존성입니다.

그러나 배포 후 프로젝트에 대한 **건전성 검사(sanity check)**를 위해 하나 또는 두 개의 포괄적인 종단 간 테스트를 생성할 수도 있습니다.

##### 8.3.4 통합 테스트: 첫 번째 시도

```
final class UserControllerTests: XCTestCase {
  func changingEmailFromCorporateToNonCorporate() {
    // Arrange
    let db = Database(connectionString: "TestConnection")
    let user = CreateUser(email: "user@mycorp.com", type: .employee, database: db)
    CreateCompany(domain: "mycorp.com", numberOfEmployees: 1, database: db)

    let messageBusMock = MessageBusMock()
    let sut = UserController(database: db, messageBus: messageBusMock)

    // Act
    let result = sut.changeEmail(userId: user.userId, newEmail: "new@gmail.com")

    // Assert
    XCTAssertEqual(result, "OK")

    let userData = db.getUserById(user.userId)
    let userFromDb = UserFactory.create(userData)
    XCTAssertEqual(userFromDb.email, "new@gmail.com")
    XCTAssertEqual(userFromDb.type, .customer)

    let companyData = db.getCompany()
    let companyFromDb = CompanyFactory.create(companyData)
    XCTAssertEqual(companyFromDb.numberOfEmployees, 0)

    XCTAssertEqual(messageBusMock.sent.count, 1)
    XCTAssertEqual(messageBusMock.sent.first?.userId, user.userId)
    XCTAssertEqual(messageBusMock.sent.first?.newEmail, "new@gmail.com")
  }
}
```

첫 번째 통합 테스트 버전에서는 데이터베이스에 연결하고, `CreateUser` 및 `CreateCompany` 헬퍼 메서드를 통해 `User` 및 `Company`를 데이터베이스에 생성합니다.

> 헬퍼 메서드 사용: Arrange 섹션에서 `CreateUser` 및 `CreateCompany`와 같은 헬퍼 메서드를 사용하면 여러 통합 테스트에서 재사용할 수 있습니다.

메시지 버스는 목으로 대체하고, `UserController`에 `db`와 `messageBusMock`을 주입합니다.

`changeEmail` 메서드를 호출한 후, 결과가 "OK"인지 확인하고, `Database`에서 `User` 및 `Company` 데이터를 다시 조회하여 상태를 검증합니다.

또한 `messageBusMock`을 검증하여 메시지 버스와의 상호작용을 확인합니다.

테스트에서는 입력 매개변수로 사용된 데이터와 별개로 데이터베이스 상태를 확인하는 것이 중요합니다. 

이를 위해 Assert 섹션에서 사용자 및 회사 데이터를 별도로 쿼리하고, 새 `userFromDb` 및 `companyFromDb` 인스턴스를 생성한 다음 상태를 검증합니다. 

이 접근 방식은 데이터베이스에 대한 쓰기 및 읽기 모두를 테스트하여 최대의 회귀 보호를 제공합니다.

### 8.4 인터페이스를 사용하여 의존성 추상화

인터페이스 사용은 단위 테스트에서 가장 오해가 많은 주제 중 하나입니다.

개발자들은 인터페이스를 도입하는 이유에 대해 잘못된 추론을 하는 경향이 있으며, 그 결과 과도하게 사용하는 경향이 있습니다.

##### 8.4.1 인터페이스와 느슨한 결합

많은 개발자가 데이터베이스나 메시지 버스와 같은 외부 프로세스 의존성에 대해, 단 하나의 구현에도 인터페이스를 도입합니다. 

이 관행은 매우 널리 퍼져서 거의 의문을 제기하지 않습니다.

```
public interface MessageBus
public class MessageBusImpl: MessageBus

public interface UserRepository
public class UserRepositoryImpl: UserRepository
```

이러한 관행의 일반적 이유는 다음과 같습니다.
* 외부 프로세스 의존성의 추상화가 느슨한 결합을 만듬
* 기존 코드를 변경하지 않고 새로운 기능을 추가하여 OCP(Open-Closed) 원칙을 준수

이 두 가지 이유 모두 오해입니다. 

단일 구현이 있는 인터페이스는 추상화가 아니며 이러한 인터페이스를 구현하는 클래스보다 느슨한 결합을 제공하지 않습니다.
  - 진정한 추상화는 만들어지는 것이 아니라 찾아내는 것입니다. 
  - 이 말은 추상화가 이미 존재하지만 아직 코드에 명확하게 정의되지 않은 사후에 일어난다는 것입니다.
  - 따라서 인터페이스가 진정한 추상화가 되려면 적어도 두 개의 구현이 있어야 합니다.

두 번째 이유(기존 코드를 변경하지 않고 새로운 기능을 추가할 수 있는 능력)는 YAGNI 원칙을 위반하는 오해입니다. 
  
**YAGNI (You Aren't Gonna Need It)** 원칙은 지금 당장 필요하지 않은 기능에 시간을 투자하지 말 것을 권고합니다.

* 기회비용
  - 당장 필요하지 않은 기능에 시간을 소비하면, 비즈니스에 필요한 기능 개발에서 시간을 뺏게 됩니다.
  - 게다가 비즈니스는 계속 진화할 가능성이 높으며, 여전히 이미 작성된 코드를 조정해야 할 것 입니다.
* 코드량 최소화 
  - 프로젝트에 코드가 적을수록 좋습니다. 불필요하게 코드를 추가하면 유지보수 비용이 증가합니다.

> 코드 작성은 문제를 해결하는 데 비용이 많이 드는 방법입니다. 
>
> 솔루션에 필요한 코드가 적고 코드가 단순할수록 좋습니다.

##### 8.4.2 외부 프로세스 의존성에 인터페이스를 사용하는 이유

그러면 각 인터페이스에 하나의 구현만 있는데도, 왜 외부 의존성에 대한 인터페이스를 사용할까요?

진짜 이유는 훨씬 더 실용적이고 현실적이기 때문입니다. 

쉽게 말하면 목 사용을 가능하게 하는 것입니다.

인터페이스가 없으면 테스트 더블을 만들 수 없으므로 테스트 중인 시스템과 외부 프로세스 의존성 간의 상호 작용을 확인할 수 없습니다.

그러니 **목을 사용할 필요가 없는 한 외부 프로세스 의존성에 대한 인터페이스를 도입하지 마십시오.** 

관리되지 않는 의존성만 목을 사용하므로 다음과 같이 요약할 수 있습니다.

관리되지 않는 의존성에 대해서만 인터페이스를 사용하십시오. 

관리되는 의존성을 컨트롤러에 명시적으로 주입하되, 이를 위해 구체적인 클래스를 사용하십시오.

하나 이상의 구현이 있는 추상화는 목 사용 여부에 관계없이 인터페이스로 표현될 수 있습니다. 

이전 예시에서 `UserController`가 생성자를 통해 메시지 버스와 데이터베이스를 명시적으로 받아들이지만 메시지 버스에만 해당 인터페이스가 있다는 것을 눈치 채셨을 겁니다.

데이터베이스는 관리되는 의존성이므로 그러한 인터페이스가 필요하지 않습니다.

```
final class UserController {
  private let database: Database
  private let messageBus: MessageBus

  init(database: Database, messageBus: MessageBus) {
    self.database = database
    self.messageBus = messageBus
  }

  func changeEmail(userId: Int, newEmail: String) -> String {
    /* the method uses _database and _messageBus */  
  }
}
```
> 가상 메서드를 사용하여 인터페이스 없이도 의존성을 모의 객체화할 수 있지만, 이는 인터페이스를 사용하는 것보다 열등한 접근 방식입니다. 
> 
> 자세한 내용은 11장에서 다룹니다.

##### 8.4.3 내부 프로세스 의존성에 인터페이스 사용

때로는 외부 프로세스 의존성뿐만 아니라 내부 프로세스 의존성에도 인터페이스가 사용되는 코드베이스를 볼 수 있습니다.

```
public interface User {
  var userId: Int { get set }
  var email: String { get }
  
  func canChangeEmail() -> String
  func changeEmail(_ newEmail: String, company: Company);
}

public class UserImpl: User {
/* ... */
}
```

예를 들어, `User` 인터페이스가 단 하나의 구현만 가지고 있다면, 이는 큰 문제의 신호입니다.

그러나 내부 프로세스 의존성(도메인 클래스) 간의 상호작용은 절대 확인해서는 안 됩니다.

이는 테스트를 구현 세부 사항에 결합시켜 리팩토링 저항성 지표에서 실패하게 만드는 **취약한 테스트(brittle tests)**로 이어집니다.

### 8.5 통합 테스트 모범 사례

통합 테스트의 효과를 극대화하는 데 도움이 되는 몇 가지 일반적인 지침이 있습니다.
* 도메인 모델 경계를 명시적으로 만들기 
* 애플리케이션의 레이어 수 줄이기
* 순환 종속성 제거

보통 테스트에 유익한 모범 사례는 코드베이스의 전반적인 건강도 향상시킵니다.

##### 8.5.1 도메인 모델 경계 명확화

코드베이스에서 도메인 모델은 항상 명확하고 알려진 위치에 있어야 합니다.

명시적 경계를 할당하면 코드 구조를 이해하고 추론하는 데 도움이 되며, 테스트 작성에도 유리합니다.

단위 테스트는 도메인 모델과 알고리즘을, 통합 테스트는 컨트롤러를 대상으로 하기 때문에 경계가 명확하면 두 테스트를 구분하기 쉽습니다.

중요한 것은 도메인 논리가 한 곳에 모여 흩어지지 않도록 하는 것입니다.

##### 8.5.2 계층 수 줄이기

대부분의 프로그래머는 코드를 추상화하고 일반화하기 위해 추가적인 간접 계층을 도입하는 경향이 있습니다.

@Image(source: "8-6.png")

극단적인 경우, 너무 많은 추상화 계층이 있어서 코드를 탐색하고 간단한 작업 뒤에 있는 논리를 이해하는 것이 너무 어려워집니다.

데이비드 J. 휠러(David J. Wheeler)는 "컴퓨터 과학의 모든 문제는 또 다른 간접 계층으로 해결할 수 있습니다. 너무 많은 간접 계층의 문제는 제외하고요."라고 말했습니다.

간접 계층은 코드에 대한 추론 능력을 저해합니다.

가능한 한 적은 수의 간접 계층을 가지도록 노력해야 합니다. 

대부분의 백엔드 시스템에서는 도메인 모델, 애플리케이션 서비스 계층(컨트롤러), 인프라 계층의 세 가지 계층으로 충분합니다.

* 도메인 계층
  - 도메인 로직을 포함합니다.

* 애플리케이션 서비스 계층(컨트롤러)
  - 외부 클라이언트에 진입점을 제공하고, 도메인 클래스와 외부 프로세스 의존성 간의 작업을 조율합니다.

* 인프라 계층
  - 외부 프로세스 의존성과 작동하며, 데이터베이스 리포지토리, ORM 매핑, SMTP 게이트웨이 등이 이 계층에 속합니다.

##### 8.5.3 순환 의존성 제거

코드베이스의 유지보수성을 향상시키고 테스트를 용이하게 하는 또 다른 방법은 **순환 의존성(circular dependencies)**을 제거하는 것입니다.

> 정의: 순환 의존성(cyclic dependency)은 제대로 작동하기 위해 직접 또는 간접적으로 서로 의존하는 두 개 이상의 클래스를 의미합니다.

일반적인 예는 콜백(callback)입니다.

```
final class CheckOutService: ReportGenerationDelegate {
  func checkOut(orderId: Int) {
    let service = ReportGenerationService()
    service.generateReport(orderId: orderId, delegate: self)
    /* other code */
  }

  func reportGenerationCompleted(orderId: Int) {
    print("Report generation completed for order \(orderId)")
  }
}

final class ReportGenerationService {
  private weak var delegate: ReportGenerationDelegate?

  func generateReport(orderId: Int, delegate: ReportGenerationDelegate) {
    self.delegate = delegate
    delegate.reportGenerationCompleted(orderId: orderId)
  }
}
```

여기서 `CheckOutService`는 `ReportGenerationService`의 인스턴스를 생성하고 인수로 해당 인스턴스에 자신을 전달합니다.

`ReportGenerationService`는 `CheckOutService`를 다시 호출하여 보고서 생성 결과에 대해 알립니다. 

순환 의존성은 코드를 읽고 이해할 때 엄청난 인지 부하를 추가합니다. 이는 순환 의존성이 솔루션을 탐색하기 시작할 명확한 시작점을 제공하지 않기 때문입니다.

순환 의존성은 테스트에도 방해가 됩니다.

클래스 그래프를 분할해야 하고, 그 과정에서 인터페이스나 목을 사용해 의존성을 끊어야 합니다.

테스트를 위해 만든 임시 인터페이스나 모의 객체는 도메인 모델 자체에 적용할 수 없기 때문에, 테스트 범위가 제한됩니다.

인터페이스를 사용하는 것은 순환 의존성 문제를 마스킹할 뿐입니다. 

컴파일 시 순환 의존성을 제거하더라도, 런타임에는 여전히 순환이 존재합니다.

@Image(source: 8-7.png)

순환 의존성을 처리하는 더 나은 접근 방식은 완전히 제거하는 것입니다. 

```
final class CheckOutService {
  func checkOut(orderId: Int) {
    let service = ReportGenerationService()
    let report = service.generateReport(orderId);
    
    /* other work */
  }
}

final class ReportGenerationService {
  func generateReport(_ orderId: Int) -> Report {
    /* ... */
  }
}
```

`ReportGenerationService`가 `CheckOutService`나 인터페이스에 의존하지 않도록 리팩토링하고, `ReportGenerationService`가 그 작업 결과를 일반 값(plain value)으로 반환하도록 합니다.

코드베이스에서 모든 순환 의존성을 제거하는 것은 어렵지만, 상호 의존적인 클래스 그래프를 가능한 한 작게 만들어 피해를 최소화할 수 있습니다.

##### 8.5.4 테스트에서 여러 Act 섹션 사용

3장에서 언급했듯이, 테스트에 두 개 이상의 arrange, act, assert 섹션이 있는 것은 코드 스멜(code smell)입니다. 

이는 테스트가 여러 동작 단위를 확인하고 있으며, 이로 인해 테스트의 유지보수성이 저해된다는 신호입니다.

테스트는 각 act를 자체 테스트로 추출하여 분할하는 것이 가장 좋습니다. 

이렇게 하면 각 테스트가 단일 동작 단위에 집중하여 이해하고 수정하기가 쉬워집니다.

바람직한 상태로 만들기 어려운 외부 프로세스 의존성과 작업하는 테스트는 예외입니다. 

외부 뱅킹 시스템에 은행 계좌를 생성하는 데 시간이 오래 걸리거나 호출 횟수가 제한될 경우, 여러 act를 하나의 테스트로 결합하여 해당 의존성과의 상호작용 횟수를 줄이는 것이 유용할 수 있습니다.

이러한 **다단계 테스트(multistep tests)** 는 거의 항상 종단 간 테스트(end-to-end tests) 범주에 속합니다. 

단위 테스트는 외부 프로세스 의존성과 작업하지 않으므로 여러 act를 가져서는 안 됩니다.

### 8.6 로깅 기능 테스트 방법

로깅은 테스트와 관련하여 무엇을 해야 할지 명확하지 않은 회색 영역입니다.

##### 8.6.1 로깅을 테스트해야 하는가?

로깅을 테스트해야 하는지에 대한 답변은 로깅이 애플리케이션의 관찰 가능한 동작의 일부인지, 아니면 구현 세부 사항인지에 달려 있습니다.

그런 의미에서, 그것은 다른 어떤 기능과도 다르지 않습니다.

로깅은 궁극적으로 텍스트 파일이나 데이터베이스와 같은 프로세스 외 종속성에 부수 효과를 만듭니다.

이러한 부작용이 고객, 애플리케이션의 고객 또는 개발자가 아닌 다른 사람이 관찰하기 위한 것이라면, 로깅은 관찰 가능한 행동이므로 테스트해야 합니다.

유일한 청중이 개발자라면, 아무도 알아차리지 않고 자유롭게 수정할 수 있는 구현 세부 사항이며, 이 경우 테스트해서는 안 됩니다.

Steve Freeman과 Nat Pryce는 Growing 테스트에 따라 성장하는 객체 지향 소프트웨어 (Addison-Wesley Professional, 2009)라는 책에서 다음과 같은 두 가지 유형의 로깅 지원 로깅과 진단 로깅을 부릅니다.

**지원 로깅(Support logging)** 은 지원 스태프나 시스템 관리자가 추적할 메시지를 생성합니다. 이는 애플리케이션의 관찰 가능한 동작의 일부입니다.

**진단 로깅(Diagnostic logging)** 은 개발자가 애플리케이션 내부에서 무슨 일이 일어나고 있는지 이해하는 데 도움이 됩니다. 이는 구현 세부 사항입니다.

##### 8.6.2 로깅을 어떻게 테스트해야 하는가?

로깅은 외부 프로세스 의존성을 포함하므로, 외부 프로세스 의존성과 관련된 다른 기능과 동일한 테스트 규칙이 적용됩니다.

```
func changeEmail(_ newEmail: String, company: Company) {
  logger.info("Changing email for user \(userId) to \(newEmail)")
  precondition(canChangeEmail() == nil, "Cannot change email: precondition failed")

  if email == newEmail { return }

  let newType: UserType = company.isEmailCorporate(newEmail) ? .employee : .customer

  if type != newType {
    let delta = newType == .employee ? 1 : -1
    company.changeNumberOfEmployees(delta)
    domainLogger.userTypeHasChanged(userId: userId, from: type, to: newType)
  }

  email = newEmail
  type = newType
  emailChangedEvents.append(EmailChangedEvent(userId: userId, newEmail: newEmail))

  logger.info("Email is changed for user \(userId)")
}
```

지원 로깅이 비즈니스 요구사항인 경우, 이 요구사항을 코드베이스에 명시적으로 반영해야 합니다.

`DomainLoggerImpl`라는 특별한 클래스를 만들어 비즈니스에 필요한 모든 지원 로깅을 명시적으로 나열하고, `Logger` 대신 이 클래스와의 상호작용을 검증합니다.

```
final class DomainLoggerImpl: DomainLogger {
  private let logger: Logger

  init(logger: Logger) {
    self.logger = logger
  }

  func userTypeHasChanged(userId: Int, from oldType: UserType, to newType: UserType) {
    logger.info("User \(userId) changed type from \(oldType) to \(newType)")
  }
}
```

`DomainLoggerImpl`는 `Logger` 위에 작동하며, 도메인 언어를 사용하여 비즈니스에 필요한 특정 로그 항목을 선언하여 지원 로깅을 이해하고 유지보수하기 쉽게 만듭니다.

이는 **구조화된 로깅(structured logging)** 개념과 매우 유사합니다.
    
구조화된 로깅은 로그 데이터 캡처를 데이터 렌더링과 분리하는 로깅 기술입니다.

전통적인 로깅은 단순 텍스트로 작동하여 로그 파일 분석이 어렵습니다.
        
```
logger.info("User Id is " + 12)
```

반면에 구조화된 로깅은 로그 저장소에 구조를 도입합니다. 구조화된

로깅 라이브러리의 사용은 표면적으로 비슷하게 보입니다.

```
let userId = 12
logger.info("User Id is \(userId)")

```

그러나 근본적인 행동은 상당히 다릅니다. 

구조화된 로깅은 메시지 템플릿과 매개변수를 사용하여 로그 데이터를 생성하며, 이는 JSON 또는 CSV 파일과 같은 다양한 형식으로 렌더링될 수 있습니다.

앞서 언급했듯이 `DomainLoggerImpl`은 외부 프로세스에 기록하는 역할을 합니다.

문제는, 도메인 코드가 이 `DomainLoggerImpl`을 직접 쓰게 되면, 비즈니스 로직이 외부 시스템과 직접 얽히는 상황이 발생합니다.

이 문제는 **도메인 이벤트(domain event)** 를 사용하여 해결할 수 있습니다.
 
```
func changeEmail(_ newEmail: String, company: Company) {
  logger.info("Changing email for user \(userId) to \(newEmail)")
  precondition(canChangeEmail() == nil, "Cannot change email: precondition failed")

  if email == newEmail { return }

  let newType: UserType = company.isEmailCorporate(newEmail) ? .employee : .customer

  if type != newType {
    let delta = newType == .employee ? 1 : -1
    company.changeNumberOfEmployees(delta)
    addDomainEvent(UserTypeChangedEvent(userId, type, newType))
  }

  email = newEmail
  type = newType
  addDomainEvent(EmailChangedEvent(userId, newEmail))

  logger.info("Email is changed for user \(userId)")
}
```

이제 `UserTypeChangedEvent` 와 `EmailChangedEvent` 라는 두 개의 도메인 이벤트가 있습니다. 

둘 다 동일한 인터페이스(`DomainEvent`)를 구현하므로 동일한 컬렉션에 저장할 수 있습니다.

```
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
```

`EventDispatcher`는 도메인 이벤트를 받아서 외부 시스템 호출로 바꿔주는 역할입니다.

`UserTypeChangedEvent`의 사용은 사용자 타입의 변경은 도메인 로직 안에서 표현되고, 그 사실을 바깥에 알리는 책임은 외부 의존성 담당 코드로 분리 시킵니다.

컨트롤러에서 로깅을 지원해야 하는 경우 도메인 이벤트를 사용할 필요가 없습니다. 

컨트롤러는 도메인 모델과 프로세스 외 종속성 간의 협업을 조정합니다. 

`DomainLoggerImpl`는 그러한 종속성 중 하나이며, `UserController`는 해당 로거를 직접 사용할 수 있습니다. 

또한 사용자는 여전히 `changeEmail` 메서드의 시작과 끝에서 로거 인스턴스를 직접 사용합니다. 

진단 로깅은 개발자 전용입니다. 

##### 8.6.3 로깅은 어느 정도가 적당한가?
    
또 다른 중요한 질문은 최적의 로깅량에 관한 것입니다.

지원 로깅은 비즈니스 요구사항이므로 제어할 수 없습니다.

하지만 진단 로깅은 제어할 수 있습니다. 

다음과 같은 두 가지 이유로 진단 로깅을 과도하게 사용하지 않는 것이 중요합니다. 
* 과도한 로깅은 코드를 어지럽게 합니다. 
  - 도메인 모델에서 진단 로깅을 사용하는 것은 권장하지 않습니다. 

* 로그의 신호 대 잡음 비율이 핵심입니다. 
  - 더 많이 기록할수록 관련 정보를 찾기가 더 어려워집니다. 
  - “핵심 정보(신호)”만 남기고 잡음은 최소화 합니다.

도메인 모델에서 진단 로깅을 전혀 사용하지 않도록 하십시오. 

대부분의 경우 해당 로깅을 도메인 클래스에서 컨트롤러로 안전하게 이동할 수 있습니다.

그리고 그 경우에도 무언가를 디버깅해야 할 때만 일시적으로 진단 로깅에 의지하십시오. 

디버깅을 마치면 제거하십시오.

##### 8.6.4 로거 인스턴스를 전달하는 방법

로거 인스턴스를 해결하는 한 가지 방법은 정적 메서드를 사용하는 앰비언트 컨텍스트(ambient context) 방식입니다.

```
final class User {
  private static let logger: Logger = LoggerImpl()

  func changeEmail(_ newEmail: String, company: Company) {
    Self.logger.info("Changing email for user \(userId) to \(newEmail)")
    
    /* ... */
    
    Self.logger.info("Email is changed for user \(userId)")
  }
}
```

이는 안티패턴입니다. 이는 프로덕션 코드를 오염시키고, 테스트를 더 어렵게 만들며, 테스트 간에 공유되는 의존성을 도입하여 테스트를 통합 테스트 영역으로 전환시킵니다.

더 나은 접근 방식은 로거 의존성을 명시적으로 주입하는 것입니다. 생성자나 메서드 인수를 통해 주입할 수 있습니다.

```
public func changeEmail(_ newEmail: String, company: Company, logger: Logger) {
  logger.info("Changing email for user \(userId) to \(newEmail)")
  
  /* ... */

  logger.info("Email is changed for user \(userId)")
}
```

### 8.7 결론

모든 외부 프로세스 의존성과의 통신은 해당 통신이 애플리케이션의 관찰 가능한 동작의 일부인지 또는 구현 세부 사항인지의 관점에서 보아야 합니다.

로그 저장소도 마찬가지입니다.

로그가 프로그래머가 아닌 사람들에게 관찰 가능하다면 로깅 기능을 목 객체화(mock)하여 테스트해야 합니다. 그렇지 않다면 테스트할 필요가 없습니다.
