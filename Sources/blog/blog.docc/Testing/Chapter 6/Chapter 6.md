# 6. 단위 테스팅 스타일

## 요약

 세 가지 단위 테스트 스타일을 비교하고, 그 중 출력 기반 스타일이 가장 높은 품질의 테스트를 생성한다는 사실을 알아봅니다.

### 6.1 세 가지 단위 테스팅 스타일

단위 테스트에는 세 가지 스타일이 있으며, 단일 테스트에 하나, 둘 또는 세 가지 스타일 모두를 함께 사용할 수 있습니다.

* 출력 기반 테스팅 (Output-based testing)
* 상태 기반 테스팅 (State-based testing)
* 커뮤니케이션 기반 테스팅 (Communication-based testing)

##### 6.1.1 출력 기반 테스팅

SUT(System Under Test)에 입력을 제공하고, SUT가 생성하는 출력 값을 확인하는 스타일입니다.

@Row {
  @Column {
    @Image(source: 6-1.png)
  }
  @Column {}
}


이 스타일은 전역 또는 내부 상태를 변경하지 않는 코드에만 적용 가능하며, 유일하게 검증할 구성 요소는 반환 값입니다.

```
public class PriceEngine
{
  public decimal CalculateDiscount(params Product[] products)
  {
    decimal discount = products.Length * 0.01m;
    return Math.Min(discount, 0.2m);
  }
}

[Fact]
public void Discount_of_two_products()
{
  var product1 = new Product("Hand wash");
  var product2 = new Product("Shampoo");
  var sut = new PriceEngine();

  decimal discount = sut.CalculateDiscount(product1, product2);

  Assert.Equal(0.02m, discount);
}
```

`PriceEngine` 클래스의 `CalculateDiscount()` 메서드는 제품 배열을 입력받아 할인율을 계산하고 반환합니다.

이 클래스는 내부 컬렉션에 제품을 추가하거나 데이터베이스에 저장하지 않으므로, 유일한 결과는 반환되는 할인율입니다.

@Row {
  @Column {
    @Image(source: 6-2.png)
  }
  @Column {}
}

이 방식은 함수형 프로그래밍(functional programming)에서 유래한 함수형(functional) 스타일이라고도 불립니다. 

이는 부수 효과 없는 코드(side-effect-free code)를 선호하는 프로그래밍 방식입니다.

##### 6.1.2 상태 기반 테스팅

작업이 완료된 후 시스템의 최종 상태를 검증하는 스타일입니다.

여기서 '상태'는 SUT 자체의 상태, 협력자 중 하나의 상태, 또는 데이터베이스나 파일 시스템과 같은 프로세스 외부 의존성의 상태를 의미할 수 있습니다.

@Row {
  @Column {
    @Image(source: 6-3.png)
  }
  @Column {}
}

```
public class Order
{
  private readonly List<Product> _products = new List<Product>();
  public IReadOnlyList<Product> Products => _products.ToList();
  
  public void AddProduct(Product product)
  {
    _products.Add(product);
  }
}

[Fact]
public void Adding_a_product_to_an_order()
{
  var product = new Product("Hand wash");
  var sut = new Order();

  sut.AddProduct(product);

  Assert.Equal(1, sut.Products.Count);
  Assert.Equal(product, sut.Products[0]);
}
```

`Order` 클래스의 `AddProduct()` 메서드는 제품을 추가한 후, `Order` 객체의 `Products` 컬렉션(내부 상태)이 예상대로 변경되었는지 확인하는 테스트입니다.

##### 6.1.3 커뮤니케이션 기반 테스팅

목(mock)을 사용하여 SUT와 그 협력자 간의 커뮤니케이션을 검증하는 스타일입니다.

테스트는 SUT의 협력자를 목으로 대체하고, SUT가 해당 협력자를 올바르게 호출하는지 확인합니다.

@Row {
  @Column {
    @Image(source: 6-4.png)
  }
  @Column {}
}

```
[Fact]
public void Sending_a_greetings_email()
{
  var emailGatewayMock = new Mock<IEmailGateway>();
  var sut = new Controller(emailGatewayMock.Object);

  sut.GreetUser("user@email.com");

  emailGatewayMock.Verify(
    x => x.SendGreetingsEmail("user@email.com"),
    Times.Once);
}
```

`Controller` 클래스의 `GreetUser()` 메서드가 `IEmailGateway` 목 객체의 `SendGreetingsEmail()` 메서드를 예상대로 한 번 호출했는지 `Verify()`하는 테스트입니다.

> 클래식 vs. 런던 스쿨: 클래식 스쿨은 상태 기반 스타일을 선호하고, 런던 스쿨은 커뮤니케이션 기반 스타일을 선호합니다. 두 스쿨 모두 출력 기반 테스팅을 사용합니다.

### 6.2 세 가지 스타일 비교

네 가지 좋은 단위 테스트 속성을 기준으로 스타일을 비교합니다.

##### 6.2.1 회귀 방지 및 피드백 속도 지표를 사용하여 스타일 비교

* 회귀 방지
  - 코드의 양, 복잡성, 도메인 중요성으로 측정됩니다.
    + 보통은 원하는 만큼 테스트 코드의 양을 작성할 수 있으므로 특정 스타일에 이점이 없습니다.
    + 코드의 복잡성과 도메인 중요성도 마찬가지입니다. 
  - 커뮤니케이션 기반 테스팅:
    + 얇은 코드 슬라이스만 검증하고 대부분을 목으로 만드는 얕은 테스트를 초래할 수 있습니다.
    + 그러나 이는 커뮤니케이션 기반 테스트만의 특징이 아니라 남용하는 사례입니다.

* 피드백 속도
  - 테스트가 외부 의존성을 건드리지 않고 단위 테스트 범위 내에 머무는 한, 모든 스타일은 대략 동일한 실행 속도를 보입니다. 
  - 커뮤니케이션 기반 테스팅:
    + 목의 런타임에 추가 대기 시간 때문에 이 약간 느릴 수 있지만, 수만 개의 테스트가 아닌 이상 차이는 미미합니다.  

##### 6.2.2 리팩토링 내성 및 유지보수성 지표를 사용하여 스타일 비교

* 리팩토링 내성
  - 리팩토링 내성은 테스트가 얼마나 많은 거짓 양성을 생성하는지에 대한 척도입니다.
  - 테스트가 코드의 구현 세부 사항에 얼마나 강하게 결합되어 있는지에 따라 달라집니다.
  - 출력 기반 테스팅:
    + 오직 테스트 중인 메서드에만 결합되므로 가장 좋은 보호를 제공합니다.
  - 상태 기반 테스팅:
    + 구현 세부 사항이 공개 API에 노출될 때 취약해질 수 있습니다.
    + 보통 테스트와 프로덕션 코드 사이의 결합이 클수록, 이 테스트가 유출된 구현 세부 사항에 연결될 가능성이 커집니다.
  - 커뮤니케이션 기반 테스팅:
    + 목을 사용하여 구현 세부 사항에 결합하므로 가장 취약합니다.
    + 특히 스텁(stub)과의 상호작용을 확인하는 경우 항상 취약합니다.
    + 따라서 프로세스 외부 경계를 넘는 상호작용을 검증할 때에만 사용하는 것이 적절합니다.

* 유지보수성
  - 테스트를 이해하기 어려운 정도(테스트의 크기)와 테스트를 실행하기 어려운 정도(프로세스 외부 의존성 사용 여부)에 따라 결정됩니다.
  - 출력 기반 테스팅:
    + 테스트가 간결하고 프로세스 외부 의존성을 다루지 않으므로 크기와 의존성 측면 모두에서 가장 좋습니다.
  - 상태 기반 테스팅:
    + 상태 검증에 더 많은 코드를 필요로 하고, 때때로 헬퍼 메서드나 값 객체를 사용하여 완화할 수 있지만 완전히 제거할 수는 없습니다.
  - 커뮤니케이션 기반 테스팅:
    + 유지보수성 측면에서 가장 나쁩니다. 
    + 테스트 더블과 상호작용 검증을 설정하는 데 많은 공간을 차지하며, 목 체인이 발생하면 더욱 복잡해집니다.

##### 6.2.3 스타일 비교 결과

| | 출력 기반 테스팅 | 상태 기반 테스팅 | 커뮤니케이션 기반 테스팅 |
|:--|:--|:--|:--|
| 리팩토링 내성 유지 비용 | 낮음 | 중간 | 중간 |
| 유지보수 비용 | 낮음 | 중간 | 높음 | 

출력 기반 테스팅이 가장 좋은 결과를 보여줍니다. 

하지만 불행히도 이러한 스타일의 단위 테스트는 기능적인 방식으로 작성된 코드에만 적용되며, 이는 대부분의 객체 지향 프로그래밍 언어에서 거의 그렇지 않습니다.

이 장의 남은 부분에서는 함수형 아키텍처로의 전환을 통해 더 많은 테스트를 출력 기반 스타일로 변경하는 방법을 알아보겠습니다.

### 6.3 함수형 아키텍처

이 섹션에서는 함수형 프로그래밍과 함수형 아키텍처가 무엇인지, 그리고 함수형 아키텍처가 육각형 아키텍처와 어떻게 관련되어 있는지 볼 수 있습니다. 

다만 이것은 함수형 프로그래밍의 주제에 대한 심층적인 탐구가 아니라, 오히려 그 이면의 기본 원칙에 대한 설명이라는 점에 유의하십시오. 

##### 6.3.1 함수형 프로그래밍이란 무엇인가?

함수형 프로그래밍은 수학 함수(Mathematical functions)를 이용한 프로그래밍입니다.

* 수학 함수
  - 수학 함수(순수 함수)는 숨겨진 입력이나 출력이 없는 함수(메서드)를 의미합니다.
  - 모든 입력과 출력은 메서드 시그니처에 명시적으로 표현되어야 하며, 주어진 입력에 대해 호출 횟수에 관계없이 항상 동일한 출력을 생성합니다.

```
public decimal CalculateDiscount(Product[] products)
{
  decimal discount = products.Length * 0.01m;
  return Math.Min(discount, 0.2m);
}
```

`CalculateDiscount()` 메서드는 `Product` 배열을 입력으로 받고 `decimal` 할인율을 출력으로 명시적으로 표현합니다.

@Row {
  @Column {
    @Image(source: 6-5.png)
  }
  @Column {}
}

이러한 방법은 수학에서 함수의 정의를 고수합니다. 

> 정의: 수학에서 함수는 첫 번째 집합의 각 요소에 대해 두 번째 집합에서 정확히 하나의 요소를 찾는 두 집합 사이의 관계입니다.

| ![](6-6.png) | ![](6-7.png) |
|:------------:|:------------:|

* 함수형 메서드는 명시적인 입력과 출력을 갖고 있기 때문에, 출력 기반 테스트를 적용할 수 있는 유일한 메서드 타입입니다.

* 한편 숨겨진 입력과 출력은 테스트를 어렵게 만들기도 합니다. 
  - 부수 효과 (side effect):
    + 부수 효과은 메서드 시그니처에 표현되지 않아 숨겨져 있는 출력입니다. 
    + 한 작업이 클래스 인스턴스의 상태를 변경하고 디스크의 파일을 업데이트할 때 생성됩니다.
  - 예외 (exceptions): 
    + 메소드가 예외를 던지면, 메소드의 서명에 의해 설정된 계약을 우회하는 경로가 프로그램 흐름에 생성됩니다.
    + 던진 예외는 호출 스택의 어느 곳에서나 포착될 수 있으며, 따라서 메서드 시그니처가 전달하지 않는 추가 출력을 만들어 냅니다.
  - 내부 또는 외부 상태에 대한 참조 (A reference to an internal or external state):
    + 메서드는 DateTime.Now와 같은 정적 속성을 사용하여 현재 날짜와 시간을 얻을 수 있습니다.
    + 또한, 데이터베이스에서 데이터를 쿼리하거나 개인 변경 가능한 필드를 참조할 수 있습니다. 
    + 이것들은 모두 메서드 시그니처에 존재하지 않아 숨겨져 있는 실행 흐름에 대한 입력입니다.

* 프로그램 동작을 변경하지 않고 메서드 호출을 반환 값으로 대체할 수 있는 능력을 참조 투명성 (Referential transparency)이라 하며, 수학 함수의 좋은 판별 기준입니다.

```
public int Increment(int x)
{
  return x + 1;
}
```

이 함수는 수학 함수로 다음 두 개의 구문은 서로 동등합니다.

```
int y = Increment(4);
int y = 5;
```

반면에, 다음 방법은 수학적 함수가 아닙니다.

반환 값이 메서드의 모든 출력을 나타내지 않기 때문에 반환 값으로 바꿀 수 없습니다. 

이 예에서 숨겨진 출력은 필드 `x`로의 변경(부수 효과)입니다.

```
int x = 0;
public int Increment()
{
  x++;
  return x;
}
```

부수 효과는 숨겨진 출력의 가장 널리 퍼진 유형입니다. 

다음 예시는 표면에서는 수학 함수처럼 보이지만 실제로는 그렇지 않은 `AddComment` 메서드를 보여줍니다.

```
public Comment AddComment(string text)
{
  var comment = new Comment(text);
  _comments.Add(comment);   // Side effect
  return comment;
}
```

##### 6.3.2 함수형 아키텍처

* 애플리케이션에서 부수 효과를 모두 없앤다는 것은 불가능합니다.

* 함수형 프로그래밍의 목표는 부수 효과를 완전히 제거하는 것이 아니라, 비즈니스 로직과 부수 효과를 분리하는 데 있습니다.

* 두 책임은 각각 충분히 복잡하기 때문에 섞이면 유지보수가 어려워집니다.

* 따라서 함수형 아키텍처는 부수 효과를 가장자리로 밀어내고 핵심 로직을 분리해 복잡성을 줄입니다.

> 정의: 함수형 아키텍처는 순수 기능적(변경 불가능) 방식으로 작성된 코드의 양을 최대화하고, 부수 효과를 다루는 코드를 최소화하는 것입니다. 변경 불가능(immutable)이란 객체가 한 번 생성되면 상태를 변경할 수 없는 것을 의미합니다.

* 비즈니스 로직과 부수 효과의 분리는 두 가지 유형의 코드를 분리하여 이루어집니다.
  - 결정을 내리는 코드: 기능적 핵심 (Functional core)
    + 수학 함수를 사용하여 부수 효과 없이 작성될 수 있습니다.
  - 그 결정에 따라 행동하는 코드: 변경 가능 껍질 (Mutable shell)
    + 기능적 핵심의 모든 결정을 데이터베이스 변경이나 메시지 버스로 메시지 전송과 같은 가시적인 부수 효과로 변환합니다.

@Row {
  @Column {
    @Image(source: 6-8.png)
  }
  @Column {}
}

* 기능적 코어와 변경 가능한 쉘은 다음과 같은 방식으로 협력합니다. 
  - 변경 가능한 쉘은 모든 입력을 수집합니다. 
  - 기능적 핵심은 결정을 내립니다. 
  - 쉘은 결정을 부수 효과로 전환합니다.

* 두 계층 간의 적절한 분리를 유지하려면 비즈니스 로직에서 만든 결정이 실행될 때 추가 판단 없이 그대로 실행될 수 있도록, 그 결정 안에 필요한 정보가 모두 담겨 있어야 합니다.

* 다시 말해, 가변성 쉘은 가능한 한 멍청해야 합니다. 

* 기능적 핵심을 출력 기반 테스트로 광범위하게 커버하고, 변경 가능한 껍질은 적은 수의 통합 테스트로 남겨둡니다.

##### 6.3.3 함수형 아키텍처와 육각형 아키텍처 비교

* 유사점
  - 관심사의 분리(separation of concerns)
    + 육각형 아키텍처는 도메인 계층(비즈니스 로직)과 애플리케이션 서비스 계층(외부 애플리케이션과의 통신)을 분리합니다.
  - 의존성의 단방향 흐름(one-way flow of dependencies)
    + 도메인 계층이 외부 세계로부터 격리되도록 합니다.

* 차이점 
  - 부수 효과 처리 방식 
    + 함수형 아키텍처는 모든 부수 효과를 변경 가능한 껍질의 비즈니스 작업 가장자리로 밀어냅니다.
    + 반면 육각형 아키텍처는 도메인 계층 내에서 부수 효과가 발생하는 것을 허용하지만, 그 부수 효과가 도메인 계층 경계를 넘지 않도록 제한합니다.

> 함수형 아키텍처는 육각형 아키텍처의 부분 집합으로 볼 수 있습니다. 즉, 육각형 아키텍처를 극한까지 밀어붙인 형태입니다.

### 6.4 함수형 아키텍처 및 출력 기반 테스팅으로의 전환

샘플 감사 시스템(audit system)을 기능 아키텍처로 리팩토링하는 과정을 두 단계로 보여줍니다.
  - 외부 프로세스 종속성 사용에서 목 사용으로 전환 
  - 목 사용에서 함수형 아키텍처 사용으로 전환

##### 6.4.1. 방문자 기록 시스템 소개
  
* 방문자 기록을 추적하며, 텍스트 파일을 저장소로 사용합니다. 

* 파일당 최대 항목 수에 도달하면 새 파일을 생성합니다.

```
public class AuditManager
{
  private readonly int _maxEntriesPerFile;
  private readonly string _directoryName;
  
  public AuditManager(int maxEntriesPerFile, string directoryName)
  {
    _maxEntriesPerFile = maxEntriesPerFile;
    _directoryName = directoryName;
  }

  public void AddRecord(string visitorName, DateTime timeOfVisit)
  {
    string[] filePaths = Directory.GetFiles(_directoryName);
    (int index, string path)[] sorted = SortByIndex(filePaths);

    string newRecord = visitorName + ';' + timeOfVisit;

    if (sorted.Length == 0)
    {
      string newFile = Path.Combine(_directoryName, "audit_1.txt");
      File.WriteAllText(newFile, newRecord);
      return;
    }

    (int currentFileIndex, string currentFilePath) = sorted.Last();
    List<string> lines = File.ReadAllLines(currentFilePath).ToList();

    if (lines.Count < _maxEntriesPerFile)
    {
      lines.Add(newRecord);
      string newContent = string.Join("\r\n", lines);
      File.WriteAllText(currentFilePath, newContent);
    }
    else
    {
      int newIndex = currentFileIndex + 1;
      string newName = $"audit_{newIndex}.txt";
      string newFile = Path.Combine(_directoryName, newName);
      File.WriteAllText(newFile, newRecord);
    }
  }
}
```

* `AuditManager`는 응용 프로그램의 주요 클래스입니다. 

* 클래스의 유일한 공개 메서드는 방문자 기록 시스템의 모든 작업을 수행하는 `AddRecord`입니다. 

  - 작업 디렉토리에서 전체 파일 목록을 검색합니다 
  - 인덱스별로 정렬합니다
  - 아직 감사 파일이 없으면 단일 레코드로 첫 번째 파일을 만듭니다 
  - 감사 파일이 있는 경우 가장 최근의 것을 얻고 새 레코드를 추가하거나 새 파일을 만듭니다. 

* `AuditManager` 클래스는 파일 시스템과 강하게 결합되어 있어 테스트하기 어렵습니다. 

* 파일 시스템은 공유 의존성이므로 테스트를 병렬화하기 어렵고, 테스트 속도가 느리며 유지보수 비용이 높습니다. 

| | 초기 버전 |
|:--|:--|
| 회귀 방지 | 좋음 |
| 리팩토링 내성 | 좋음 |
| 빠른 피드백 | 나쁨 | 
| 유지보수성 | 나쁨 | 

이러한 테스트는 단위 테스트 정의(빠르고 격리된 실행)에 맞지 않으므로 통합 테스트로 분류됩니다.

##### 6.4.2 목을 사용하여 파일 시스템으로부터 테스트 분리

* 강하게 결합된 테스트 문제에 대한 일반적인 해결책은 파일 시스템을 목으로 대체하는 것입니다. 

* 파일 작업(`Directory.GetFiles`, `File.WriteAllText`, `File.ReadAllLines`)을 `IFileSystem` 인터페이스로 추출하고 `AuditManager`에 주입합니다.

```
public interface IFileSystem
{
  string[] GetFiles(string directoryName);
  void WriteAllText(string filePath, string content);
  List<string> ReadAllLines(string filePath);
}
```

```
public class AuditManager
{
  private readonly int _maxEntriesPerFile;
  private readonly string _directoryName;
  private readonly IFileSystem _fileSystem;   // 새 파일 시스템 인터페이스
  
  public AuditManager(
    int maxEntriesPerFile,
    string directoryName,
    IFileSystem fileSystem)
  {
    _maxEntriesPerFile = maxEntriesPerFile;
    _directoryName = directoryName;
    _fileSystem = fileSystem;   // 새 파일 시스템 인터페이스
  }
}
```

```
public void AddRecord(string visitorName, DateTime timeOfVisit)
{
  // 새 파일 시스템 인터페이스
  string[] filePaths = _fileSystem
    .GetFiles(_directoryName);
  (int index, string path)[] sorted = SortByIndex(filePaths);
  
  string newRecord = visitorName + ';' + timeOfVisit;

  if (sorted.Length == 0)
  {
    string newFile = Path.Combine(_directoryName, "audit_1.txt");
    // 새 파일 시스템 인터페이스
    _fileSystem.WriteAllText(
      newFile, newRecord);
    return;
  }

  (int currentFileIndex, string currentFilePath) = sorted.Last();
  List<string> lines = _fileSystem
    .ReadAllLines(currentFilePath);

  if (lines.Count < _maxEntriesPerFile)
  {
    lines.Add(newRecord);
    string newContent = string.Join("\r\n", lines);
    // 새 파일 시스템 인터페이스
    _fileSystem.WriteAllText(
      currentFilePath, newContent);
  }
  else
  {
    int newIndex = currentFileIndex + 1;
    string newName = $"audit_{newIndex}.txt";
    string newFile = Path.Combine(_directoryName, newName);
    // 새 파일 시스템 인터페이스
    _fileSystem.WriteAllText(
      newFile, newRecord);
  }
}
```

* 이제 `AuditManager`가 파일 시스템에서 분리되었으므로 공유 종속성이 사라지고 테스트가 서로 독립적으로 실행될 수 있습니다. 

```
[Fact]
public void A_new_file_is_created_when_the_current_file_overflows()
{
  var fileSystemMock = new Mock<IFileSystem>();
  fileSystemMock
    .Setup(x => x.GetFiles("audits"))
    .Returns(new string[]
    {
      @"audits\audit_1.txt",
      @"audits\audit_2.txt"
    });
  fileSystemMock
    .Setup(x => x.ReadAllLines(@"audits\audit_2.txt"))
    .Returns(new List<string>
    {
      "Peter; 2019-04-06T16:30:00",
      "Jane; 2019-04-06T16:40:00"
      "Jack; 2019-04-06T17:00:00"
    });
  var sut = new AuditManager(3, "audits", fileSystemMock.Object);

  sut.AddRecord("Alice", DateTime.Parse("2019-04-06T18:00:00"));
  
  fileSystemMock.Verify(x => x.WriteAllText(
    @"audits\audit_3.txt",
    "Alice;2019-04-06T18:00:00"));
}
```

* 이 테스트는 현재 파일의 항목 수가 제한(3개)에 도달하면 단일 방문자 기록 항목이 있는 새 파일이 생성되는지 확인합니다.

* 응용 프로그램은 최종 사용자가 볼 수 있는 파일을 만듭니다. 

* 파일 시스템과의 통신 및 이러한 통신의 부수 효과(파일의 변경)은 애플리케이션의 관찰 가능한 동작의 일부입니다. 
  - 이 경우는 목에 대한 유일한 정당한 사용 사례입니다.

* 테스트는 더 이상 파일 시스템에 액세스하지 않기 때문에 더 빠르게 실행됩니다.

* 테스트를 만족시키기 위해 파일 시스템을 관리할 필요가 없기 때문에 유지 관리 비용도 줄어듭니다. 

| | 초기 버전 | 목 전환 |
|:--|:--|:--|
| 회귀 방지 | 좋음 | 좋음 |
| 리팩토링 내성 | 좋음 | 좋음 |
| 빠른 피드백 | 나쁨 | 좋음 |
| 유지보수성 | 나쁨 | 괜찮음 |

* 테스트에는 복잡한 설정이 포함되어 있으며, 이는 유지 보수 비용 측면에서 이상적이지 않습니다. 

* 결과 테스트는 여전히 일반 입력 및 출력에 의존하는 테스트만큼 읽기 쉽지 않습니다.

##### 6.4.3. 함수형 아키텍처로 리팩토링

* 부수 효과를 `AuditManager` 클래스 밖으로 완전히 이동시킵니다. 

* `AuditManager`는 파일에 대한 결정만 내리고, 새로운 `Persister` 클래스가 그 결정에 따라 파일 시스템에 업데이트를 적용합니다.

```
public class AuditManager
{
  private readonly int _maxEntriesPerFile;

  public AuditManager(int maxEntriesPerFile)
  {
    _maxEntriesPerFile = maxEntriesPerFile;
  }

  public FileUpdate AddRecord(
    FileContent[] files,
    string visitorName,
    DateTime timeOfVisit)
  {
    (int index, FileContent file)[] sorted = SortByIndex(files);
    
    string newRecord = visitorName + ';' + timeOfVisit;
    
    if (sorted.Length == 0)
    {
      // 업데이트 지침을 반환
      return new FileUpdate(
        "audit_1.txt", newRecord);
    }
    
    (int currentFileIndex, FileContent currentFile) = sorted.Last();
    List<string> lines = currentFile.Lines.ToList();

    if (lines.Count < _maxEntriesPerFile)
    {
      lines.Add(newRecord);
      string newContent = string.Join("\r\n", lines);
      // 업데이트 지침을 반환
      return new FileUpdate(
        currentFile.FileName, newContent);
    }
    else
    {
      int newIndex = currentFileIndex + 1;
      string newName = $"audit_{newIndex}.txt";
      // 업데이트 지침을 반환
      return new FileUpdate(
        newName, newRecord);
    }
  }
}
```

* `AuditManager`는 이제 작업 디렉토리 경로 대신 `FileContent`의 배열을 허용합니다.

* 이 클래스에는 `AuditManager`가 결정을 내리기 위해 파일에 대해 알아야 할 모든 것이 포함되어 있습니다.

```
public class FileContent
{
  public readonly string FileName;
  public readonly string[] Lines;

  public FileContent(string fileName, string[] lines)
  {
    FileName = fileName;
    Lines = lines;
  }
}
```

* 작업 디렉토리의 파일을 변경하는 대신 `AuditManager`는 이제 수행하려는 부수 효과에 대한 지침을 반환합니다.

```
public class FileUpdate
{
  public readonly string FileName;
  public readonly string NewContent;
  
  public FileUpdate(string fileName, string newContent)
    FileName = fileName;
    NewContent = newContent;
  }
}
```

* `Persister`는 변경 가능한 껍질 역할을 하며, 작업 디렉토리에서 내용을 읽어 `AuditManager`에 전달하고, `AuditManager`에서 받은 업데이트를 파일 시스템에 적용합니다. 

* `Persister`는 `if` 문이 없는 매우 간단한 클래스입니다.

```
public class Persister
{
  public FileContent[] ReadDirectory(string directoryName)
  {
    return Directory
      .GetFiles(directoryName)
      .Select(x => new FileContent(
        Path.GetFileName(x),
        File.ReadAllLines(x)))
          .ToArray();
  }
  
  public void ApplyUpdate(string directoryName, FileUpdate update)
  {
    string filePath = Path.Combine(directoryName, update.FileName);
    File.WriteAllText(filePath, update.NewContent);
  }
}
```
 
* 모든 복잡성은 `AuditManager` 클래스에 있습니다. 
  - 이것이 비즈니스 논리와 행동의 부수 효과 사이의 분리입니다. 
  - 기능적 핵심 역할을 하여 파일 시스템의 가상의 상태(FileContent 배열)를 입력받아 파일 업데이트 지시(FileUpdate 객체)를 반환합니다.

* `FileUpdate`는 `AuditManager`가 수행하려는 부수 효과에 대한 지시를 담은 객체입니다.

```
public class FileContent
{
  public readonly string FileName;
  public readonly string Text; // previously, string[] Lines;
}
```

* `ApplicationService`는 `AuditManager`와 `Persister`를 연결하는 역할을 합니다 (육각형 아키텍처의 애플리케이션 서비스 계층).

```
public class ApplicationService
{
  private readonly string _directoryName;
  private readonly AuditManager _auditManager;
  private readonly Persister _persister;

  public ApplicationService(
    string directoryName, int maxEntriesPerFile)
  {
    _directoryName = directoryName;
    _auditManager = new AuditManager(maxEntriesPerFile);
    _persister = new Persister();
  }

  public void AddRecord(string visitorName, DateTime timeOfVisit)
  {
    FileContent[] files = _persister.ReadDirectory(_directoryName);
    FileUpdate update = _auditManager.AddRecord(
      files, visitorName, timeOfVisit);
    _persister.ApplyUpdate(_directoryName, update);
  }
}
```

* 애플리케이션 서비스는 외부 클라이언트를 위한 시스템에 대한 진입점도 제공합니다.

* 이 구현을 통해 방문자 기록 시스템의 동작을 쉽게 확인할 수 있습니다.

@Row {
  @Column {
    @Image(source: 6-9.png)
  }
  @Column {}
}


```
[Fact]
public void A_new_file_is_created_when_the_current_file_overflows()
{
  var sut = new AuditManager(3);
  var files = new FileContent[]
  {
    new FileContent("audit_1.txt", new string[0]),
    new FileContent("audit_2.txt", new string[]
    {
      "Peter; 2019-04-06T16:30:00",
      "Jane; 2019-04-06T16:40:00",
      "Jack; 2019-04-06T17:00:00"
    })
  };

  FileUpdate update = sut.AddRecord(
    files, "Alice", DateTime.Parse("2019-04-06T18:00:00"));
  
  Assert.Equal("audit_3.txt", update.FileName);
  Assert.Equal("Alice;2019-04-06T18:00:00", update.NewContent);
}
```

* 이 리팩토링을 통해 `AuditManager`의 테스트는 더 이상 목 객체를 사용하지 않고, 가상의 파일 시스템 상태를 입력으로 제공하고 `FileUpdate` 객체를 출력으로 검증하는 출력 기반 테스트가 됩니다.

* 이는 테스트의 유지보수성을 크게 향상시킵니다.
  
| | 초기 버전 | 목 전환 | 출력 기반 |
|:--|:--|:--|:--|
| 회귀 방지 | 좋음 | 좋음 | 좋음 |
| 리팩토링 내성 | 좋음 | 좋음 | 좋음 |
| 빠른 피드백 | 나쁨 | 좋음 | 좋음 |
| 유지보수성 | 나쁨 | 괜찮음 | 좋음 |

##### 6.4.4 더 개발할 거리 찾아보기

우리가 만든 시스템은 단순하고 세 가지 분기만 포함되어 있습니다.

  * 빈 작업 디렉토리의 경우 새 파일 만들기 
  * 기존 파일에 새 레코드 추가하기 
  * 현재 파일의 항목 수가 제한을 초과할 때 다른 파일 만들기

또한, 단 하나의 유즈케이스가 있습니다
  
  * 로그에 새 항목을 추가하기 

다음과 같은 기능들이 추가될 수 있습니다.

  * 특정 방문자의 모든 기록 삭제
    - 이 기능은 여러 파일에 영향을 미칠 수 있으며, 여러 파일 업데이트 지침(`FileUpdate` 또는 `FileAction` 배열)을 반환해야 할 수 있습니다.

  * 빈 파일 처리
    - 항목이 모두 삭제될 경우 빈 파일을 제거하는 요구사항이 추가될 수 있으며, 이를 위해 `FileUpdate`를 `FileAction`으로 이름을 변경하고 `ActionType` 열거형 필드(업데이트 또는 삭제)를 도입하는 것을 고려해볼 수 있습니다.

  * 오류 처리
    - 함수형 아키텍처를 사용하면 오류를 메서드 시그니처에 명시적으로 포함하여 오류 처리를 더 간단하고 명확하게 할 수 있습니다.
    - 이 경우 애플리케이션 서비스는 이 오류를 확인하고 사용자에게 메시지를 전달할 것입니다.

### 6.5 함수형 아키텍처의 단점

함수형 아키텍처는 항상 달성 가능한 것은 아니며, 유지보수 이점은 성능 영향 및 코드베이스 크기 증가로 상쇄될 수 있습니다.

##### 6.5.1 함수형 아키텍처의 적용 가능성

* 모든 입력을 미리 수집할 수 있는 시스템에 적합합니다.

* 의사 결정 과정의 중간 결과에 따라 프로세스 외부 의존성으로부터 추가 데이터를 쿼리해야 하는 복잡한 실행 흐름에서는 기능 아키텍처를 유지하기 어렵습니다.

@Row {
  @Column {
    @Image(source: 6-10.png)
  }
  @Column {}
}

* 이 경우 두가지 해결책이 있습니다.
  - 모든 외부 읽기 및 쓰기를 가장자리로 밀어넣기
    + 추가 데이터를 `AuditManager`에 전달하기 전에 애플리케이션 서비스에서 미리 모든 필요한 데이터를 수집하는 방식입니다. 
    + 이 접근 방식은 비즈니스 로직(`AuditManager`)과 외부 시스템(데이터베이스)과의 통신 분리를 온전히 유지합니다. 
    + `AuditManager`는 여전히 순수 함수로 남아있어, 모든 의사 결정은 `AuditManager`에서 이루어집니다. 
    + 이는 도메인 모델의 테스트 용이성을 높여줍니다.
    + 필요하지 않은 경우에도 데이터베이스를 무조건적으로 쿼리하게 되므로 성능이 저하될 수 있습니다.
  - 의사 결정 프로세스를 더 세분화된 단계로 분할
    + 새로운 메서드를 도입하여 데이터가 필요한지 여부를 먼저 결정하도록 합니다. 
    + 애플리케이션 서비스는 이 메서드를 호출하여 `true`를 반환하면 데이터베이스에서 데이터를 가져와 기존 메서드에 전달합니다.
    + 접근 수준 확인이 필요할 때만 데이터베이스를 쿼리하므로 성능을 유지할 수 있습니다.
    + `AuditManager`는 여전히 외부 종속성에 직접 의존하지 않으므로 도메인 모델의 테스트 용이성을 유지할 수 있습니다.
    + 데이터베이스를 호출할지 여부에 대한 의사 결정이 애플리케이션 서비스로 이동하게 되므로 비즈니스 로직과 외부 시스템 통신 간의 분리 정도가 다소 저하됩니다.
    + 이는 컨트롤러에 의사 결정 지점을 추가하여 컨트롤러의 복잡성을 증가시킵니다.

##### 6.5.2 성능 저하
* 함수형 아키텍처는 시스템이 프로세스 외부 의존성에 더 많은 호출을 하도록 만들 수 있어 전반적인 시스템 성능에 영향을 줄 수 있습니다. 

* 예를 들어, 모든 파일을 미리 읽어와야 하는 경우 원래 버전보다 더 많은 I/O 작업을 수행할 수 있습니다.

* 이는 성능과 코드 유지보수성 사이의 트레이드오프입니다.

##### 6.5.3 코드베이스 크기 증가
* 기능 아키텍처는 기능적 핵심과 변경 가능 껍질을 명확히 분리하기 위해 추가적인 코딩이 필요하며, 이는 초기 코드베이스 크기를 증가시킬 수 있습니다.

* 모든 프로젝트가 이러한 초기 투자에 대한 충분한 복잡성이나 중요도를 가지지 않으므로, 기능 아키텍처는 전략적으로 적용되어야 합니다.

* 목표는 모든 테스트를 출력 기반 스타일로 전환하는 것이 아니라, 합리적으로 가능한 한 많은 테스트를 출력 기반 스타일로 전환하는 것입니다.
