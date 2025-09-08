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

##### 7.2.1 고객 관리 시스템 소개

* 사용자 이메일 변경 기능에 대한 3가지 비즈니스 규칙이 있는 CRM 시스템을 예시로 제시합니다.
  - 사용자의 이메일이 회사의 도메인에 속하는 경우 해당 사용자는 직원으로 표시됩니다. 그렇지 않으면 고객으로 취급됩니다.
  - 시스템은 회사의 직원 수를 추적해야 합니다. 사용자 유형이 직원에서 고객으로 변경되거나 그 반대로 변경되는 경우 이 숫자도 변경되어야 합니다. 
  - 이메일이 변경되면 시스템은 메시지 버스에 메시지를 보내 외부 시스템에 알려야 합니다.

```
public class User
{
  public int UserId { get; private set; }
  public string Email { get; private set; }
  public UserType Type { get; private set; }

  public void ChangeEmail(int userId, string newEmail)
  {
    object[] data = Database.GetUserById(userId);
    UserId = userId;
    Email = (string)data[1];
    Type = (UserType)data[2];

    if (Email == newEmail)
      return;

    object[] companyData = Database.GetCompany();
    string companyDomainName = (string)companyData[0];
    int numberOfEmployees = (int)companyData[1];

    string emailDomain = newEmail.Split('@')[1];
    bool isEmailCorporate = emailDomain == companyDomainName;
    UserType newType = isEmailCorporate
      ? UserType.Employee
      : UserType.Customer;

    if (Type != newType)
    {
      int delta = newType == UserType.Employee ? 1 : -1;
      int newNumber = numberOfEmployees + delta;
      Database.SaveCompany(newNumber);
    }

    Email = newEmail;
    Type = newType;

    Database.SaveUser(this);
    MessageBus.SendEmailChangedMessage(UserId, newEmail);
  }
}

public enum UserType
{
  Customer = 1,
  Employee = 2
}
```

* `User` 클래스는 사용자 이메일을 변경합니다. 

* 코드 유형 다이어그램의 관점에서 이 구현을 분석해 봅시다. 
  - 코드의 복잡성은 그리 높지 않습니다. 
    + `ChangeEmail` 메서드에는 `User`를 `Employee` 또는 `Customer`로 식별할지 여부와 `Company`의 `numberOfEmployees`를 업데이트하는 방법이라는 몇 가지 명시적인 의사 결정 사항만 포함되어 있습니다. 
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

* 이는 Active Record 패턴의 예시이며, 간단한 프로젝트에는 적합하지만 테스트하기 어렵고 확장성이 떨어집니다.


문제점: 도메인 모델이 아웃-오브-프로세스 의존성에 직접 또는 간접적으로 의존하면 테스트 비용이 많이 들고 테스트 취약성(fragility)을 유발할 수 있습니다.

##### 7.2.2 암시적 의존성을 명시적으로 만들기

* 테스트 가능성을 개선하기 위한 일반적인 접근 방식은 암시적 종속성을 명시적으로 만드는 것입니다.

* 즉, 데이터베이스와 메시지 버스에 대한 인터페이스를 도입하고, 해당 인터페이스를 사용자에게 삽입한 다음 테스트에서 목을 사용하는 것입니다.

* 하지만 코드 유형 다이어그램의 관점에서 볼 때, 도메인 모델이 프로세스 외 종속성을 직접 참조하는지 아니면 인터페이스를 통해 참조하는지 여부는 중요하지 않습니다.

* 이러한 의존성은 아직 처리되지 않은 상태입니다.

* 그러한 클래스를 테스트하기 위해서는 여전히 복잡한 목 체계를 유지해야 하며, 이는 테스트의 유지 보수 비용을 증가시킵니다. 

* 전반적으로, 도메인 모델이 직접 또는 간접적으로 (인터페이스를 통해) 외부 프로세스 협력자에 전혀 의존하지 않는 것이 훨씬 더 깨끗합니다.

##### 7.2.3 애플리케이션 서비스 계층 도입


* 도메인 모델이 외부 시스템과 직접 통신하는 책임을 `UserController`라는 애플리케이션 서비스(험블 컨트롤러)로 옮깁니다.

* 도메인 클래스는 다른 도메인 클래스 또는 순수 값과 같은 프로세스 내 종속성에만 의존해야 합니다. 

```
public class UserController
{
  private readonly Database _database = new Database();
  private readonly MessageBus _messageBus = new MessageBus();
  
  public void ChangeEmail(int userId, string newEmail)
  {
    object[] data = _database.GetUserById(userId);
    string email = (string)data[1];
    UserType type = (UserType)data[2];
    var user = new User(userId, email, type);

    object[] companyData = _database.GetCompany();
    string companyDomainName = (string)companyData[0];
    int numberOfEmployees = (int)companyData[1];
    int newNumberOfEmployees = user.ChangeEmail(
      newEmail, companyDomainName, numberOfEmployees);
    
    _database.SaveCompany(newNumberOfEmployees);
    _database.SaveUser(user);
    _messageBus.SendEmailChangedMessage(userId, newEmail);
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
public int ChangeEmail(string newEmail,
  string companyDomainName, int numberOfEmployees)
{
  if (Email == newEmail)
    return numberOfEmployees;
  
  string emailDomain = newEmail.Split('@')[1];
  bool isEmailCorporate = emailDomain == companyDomainName;
  UserType newType = isEmailCorporate
    ? UserType.Employee
    : UserType.Customer;

  if (Type != newType)
  {
    int delta = newType == UserType.Employee ? 1 : -1;
    int newNumber = numberOfEmployees + delta;
    numberOfEmployees = newNumber;
  }

  Email = newEmail;
  Type = newType;
  return numberOfEmployees;
}
```
* 결과적으로 `User` 클래스는 협력자가 없어 테스트하기 훨씬 쉬워지며, 코드 유형 다이어그램의 "도메인 모델" 사분면으로 이동합니다. 

* 하지만 `UserController`는 여전히 복잡한 데이터 재구성 로직을 포함하여 "지나치게 복잡한 코드" 영역에 가깝습니다.

@Row {
  @Column {
    @Image(source: 7-7.png)  
  }
  @Column {}
}

##### 7.2.4 애플리케이션 서비스에서 복잡성 제거
    ◦ 목표: UserController의 재구성 로직 복잡성을 제거하여 "컨트롤러" 사분면에 확고히 배치하는 것입니다.
    ◦ 해결책: 재구성 로직을 UserFactory와 같은 별도의 클래스로 추출합니다. 이 팩토리는 object[] 데이터를 받아 User 객체를 생성하며 Precondition.Requires를 사용한 유효성 검사를 포함할 수 있습니다. 이 재구성 로직은 복잡하지만 도메인 중요성이 낮아 유틸리티 코드의 예시입니다.

##### 7.2.5 새로운 Company 클래스 도입
    ◦ 문제점: User 클래스가 회사 직원 수 업데이트 같은 회사 관련 책임을 가지는 것은 잘못된 것입니다.
    ◦ 해결책: Company라는 새로운 도메인 클래스를 도입하여 회사 관련 로직과 데이터를 캡슐화합니다. 이 클래스는 "묻지 말고 시켜라 (tell-don't-ask)" 원칙을 따릅니다.
    ◦ CompanyFactory도 도입되어 Company 객체 재구성을 담당합니다.
    ◦ UserController와 User 클래스는 Company 인스턴스를 통해 작업을 위임하도록 변경됩니다.
    ◦ 최종 결과: User, Company, UserFactory, CompanyFactory는 모두 "도메인 모델 및 알고리즘" 사분면에 위치하며, UserController는 "컨트롤러" 사분면에 확고히 자리 잡습니다.
    ◦ 이점: 모든 부수 효과(이메일 변경, 직원 수 변경)가 도메인 모델 내에만 존재하고, 컨트롤러가 데이터베이스에 저장할 때만 도메인 모델 경계를 넘으므로 테스트 용이성이 크게 향상됩니다.

### 7.3 최적의 단위 테스트 커버리지 분석
리팩토링 후 코드 유형 분류표를 기반으로 테스트 방법을 분석합니다.

##### 7.3.1 도메인 계층 및 유틸리티 코드 테스트
    ◦ "도메인 모델 및 알고리즘" 사분면의 코드 테스트가 비용-이점 측면에서 최고의 결과를 제공합니다. 높은 복잡성/도메인 중요성으로 회귀 방어 효과가 크고, 적은 협력자로 유지보수 비용이 낮습니다.
    ◦ 매개변수화된 테스트를 사용하여 여러 테스트 케이스를 그룹화하는 것이 효과적입니다.

##### 7.3.2 나머지 세 가지 사분면의 코드 테스트

    ◦ 낮은 복잡성과 적은 협력자를 가진 코드는 테스트할 가치가 없으며, 지나치게 복잡한 코드는 리팩토링으로 제거되었으므로 테스트할 것이 없습니다. 컨트롤러 테스트는 다음 챕터에서 다룹니다.

##### 7.3.3 선결 조건을 테스트해야 하는가?
    ◦ 일반 가이드라인: 도메인 중요성이 있는 모든 선결 조건은 테스트해야 합니다. 이는 클래스의 불변식(invariants)의 일부이기 때문입니다.
    ◦ 테스트하지 않는 경우: 도메인 중요성이 없는 선결 조건은 테스트할 필요가 없습니다.

### 7.4 컨트롤러의 조건부 로직 처리
도메인 계층을 아웃-오브-프로세스 협력자로부터 자유롭게 유지하면서 컨트롤러의 조건부 로직을 처리하는 것은 트레이드오프가 따릅니다.
• 비즈니스 작업은 일반적으로 데이터 검색 -> 비즈니스 로직 실행 -> 데이터 유지의 세 단계로 잘 작동합니다.
• 하지만 비즈니스 로직 중간에 추가 데이터 쿼리가 필요할 때 세 가지 처리 옵션이 있습니다:
    1. 모든 외부 읽기/쓰기를 가장자리로 밀어넣기: 컨트롤러 단순성 및 도메인 모델 테스트 용이성 유지, 성능 희생. (불필요한 DB 호출이 많아짐)
    2. 아웃-오브-프로세스 의존성을 도메인 모델에 주입: 성능 및 컨트롤러 단순성 유지, 도메인 모델 테스트 용이성 손상. (도메인 모델이 "지나치게 복잡한 코드"가 됨)
    3. 의사 결정 프로세스를 더 세분화된 단계로 분할: 성능 및 도메인 모델 테스트 용이성 유지, 컨트롤러 단순성 희생. (컨트롤러에 의사 결정 지점이 도입되어 복잡성 증가)
• 권장 사항: 대부분의 프로젝트에서 **세 번째 옵션(의사 결정 프로세스 분할)**이 가장 현실적인 절충안입니다. 이로 인해 컨트롤러가 더 복잡해질 수 있지만 관리 가능합니다.

##### 7.4.1 CanExecute/Execute 패턴 사용
    ◦ 컨트롤러 복잡성 증가를 완화하는 방법 중 하나입니다.
    ◦ 패턴: User 클래스에 CanChangeEmail() 메서드를 도입하여 이메일 변경이 가능한지 여부를 확인하고, 실제 변경 로직인 ChangeEmail() 메서드의 선결 조건으로 CanChangeEmail() == null을 설정합니다.
    ◦ 이점:
        ▪ 컨트롤러는 이메일 변경 과정에 대한 복잡한 지식 없이 CanChangeEmail()만 호출하여 작업 가능 여부를 확인합니다.
        ▪ ChangeEmail()의 선결 조건은 확인 없이 이메일이 변경되는 것을 방지합니다.
    ◦ 결과: 모든 의사 결정이 도메인 계층으로 통합되어 컨트롤러의 의사 결정 지점이 사실상 제거됩니다.

##### 7.4.2 도메인 이벤트를 사용하여 도메인 모델의 변경 사항 추적
    ◦ 도메인 모델의 중요한 변경 사항을 추적하고, 이를 비즈니스 작업 완료 후 외부 시스템 호출로 전환해야 할 때 도메인 이벤트를 사용합니다.
    ◦ 적용: User 클래스 내에서 이메일이 변경될 때 EmailChangedEvent를 추가합니다.
    ◦ 컨트롤러 처리: EventDispatcher와 같은 클래스가 이 도메인 이벤트를 외부 시스템(예: 메시지 버스, 로거) 호출로 변환합니다.
    ◦ 데이터베이스 vs. 메시지 버스: 데이터베이스와의 통신은 CRM의 "구현 세부 정보"로 간주되어 무조건 영속화될 수 있지만, 메시지 버스와의 통신은 "관찰 가능한 동작"이므로 이메일 변경 시에만 메시지를 보내야 합니다.
    ◦ 이점: 도메인 이벤트는 컨트롤러의 의사 결정 책임을 도메인 모델로 옮겨 외부 시스템과의 통신 단위 테스트를 단순화합니다. 단위 테스트에서는 도메인 이벤트 생성을 직접 테스트할 수 있습니다.

### 7.5 결론 (Conclusion)
• 핵심 주제: 외부 시스템에 대한 부수 효과 적용을 추상화하는 것입니다. 도메인 이벤트는 메시지 버스 메시지에 대한 추상화이며, 도메인 클래스의 변경은 데이터베이스 수정에 대한 추상화입니다.
• 이점: 추상화는 추상화되는 것보다 테스트하기 쉽습니다.
• 한계: 모든 비즈니스 로직을 도메인 모델에 완벽하게 포함시키는 것은 불가능하며 (예: 이메일 고유성 검증, 외부 의존성 실패 처리), 일부 로직은 컨트롤러에 남아 통합 테스트로 커버해야 합니다.
• 협력자: 도메인 클래스에서 모든 협력자를 제거하는 것은 항상 필요하지 않습니다. 아웃-오브-프로세스 의존성을 참조하지 않는 한 소수의 협력자는 문제가 되지 않습니다.
• 목(Mock) 사용 주의: 도메인 모델의 관찰 가능한 동작과 관련 없는 내부 협력자(동일 비즈니스 로직 내 다른 도메인 클래스)와의 상호 작용은 구현 세부 정보이므로 목으로 검증해서는 안 됩니다.
• 관찰 가능한 동작 대 구현 세부 정보: 코드 구성 요소를 양파 껍질처럼 바라보며, 각 계층을 외부 계층의 관점에서 테스트하고 하위 계층과의 통신 방식은 무시해야 합니다. 즉, 이전 계층에서는 구현 세부 정보였던 것이 다음 계층에서는 관찰 가능한 동작이 될 수 있습니다.
