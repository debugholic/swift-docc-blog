# 7. 가치 있는 유닛 테스트로 리팩토링하기

## Overview

좋은 테스트를 작성하는 방법을 터득하고 코드 설계 기술의 중요성을 알아봅니다.

### 7.1 리팩토링할 코드 식별하기

* 단위 테스트 스위트를 크게 개선하려면 기본 코드를 리팩토링하는 것이 필수적입니다.

* 이 섹션에서는 코드 분류 방법을 통해 리팩토링의 방향을 제시합니다.

##### 7.1.1 네 가지 코드 유형

* 모든 프로덕션 코드는 두 가지 차원을 기준으로 분류될 수 있습니다.
  - 복잡성 또는 도메인 중요성 (Complexity or domain significance)
  - 협력자 수 (The number of collaborators)

* 코드 복잡성
  - 코드 복잡성은 코드의 의사 결정(분기) 지점의 수에 의해 정의됩니다. 
  - 그 숫자가 클수록 복잡성이 높아집니다.

> 사이클로매틱 복잡도(cyclomatic complexity): 
> 1 + 분기점 수

* 도메인 중요성
  - 프로젝트의 문제 도메인에 대한 코드의 중요성을 나타냅니다. 
  - 도메인 계층 코드는 일반적으로 높은 도메인 중요성을 가집니다.

* 협력자 수
  - 클래스나 메서드가 가진 의존성 중 가변적이거나 외부 프로세스인 것의 수입니다.
  - 협력자가 많은 코드는 테스트 비용이 높습니다. 
  - 불변 의존성(값 객체)은 협력자로 간주되지 않습니다.

* 이 두 가지 차원을 조합하여 코드는 네 가지 유형으로 분류됩니다.
  - 도메인 모델 및 알고리즘 (Domain model and algorithms)
    + 높은 복잡성/도메인 중요성, 적은 협력자를 가집니다. 
    + 단위 테스트 노력에 대한 최상의 수익을 제공합니다.
  - 간단한 코드 (Trivial code)
    + 낮은 복잡성/도메인 중요성, 적은 협력자를 가집니다.
    + 테스트할 가치가 거의 없습니다.
  - 컨트롤러 (Controllers)
    + 낮은 복잡성/도메인 중요성, 많은 협력자를 가집니다. 
    + 다른 구성 요소의 작업을 조정하는 역할을 하며, 간략하게 통합 테스트로 커버해야 합니다.
  - 지나치게 복잡한 코드 (Overcomplicated code)
    + 높은 복잡성/도메인 중요성, 많은 협력자를 가집니다.
    + 테스트하기 어렵지만 테스트 커버리지 없이는 위험하므로, 알고리즘과 컨트롤러로 분리하는 것이 목표입니다.

| ![](7-1.png) | ![](7-2.png) |
|:------------:|:------------:|

> 코드가 중요하거나 복잡할 수록 협력자가 적어야 합니다.

> 나쁜 테스트를 작성하는 것보다 테스트를 아예 작성하지 않는 것이 낫습니다.

##### 7.1.2 험블 객체(Humble Object) 패턴을 사용하여 지나치게 복잡한 코드 분할하기

* 우리는 종종 코드가 프레임워크 의존성에 결합되어 있기 때문에 테스트하기 어렵다는 것을 발견합니다 (예: 비동기 실행, UI, 외부 프로세스 통신).

* Humble Object 패턴은 테스트하기 어려운 의존성에 강하게 결합된 코드에서 로직을 추출하여 테스트할 필요 없는 험블 래퍼(humble wrapper)로 만드는 패턴입니다.

| ![](7-3.png) | ![](7-4.png) |
|:------------:|:------------:|

* 테스트하기 어려운 종속성과 새로 추출된 구성 요소(험블 객체)가 함께 있지만, 그 자체에는 논리가 거의 또는 전혀 포함되어 있지 않으므로 테스트할 필요가 없습니다

* 육각형 아키텍처와 함수형 아키텍처 모두 이 정확한 패턴을 구현합니다. 
  - 육각형 아키텍처
    + 비즈니스 로직과 프로세스 외 종속성과의 커뮤니케이션의 분리를 옹호합니다.
    + 이것은 도메인과 애플리케이션 서비스 계층이 각각 책임지는 것입니다. 
  - 함수형 아키텍처
    + 프로세스 외의 공동 작업자뿐만 아니라 모든 공동 작업자와의 커뮤니케이션에서 비즈니스 논리를 분리합니다. 
    + 이것이 함수형 아키텍처를 테스트하기 쉬운 이유입니다. 
    + 함수형 핵심은 협력자가 없습니다. 
    + 함수형 코어의 모든 의존성은 불변이며, 이는 코드 유형 다이어그램의 수직 축에 매우 가깝게 만듭니다.

* 험블 객체 패턴은 각 클래스가 단일 책임(예: 비즈니스 로직)만 가지도록 하는 수단으로 볼 수 있습니다. (단일 책임 원칙)

* 코드 깊이 대 코드 폭 (Code depth vs. code width)
  - 비즈니스 로직은 "깊고"(복잡하거나 중요), 오케스트레이션(컨트롤러)은 "넓으며"(많은 협력자와 작업) 둘 다 일 수는 없습니다.

@Row {
  @Column {
    @Image(source: 7-5.png)  
  }
  @Column {}
}

* MVC 패턴, MVP 패턴, Domain-Driven 디자인 Aggregate 패턴 등은  본질적으로 Humble Object 패턴의 한 형태로 볼 수 있으며, 복잡한 코드를 오케스트레이션 코드로부터 분리하여 테스트하기 쉽게 만들고 코드 복잡성을 관리하는 데 기여합니다.

### 7.2 가치 있는 단위 테스트를 향한 리팩토링

CRM 시스템 예시를 통해 지나치게 복잡한 코드를 알고리즘과 컨트롤러로 분리하는 과정을 알아봅니다.

##### 7.2.1 1단계: 고객 관리 시스템 소개

* 사용자 이메일 변경 기능에 대한 3가지 비즈니스 규칙이 있는 CRM 시스템을 예시로 제시합니다.
  - 사용자의 이메일이 회사의 도메인에 속하는 경우 해당 사용자는 직원으로 표시됩니다. 그렇지 않으면 고객으로 취급됩니다.
  - 시스템은 회사의 직원 수를 추적해야 합니다. 사용자 유형이 직원에서 고객으로 변경되거나 그 반대로 변경되는 경우 이 숫자도 변경되어야 합니다. 
  - 이메일이 변경되면 시스템은 메시지 버스에 메시지를 보내 외부 시스템에 알려야 합니다.

```
class User {
  private(set) var userId: Int = 0
  private(set) var email: String = ""
  private(set) var type: UserType = .customer

  func changeEmail(userId: Int, newEmail: String) {
    guard let data = Database.getUserById(userId),
      data.count >= 3,
      let emailFromDb = data[1] as? String,
      let typeFromDb = data[2] as? UserType
    else { return }

    self.userId = userId
    self.email = emailFromDb
    self.type = typeFromDb

    if self.email == newEmail { return }
  
    guard let companyData = Database.getCompany(),
      companyData.count >= 2,
      let companyDomainName = companyData[0] as? String,
      let numberOfEmployees = companyData[1] as? Int
    else { return }

    let parts = newEmail.split(separator: "@")
    guard parts.count == 2 else { return }
    let emailDomain = String(parts[1])
    let isEmailCorporate = emailDomain == companyDomainName
    let newType: UserType = isEmailCorporate ? .employee : .customer

    if self.type != newType {
      let delta = newType == .employee ? 1 : -1
      let newNumber = numberOfEmployees + delta
      Database.saveCompany(newNumber)
    }

    self.email = newEmail
    self.type = newType

    Database.saveUser(self)
    MessageBus.sendEmailChangedMessage(self.userId, newEmail)
  }
}

enum UserType: Int {
  case customer = 1
  case employee = 2
}
```

* `User` 클래스는 사용자 이메일을 변경합니다. 

* 코드 유형 다이어그램의 관점에서 이 구현을 분석해 봅시다. 
  - 코드의 복잡성은 그리 높지 않습니다. 
    + `changeEmail` 메서드에는 `User`를 `employee` 또는 `customer`로 식별할지 여부와 `companyData`의 `numberOfEmployees`를 업데이트하는 방법이라는 몇 가지 명시적인 의사 결정 사항만 포함되어 있습니다. 
    + 단순하긴 하지만 이러한 결정은 애플리케이션의 핵심 비즈니스 논리입니다.
    + 클래스은 복잡성과 영역 중요성 차원에서 높은 점수를 받았습니다. 
  - `User` 클래스는 네 개의 종속성을 가지고 있으며, 그 중 두 개는 명시적이고 나머지 두 개는 암시적입니다. 
    + 명시적 종속성은 `userId` 및 `newEmail`이고, 값이므로 수업의 공동 작업자 수에 포함되지 않습니다. 
    + 암시적인 것들은 `Database`와 `MessageBus`이고, 외부 프로세스 협력자입니다.
    + 외부 프로세스 협력자는 도메인 중요도가 높은 코드에는 사용할 수 없습니다. 따라서 사용자 클래스는 공동 작업자에 대해 높은 점수를 받았습니다.

@Row {
  @Column {
    @Image(source: 7-6.png)  
  }
  @Column {}
}

* 초기 `User` 클래스는 `Database`와 `MessageBus` 같은 외부 프로세스 협력자를 직접 다루어 "지나치게 복잡한 코드" 유형에 해당합니다. 

* 이는 활성 레코드(Active record) 패턴의 예시이며, 간단한 프로젝트에는 적합하지만 테스트하기 어렵고 확장성이 떨어집니다.


문제점: 도메인 모델이 아웃-오브-프로세스 의존성에 직접 또는 간접적으로 의존하면 테스트 비용이 많이 들고 테스트 취약성을 유발할 수 있습니다.

##### 7.2.2 암시적 의존성을 명시적으로 만들기

* 테스트 가능성을 개선하기 위한 일반적인 접근 방식은 암시적 종속성을 명시적으로 만드는 것입니다.

* 즉, 데이터베이스와 메시지 버스에 대한 인터페이스를 도입하고, 해당 인터페이스를 사용자에게 삽입한 다음 테스트에서 목을 사용하는 것입니다.

* 하지만 코드 유형 다이어그램의 관점에서 볼 때, 도메인 모델이 프로세스 외 종속성을 직접 참조하는지 아니면 인터페이스를 통해 참조하는지 여부는 중요하지 않습니다.

* 이러한 의존성은 아직 처리되지 않은 상태입니다.

* 그러한 클래스를 테스트하기 위해서는 여전히 복잡한 목 체계를 유지해야 하며, 이는 테스트의 유지 보수 비용을 증가시킵니다. 

* 전반적으로, 도메인 모델이 직접 또는 간접적으로 (인터페이스를 통해) 외부 프로세스 협력자에 전혀 의존하지 않는 것이 훨씬 더 깨끗합니다.

##### 7.2.3 2단계: 애플리케이션 서비스 계층 도입


* 도메인 모델이 외부 시스템과 직접 통신하는 책임을 `UserController`라는 애플리케이션 서비스(험블 컨트롤러)로 옮깁니다.

* 도메인 클래스는 다른 도메인 클래스 또는 순수 값과 같은 프로세스 내 종속성에만 의존해야 합니다. 

```
class UserController {
  private let database = Database()
  private let messageBus = MessageBus()

  func changeEmail(userId: Int, newEmail: String) {
    guard let data = database.getUserById(userId),
      data.count >= 3,
      let emailFromDb = data[1] as? String,
      let typeFromDb = (data[2] as? UserType) ?? {
        if let raw = data[2] as? Int { 
          return UserType(rawValue: raw) 
        }
        return nil
      }()
    else { return }

    let user = User(userId: userId, email: emailFromDb, type: typeFromDb)

    guard let companyData = database.getCompany(),
      companyData.count >= 2,
      let companyDomainName = companyData[0] as? String,
      let numberOfEmployees = companyData[1] as? Int else { return }

    let newNumberOfEmployees = user.changeEmail(newEmail, companyDomainName: companyDomainName, numberOfEmployees: numberOfEmployees)

    database.saveCompany(newNumberOfEmployees)
    database.saveUser(user)
    messageBus.sendEmailChangedMessage(userId, newEmail)
  }
}
```

* 응용 프로그램 서비스는 `User` 클래스에서 외부 프로세스 종속성으로 작업을 오프로드하는 데 도움이 되었습니다.

* 그러나 이 구현에는 몇 가지 문제가 있습니다.
  - 외부 프로세스 종속성(데이터베이스 및 메시지 버스)은 주입되지 않고 직접 인스턴스화됩니다.
    + 그것은 우리가 이 클래스를 위해 작성할 통합 테스트에 문제가 될 것입니다. 
  - 컨트롤러는 데이터베이스에서 받은 원시 데이터에서 `User` 인스턴스를 재구성합니다.
    + 이것은 복잡한 논리이므로 오케스트레이션 역할인 응용 프로그램 서비스에 속해서는 안 됩니다.
  - 또 다른 문제는 `User`가 이제 업데이트된 `newNumberOfEmployees`를 반환한다는 것입니다. 
    + 회사 직원 수는 특정 사용자와 관련이 없으므로 이 책임은 다른 곳에 있어야 한다.
  - 컨트롤러는 수정된 데이터를 유지하고 새 이메일이 이전 이메일과 다른지 여부에 관계없이 `MessageBus`에 무조건 알림을 보냅니다. 

* 사용자 클래스는 더 이상 종속성이 없으므로 테스트하기가 매우 쉬워졌습니다.

```
func changeEmail(_ newEmail: String, companyDomainName: String, numberOfEmployees: Int) -> Int {
  if email == newEmail {
    return numberOfEmployees
  }

  let parts = newEmail.split(separator: "@")
  guard parts.count == 2 else { return numberOfEmployees }
  let emailDomain = String(parts[1])
  let isEmailCorporate = emailDomain == companyDomainName
  let newType: UserType = isEmailCorporate ? .employee : .customer

  var updatedNumber = numberOfEmployees
  if type != newType {
    let delta = newType == .employee ? 1 : -1
    updatedNumber = numberOfEmployees + delta
  }

  email = newEmail
  type = newType
  return updatedNumber
}
```
* 결과적으로 `User` 클래스는 협력자가 없어 테스트하기 훨씬 쉬워지며, 코드 유형 다이어그램의 "도메인 모델" 사분면으로 이동합니다. 

* 하지만 `UserController`는 여전히 복잡한 데이터 재구성 로직을 포함하여 "지나치게 복잡한 코드" 영역에 가깝습니다.

@Row {
  @Column {
    @Image(source: 7-7.png)  
  }
  @Column
}

##### 7.2.4 3단계: 애플리케이션 서비스에서 복잡성 제거

  * `UserController`를 컨트롤러 영역에 확고히 두기 위해, 컨트롤러에서 재구성 로직을 추출해야 합니다. 

  * 객체-관계 매핑(ORM) 라이브러리는 데이터베이스를 도메인 모델에 매핑하는 방법을 지정할 수 있는 전용 공간을 제공하므로, 이러한 재구성 로직을 귀속시키기에 좋은 장소입니다.

```
class UserFactory {
  static func create(_ data: [Any]) -> User {
    precondition(data.count >= 3, "data must contain at least 3 elements")
    guard let id = data[0] as? Int,
          let email = data[1] as? String else {
      preconditionFailure("Invalid user id or email")
    }

    let type: UserType
    if let t = data[2] as? UserType {
      type = t
    } else if let raw = data[2] as? Int, let t = UserType(rawValue: raw) {
      type = t
    } else {
      preconditionFailure("Invalid user type")
    }

    return User(userId: id, email: email, type: type)
  }
}
```
  * `UserFactory`는 `create()` 메서드를 통해 사용자 재구성 로직을 제공합니다. 

  * 이 메서드는 모든 협력자로부터 완전히 격리되어 테스트하기 쉽습니다. 

  * 또한, 이 메서드에는 `preconditionRequires()`와 같은 안전장치가 포함되어, data 배열에 최소한 3개의 요소가 있어야 한다는 요구사항을 강제합니다. 

  * 이는 코드를 간결하게 만들고 조건 반전을 통해 가독성을 높입니다.

  * 재구성 로직은 복잡할 수 있지만, 사용자 이메일 변경과 같은 클라이언트의 목표와 직접적으로 관련이 없으므로 도메인 중요성은 낮습니다.

##### 7.2.5 4단계: 새로운 Company 클래스 도입

  * 아래 코드를 다시 봅시다.

```
guard let companyData = database.getCompany(),
  companyData.count >= 2,
  let companyDomainName = companyData[0] as? String,
  let numberOfEmployees = companyData[1] as? Int else { return }

let newNumberOfEmployees = user.changeEmail(newEmail, companyDomainName: companyDomainName, numberOfEmployees: numberOfEmployees)
```

  * `User` 클래스가 업데이트된 회사 직원 수를 반환하는 것은 잘못된 책임 소재입니다.

  * `Company`라는 새로운 도메인 클래스를 도입하여 회사 관련 로직과 데이터를 캡슐화합니다.

```
class Company {
  private(set) var domainName: String
  private(set) var numberOfEmployees: Int

  init(domainName: String, numberOfEmployees: Int) {
    self.domainName = domainName
    self.numberOfEmployees = numberOfEmployees
  }

  func changeNumberOfEmployees(_ delta: Int) {
    precondition(numberOfEmployees + delta >= 0)
    numberOfEmployees += delta
  }

  func isEmailCorporate(_ email: String) -> Bool {
    let parts = email.split(separator: "@")
    guard parts.count == 2 else { return false }
    let emailDomain = String(parts[1])
    return emailDomain == domainName
  }
}
```

  * `Company` 클래스에는 `changeNumberOfEmployees()` 및 `isEmailCorporate()` 두 가지 메서드가 있습니다. 

  * `User` 인스턴스는 `Company` 에게 직원 수를 변경하거나 특정 이메일이 회사 이메일인지 판단하도록 지시할 뿐, 원시 데이터를 요청하여 스스로 모든 작업을 처리하지 않습니다.
  
  * `Company` 클래스가 도입된 후 `UserController`와 `User` 클래스는 다음과 같이 리팩토링됩니다.

```
class UserController {
  private let database = Database()
  private let messageBus = MessageBus()

  func changeEmail(userId: Int, newEmail: String) {
    guard let userData = database.getUserById(userId) else { return }
    let user = UserFactory.create(userData)

    guard let companyData = database.getCompany() else { return }
    let company = CompanyFactory.create(companyData)

    _ = user.changeEmail(newEmail, company: company)
    database.saveCompany(company)
    database.saveUser(user)
    messageBus.sendEmailChangedMessage(userId, newEmail)
  }
}
```

  * `UserController`는 이제 `UserFactory`와 `CompanyFactory`를 통해 `User`와 `Company` 객체를 생성하고, `user.changeEmail()`을 호출한 후 변경된 데이터를 데이터베이스에 저장하고 메시지 버스에 이벤트를 보냅니다.

```
class User {
  private(set) var userId: Int
  private(set) var email: String
  private(set) var type: UserType

  init(userId: Int, email: String, type: UserType) {
    self.userId = userId
    self.email = email
    self.type = type
  }

  func changeEmail(_ newEmail: String, company: Company) {
    if email == newEmail { return }

    let newType: UserType = company.isEmailCorporate(newEmail) ? .employee : .customer
    if type != newType {
      let delta = newType == .employee ? 1 : -1
      company.changeNumberOfEmployees(delta)
    }

    email = newEmail
    type = newType
  }
}
```

  * `User` 클래스는 `Company` 인스턴스를 받아 이메일이 회사 이메일인지 판단하고, 필요한 경우 `Company` 인스턴스를 통해 직원 수를 변경하는 작업을 위임합니다. 

  * 이제 `User`, `Company`, `UserFactory`, `CompanyFactory`는 모두 "도메인 모델 및 알고리즘" 사분면에 위치하며, `UserController`는 "컨트롤러" 사분면에 확고히 자리 잡습니다.

@Row {
  @Column {
    @Image(source: 7-7.png)  
  }
  @Column
}

  * 모든 부수 효과(이메일 변경, 직원 수 변경)가 도메인 모델 내에만 존재하고, 컨트롤러가 데이터베이스에 저장할 때만 도메인 모델 경계를 넘으므로 테스트 용이성이 크게 향상됩니다.


### 7.3 최적의 단위 테스트 커버리지 분석

  * 비즈니스 로직과 오케스트레이션의 완전한 분리를 통해, 프로젝트의 어떤 부분을 단위 테스트할지 쉽게 결정할 수 있습니다.

@Row {
  @Column
  @Column {
    적은 협력자        
  }
  @Column {
    많은 협력자        
  }
}
---
@Row {
  @Column {
    높은 복잡성 또는 도메인 중요도
  }
  @Column {
    `User` 의 `changeEmail(newEmail, company)`; 
  }
  @Column  
}

@Row {
  @Column
  @Column {
    `Company` 의 `changeNumberOfEmploye(delta)` 와 `isEmailCorporate(email)`;
  }
  @Column
}

@Row {
  @Column
  @Column {
    `UserFactory` 와 `CompanyFactory` 의 `create(data)` 
  }
  @Column
}
---
@Row {
  @Column {
    낮은 복잡성과 도메인 중요성
  }
  @Column {
    `User` 및 `Company`의 생성자        
  }
  @Column {
    `UserController` 의 `changeEmail(userId, newEmail)`        
  }
}

##### 7.3.1 도메인 계층 및 유틸리티 코드 테스트
  * "도메인 모델 및 알고리즘" 사분면의 코드 테스트가 비용-이점 측면에서 최고의 결과를 제공합니다. 

  * 높은 복잡성/도메인 중요성으로 회귀 방어 효과가 크고, 적은 협력자로 유지보수 비용이 낮습니다.

  * `User` 는 다음과 같이 테스트 됩니다.

```
final class UserTests: XCTestCase {
  func changing_email_from_non_corporate_to_corporate()() {
    let company = Company("mycorp.com", 1)
    let sut = User(1, "user@gmail.com", .customer)

    sut.changeEmail("new@mycorp.com", company: company)

    XCTAssertEqual(2, company.numberOfEmployees)
    XCTAssertEqual("new@mycorp.com", sut.email)
    XCTAssertEqual(.employee, sut.type)
  }
}
```

* 완전한 커버리지를 달성하려면, 이와 같은 테스트를 세 번 더 수행해야 합니다.

```
func changing_email_from_corporate_to_non_corporate()
func changing_email_without_changing_user_type()
func changing_email_to_the_same_one()
```

* 매개변수화된 테스트를 사용하여 여러 테스트 케이스를 그룹화하는 것이 효과적입니다.

```
final class CompanyTests: XCTestCase {
  func differentiates_a_corporate_email_from_non_corporate() {
    let cases: [(domain: String, email: String, expected: Bool)] = [
      ("mycorp.com", "email@mycorp.com", true),
      ("mycorp.com", "email@gmail.com", false)
    ]

    for (domain, email, expected) in cases {
      let sut = Company(domain, 0)
      let isEmailCorporate = sut.isEmailCorporate(email)
      XCTAssertEqual(expected, isEmailCorporate, "domain: \(domain), email: \(email)")
    }
  }
}
```

##### 7.3.2 나머지 세 가지 사분면의 코드 테스트

  * 복잡도가 낮고 협력자가 적은 코드는
`User` 및 `Company`의 생성자들이 대표적이며, 예를 들어 다음과 같습니다.

```
class User
  private(set) var userId: Int
  private(set) var email: String
  private(set) var type: UserType

  init(userId: Int, email: String, type: UserType) {
    self.userId = userId
    self.email = email
    self.type = type
  }
}
```
  * 생성자들은 테스트할 가치가 없으며, 생성된 테스트는
회귀에 대한 충분한 보호를 제공하지 못할 것입니다.

  * 지나치게 복잡한 코드는 리팩토링으로 제거되었으므로 테스트할 것이 없습니다.

##### 7.3.3 선결 조건을 테스트해야 하는가?

  * 특별한 종류의 분기점인 전제 조건을 살펴보고 이를 테스트해야 하는지 알아봅시다.

  * 예를 들어, `Company`의 이 메서드를 다시 한번 살펴보겠습니다

```
func changeNumberOfEmployees(_ delta: Int) {
  precondition(numberOfEmployees + delta >= 0)
  numberOfEmployees += delta
}
```
  * 이 조건은 회사 직원 수가 절대 음수가 되어서는 안 된다는 전제 조건을 명시합니다.

  * 이러한 예외적인 경우는 대개 버그로 인해 발생합니다. 

  * 직원 수가 0 미만으로 떨어질 수 있는 유일한 가능성은 코드에 오류가 있을 때입니다.

  * 이 안전 장치는 소프트웨어가 빠르게 실패하도록 하고, 오류가 확산되어
데이터베이스에 영구적으로 저장되는 것을 방지하는 메커니즘을 제공합니다.

  * 권장하는 일반적인 지침은 도메인 중요성이 있는 모든 전제 조건을 테스트하는 것입니다. 

  * 이는 클래스의 불변식(invariants)의 일부이기 때문입니다.

  * 그러나 도메인 상의 의미가 없는 전제조건을 테스트하는 데 시간을 낭비하지 마십시오. 

  * 예를 들어, `UserFactory`의 `Create` 메서드에는 다음과 같은 안전 장치가 있습니다:

```
extension User {
  static func create(_ data: [Any]) -> User {
    precondition(data.count >= 3, "data must contain at least id, email, and type")
}
```

### 7.4 컨트롤러의 조건부 로직 처리

* 도메인 계층을 외부 프로세스 협력자로부터 자유롭게 유지하면서 컨트롤러의 조건부 로직을 처리하는 것은 트레이드오프가 따릅니다.
* 비즈니스 로직과 오케스트레이션의 분리는 비즈니스 운영이 세 가지 개별 단계를 가질 때 가장 효과적으로 작동합니다.

  - 저장소에서 데이터 가져오기
  - 비즈니스 로직 실행
  - 데이터를 스토리지에 다시 저장

* 하지만 비즈니스 로직 중간에 추가 데이터 쿼리가 필요할 때 세 가지 처리 옵션이 있습니다.

  - 모든 외부 읽기/쓰기를 가장자리로 밀어넣기
    + 읽기-결정-실행 구조를 유지하지만 성능을 희생합니다.
    + 컨트롤러 단순성을 유지하고 도메인 모델을 프로세스 외부 의존성으로부터 격리시킵니다.
    + 컨트롤러는
필요하지 않은 경우에도 프로세스 외부 종속성을 호출할 것입니다.
  - 도메인 모델에 외부 프로세스 종속성을 주입
    + 비즈니스 로직이 해당 종속성을 호출할 시점을 직접 결정할 수 있도록 허용합니다.
    + 성능과 컨트롤러 단순성은 유지하지만 도메인 모델 테스트 가능성을 저해합니다.
  - 의사 결정 프로세스를 더 세분화된 단계로 분할
    + 컨트롤러는 각 단계마다 개별적으로 동작합니다.
    + 성능과 도메인 모델 테스트 가능성 모두에 도움이 되지만 컨트롤러 단순성을 희생합니다.

* 다음 세 가지 속성의 균형을 맞추는 것이 과제입니다
  - 도메인 모델의 테스트 가능성
    + 도메인 클래스 내 협업자의 수와 유형에 따라 달라짐
  - 컨트롤러의 단순성
    + 컨트롤러 내 의사결정(분기) 지점의 유무에 따라 달라짐
  - 성능
    + 외부 프로세스 종속성에 대한 호출 횟수로 정의됨

@Row {
  @Column {
    @Image(source: 7-9.png)  
  }
  @Column
}

* 대부분의 프로젝트에서 세 번째 옵션(의사 결정 프로세스 분할)이 가장 현실적인 절충안입니다. 

##### 7.4.1 CanExecute/Execute 패턴 사용

  * 컨트롤러의 복잡성 증가를 완화하는 첫 번째 방법은 CanExecute/Execute 패턴을 사용하는 것입니다. 

  * 이는 도메인 모델에서 컨트롤러로 비즈니스 로직이 유출되는 것을 방지합니다.

```
class User {
  private(set) var userId: Int
  private(set) var email: String
  private(set) var type: UserType
  private(set) var type: UserType
  private(set) isEmailConfirmed: Bool // 추가된 프로퍼티
}
```

  * 예를 들어, 사용자가 이메일 확인 후에는 이메일을 변경할 수 없다는 요구사항이 추가될 경우 `User` 클래스에 `isEmailConfirmed` 속성을 추가합니다.

  * 이 확인 로직을 넣는 방법에는 두 가지 옵션이 있습니다.

```
func changeEmail(_ newEmail: String, company: Company) -> String {
  if isEmailConfirmed {
    return "Can't change a confirmed email"
  }
  /* the rest of the method */
}
```

  * 이 확인 로직을 `User.changeEmail()` 메서드에 넣으면 컨트롤러는 간단하지만, 이메일이 확인되어 변경할 수 없는 경우에도 `Company` 인스턴스를 무조건 데이터베이스에서 가져오므로 성능 저하가 발생합니다. 

```
func changeEmail(userId: Int, newEmail: String) -> String {
  let userData = database.getUserById(userId)
  let user = UserFactory.create(userData)
  let companyData = database.getCompany()
  let company = CompanyFactory.create(companyData)

  if let error = user.changeEmail(newEmail, company: company) {
    return error
  }

  database.saveCompany(company)
  database.saveUser(user)
  messageBus.sendEmailChangedMessage(userId: userId, newEmail: newEmail)
  return "OK"
}
```

  * 이 확인 로직을 `UserController`로 옮기면 성능은 유지되지만, 의사 결정 프로세스가 분할되어 도메인 모델의 캡슐화를 손상시킵니다.

```
func changeEmail(userId: Int, newEmail: String) -> String {
  let userData = database.getUserById(userId)
  let user = UserFactory.create(userData)

  if user.isEmailConfirmed {
    return "Can't change a confirmed email"
  }

  let companyData = database.getCompany()
  let company = CompanyFactory.create(companyData)

  user.changeEmail(newEmail, company: company)

  database.saveCompany(company)
  database.saveUser(user)
  messageBus.sendEmailChangedMessage(userId: userId, newEmail: newEmail)
  return "OK"
}
```

  * 이러한 단편화를 방지하기 위해 `User` 클래스에 `canChangeEmail()` 메서드를 도입하고, 이 메서드의 성공적인 실행을 `changeEmail()`의 선행 조건으로 만듭니다. 

```
func canChangeEmail() -> String? {
  if isEmailConfirmed {
    return "Can't change a confirmed email"
  }
  return nil
}

func changeEmail(_ newEmail: String, company: Company) {
  precondition(canChangeEmail() == nil)
  /* the rest of the method */
}
```
  * 이 패턴은 두 가지 이점을 제공합니다:
    - 컨트롤러는 이메일 변경 과정에 대해 아무것도 알 필요가 없습니다. 
    - `changeEmail()` 메서드 내의 추가 선행 조건은 확인 없이 이메일이 변경되지 않도록 보장하여 도메인 계층에 모든 결정을 통합합니다.

  * 따라서 컨트롤러에 `if` 문이 남아있더라도 해당 `if` 문을 테스트할 필요가 없습니다. 
  
  * User 클래스 자체의 선행 조건을 단위 테스트하는 것으로 충분합니다.

##### 7.4.2 도메인 이벤트를 사용하여 도메인 모델의 변경 사항 추적

  * 때로는 도메인 모델이 현재 상태에 도달한 단계를 추론하기 어려울 때가 있습니다. 

  * 애플리케이션에서 어떤 일이 일어났는지 외부 시스템에 알려야 할 때 이러한 단계 정보를 아는 것이 중요할 수 있습니다. 
  
  * 이 책임을 컨트롤러에 두면 컨트롤러가 복잡해지므로, 이를 피하기 위해 도메인 이벤트를 사용하여 도메인 모델의 중요한 변경 사항을 추적하고, 비즈니스 작업 완료 후 이러한 변경 사항을 외부 프로세스 의존성 호출로 변환할 수 있습니다.

  * CRM 예시에서는, 이메일이 변경되지 않았는데도 메시지 버스에 메시지를 보내는 현재 알림 기능의 결함을 해결해야 합니다.


```
// User
func changeEmail(_ newEmail: String, company: Company) {
  precondition(canChangeEmail() == nil)
  if email == newEmail { return }
  /* the rest of the method */
}

// Controller
func changeEmail(userId: Int, newEmail: String) -> String {
  /* preparations */
  
  user.changeEmail(newEmail, company: company)

  database.saveCompany(company)
  database.saveUser(user)
  messageBus.sendEmailChangedMessage(userId: userId, newEmail: newEmail)
  return "OK"
}
```

  * 이메일 변경 여부 확인을 컨트롤러로 옮기면 비즈니스 로직 단편화 문제가 발생합니다.


  * 해결책은 `User` 클래스에 `emailChangedEvent`와 같은 도메인 이벤트를 도입하고, 이메일 변경 시 새로운 이벤트를 컬렉션에 추가하는 것입니다. 

```
func changeEmail(_ newEmail: String, company: Company) {
  precondition(canChangeEmail() == nil)

  if email == newEmail { return }

  let newType: UserType = company.isEmailCorporate(newEmail) ? .employee : .customer

  if type != newType {
    let delta = (newType == .employee) ? 1 : -1
    company.changeNumberOfEmployees(delta)
  }

  email = newEmail
  type = newType
  emailChangedEvents.append(EmailChangedEvent(userId: userId, newEmail: newEmail))
}
```
  
  * 이후 컨트롤러는 이러한 도메인 이벤트를 메시지 버스 호출로 변환합니다.

```
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
```

  * 이메일 변경과 관련된 `Company` 및 `User` 인스턴스는 조건 없이 데이터베이스에 계속 저장됩니다. 
  
  * 데이터베이스와의 통신은 구현 세부 정보이므로, 데이터베이스의 최종 상태가 정확하다면 애플리케이션이 데이터베이스에 몇 번을 호출하는지는 중요하지 않습니다. 

  * 반면에 메시지 버스와의 통신은 애플리케이션의 관찰 가능한 동작에 속하므로, 외부 시스템과의 계약을 유지하기 위해 이메일이 실제로 변경될 때만 메시지를 버스에 게시해야 합니다.

  * 도메인 이벤트를 사용하면 컨트롤러의 의사 결정 책임이 도메인 모델로 옮겨져 외부 시스템과의 통신에 대한 단위 테스트가 단순해집니다. 
    
  * 단위 테스트에서는 `User` 객체 내에서 도메인 이벤트 생성을 직접 테스트하고, 통합 테스트에서는 목을 사용하여 상호작용을 확인합니다.

```
final class UserTests: XCTestCase {
  func testChangingEmailFromCorporateToNonCorporate() {
    let company = Company(domain: "mycorp.com", numberOfEmployees: 1)
    let sut = User(id: 1, email: "user@mycorp.com", type: .employee, isEmailConfirmed: false)

    sut.changeEmail("new@gmail.com", company: company)

    XCTAssertEqual(company.numberOfEmployees, 0)
    XCTAssertEqual(sut.email, "new@gmail.com")
    XCTAssertEqual(sut.type, .customer)
    XCTAssertEqual(sut.emailChangedEvents, [EmailChangedEvent(userId: 1, newEmail: "new@gmail.com")])
  }
}
```

### 7.5 결론 (Conclusion)

  * 이 장의 주요 주제는 외부 시스템에 대한 부수 효과 적용을 추상화하는 것이었습니다.
  
  * 이러한 추상화는 비즈니스 작업이 끝날 때까지 부작용을 메모리에 유지하여, 외부 프로세스 의존성 개입 없이 일반 단위 테스트로 테스트할 수 있게 합니다. 
  
  * 도메인 이벤트는 메시지 버스의 향후 메시지에 대한 추상화이며, 도메인 클래스의 변경 사항은 데이터베이스의 향후 수정 사항에 대한 추상화입니다.
  
  * 추상화된 것을 테스트하는 것이 추상화 자체를 테스트하는 것보다 더 쉽습니다.

  * 도메인 이벤트와 CanExecute/Execute 패턴을 통해 모든 의사 결정 로직을 도메인 모델 내에 성공적으로 포함시켰지만, 항상 그렇게 할 수 있는 것은 아닙니다. 
    
  * 메일 고유성 검사나 외부 프로세스 의존성 실패가 비즈니스 작업의 흐름을 변경해야 하는 상황에서는 비즈니스 로직의 단편화가 불가피합니다.
    - 이러한 로직은 컨트롤러에 배치하고 통합 테스트로 커버해야 합니다. 
    - 그럼에도 불구하고, 비즈니스 로직과 오케스트레이션을 분리하는 것은 단위 테스트 프로세스를 대폭 단순화하므로 매우 가치 있는 일입니다.

  * `UserController`의 `changeEmail()` 메서드와 메시지 버스 호출은 외부 클라이언트에게 관찰 가능한 동작입니다. 
  
  * 반면에 컨트롤러에서 `User`로의 호출은 외부 클라이언트에게 관찰 가능한 동작이 아닙니다. 
  
  * 외부 클라이언트는 최종 시스템 상태가 올바르고 메시지 버스 호출이 제대로 이루어지는 한 컨트롤러가 이메일 변경을 어떻게 구현하는지 신경 쓰지 않습니다.

  * 관찰 가능한 동작과 구현 세부 사항을 양파 껍질처럼 생각할 수 있습니다. 
    - 각 계층을 외부 계층의 관점에서 테스트하고, 해당 계층이 하위 계층과 어떻게 통신하는지는 무시해야 합니다. 
    - 이러한 계층을 하나씩 벗겨낼 때마다 관점이 전환되어, 이전에 구현 세부 사항이었던 것이 이제는 관찰 가능한 동작이 되고, 이를 새로운 테스트 세트로 커버하게 됩니다.
