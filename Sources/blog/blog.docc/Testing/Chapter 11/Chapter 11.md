# Chapter 11 유닛 테스팅 안티 패턴

## 요약

안티 패턴(Anti-pattern)이란 표면적으로는 적절해 보이지만 결국 문제를 야기하는 흔한 해결책을 의미합니다. 

이 장에서는 주로 유닛 테스트의 네 가지 주요 속성(회귀 방지, 리팩토링 저항성, 빠른 피드백, 유지보수성)을 기반으로 여러 안티 패턴을 분석합니다.

### 11.1 프라이빗 메서드 유닛 테스트

프라이빗 메서드를 유닛 테스트하는 것은 안티 패턴입니다.

하지만 이 주제에는 꽤 많은 뉘앙스가 있습니다.

##### 11.1.1 프라이빗 메서드와 테스트 취약성

프라이빗 메서드는 **구현 세부 사항(implementation details)** 을 대리합니다. 

테스트가 구현 세부 정보에 결합되면
* 테스트가 코드에 단단히 결합되어 리팩토링 저항성을 잃게 됩니다.
* 테스트는 **취약한 테스트(brittle tests)** 가 되어, 기능 변경 없이 코드만 정리해도 **거짓 양성(false positives)** 을 발생시킵니다.
* 따라서 프라이빗 메서드는 직접 테스트하지 않고, 공개 API를 통해 간접적으로 **관찰 가능한 동작(observable behavior)** 의 일부로 테스트해야 합니다.


##### 11.1.2 프라이빗 메서드와 불충분한 커버리지

프라이빗 메서드가 너무 복잡하여 공개 API를 통한 테스트만으로는 충분한 커버리지를 제공할 수 없는 경우, 이는 다음 두 가지 중 하나를 의미합니다.

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

##### 11.1.3 프라이빗 메서드 테스트가 허용되는 경우

매우 드물지만, 프라이빗 메서드가 클래스의 **관찰 가능한 동작(observable behavior)** 의 일부를 구성하는 경우가 있습니다.

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

그 ORM은 공공 건설자가 필요하지 않습니다.

개인 건설자와 함께 작동할 수도 있습니다. 동시에, 우리 시스템도 생성자가 필요하지 않습니다. 왜냐하면 그러한 문의의 생성에 대한 책임이 없기 때문입니다. 대상체를 인스턴스화할 수 없는 경우 Inquiry 클래스를 어떻게 테스트합니까? 한편으로, 승인 논리는 분명히 중요하므로 단위 테스트를 거쳐야 합니다. 그러나 다른 한 가지로, 생성자를 공개하는 것은 사적인 방법을 노출하지 않는 규칙을 위반할 것이다. Inquiry의 생성자는 비공개이자 관찰 가능한 동작의 일부인 방법의 예입니다. 이 생성자는 ORM과의 계약을 이행하며, 그것이 비공개라는 사실이 그 계약을 덜 중요하게 만들지는 않습니다: ORM은 그것 없이는 데이터베이스에서 문의를 복원할 수 없습니다. 따라서 Inquiry의 생성자를 공개하는 것은 이 특별한 경우에 테스트 취성으로 이어지지 않습니다.

클라이언트와 클래스 간의 **비공개 계약(non-public contract)** 을 구현하는 메서드일 때입니다.

이 경우, 해당 생성자를 공개로 만들거나, **리플렉션(reflection)** 을 사용하여 테스트에서 인스턴스를 생성할 수 있습니다.
