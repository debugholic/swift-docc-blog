# 3. 단위 테스트의 구조

## 요약

단위 테스트를 어떤 구조로 작성해야 하는지, 픽스처를 어떻게 재사용하고 테스트 이름을 어떻게 지어야 하는지 알아봅니다.

### 3.1 단위 테스트 구성하기

##### 3.1.1 AAA 패턴 사용하기

AAA 패턴은 모든 테스트를 세 구절로 나눕니다.

* **준비(Arrange)** — 테스트 대상 시스템(SUT)과 의존성을 원하는 상태로 만든다
* **행위(Act)** — SUT의 메서드를 호출한다
* **검증(Assert)** — 결과를 확인한다

```swift
func test_sum_of_two_numbers() {
  // 준비
  let first = 10.0
  let second = 20.0
  let sut = Calculator()

  // 행위
  let result = sut.sum(first, second)

  // 검증
  XCTAssertEqual(30.0, result)
}
```

* Given-When-Then 패턴도 같은 구조이며, 비개발자에게 설명하기에 더 자연스럽습니다.
* TDD로 작업할 때는 검증부터 쓰는 편이 자연스럽습니다. 확인하고 싶은 결과를 먼저 적으면 무엇을 준비해야 하는지가 따라옵니다.
* 반면 이미 동작하는 코드를 테스트할 때는 준비부터 쓰는 편이 낫습니다.

##### 3.1.2 여러 개의 준비, 행위, 검증 구절 피하기

* 구절이 여러 번 반복된다면 그것은 하나가 아니라 **여러 개의 테스트** 입니다.
* 각각을 별도의 테스트로 분리해야 합니다.
* 여러 단계를 한 테스트에 담아야 할 만큼 준비 비용이 크다면, 그것은 단위 테스트가 아니라 통합 테스트의 신호입니다.
  - 통합 테스트에서는 속도 때문에 여러 단계를 묶는 것이 정당화되기도 합니다.

##### 3.1.3 테스트 내 if 문 피하기

* 단위 테스트든 통합 테스트든 `if` 문은 안티 패턴입니다.
* 분기가 있다는 것은 한 테스트가 여러 가지를 한꺼번에 검증한다는 뜻입니다.
* 또한 테스트 코드 자체가 복잡해져 읽기 어려워지고, 테스트에 버그가 생길 여지가 커집니다.

> 테스트는 분기 없는 **단순한 사실의 나열** 이어야 합니다.

##### 3.1.4 각 구절의 크기

* **준비 구절이 가장 큽니다.** 행위와 검증을 합친 것보다 클 수 있습니다.
  - 너무 커지면 별도의 팩토리 메서드나 헬퍼로 추출합니다.

* **행위 구절은 보통 한 줄이어야 합니다.**
  - 행위가 두 줄 이상이라면 SUT의 API에 문제가 있다는 신호입니다.
  - 클라이언트가 두 메서드를 반드시 순서대로 호출해야 한다면, 하나를 빠뜨릴 수 있다는 뜻입니다.

```swift
// 나쁜 예 - 행위 구절이 두 줄
let store = Store()
store.removeInventory(product: .shampoo, quantity: 5)
store.persist()                     // 이걸 빠뜨리면?
```

  - 이렇게 모순된 상태를 만들 수 있는 것을 **불변 위반(invariant violation)** 이라 하고, 그런 코드로부터 보호하는 것을 **캡슐화** 라고 합니다.
  - 다만 이 규칙은 단위 테스트에만 적용됩니다. 통합 테스트에서는 여러 줄이 될 수 있습니다.

##### 3.1.5 검증 구절에 검증문은 몇 개?

* "테스트당 검증문 하나"라는 지침이 널리 퍼져 있지만, 이는 잘못된 전제에서 나왔습니다.
* 단위는 **코드의 단위** 가 아니라 **동작의 단위** 이며, 하나의 동작이 여러 결과를 만들 수 있습니다.
* 그 결과들을 한 테스트에서 함께 검증하는 것은 전혀 문제가 아닙니다.

```swift
func test_purchase_reduces_inventory() {
  let store = InMemoryStore()
  store.addInventory(product: .shampoo, quantity: 10)
  let sut = Customer()

  let success = sut.purchase(store: store, product: .shampoo, quantity: 5)

  XCTAssertTrue(success)                                    // 결과 1
  XCTAssertEqual(5, store.getInventory(product: .shampoo))  // 결과 2
}
```

* 다만 검증 구절이 지나치게 커진다면 **프로덕션 코드에 추상화가 빠졌다는 신호** 일 수 있습니다.
  - 반환된 객체의 프로퍼티를 하나하나 검증하는 대신, 그 타입에 동등성 비교를 제대로 구현하고 한 줄로 비교하는 편이 낫습니다.

##### 3.1.6 해체(teardown) 구절

* 준비·행위·검증 뒤에 네 번째 구절로 해체를 두는 사람도 있습니다.
* 그러나 해체는 보통 **별도의 메서드로 분리되어 클래스의 모든 테스트에서 재사용** 되므로, 저자는 이를 AAA 패턴에 포함하지 않습니다.
* 대부분의 단위 테스트에는 해체가 필요하지 않습니다.
  - 단위 테스트는 프로세스 외부 의존성과 통신하지 않으므로 정리할 부수 효과가 없습니다.
  - 해체가 필요한 경우는 통합 테스트의 영역입니다.

##### 3.1.7 테스트 대상 시스템 구별하기

* 테스트 안에는 여러 객체가 등장하므로, 무엇이 검증 대상인지 한눈에 보여야 합니다.
* SUT에 해당하는 변수는 항상 `sut` 라는 이름을 씁니다.

```swift
let sut = Calculator()     // 검증 대상
let logger = FakeLogger()  // 협력자
```

##### 3.1.8 AAA 주석 떼어내기

* `// 준비`, `// 행위`, `// 검증` 주석은 구조를 드러내지만 반복되면 잡음이 됩니다.
* 각 구절을 **빈 줄** 로 분리하는 것만으로 충분한 경우가 많습니다.
* 다만 준비 구절 안에 빈 줄이 필요할 만큼 복잡한 테스트에서는 주석을 유지하는 편이 낫습니다.

### 3.2 테스트 프레임워크 살펴보기

원서는 .NET의 xUnit을 다루지만, 대부분의 단위 테스트 프레임워크는 비슷한 기능을 제공합니다. Swift에는 두 가지 선택지가 있습니다.

```swift
// XCTest
final class CalculatorTests: XCTestCase {
  func test_sum_of_two_numbers() {
    let sut = Calculator()
    let result = sut.sum(10, 20)
    XCTAssertEqual(30, result)
  }
}
```

```swift
// Swift Testing
struct CalculatorTests {
  @Test func 두_수의_합() {
    let sut = Calculator()
    let result = sut.sum(10, 20)
    #expect(result == 30)
  }
}
```

* Swift Testing은 테스트 이름을 자유롭게 쓸 수 있고 `#expect` 하나로 검증을 표현합니다.
* 이 장에서 다루는 원칙은 프레임워크와 무관하게 그대로 적용됩니다.

### 3.3 테스트 픽스처 재사용

> 정의: **테스트 픽스처(test fixture)** 는 테스트 실행의 대상이 되는 객체로, 각 테스트가 실행되기 전에 고정된 상태로 준비됩니다.

준비 구절에 중복이 쌓이면 이를 재사용하고 싶어집니다. 가장 먼저 떠오르는 방법은 초기화 코드를 `setUp` 으로 옮기는 것입니다.

```swift
final class CustomerTests: XCTestCase {
  private var store: InMemoryStore!
  private var sut: Customer!

  override func setUp() {
    store = InMemoryStore()
    store.addInventory(product: .shampoo, quantity: 10)
    sut = Customer()
  }

  func test_purchase_succeeds() { ... }
  func test_purchase_fails() { ... }
}
```

중복은 사라졌지만, 두 가지 문제가 생깁니다.

##### 3.3.1 테스트 간의 높은 결합도는 안티 패턴

* 한 테스트의 요구가 바뀌어 `setUp` 을 수정하면 다른 모든 테스트에 영향을 줍니다.
* 예를 들어 재고 수량을 10에서 15로 바꾸면, 그 값에 의존하던 다른 테스트가 함께 깨집니다.
* **테스트를 수정할 때 다른 테스트에 영향을 주어서는 안 됩니다.**

##### 3.3.2 생성자 사용은 테스트 가독성을 떨어뜨린다

* 테스트 본문만 읽어서는 어떤 상태가 준비되었는지 알 수 없습니다.
* 테스트를 이해하려고 클래스의 다른 부분을 뒤져야 한다면 이미 실패한 것입니다.
* 단위 테스트는 그 자체로 **완결된 이야기** 여야 합니다.
  - 테스트를 이해하기 위해 클래스 안의 다른 곳을 살펴봐야 한다면, 그만큼 이해 비용이 늘어납니다.

##### 3.3.3 더 나은 재사용 방법

* 비공개 팩토리 메서드를 사용합니다.

```swift
final class CustomerTests: XCTestCase {
  func test_purchase_succeeds_when_enough_inventory() {
    let store = makeStore(inventory: 10)
    let sut = Customer()

    let success = sut.purchase(store: store, product: .shampoo, quantity: 5)

    XCTAssertTrue(success)
  }

  // 비공개 팩토리 - 기본값을 두고 필요한 것만 인자로 받는다
  private func makeStore(product: Product = .shampoo,
                         inventory: Int = 10) -> InMemoryStore {
    let store = InMemoryStore()
    store.addInventory(product: product, quantity: inventory)
    return store
  }
}
```

* 중복은 제거하면서도, 테스트가 어떤 상태에서 시작하는지 본문에서 바로 읽힙니다.
* 기본값을 두면 각 테스트는 자기가 신경 쓰는 값만 넘기면 됩니다.

* 예외: 모든 테스트가 예외 없이 사용하는 픽스처(예: 데이터베이스 연결)는 `setUp` 에 두어도 좋습니다.

### 3.4 단위 테스트 명명하기

가장 널리 퍼진 규칙은 다음과 같습니다.

```
[테스트할 메서드]_[시나리오]_[예상 결과]
```

* 예: `isDeliveryValid_InvalidDate_ReturnsFalse`
* 그러나 이 규칙은 **좋지 않습니다.**
  - 복잡한 동작에 대한 상위 수준의 설명을 이런 좁은 틀에 밀어 넣을 수 없습니다.
  - 메서드 이름을 테스트 이름에 넣으면 테스트가 구현에 결합됩니다. 메서드 이름이 바뀔 때마다 테스트 이름도 바꿔야 합니다.
  - 무엇보다, 검증 대상은 코드가 아니라 **동작** 입니다.

##### 3.4.1 단위 테스트 명명 지침

* **엄격한 명명 규칙을 강요하지 마십시오.**
  - 복잡한 동작을 좁은 틀에 맞출 수 없습니다. 표현의 자유를 허용하십시오.

* **문제 도메인에 익숙한 비개발자에게 시나리오를 설명하듯 이름을 지으십시오.**
  - 도메인 전문가나 비즈니스 분석가가 좋은 기준입니다.

* **단어를 밑줄로 구분하십시오.**
  - 특히 이름이 길 때 가독성이 올라갑니다.

* 테스트 클래스 이름에는 밑줄을 쓰지 않습니다. 보통 길지 않아 그대로도 잘 읽힙니다.
* `[클래스이름]Tests` 라는 이름을 쓰더라도, 그 테스트가 해당 클래스만 검증한다는 뜻은 아닙니다.
  - 단위는 여전히 **동작의 단위** 이며 여러 클래스에 걸칠 수 있습니다.
  - 클래스 이름은 동작을 검증하기 위한 **진입점** 일 뿐입니다.

##### 3.4.2 예시: 지침에 맞게 이름 바꾸기

```
isDeliveryValid_InvalidDate_ReturnsFalse
  ↓
test_delivery_with_a_past_date_is_invalid
```

* 두 번째 이름은 도메인 사실을 그대로 서술합니다.
* `isDeliveryValid` 를 다른 이름으로 리팩토링해도 테스트 이름은 그대로 유효합니다.

> TIP: 이름에 `should be` 대신 `is` 를 쓰십시오.
>
> 테스트는 **바람** 이 아니라 **사실** 을 기술합니다.

### 3.5 매개변수화된 테스트로 리팩토링

비슷한 테스트가 값만 바꿔 반복된다면 매개변수화할 수 있습니다.

```swift
// XCTest - 헬퍼로 처리
func test_detects_an_invalid_delivery_date() {
  assertDeliveryValidity(daysFromNow: -1, expected: false)
  assertDeliveryValidity(daysFromNow: 0,  expected: false)
  assertDeliveryValidity(daysFromNow: 1,  expected: false)
  assertDeliveryValidity(daysFromNow: 2,  expected: true)
}

private func assertDeliveryValidity(daysFromNow: Int, expected: Bool,
                                    line: UInt = #line) {
  let sut = DeliveryService()
  let delivery = Delivery(date: .now.addingTimeInterval(TimeInterval(daysFromNow * 86400)))

  XCTAssertEqual(expected, sut.isValid(delivery), line: line)
}
```

* `line: UInt = #line` 을 넘기면 실패했을 때 호출 지점을 정확히 짚어 줍니다.

```swift
// Swift Testing - 프레임워크가 직접 지원
@Test(arguments: [(-1, false), (0, false), (1, false), (2, true)])
func 배송일_유효성(daysFromNow: Int, expected: Bool) {
  let sut = DeliveryService()
  let delivery = Delivery(date: .now.addingTimeInterval(TimeInterval(daysFromNow * 86400)))

  #expect(sut.isValid(delivery) == expected)
}
```

* 매개변수화는 코드를 크게 줄여주지만 **가독성을 희생합니다.**
  - 입력값만 보고는 무엇을 검증하는지 알기 어려워집니다.
  - 매개변수가 늘어날수록 더 심해집니다.
* 절충안으로 **긍정 경로와 부정 경로를 별도의 테스트로 분리** 하는 방법이 있습니다.
  - 가장 중요한 경우는 이름 있는 테스트로 따로 두고, 나머지 경계값만 매개변수화합니다.

> TIP: 동작이 단순할수록 매개변수화의 이득이 큽니다.
>
> 동작이 복잡하다면 차라리 테스트를 나누십시오.

##### 3.5.1 매개변수화된 테스트의 데이터 생성

* 인라인 배열로 데이터를 넘기는 방식에는 제약이 있습니다.
  - Swift에서도 컴파일 타임에 확정되는 리터럴만 속성 인자로 넘길 수 있습니다.
  - `Date` 처럼 런타임에 만들어야 하는 값은 그대로 넣기 어렵습니다.
* 그래서 위 예시에서도 날짜 자체가 아니라 **오늘로부터의 일수** 를 넘기고, 테스트 본문에서 날짜로 변환했습니다.
* 값을 만들어 주는 별도의 제공자를 두는 방법도 있지만, 그만큼 테스트가 어디서 무엇을 받는지 추적하기 어려워집니다.

### 3.6 검증문 라이브러리로 테스트 가독성 높이기

* `XCTAssertEqual(30, result)` 같은 형태는 인자 순서가 눈에 들어오지 않습니다.
  - 기대값이 먼저인지 실제값이 먼저인지 매번 확인해야 합니다.
* 검증문을 영어 문장에 가깝게 쓰면 의도가 더 빨리 전달됩니다.

```swift
// Swift Testing 은 표현식을 그대로 쓴다
#expect(result == 30)
#expect(delivery.isValid)
```

* 문장이 자연스럽게 읽히면 테스트가 무엇을 주장하는지 한 번에 들어옵니다.

여기까지가 단위 테스트의 기초입니다. <doc:Chapter-4>부터는 **가치 있는 테스트란 무엇인가** 를 다룹니다.
