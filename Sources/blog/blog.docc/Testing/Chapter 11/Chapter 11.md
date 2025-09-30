# Chapter 11 유닛 테스팅 안티 패턴

## 요약

안티 패턴(Anti-pattern)이란 표면적으로는 적절해 보이지만 결국 문제를 야기하는 흔한 해결책을 의미합니다. 

이 장에서는 주로 유닛 테스트의 네 가지 주요 속성(회귀 방지, 리팩토링 저항성, 빠른 피드백, 유지보수성)을 기반으로 여러 안티 패턴을 분석합니다.

### 11.1 비공개 메서드 유닛 테스트

비공개 메서드를 유닛 테스트하는 것은 안티 패턴입니다.

하지만 이 주제에는 꽤 많은 뉘앙스가 있습니다.

##### 11.1.1 비공개 메서드와 테스트 취약성

비공개 메서드는 **구현 세부 사항(implementation details)** 을 대리합니다. 

테스트가 구현 세부 정보에 결합되면
* 테스트가 코드에 단단히 결합되어 리팩토링 저항성을 잃게 됩니다.
* 테스트는 **취약한 테스트(brittle tests)** 가 되어, 기능 변경 없이 코드만 정리해도 **거짓 양성(false positives)** 을 발생시킵니다.
* 따라서 비공개 메서드는 직접 테스트하지 않고, 공개 API를 통해 간접적으로 **관찰 가능한 동작(observable behavior)** 의 일부로 테스트해야 합니다.


##### 11.1.2 비공개 메서드와 불충분한 커버리지

비공개 메서드가 너무 복잡하여 공개 API를 통한 테스트만으로는 충분한 커버리지를 제공할 수 없는 경우, 이는 다음 두 가지 중 하나를 의미합니다.

* 데드 코드 (Dead code)
  - 리팩토링 후 남겨진 불필요한 코드이므로, 삭제해야 합니다.
* 누락된 추상화 (Missing abstraction)
  - 복잡한 로직을 별도의 클래스로 **추출(extract)** 해야 함을 의미합니다.

예를 들어 두 번째 문제를 설명해 보겠습니다.

```
final class Order {
  private var customer: Customer
  private var products: [Product]

  init(customer: Customer, products: [Product]) {
    self.customer = customer
    self.products = products
  }

  func generateDescription() -> String {
    return "Customer name: \(customer.name), total number of products: \(products.count), total price: \(getPrice())"
  }

  private func getPrice() -> Decimal {
    // Calculate based on products
    let basePrice: Decimal = /* Calculate based on products */ 0
    // Calculate based on customer
    let discounts: Decimal = /* Calculate based on customer */ 0
    // Calculate based on products
    let taxes: Decimal = /* Calculate based on products */ 0
    return basePrice - discounts + taxes
  }
}
```

`generateDescription()` 메서드는 매우 간단하게 `Order`에 대한 일반적인 설명을 반환합니다. 

그러나 그것은 훨씬 더 복잡한 개인 `getPrice()` 메서드를 사용합니다.

중요한 비즈니스 로직을 포함하고 있으며 철저히 테스트해야 합니다. 

```
final class Order {
  private var customer: Customer
  private var products: [Product]

  init(customer: Customer, products: [Product]) {
    self.customer = customer
    self.products = products
  }

  func generateDescription() -> String {
    let calc = PriceCalculator()
    return "Customer name: \(customer.name), total number of products: \(products.count), total price: \(calc.calculate(customer: customer, products: products))"
  }
}

final class PriceCalculator {
  func calculate(customer: Customer, products: [Product]) -> Decimal {
    // Calculate based on products
    let basePrice: Decimal = /* Calculate based on products */ 0
    // Calculate based on customer
    let discounts: Decimal = /* Calculate based on customer */ 0
    // Calculate based on products
    let taxes: Decimal = /* Calculate based on products */ 0
    return basePrice - discounts + taxes
  }
}
```

이제 `Order`와 독립적으로 `PriceCalculator`를 테스트할 수 있습니다.

##### 11.1.3 비공개 메서드 테스트가 허용되는 경우

매우 드물지만, 비공개 메서드가 클래스의 **관찰 가능한 동작(observable behavior)** 의 일부를 구성하는 경우가 있습니다.

신용 조회를 관리하는 시스템을 예로 들어보겠습니다. 

새로운 문의는 하루에 한 번 데이터베이스에 직접 대량으로 로드됩니다. 

그런 다음 관리자는 이러한 문의를 하나씩 검토하고 승인 여부를 결정합니다. 

해당 시스템에서 `Inquiry`의 모습은 다음과 같습니다.

```
final class Inquiry {
  private(set) var isApproved: Bool
  private(set) var timeApproved: Date?

  private init(isApproved: Bool, timeApproved: Date?) {
    if isApproved && timeApproved == nil {
      fatalError("Invalid state: approved but no approval time")
    }
    self.isApproved = isApproved
    self.timeApproved = timeApproved
  }

  func approve(now: Date) {
    if isApproved { return }
    isApproved = true
    timeApproved = now
  }
}
```

클래스가 객체 관계형 매핑(ORM) 라이브러리에 의해 데이터베이스에서 복원되기 때문에 생성자는 비공개입니다. 

이 경우, 해당 생성자를 공개로 만들거나, **리플렉션(reflection)** 을 사용하여 테스트에서 인스턴스를 생성할 수 있습니다.

### 11.2 비공개 상태 노출

또 다른 흔한 안티패턴은 유닛 테스트만을 목적으로 사적 상태를 노출하는 것입니다. 

다음 코드 예시를 살펴보겠습니다.

```
import Foundation

public final class Customer {
  private let status: CustomerStatus = .regular

  public func promote() {
    status = .preferred
  }

  public getDiscount() -> Decimal {
    return status == .preferred ? Decimal(0.05) : Decimal(0)
  }
}

public enum CustomerStatus {
  case regular, preferred
}
```

이 예제는 `Customer` 클래스를 보여줍니다. 

각 고객은 `regular` 상태로 생성되며, 이후 `preferred` 상태로 승격될 수 있습니다.

이 시점에서 고객은 모든 상품에 대해 5% 할인을 받게 됩니다.

`promote()` 메서드를 어떻게 테스트할까요? 이 메서드의 부수 효과는 `status` 필드의 변경이지만, 해당 필드 자체는 `private`이므로 테스트에서 접근할 수 없습니다.

이 필드를 `public`으로 만드는 것이 유혹적인 해결책일 수 있습니다.

그러나 이는 안티패턴입니다. 

테스트는 프로덕션 코드와 정확히 동일한 방식으로 시스템과 상호작용해야 하며, 테스트에 특별한 권한이 있어서는 안 됩니다.

테스트 대상 시스템(SUT)의 비공개 상태(private state)를 노출하면, 테스트가 **구현 세부 사항(implementation details)** 에 결합되어 **리팩토링 저항성(resistance to refactoring)** 이라는 가장 중요한 지표를 손상시킵니다.

비공개 상태를 직접 확인하는 대신, 프로덕션 코드가 관심을 가지는 **관찰 가능한 행동(observable behavior)** 을 확인해야 합니다. 

* 새로 생성된 고객에게는 할인이 적용되지 않습니다.
* 고객이 승격되면 할인이 5%로 적용됩니다.

> 테스트 가능성을 이유로 클래스의 공용 API 표면을 확대하는 것은 나쁜 관행입니다.

### 11.3 테스트에 도메인 지식 유출

테스트에 도메인 지식을 유출하는 것도 매우 흔한 안티패턴입니다.

이는 주로 복잡한 알고리즘을 테스트할 때 발생합니다.

```
final class Calculator {
  static func add(value1: Int, value2: Int) {
    return value1 + value2
  }
}
```

다음은 이를 잘못된 방식으로 테스트 하는 예시 입니다.

```
final class CalculatorTests: XCTestCase {
  func addingTwoNumbers() {
    let value1 = 1
    let value2 = 3
    let expected = value1 + value2
    let actual = Calculator.add(value1, value2)
    XCTAssertEqual(expected, actual)
  }
}
```

테스트를 매개변수화하여 몇 가지 테스트 케이스를 더 포함시킬 수도 있습니다.

```
final class CalculatorTests: XCTestCase {
  func testAddingTwoNumbers() {
    let testCases = [
      (1, 3),
      (11, 33),
      (100, 500)
    ]
    for (value1, value2) in testCases {
      let expected = value1 + value2
      let actual = Calculator.add(value1, value2)
        XCTAssertEqual(expected, actual, "Failed for values: \(value1), \(value2)")
    }
  }
}
```

처음 보기엔 괜찮아 보이지만, 사실은 안티패턴의 사례입니다.

이 테스트들은 실제 코드의 알고리즘 구현을 그대로 복제하고 있습니다.

이러한 테스트는 구현 세부사항에 대한 결합도의 또 다른 예시입니다.

테스트가 알고리즘의 로직을 복제하여 예상 결과(expected 값)를 계산하면, 실제 알고리즘에 버그가 생기거나 리팩토링될 때 테스트가 잘못된 경보를 발생시킵니다.

대신, 알고리즘의 결과를 하드코딩하여 테스트해야 합니다. 

이 하드코딩된 예상 결과는 테스트 대상 시스템(SUT)이 아닌 다른 수단 (이상적으로는 도메인 전문가의 도움)을 통해 미리 계산되어야 합니다. 

테스트는 프로덕션 코드를 블랙박스 관점에서 검증해야 합니다.

```
final class CalculatorTests: XCTestCase {
  func testAddingTwoNumbers() {
    let testCases = [
      (1, 3, 4),
      (11, 33, 44),
      (100, 500, 600)
    ]
    for (value1, value2, expected) in testCases {
      let actual = Calculator.add(value1, value2)
        XCTAssertEqual(expected, actual, "Failed for values: \(value1), \(value2)")
    }
  }
}
```

### 11.4 코드 오염 

다음 안티패턴은 코드 오염입니다.

> 정의: 코드 오염(code pollution)은 오직 테스트에만 필요한 프로덕션 코드를 추가하는 행위를 말합니다.

코드 오염은 종종 다양한 유형의 스위치 형태로 나타납니다. 로거를 예로 들어 보겠습니다.

```
final class Logger {
  private let isTestEnvironment: Bool

  init(isTestEnvironment: Bool) {
    self.isTestEnvironment = isTestEnvironment
  }

  func log(_ text: String) {
    if isTestEnvironment { return }
    // Log the text
  }
}

final class Controller {
  func someMethod(logger: Logger) {
    logger.log("SomeMethod is called")
  }
}
```
이 예제에서 `Logger`는 해당 클래스가 프로덕션 환경에서 실행되는지 여부를 나타내는 생성자 매개변수를 가집니다.

```
func testSomeMethod() {
  let logger = Logger(isTestEnvironment: true)
  let sut = Controller()
  sut.someMethod(logger: logger)
  /* assert */
}
```

코드 오염의 문제는 테스트 코드와 프로덕션 코드를 혼합하여 후자의 유지보수 비용을 증가시킨다는 점입니다.

이를 해결하려면 먼저 프로덕션 코드에서 테스트 코드를 분리해야 합니다.

`Logger`와 같은 인터페이스를 도입하고, 프로덕션용 실제 구현과 테스트용 가짜 구현(`FakeLogger`)을 만들어 주입하는 방식을 사용해야 합니다.

```
protocol Logger {
  func log(_ text: String)
}

final class LoggerImpl: Logger {
  func log(_ text: String) {
    // 실제 로그 처리
  }
}

final class FakeLoggerImpl: Logger {
  private(set) var logs: [String] = []

  func log(_ text: String) {
    logs.append(text)
  }
}

final class Controller {
  func someMethod(logger: Logger) {
      logger.log("SomeMethod is called")
  }
}
```

### 11.5 구체적인 클래스 모킹

지금까지 이 책은 인터페이스를 사용한 모킹 예제를 보여줬지만, 다른 접근법도 있습니다.

구체적인 클래스를 대신 모킹하여 원본 클래스의 기능 일부를 보존할 수 있으며, 이는 때로 유용할 수 있습니다. 

하지만 이 대안에는 중대한 단점이 있습니다.

단일 책임 원칙을 위반한다는 점입니다.

```
final class StatisticsCalculator {
  func calculate(customerId: Int) -> (totalWeight: Double, totalCost: Double) {
    let records = getDeliveries(customerId: customerId)
    let totalWeight = records.reduce(0) { $0 + $1.weight }
    let totalCost = records.reduce(0) { $0 + $1.cost }
    return (totalWeight, totalCost)
  }

  func getDeliveries(customerId: Int) -> [DeliveryRecord] {
    // 외부 의존성 호출하여 배송 목록을 가져옴
  }
}
```

`StatisticsCalculator`는 고객 통계를 수집하고 계산합니다.

특정 고객에게 발송된 모든 배송의 무게와 비용입니다.

이 클래스는 외부 서비스(`getDeliveries` 메서드)에서 가져온 배송 목록을 기반으로 계산을 수행합니다.

다음과 같이 `StatisticsCalculator`를 사용하는 컨트롤러가 있다고 가정해 보겠습니다.

```
final class CustomerController {
  private let calculator: StatisticsCalculator

  init(calculator: StatisticsCalculator) {
    self.calculator = calculator
  }

  func getStatistics(customerId: Int) -> String {
    let (totalWeight, totalCost) = calculator.calculate(customerId: customerId)
    return "Total weight delivered: \(totalWeight). Total cost: \(totalCost)"
  }
}
```

이 컨트롤러를 어떻게 테스트할 수 있을까요? 

실제 `StatisticsCalculator` 인스턴스를 제공할 수 없습니다. 

해당 인스턴스는 관리되지 않는 외부 프로세스 종속성을 참조하기 때문입니다.

관리되지 않는 종속성은 스텁으로 대체해야 합니다.

동시에 이 클래스에는 중요한 계산 기능이 포함되어 있어 그대로 유지해야 합니다.

이 딜레마를 극복하는 한 가지 방법은 `StatisticsCalculator` 클래스를 모킹하고 `getDeliveries()` 메서드만 오버라이드하는 것입니다. 

이는 해당 메서드를 가상(virtual)으로 만들어 수행할 수 있습니다.

```
import XCTest

class StubStatisticsCalculator: StatisticsCalculator {
  override func getDeliveries(customerId: Int) -> [DeliveryRecord] {
    return []
  }
}

final class CustomerControllerTests: XCTestCase {
  func testCustomerWithNoDeliveries() {
    // Arrange
    let stub = StubStatisticsCalculator()
    let sut = CustomerController(calculator: stub)
    
    // Act
    let result = sut.getStatistics(customerId: 1)
    
    // Assert
    XCTAssertEqual(result, "Total weight delivered: 0. Total cost: 0")
  }
}
```

이 클래스는 도메인 로직(예: 통계 계산)과 관리되지 않는 의존성(unmanaged dependency)과의 통신(예: 외부 서비스 호출)이라는 두 가지 무관한 책임을 결합하고 있을 가능성이 높습니다.

`StatisticsCalculator`를 모킹하는 대신, 다음과 같이 이 클래스를 두 개로 분할하세요.

```
final class DeliveryGateway {
  func getDeliveries(customerId: Int) -> [DeliveryRecord] {
    // 외부 의존성 호출하여 배송 목록을 가져옴
    return []
  }
}

final class StatisticsCalculator {
  func calculate(records: [DeliveryRecord]) -> (totalWeight: Double, totalCost: Double) {
    let totalWeight = records.reduce(0) { $0 + $1.weight }
    let totalCost = records.reduce(0) { $0 + $1.cost }
    return (totalWeight, totalCost)
  }
}
```
```
final class CustomerController {
  private let calculator: StatisticsCalculator
  private let gateway: DeliveryGateway

  init(calculator: StatisticsCalculator, gateway: DeliveryGateway) {
    self.calculator = calculator
    self.gateway = gateway
  }

  func getStatistics(customerId: Int) -> String {
    let records = gateway.getDeliveries(customerId: customerId)
    let (totalWeight, totalCost) = calculator.calculate(records: records)
    return "Total weight delivered: \(totalWeight). Total cost: \(totalCost)"
  }
}
```

하나는 도메인 로직을 담당하고, 다른 하나는 관리되지 않는 의존성과의 통신(예: DeliveryGateway 인터페이스)을 담당해야 합니다. 

이는 Humble Object(겸손한 객체) 디자인 패턴의 예시이며, 테스트는 통신을 담당하는 게이트웨이를 모킹하고 도메인 로직은 독립적으로 테스트할 수 있습니다.

### 11.6 시간 작업

현재 날짜와 시간에 의존하는 기능(예: `Date()`)을 테스트하는 것은 **거짓 양성(false positives)** 을 유발할 수 있습니다.

행위 단계의 시간이 검증 단계와 동일하지 않을 수 있기 때문입니다. 

이 의존성을 안정화하기 위한 세 가지 옵션이 있습니다.

이 중 하나는 안티패턴이며, 나머지 두 가지 중 하나가 다른 하나보다 선호됩니다.

##### 11.6.1 주변 컨텍스트로서의 시간

첫 번째 옵션은 주변 컨텍스트 패턴을 사용하는 것입니다.

시간의 맥락에서 주변 컨텍스트는 다음 코드 예시에서 보여지듯, 프레임워크의 내장 `Date()` 대신 코드에서 사용할 사용자 정의 클래스가 될 것입니다.

```
final class DateTimeServer {
  static var now: () -> Date = { Date() }

  static func initWith(_ provider: @escaping () -> Date) {
    now = provider
  }
}
```

로거 기능과 마찬가지로 시간에 대한 주변 컨텍스트 사용 역시 안티패턴입니다.

주변 컨텍스트는 생산 코드를 오염시키고 테스트를 더 어렵게 만듭니다.

또한 정적 필드는 테스트 간 공유 의존성을 도입하여 해당 테스트들을 통합 테스트 영역으로 전환시킵니다.

#### 11.6.2 명시적 의존성으로서의 시간

더 나은 접근 방식은 시간 의존성을 명시적으로 주입하는 것입니다.

이는 서비스(`DateTimeServer`) 형태 또는 순수 값(plain value) 형태(예: `Date` 값)로 주입될 수 있습니다.

```
protocol DateTimeServer {
  var now: Date { get }
}

final class DateTimeServerImpl: DateTimeServer {
  var now: Date { Date() }
}

final class InquiryController {
  private let dateTimeServer: DateTimeServer

  init(dateTimeServer: DateTimeServer) {
    self.dateTimeServer = dateTimeServer
  }

  func approveInquiry(id: Int) {
    let inquiry = getById(id)
    inquiry.approve(now: dateTimeServer.now)
    saveInquiry(inquiry)
  }
}
```

일반적으로 순수 값으로 주입하는 것이 더 쉽고 테스트에서 스텁(stub) 처리하기 용이하므로 가능할 때마다 순수 값 주입을 선호해야 합니다.

### 11.7 결론

이 장에서는 가장 대표적인 실제 유닛 테스트 사용 사례를 살펴보고,
좋은 테스트의 네 가지 속성을 활용해 분석했습니다.

이 책의 모든 아이디어와 지침을 한꺼번에 적용하기 시작하는 것이 부담스러울 수 있다는 점을 이해합니다.

실제로 활용해보고 천천히 적용해 나가도록 합시다. 안녕!
