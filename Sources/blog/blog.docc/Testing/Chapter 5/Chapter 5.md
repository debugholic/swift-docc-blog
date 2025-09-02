# 5. Mocks 및 테스트 취약성

## 요약

Mock 사용 사례를 구축하고 테스트 취약성과의 관계를 탐구합니다.

### 5.1 Mocks와 Stubs 구분하기(Differentiating mocks from stubs)

##### 5.1.1 테스트 더블(Test Double)의 유형(The types of test doubles)
테스트 더블은 실제 의존성 대신 시스템 테스트 대상(SUT)에 전달되는 비-실제(non-production-ready), 가짜 의존성을 총칭하는 용어입니다.

테스트 더블의 주요 용도는 테스트를 용이하게 하는 것입니다. 테스트는 설정하거나 유지하기 어려울 수 있는 실제 종속성 대신 테스트 중인 시스템으로 전달됩니다.

제라드 메사로스(Gerard Meszaros)에 따르면 더미(dummy), 스텁(stub), 스파이(spy), 목(mock), 페이크(fake)의 다섯 가지 변형이 있지만, 이들은 크게 Mocks와 Stubs 두 가지 유형으로 분류할 수 있습니다.

@Image(source: 5-1.png, alt: nil)

* Mocks (Mock, Spy 포함) 
  
  - SUT가 의존성 객체에 상태 변경을 유발하기 위해 호출하는 "나가는 상호작용(outcoming interactions)"을 에뮬레이션하고 검사하는 데 도움을 줍니다. 
  - 이는 주로 사이드 이펙트(side effects)를 생성하는 명령(commands)과 관련됩니다.
  - Spy는 수동으로 작성된 Mock에 해당합니다.

* Stubs (Stub, Dummy, Fake 포함)
  
  - SUT가 의존성 객체로부터 입력 데이터를 얻기 위해 호출하는 "들어오는 상호작용(incoming interactions)"을 에뮬레이션하는 데 도움을 줍니다. (하지만 검사하지는 않습니다.) 
  - 이는 값을 반환하고 사이드 이펙트가 없는 쿼리(queries)와 관련됩니다. 
  - Dummy는 간단한 하드코딩된 값이고, Stub은 더 정교하며, Fake는 아직 존재하지 않는 의존성을 대체하기 위해 구현됩니다.

##### 5.1.2 Mock(도구) vs. Mock(테스트 더블)의 구분(Mock (the tool) vs. mock (the test double))

Mock이라는 용어는 모의 객체 라이브러리의 클래스 자체 (예: Moq의 Mock<T>)를 지칭할 수도 있고, 그 클래스로 생성된 특정 유형의 테스트 더블 (Mock 객체)을 의미할 수도 있습니다.

Mock(도구)는 Mock(테스트 더블)과 Stub을 모두 생성할 수 있습니다.

##### 5.1.3 Stub과의 상호작용을 검증(assert)하지 마라(Don’t assert interactions with stubs)

Stub과의 상호작용을 검증하는 것은 흔히 발생하는 안티패턴이며, 취약한 테스트(fragile tests)로 이어집니다. 

이는 SUT의 최종 결과가 아닌 구현 세부 사항(implementation details)을 검증하는 것이기 때문입니다.

```
[Fact]
public void Creating_a_report()
{
  var stub = new Mock<IDatabase>();
  stub.Setup(x => x.GetNumberOfUsers()).Returns(10);
  var sut = new Controller(stub.Object);

  Report report = sut.CreateReport();

  Assert.Equal(10, report.NumberOfUsers);
  stub.Verify(
    x => x.GetNumberOfUsers(),
    Times.Once);
}
```

예시에서 GetNumberOfUsers() 호출을 검증하는 것은 리포트 생성에 필요한 데이터를 SUT가 어떻게 수집하는지에 대한 내부 구현을 검증하는 것입니다.

최종 결과물에 포함되지 않는 사항을 검증하는 이러한 관행을 과잉 명세(overspecification)라고도 합니다.

##### 5.1.4 Mocks와 Stubs 함께 사용하기(Using mocks and stubs together)

때로는 테스트 더블이 미리 정의된 응답(stub의 역할)을 제공하고, 동시에 특정 상호작용(mock의 역할)이 발생했는지도 검증해야 하는 경우가 있습니다.

```
[Fact]
public void Purchase_fails_when_not_enough_inventory()
{
  var storeMock = new Mock<IStore>();
  storeMock
    .Setup(x => x.HasEnoughInventory(
      Product.Shampoo, 5))
    .Returns(false);

  var sut = new Customer();

  bool success = sut.Purchase(
    storeMock.Object, Product.Shampoo, 5);

  Assert.False(success);
  storeMock.Verify(
    x => x.RemoveInventory(Product.Shampoo, 5),
    Times.Never);
}
```

이 테스트에서 storeMock은 HasEnoughInventory() 호출에 대해 false를 반환하도록 사전 설정된 응답을 제공합니다. 

이는 Stub의 역할입니다.

동시에, 이 테스트는 storeMock.Verify()를 사용하여 RemoveInventory() 메서드가 호출되지 않았음(Times.Never)을 검증합니다. 

이는 SUT가 의존성 객체에 상태 변경을 유발하는 상호작용을 검사하는 Mock의 역할입니다.

이 예시에서 storeMock은 두 가지 역할을 하지만, HasEnoughInventory() (stub 역할)와 RemoveInventory() (mock 역할)는 서로 다른 메서드이므로, Stub과의 상호작용을 직접 검증하지 않는다는 원칙을 위반하지 않습니다. 

즉, 데이터를 얻기 위한 상호작용(쿼리)을 검증하는 것이 아니라, 사이드 이펙트를 발생시키는 상호작용(명령)을 검증합니다.

테스트 더블이 Mock과 Stub의 역할을 동시에 수행할 때, 일반적으로 "Mock"이라고 부르는 경향이 있습니다. 

이는 Mock으로서의 역할(상태 변경 유발 상호작용 검사)이 Stub으로서의 역할(입력 데이터 제공)보다 더 중요하게 간주되기 때문입니다.

##### 5.1.5 Mocks와 Stubs가 Commands 및 Queries와 어떻게 관련되는가(How mocks and stubs relate to commands and queries)

커맨드 쿼리 분리 원칙(CQS 원칙)은 모든 메서드는 명령(Command)이거나 쿼리(Query)여야 하며 둘 다여서는 안 된다고 하고 있습니다.

@Image(source: 5-2.png, alt: nil)

* 명령(Commands)

  - 사이드 이펙트(side effects)를 발생시킵니다 (객체의 상태 변경, 파일 시스템 변경 등).
  - 값을 반환하지 않습니다 (void 반환)
  - Mock은 이러한 명령을 대체하는 테스트 더블이 됩니다. 
  - Mock은 SUT가 의존성 객체에 상태 변경을 유발하기 위해 호출하는 나가는 상호작용(outcoming interactions)을 에뮬레이션하고 검사하는 데 도움을 줍니다.

* 쿼리(Queries)

  - 사이드 이펙트가 없습니다.
  - 값을 반환합니다.
  - Stub은 이러한 쿼리를 대체하는 테스트 더블이 됩니다. 
  - Stub은 SUT가 의존성 객체로부터 입력 데이터를 얻기 위해 호출하는 들어오는 상호작용(incoming interactions)을 에뮬레이션하는 데 도움을 줍니다 (하지만 검사하지는 않습니다).

CQS 원칙을 따르면 코드 가독성이 향상되고, 메서드의 시그니처만 보고도 그 역할(사이드 이펙트 발생 여부 및 값 반환 여부)을 파악할 수 있습니다.

> var mock = new Mock<IEmailGateway>();
> mock.Verify(x => x.SendGreetingsEmail("user@email.com"));

SendGreetingsEmail() 메서드는 이메일을 전송하는 사이드 이펙트를 발생시키는 명령입니다. 

따라서 이 메서드를 대체하는 테스트 더블은 Mock이 됩니다. 테스트에서는 이메일 전송이라는 상호작용이 일어났는지 mock.Verify()로 검증합니다.

> var stub = new Mock<IDatabase>();
> stub.Setup(x => x.GetNumberOfUsers()).Returns(10);

GetNumberOfUsers() 메서드는 데이터베이스 상태를 변경하지 않고 단순히 사용자 수를 반환하는 쿼리입니다. 

따라서 이 메서드를 대체하는 테스트 더블은 Stub이 됩니다. 

테스트에서는 이 메서드가 반환할 "가상의" 값을 stub.Setup().Returns()로 설정합니다.

### 5.2 관찰 가능한 행동 vs. 구현 세부 사항(Observable behavior vs. implementation details)

테스트 취약성은 Chapter 4에서 다루었던 리팩토링에 대한 내성(resistance to refactoring)과 밀접하게 관련되어 있으며, 거짓 양성(false positive)을 줄여 리팩토링 내성을 높이는 것이 중요합니다.

거짓 양성은 테스트가 코드의 구현 세부 사항(implementation details)에 결합(coupling)되어 발생하며, 이를 피하려면 테스트가 코드의 최종 결과(end result), 즉 관찰 가능한 동작(observable behavior)을 검증해야 합니다. 

이는 테스트가 "어떻게(hows)"가 아닌 "무엇(whats)"에 집중해야 함을 의미합니다.

##### 5.2.1 관찰 가능한 동작은 public API와 동일하지 않다(Observable behavior is not the same as a public API)

모든 프로덕션 코드는 두 가지 차원을 따라 분류될 수 있습니다.

* Public API vs. private API
  
  - 메서드가 public인지 private인지.

* Observable behavior vs. implementation details 
  
  - 코드가 시스템의 관찰 가능한 동작에 속하는지, 아니면 내부 구현 세부 사항인지.

잘 설계된 API에서는 관찰 가능한 동작이 public API와 일치하고, 모든 구현 세부 사항은 private API 뒤에 숨겨져야 합니다. 

이는 코드 조각이 최소한 하나의 클라이언트 목표와 직접적인 관련이 있어야 관찰 가능한 동작의 일부로 간주될 수 있음을 의미합니다.

@Image(source: 5-3.png, alt: nil)

시스템의 public API가 관찰 가능한 동작을 넘어 구현 세부 사항을 노출할 때 구현 세부 사항이 유출(leaking implementation details)됩니다.

@Image(source: 5-4.png, alt: nil)

##### 5.2.2 구현 세부 사항 유출: 작업(operation) 예시(Leaking implementation details: An example with an operation)

```
public class User
{
  public string Name { get; set; }

  public string NormalizeName(string name)
  {
    string result = (name ?? "").Trim();

    if (result.Length > 50)
      return result.Substring(0, 50);

    return result;
  }
}
```

* User 클래스 예시

  - User 클래스는 Name 속성과 NormalizeName() 메서드를 public API로 가집니다. 
  - NormalizeName()은 사용자 이름이 50자를 초과하지 않도록 잘라내는 불변 조건(invariant)을 유지하기 위한 내부 로직입니다.

```
public class UserController
{
  public void RenameUser(int userId, string newName)
  {
    User user = GetUserFromDatabase(userId);
  
    string normalizedName = user.NormalizeName(newName);
    user.Name = normalizedName;

    SaveUserToDatabase(user);
  }
}
```

UserController (클라이언트 코드)가 RenameUser 메서드에서 NormalizeName()과 Name 속성 설정을 두 번 호출해야 하는 경우, NormalizeName()은 클라이언트의 목표(이름 변경)와 직접적인 관련이 없으므로 유출된 구현 세부 사항으로 간주됩니다.

@Image(source: 5-5.png, alt: nil)

```
public class User
{
  private string _name;
  public string Name
  {
    get => _name;
    set => _name = NormalizeName(value);
  }

  private string NormalizeName(string name)
  {
    string result = (name ?? "").Trim();

    if (result.Length > 50)
      return result.Substring(0, 50);

    return result;
  }
}

public class UserController
{
  public void RenameUser(int userId, string newName)
  {
    User user = GetUserFromDatabase(userId);
    user.Name = newName;
    SaveUserToDatabase(user);
  }
}
```

User 클래스 내부에서 Name 속성 설정 시 NormalizeName()을 호출하도록 리팩토링하면, NormalizeName()은 private 메서드가 되고 UserController는 Name 속성만 한 번 호출하면 되므로 잘 설계된 API가 됩니다.

클라이언트가 단일 목표를 달성하기 위해 클래스에서 하나 이상의 작업(operation)을 호출해야 한다면, 해당 클래스는 구현 세부 사항을 유출하고 있을 가능성이 높습니다.

##### 5.2.3 잘 설계된 API와 캡슐화(Well-designed API and encapsulation)
잘 설계된 API를 유지하는 것은 캡슐화와 관련이 있습니다. 캡슐화는 불변 조건 위반(invariant violation)과 같은 코드의 불일치(inconsistencies)로부터 코드를 보호하는 행위입니다.

구현 세부 사항을 노출하는 것은 종종 불변 조건 위반으로 이어집니다. 초기 User 클래스 예시에서 NormalizeName()을 public으로 두면 클라이언트가 이름 정규화 없이 Name을 직접 변경할 수 있어 불일치가 발생할 수 있었습니다.

캡슐화는 코드 복잡성을 관리하는 데 필수적입니다. 캡슐화가 없으면 개발자가 너무 많은 정보를 기억해야 하므로 프로그래밍 과정에 추가적인 정신적 부담(mental burden)이 가해집니다. 적절한 캡슐화는 오류 발생 가능성을 제거하여 소프트웨어 프로젝트의 지속 가능한 성장을 가능하게 합니다.

데이터와 해당 데이터에 대한 작업을 함께 묶는 것(tell-don’t-ask 원칙)은 클래스의 불변 조건이 위반되지 않도록 보장하는 데 도움이 됩니다.

##### 5.2.4 구현 세부 사항 유출: 상태(state) 예시(Leaking implementation details: An example with state)

```
public class MessageRenderer : IRenderer
{
  public IReadOnlyList<IRenderer> SubRenderers { get; }

  public MessageRenderer()
  {
    SubRenderers = new List<IRenderer>
    {
      new HeaderRenderer(),
      new BodyRenderer()
      new FooterRenderer()
    };
  }

  public string Render(Message message)
    return SubRenderers
            .Select(x => x.Render(message))
            .Aggregate("", (str1, str2) => str1 + str2);
  }
}
```

SubRenderers 컬렉션은 public이지만, 클라이언트의 목표가 HTML 메시지를 렌더링하는 것이라면 Render 메서드 외에는 필요 없습니다. 

따라서 SubRenderers는 유출된 구현 세부 사항입니다.

이전 장에서 이 테스트는 SubRenderers 컬렉션 구성에 묶여 있었기 때문에 취약한 테스트였습니다.

이러한 취약성은 테스트를 Render 메서드의 최종 출력(관찰 가능한 동작)으로 리타겟팅하여 해결되었습니다.

API를 잘 설계하여 모든 구현 세부 사항을 private으로 만들면, 테스트는 코드의 관찰 가능한 동작만 검증하게 되므로 자동으로 리팩토링 내성이 향상됩니다.

클라이언트가 목표를 달성하는 데 직접적으로 도움이 되는 최소한의 작업과 상태만 노출해야 합니다. 나머지는 구현 세부 사항이므로 private API 뒤에 숨겨야 합니다.

@Image(source: 5-6.png, alt: nil)

### 5.3 Mocks와 테스트 취약성 간의 관계 (The relationship between mocks and test fragility)

##### 5.3.1 육각형 아키텍처 정의(Defining hexagonal architecture)

전형적인 애플리케이션은 도메인 계층(domain layer)과 애플리케이션 서비스 계층(application services layer)으로 구성됩니다.

* 도메인 계층: 애플리케이션의 핵심 비즈니스 로직을 포함하며, 애플리케이션의 중심 부분입니다.

* 애플리케이션 서비스 계층: 도메인 계층과 외부 세계(external world) 간의 통신을 조율합니다 (예: 데이터베이스 쿼리, 도메인 클래스 인스턴스화, 외부 의존성과의 작업 조정).

애플리케이션 서비스 계층과 도메인 계층의 조합이 육각형을 형성하며, 이는 애플리케이션 자체를 나타냅니다. 이 육각형은 SMTP 서비스, 서드파티 시스템, 메시지 버스 등 다른 외부 애플리케이션(다른 육각형)과 상호작용할 수 있습니다.

육각형 아키텍처는 다음 세 가지 중요한 지침을 강조합니다.

* 관심사의 분리 

  - 도메인 계층은 비즈니스 로직만 담당하고, 애플리케이션 서비스 계층은 외부 애플리케이션과의 통신 및 데이터 검색과 같은 다른 책임들을 가집니다. 
  - 애플리케이션 서비스는 비즈니스 로직을 포함하지 않아야 합니다.

* 단방향 의존성 흐름
  
  - 애플리케이션 서비스 계층에서 도메인 계층으로의 단방향 의존성을 따릅니다. 
  - 도메인 계층의 클래스들은 오직 서로에게만 의존해야 하며, 애플리케이션 서비스 계층의 클래스에 의존해서는 안 됩니다. 
  - 이는 도메인 계층이 외부 세계로부터 완전히 격리되어야 함을 의미합니다.

* 외부 애플리케이션과의 통신
  
  - 외부 애플리케이션은 애플리케이션 서비스 계층에서 유지 관리하는 공통 인터페이스를 통해 애플리케이션과 연결됩니다.
  - 도메인 계층에는 직접적인 접근이 없습니다.

@Image(source: 5-7.png, alt: nil)

서로 다른 계층으로 작업하는 테스트는 프랙탈 특성을 가지고 있습니다. 

애플리케이션 서비스의 테스트는 전반적인 비즈니스 사용 사례가 어떻게 실행되는지 확인합니다. 

도메인 클래스로 작업하는 테스트는 사용 사례 완료에 대한 중간 하위 목적을 확인합니다.

##### 5.3.2 시스템 내부 통신 vs. 시스템 외부 통신(Intra-system vs. inter-system communications)

* 시스템 내부 통신

  - 애플리케이션 내부 클래스 간의 통신입니다. 이는 구현 세부 사항입니다. 
  - 도메인 클래스 간의 협업은 클라이언트의 목표와 직접적인 연결이 없기 때문에 관찰 가능한 동작의 일부가 아닙니다.

@Image(source: 5-8.png, alt: nil)

* 시스템 외부 통신

  - 애플리케이션이 다른 외부 애플리케이션과 통신하는 경우입니다. 이는 관찰 가능한 동작입니다. 
  - 외부 세계와의 통신 방식은 시스템 전체의 관찰 가능한 동작을 형성하며, 애플리케이션이 항상 유지해야 하는 계약(contract)의 일부입니다.
  - 시스템 외부 통신 패턴은 외부 애플리케이션이 변경 사항을 이해할 수 있도록 하위 호환성을 유지해야 합니다.

@Image(source: 5-9.png, alt: nil)
  
Mocks는 시스템 외부 통신을 검증할 때 유용합니다. 이는 리팩토링 후에도 통신 패턴이 유지되도록 보장하는 데 도움이 됩니다.

반대로 Mocks를 시스템 내부 통신을 검증하는 데 사용하면, 구현 세부 사항에 결합되어 테스트 취약성을 야기합니다.

##### 5.3.3 시스템 내부 통신 vs. 시스템 외부 통신 예시(Intra-system vs. inter-system communications: An example)

* 고객 구매 시나리오
  
  - 고객이 제품을 구매하고, 재고가 충분하면 재고가 감소하고 고객에게 이메일 영수증이 발송되며 확인 메시지가 반환됩니다.

```
public class CustomerController
{
  public bool Purchase(int customerId, int productId, int quantity)
  {
    Customer customer = _customerRepository.GetById(customerId);
    Product product = _productRepository.GetById(productId);

    bool isSuccess = customer.Purchase(
      _mainStore, product, quantity);

    if (isSuccess)
    {
      _emailGateway.SendReceipt(
      customer.Email, product.Name, quantity);
    }

    return isSuccess;
  }
}
```

CustomerController는 Customer, Product, Store와 같은 도메인 클래스와 EmailGateway (SMTP 서비스 프록시) 같은 외부 애플리케이션 간의 작업을 조율합니다.

* 시스템 외부 통신 (관찰 가능한 동작)

  - CustomerController와 서드파티 시스템(외부 클라이언트), EmailGateway 간의 통신.

  - EmailGateway.SendReceipt() 호출은 외부 세계에 보이는 사이드 이펙트이며, 클라이언트의 목표(구매 확인 이메일 수신)와 직접 연결됩니다.

* Mocks의 올바른 사용 예시

```
[Fact]
public void Successful_purchase()
{
  var mock = new Mock<IEmailGateway>();
  var sut = new CustomerController(mock.Object);

  bool isSuccess = sut.Purchase(
    customerId: 1, productId: 2, quantity: 5);

  Assert.True(isSuccess);
  mock.Verify(
    x => x.SendReceipt(
      "customer@email.com", "Shampoo", 5),
      Times.Once);
}
```

IEmailGateway에 대한 mock.Verify()는 시스템 외부 통신을 검증하므로 테스트 취약성으로 이어지지 않습니다.

```
[Fact]
public void Purchase_succeeds_when_enough_inventory()
{
  var storeMock = new Mock<IStore>();
  storeMock
    .Setup(x => x.HasEnoughInventory(Product.Shampoo, 5))
    .Returns(true);
  var customer = new Customer();

  bool success = customer.Purchase(
    storeMock.Object, Product.Shampoo, 5);

  Assert.True(success);
  storeMock.Verify(
    x => x.RemoveInventory(Product.Shampoo, 5),
    Times.Once);
}
```

Customer에서 Store로 호출되는 RemoveInventory() 메서드는 애플리케이션 경계를 넘지 않습니다.

즉, 호출자와 수신자 모두 애플리케이션 내부에서 존재합니다.

이 두 도메인 클래스의 클라이언트는 구매를 목표로 하는 CustomerController입니다. 

이 목표와 직접 연결된 유일한 두 멤버는 customer.Purchase()와 store.GetInventory()입니다.

Purchase() 메서드는 구매를 시작하고, GetInventory()는 구매 완료 후 시스템 상태를 보여줍니다.

RemoveInventory() 메서드 호출은 클라이언트 목표 달성을 위한 중간 단계, 즉 구현 세부사항에 불과합니다.

### 5.4 유닛 테스트의 고전적 학파와 런던 학파 재검토(The classical vs. London schools of unit testing, revisited)

* 런던 학파의 문제점

  - 런던 학파는 불변(immutable) 의존성을 제외한 모든 의존성에 Mock을 사용하도록 권장합니다. 
  - 이로 인해 시스템 내부 통신과 외부 통신을 구분하지 않고 Mock을 사용하게 되며, 결과적으로 테스트가 구현. 세부. 사항에 결합되어 리팩토링 내성을 상실하게 됩니다. 
  - 리팩토링 내성은 테스트 가치를 결정하는 이분법적인(binary) 속성이므로, 이를 훼손하는 것은 테스트를 거의 가치 없게 만듭니다.

* 고전적 학파의 강점과 한계

  - 고전적 학파는 테스트 간에 공유되는 의존성(shared dependencies)만 대체하도록 주장합니다.
  - 이는 거의 항상 SMTP 서비스나 메시지 버스와 같은 시스템 외부 의존성(out-of-process dependencies)을 의미합니다. 
  - 이는 런던 학파보다 낫지만, 여전히 일부 시스템 외부 의존성에 대한 과도한 Mock 사용을 권장할 수 있습니다.

##### 5.4.1 모든 시스템 외부 의존성을 Mock으로 대체해야 하는 것은 아니다. (Not all out-of-process dependencies should be mocked out)

* 의존성 유형 복습
    
  - Shared dependency: 테스트 간에 공유되어 테스트 결과에 서로 영향을 줄 수 있는 의존성 (예: static mutable field, 데이터베이스).
  - Out-of-process dependency: 애플리케이션 실행 프로세스 외부에서 실행되는 의존성 (예: 데이터베이스, 메시지 버스, SMTP 서비스).
  - Private dependency: 공유되지 않는 의존성.

고전적 접근법은 공유 종속성을 피할 것을 권장합니다. 

공유 종속성은 테스트 간 실행 컨텍스트 간섭을 유발하여 테스트의 병렬 실행을 방해하기 때문입니다. 

테스트가 병렬, 순차적, 임의 순서로 실행될 수 있는 능력을 테스트 격리(test isolation)라고 합니다.

* 공유 종속성이 프로세스 내부인 경우

- 각 테스트 실행 시마다 새로운 인스턴스를 제공함으로써 테스트에서 재사용을 쉽게 방지할 수 있습니다. 

* 공유 종속성이 프로세스 외부인 경우 

- 일반적인 접근 방식은 종속성을 테스트 더블로 대체하는 것입니다.
- 테스트 실행마다 새 데이터베이스를 생성하거나 새 메시지 버스를 프로비저닝하면 테스트 스위트 속도가 크게 느려지기 때문입니다.

* 관리되는 의존성(managed dependencies)

- 외부 프로세스 종속성이 오직 해당 애플리케이션을 통해서만 접근 가능한 경우, 시스템의 관측 가능한 행동 범위에 포함되지 않습니다. 
- 애플리케이션이 외부 시스템에 대한 프록시 역할을 하고 클라이언트가 직접 액세스할 수 없는 경우 이전 버전과의 호환성 요구 사항이 사라집니다.
- 하위 호환성 유지 요구 사항이 필요한 이유는 외부 시스템과 애플리케이션을 동시에 변경할 수 없거나, 다른 배포 주기를 따르거나, 간단하게 제어할 수 없기 때문입니다.

##### 5.4.2 행동 검증에 모킹 사용하기(Using mocks to verify behavior)

Mocks은 흔히 행동을 검증한다고 알려져 있지만 대부분의 경우 그렇지 않습니다.

개별 클래스가 특정 목표를 달성하기 위해 주변 클래스와 상호작용하는 방식은 관찰 가능한 행동과 무관하며, 이는 구현 세부사항에 불과합니다.

중요한 것은 클라이언트 목표까지 추적 가능한 행동입니다.

Mocks이 행동과 관련이 있는 경우는 오직 애플리케이션 경계를 가로지르는 상호작용을 검증할 때이며, 그 상호작용의 부작용이 외부 세계에 가시적으로 드러날 때뿐입니다.
