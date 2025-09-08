# Protocol-Oriented Programming in Swift

스위프트 디자인의 중심에는 두 가지 믿기지 않는 강력한 아이디어가 있습니다: 프로토콜 지향 프로그래밍(protocol-oriented progmamming)과 일급 값 의미론(first-class value semantics). 각각은 예측 가능성 및 성능 그리고 생산성에 도움이 되지만, 함께 사용하면 우리가 프로그래밍할 때의 사고를 바꿀 수도 있습니다. 당신이 작성한 코드를 개선하기 위해 이러한 아이디어를 어떻게 적용할 수 있는지 알아보세요.

@Metadata {
  @CallToAction(purpose: link,
                url:"https://devstreaming-cdn.apple.com/videos/wwdc/2015/408509vyudbqvts/408/408_hd_protocoloriented_programming_in_swift.mp4",
                label: "보기 (45분)")
  @TitleHeading("Session 408")
}

--- 

#### 크러스티

@Row {
  @Column { ![Crusty](15-Session-408-1.png) }
}

이 세션은 구식 개발자 크러스티와 발표자와의 대담으로 구성됩니다.

크러스티는 디버거를 신용하지 않고, IDE도 사용하지 않는 구식 프로그래머입니다.

객체지향을 아주 싫어하죠. 객체지향은 오래된 프로그래밍 방법론이고, 많은 개발자들이 현재까지 사용하고 있습니다.

---

#### 클래스

* 캡슐화(Encapsulation)

    - 연관된 데이터와 활동을 그룹화 시킬 수 있습니다.

* 접근 제어(Access Control)

    - 코드 외부와 내부를 분리하기 위한 벽을 세워, 불변성을 유지할 수 있습니다.

* 추상화(Abstraction)

    - 관련성 있는 아이디어를 표현하는 의사소통 채널로 클래스를 사용할 수 있습니다.

* 이름 공간(Namespace)

    - 소프트웨어 성장에 따른 충돌을 예방할 수 있도록 하는 공간을 제공합니다.
    
* 놀라운 표현 구문(Expressive Syntax)

    - 메소드 호출과 속성 그리고 이들을 같이 엮도록 작성할 수 있습니다.

    - 서브스크립트를 만들 수 있고, 심지어 연산 프로퍼티도 만들 수 있습니다."

* 확장성(Extensibility)

    - 클래스는 확장 가능성이 열려있습니다.

    - 클래스 작성자가 필요한 무언가를 빼먹었다면, 나중에 그것을 추가할 수 있습니다.

&nbsp;

무엇보다 중요한 점은 클래스는 우리에게 복잡함을 관리하도록 한다는 것입니다.
    
무언가를 객체로 표현하고 객체 간의 메소드 교환으로 나타내면 문제가 명확해지죠.

이를 듣던 크러스티는 코웃음을 칩니다.

    나는 구조체와 열거형을 가지고 그 모든 걸 할 수 있다고.
    
맞는 말입니다. Swift에서 모든 자료형(Types)은 일급 객체이고 따라서 이 모든 이점을 얻을 수 있습니다.
    
@Row {
    @Column { ![Crusty](15-Session-408-2.png) }
    @Column { ![Crusty](15-Session-408-3.png) }
}

---

#### 상속

구조체와 열거형만으로 할 수 없는 것이 있습니다. 상속이죠.

* 코드 공유

    - 슈퍼클래스에서 메소드를 정의하면, 상속을 받는 것만으로 모든 작업을 수행할 수 있습니다.
    
* 사용자 정의

    - 슈퍼클래스에서 오버라이딩 할 수 있는 지점으로 연산을 나누고, 중첩하여 확장이 가능합니다.

상속을 통해 우리는 코드 재사용성을 향상시키고, 개념을 확장시켜 커스터마이징을 합니다.

하지만 그 비용에 대해 크러스티는 불만이 있습니다.

---

#### 불만 #1: 암시적인 공유

@Row {
    @Column { ![Implicit Sharing 1](15-Session-408-4.png) }
    @Column { ![Implicit Sharing 2](15-Session-408-5.png) }
    @Column { ![Implicit Sharing 3](15-Session-408-6.png) }
}


A가 B에게 데이터를 건네줄 때, 정상적인 데이터를 건네주면 B는 "대화가 끝났다"고 생각합니다. 

근데 갑자기 A가 정상적인 데이터에 싫증을 느껴 데이터를 '조랑말'로 변경하게 된다면?

B는 처음에 받은 정상적인 데이터를 기대했는데, 데이터를 확인해 보니 '조랑말' 데이터를 얻게 됩니다.
    
문제는 B가 데이터를 얻기 전에는 이런 일이 발생했는지 알 수 없다는 것입니다.

크러스티는 이 문제가 어떻게 흘러갈지 설명합니다.
     
    개발자는 코드 내의 버그를 뭉개버리기 위해서 미친듯이 모든 것을 복사하기 시작할거야.
    하지만, 복사본이 많아질수록 코드가 느려지겠지.
      
    그러던 어느날 디스패치 큐(Dispatch queue)에서 작업을 처리하다가
    갑자기 경쟁 상태(Race condition)에 빠져버렸어.
    스레드는 가변(mutable)상태를 공유하니까.

    그래서 불변성을 추가하기 위해서 잠금(lock)을 걸겠지.
    하지만 잠금을 걸면 코드가 더 느려지고, 교착(deadlock)에 빠져버릴거야.
    이렇게 점점 복잡성이 증가하고, 나중에는 이런 상황을 한 단어로 요약할 수 있겠지 - 버그.
 
이 상황은 Cocoa 프로그래머에게 전혀 새로운 것이 아닙니다.

예를 들어, 가변 컬렉션 수정에 관한 Cocoa 문서에는 이러한 경고가 있습니다.

> 변경 가능한 컬렉션을 통해 열거하는 동안 컬렉션을 수정하는 것은 안전하지 않습니다. 일부 열거자는 현재 수정된 컬렉션의 열거를 허용할 수 있지만 이 동작은 향후에 지원된다는 보장이 없습니다.

다행히 이는 Swift에 적용되지 않습니다. Swift 컬렉션은 모두 값 타입이기 때문입니다.

---

#### 불만 #2: 클래스 상속

* 신중한 슈퍼클래스 선택

    - 딱 하나의 클래스만 상속 가능

    - 여러 속성을 추상화한 데이터 모델에는 적용 불가

* 상속 한번에 걸리는 높은 부하
    
    - 하나의 슈퍼클래스에 관련된 모든 것을 정의

* 소급적용이 없는 모델링

    - 천천히 확장할 수 없고, 정의하는 순간에 지정

* 슈퍼클래스의 저장 속성

    - 슈퍼클래스에 있는 속성은 강제적으로 수용하고 초기화도 필요

    - 불변성을 깨지 않고 슈퍼클래스와 상호 작용하는 방법이 복잡함

* 메소드 사용처 예측하기 
    
    - 클래스 작성자는 메소드의 용도를 예측하여 작성
    
    - `final`을 사용하지 않고 메소드를 오버라이딩할 여지를 남겨둠

&nbsp;

Cocoa 프로그래머에게 이런 것들은 별로 새롭지 않습니다.

이런 이유로 우리는 Cocoa의 모든 곳에 위임 패턴(delegate pattern)을 만듭니다.
 
---

#### 불만 #3: 타입 관계의 부재 (예제: 정렬된 배열에 대한 이진 검색)
 
비교와 같은 대칭 연산에서 타입 간의 관계는 아주 중요합니다.
 
예를 들어 이진 검색에서는 두 요소를 비교할 방법이 필요합니다.

```
class Ordered {
    func precedes(other: Ordered) -> Bool {
        ... 
    }
}

func binarySearch(sortedKeys: [Ordered], forKey k: Ordered) -> Int {
    var lo = 0, hi = sortedKeys.count
    while hi > lo {
        let mid = lo + (hi - lo) / 2
        if sortedKeys[mid].precedes(k) { lo = mid + 1 }
        else { hi = mid }
    }
    return lo
}
```

Swift는 `precedes` 메서드의 바디를 먼저 작성하기를 요구합니다.

하지만 우리는 아직 `Ordered` 인스턴스에 대해 아무것도 모릅니다.

그저 트랩을 만드는 것 외에 할 수 있는 것이 없죠.

```
class Ordered {
    func precedes(other: Ordered) -> Bool { 
        fatalError("implement me!") 
    }
}
```

이 방식은 우리가 타입 시스템과 싸우고 있다는 신호입니다.

각 서브클래스가 메서드를 구현하는게 당연한 문제로 여기죠.

여기 `Double` 값을 가진 서브 클래스 `Number`가 있습니다.

```
class Label: Ordered { var text: String = "" ... }

class Number: Ordered {
    var value: Double = 0 
    override func precedes(other: Ordered) -> Bool {
        // Ordered에는 value 프로퍼티가 없음.
        return value < other.value  
    }
}
```

이때, `precedes` 메서드의 시그니처 `other`에는 `value` 프로퍼티가 있을지 알 수 없습니다. 

실제로는 `text` 프로퍼티를 가진 `Label`일 수도 있죠.

그래서 다운캐스팅을 해야 합니다.

```
class Number: Ordered {
    var value: Double = 0 
    override func precedes(other: Ordered) -> Bool {
        return value < (other as! Number).value
    }
}
```

`other`가 `Label`로 밝혀졌다고 가정해봅시다. 다시 트랩입니다.

처음 `precedes`메서드를 작성할 때와 비슷한 코드 스멜(code smell)이 발생했어요.

이는 클래스로는 `self`의 타입과 `other`의 타입 사이의 관계를 표현하지 못하기 때문입니다.

---

#### 프로토콜을 사용한 추상화 (예제: 정렬된 배열에 대한 이진 검색)

우리에게 필요한 것은 더 나은 추상화(abstraction) 메커니즘입니다.

* 값 타입 (및 클래스) 지원

* 정적 타입 관계 (및 동적 디스패치) 지원

* 비독단적

* 소급 적용 모델링 지원

* 인스턴스 데이터를 강요하지 않음

* 초기화 부담을 강요하지 않음

* 구현이 필요한 대상에 대한 명확함

프로토콜은 이 모든 장점을 가지고 있고, Swift는 최초의 프로토콜 지향 프로그래밍 언어로 만들어졌습니다.

조금 전 예제를 프로토콜을 사용하여 추상화 해보겠습니다.

먼저 프로토콜이 필요하죠.

```
protocol Ordered {
    // 프로토콜 메서드는 본문를 가질 수 없음.
    func precedes(other: Ordered) -> Bool { fatalError("implement me!") }
}
```

이것은 긍적적으로 해석할 수 있습니다.

메서드에 대해 정적인 검사에서, 동적인 런타임 검사로 전환한다는 의미이기 때문입니다.

```
protocol Ordered {
    func precedes(other: Ordered) -> Bool
}
```

그 다음, 오버라이딩할 메서드가 없다고 합니다.

```
protocol Ordered {
    func precedes(other: Ordered) -> Bool
}

class Number : Ordered {
    var value: Double = 0
    // 이 메서드는 슈퍼클래스의 어떤 메서드도 오버라이딩 하지 않음.
    override func precedes(other: Ordered) -> Bool {
        return self.value < (other as! Number).value
    }
}
```

물론이죠. 더 이상 베이스 클래스가 없으니까요.

그러면 이제는 `Number`가 클래스일 필요도 없겠죠.

```
protocol Ordered {
    func precedes(other: Ordered) -> Bool
}

struct Number : Ordered {
    var value: Double = 0
    func precedes(other: Ordered) -> Bool {
        return self.value < (other as! Number).value
    }
}
```

이제 프로토콜이 첫번째 예제의 클래스와 똑같은 역할을 하고 있습니다.

하지만 여전히 강제 다운캐스트가 필요하기 때문에, `other`를 `Number`로 만들고 타입 캐스팅을 삭제하고 싶습니다.

이제 Swift가 시그니처가 일치하지 않는다고 하네요.

```
protocol Ordered {
    func precedes(other: Ordered) -> Bool
}

struct Number : Ordered {
    var value: Double = 0
    func precedes(other: Number) -> Bool {
        // 프로토콜에는 '(Ordered) -> Bool' 타입의 'precedes' 함수가 필요합니다.
        // 후보가 일치하지 않는 타입 '(Number) -> Bool'을 가집니다.
        return self.value < other.value
    }
}
```

이 문제를 해결하려면 프로토콜 시그니처에서 `Ordered`를 `Self`로 바꿔야 합니다.

이를 자체 요구사항(Self requirement)이라고 합니다.

```
protocol Ordered {
    func precedes(other: Self) -> Bool
}

struct Number : Ordered {
    var value: Double = 0
    func precedes(other: Number) -> Bool {
        return self.value < other.value
    }
}
```

다시 유효한 코드가 생겼습니다. 이 프로토콜을 어떻게 사용하는지 살펴보겠습니다.

```
// 프로토콜 'Ordered'는 일반 제약 조건으로만 사용할 수 있습니다.
// Self 또는 연관된 타입 요구사항이 있기 때문입니다.
func binarySearch(sortedKeys: [Ordered], forKey k: Ordered) -> Int {
    var lo = 0
    var hi = sortedKeys.count
    while hi > lo {
        let mid = lo + (hi - lo) / 2
        if sortedKeys[mid].precedes(k) { lo = mid + 1 }
        else { hi = mid }
    }
    return lo
}
```

이것은 `Ordered`가 클래스일 때 작동했던 이진 검색입니다.

`[Ordered]`라는 것은 이질적인(heterogeneous) `Ordered` 타입을 처리하겠다는 말이죠.

배열 내에는 `Number`와 `Label`이 섞여 있을 겁니다.

`Ordered`에 자체 요구사항을 추가했으니, 컴파일러는 아마 이것을 동질하게(homogeneous) 만들도록 강제할 것입니다.

이제 `Ordered`를 단일 타입 'T'의 동질한 배열로 고치겠습니다.

```
func binarySearch<T : Ordered>(sortedKeys: [T], forKey k: T) -> Int {
    var lo = 0
    var hi = sortedKeys.count
    while hi > lo {
        let mid = lo + (hi - lo) / 2
        if sortedKeys[mid].precedes(k) { lo = mid + 1 }
        else { hi = mid }
    }
    return lo
}
```

배열을 강제로 동질하게 만드는 것이 너무 제한적이거나, 기능과 유연성을 잃는 것 같다고 생각할 수 있습니다.

하지만 생각해 보면 기존 시그니처는 트랩을 만드는 것 외에 아무것도 하지 않았습니다.

프로토콜에 자체 요구사항을 추가하면 다음과 같이 큰 차이가 발생합니다.

| **Without Self Requirement** | **With Self Requirement** |
|:-- | :-- |
| *타입으로 사용 가능* | *제네릭으로만 사용 가능* |
| *`func sort(inout a: [Ordered])`* | *`func sort<T : Ordered>(inout a: [T])`* |
| *이질적(heterogeneous)* | *동질적(homogeneous)* |
| 각 모델들이 다른 모든 타입의 모델을 처리해야 함 | 모델 타입 간의 상호 작용에서 자유로움 |
| 동적 디스패치 | 정적 디스패치 |
| 낮은 최적화 | 높은 최적화 | 

---

#### 프로토콜 지향 프로그래밍 (예제: 다이어그램 그리기)

본격적으로 객체 지향을 프로토콜로 대체할 수 있는지 보겠습니다.

저는 도형을 드래그 앤 드롭해서 도형과 상호작용할 수 있는 작은 다이어그램 앱을 염두에 두고 있었어요.

그래서 크러스티에게 디스플레이 모델을 만들어 달라고 부탁했죠.

먼저 그는 그리기 모델을 만들었습니다.

```
struct Renderer {
    func moveTo(p: CGPoint) { print("moveTo(\(p.x), \(p.y))") }
    func lineTo(p: CGPoint) { print("lineTo(\(p.x), \(p.y))") }
    func arcAt(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat) {
        print("arcAt(\(center), radius: \(radius)," + " startAngle: \(startAngle), endAngle: \(endAngle))")
    }
}
```

그리고 모든 그리기 요소에 공통 인터페이스를 제공하는 `Drawable` 프로토콜을 만들었죠. 

```
protocol Drawable {
    func draw(renderer: Renderer)
}
```

다음으로 `Polygon`을 만들었습니다.

`Polygon`은 값 타입으로 각 모서리에 대한 배열을 프로퍼티로 가지고 있습니다.

다각형을 그리려면 마지막 모서리로 이동한 다음 모든 모서리를 순환하며 선을 그리면 됩니다.

```
struct Polygon : Drawable {
    func draw(renderer: Renderer) {
        renderer.moveTo(corners.last!)
        for p in corners {
            renderer.lineTo(p)
        }
    }
    var corners: [CGPoint] = []
}
```

이번에는 `Circle`을 봅시다.

`Circle` 역시 값 타입으로, `center`와 `radius`을 포함하는 구조체입니다.

원을 그리려면 0에서 2π 라디안까지 이어지는 호를 그립니다.

```
struct Circle : Drawable {
    func draw(renderer: Renderer) {
        renderer.arcAt(center, radius: radius, startAngle: 0.0, endAngle: twoPi)
    }
    var center: CGPoint
    var radius: CGFloat
}
```

이제 원과 다각형이 있으니, 다이어그램을 만들 수 있습니다.

크러스티가 말했습니다.

    한 번 달려볼까

그리고 `Diagram`을 만들었습니다.

```
struct Diagram : Drawable {
    func draw(renderer: Renderer) {
        for f in elements {
            f.draw(renderer)
        }
    }
    var elements: [Drawable] = []
}
```

`Diagram`은 `Drawable`이고, 또 다른 값 타입입니다.

모든 `Drawable`은 값 타입이고, `[Drawable]`도 값 타입이기 때문입니다.

다이어그램을 그리려면 모든 그리기 요소들을 반복해서 하나씩 그리면 됩니다.

테스트해 봅시다.

크러스티는 중심과 반지름이 특정한 `circle`을 만들었습니다.

그리고 `triangle`을 추가하고 마지막으로 `diagram`을 만들어 그리라고 지시했습니다.

```
var circle = Circle(center: CGPoint(x: 187.5, y: 333.5), radius: 93.75)

var triangle = Polygon(corners: [ 
    CGPoint(x: 187.5, y: 427.25),
    CGPoint(x: 268.69, y: 286.625),
    CGPoint(x: 106.31, y: 286.625) 
])

var diagram = Diagram(elements: [circle, triangle])

diagram.draw(Renderer())
```

    짜잔!

크러스티는 승리의 환호성을 지르며 말했습니다.

    원 안에 있는 정삼각형이 잘 보이지?

저는 크러스티만큼 머릿속으로 삼각형을 그리는데 능숙하지 않나 봅니다.

    아니요, 크러스티, 내 눈에는 안보여요.
    화면에 그림을 그리는 것처럼 실용적이였다면 이 데모가 훨씬 더 설득력 있었을 텐데요.

짜증을 가라앉히고, 저는 `CoreGraphics`를 사용해 그의 `Renderer`를 다시 작성해야겠다고 생각했습니다.

    잠깐 기다려 봐, 애송이.
    그렇게 해버리면 내가 어떻게 코드를 테스트할 수 있겠어?

그는 테스트 값을 텍스트 출력으로 확인할 수 있는 방식을 사용하되, 프로토콜 지향 프로그래밍을 해보자고 제안했습니다.

그리고 `Renderer` 프로토콜을 만들었습니다.

```
protocol Renderer {
    func moveTo(p: CGPoint)
    func lineTo(p: CGPoint)
    func arcAt(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat)
}
```

요구사항을 작성한 다음, 원래 `Renderer`의 이름을 바꾸고 적절하게 만들었습니다.

```
struct TestRenderer : Renderer {
    func moveTo(p: CGPoint) { print("moveTo(\(p.x), \(p.y))") }
    func lineTo(p: CGPoint) { print("lineTo(\(p.x), \(p.y))") }
    func arcAt(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat) {
        print("arcAt(\(center), radius: \(radius)," + " startAngle: \(startAngle), endAngle: \(endAngle))")
    }
}
```

이 리팩터링 작업은 저를 초조하게 만들었고 저는 얼른 `CoreGraphics`를 사용한 렌더러를 구현하고 싶었습니다.

테스트를 마치고 이윽고 만족스러워진 그가 말했습니다.

    Renderer에 뭘 넣을 건데?

저는 대답했죠.

    CGContext요.

`CGContext`에는 기본적으로 렌더러에 필요한 모든 것이 있습니다. C 인터페이스 범위 내라면 그 자체로 렌더러라고 볼 수 있죠.

그가 말했습니다.

    좋아. 키보드 줘봐.

그리고 키보드를 낚아채고는 눈 깜짝할 사이에 끝내버렸습니다.

```
extension CGContext : Renderer {
    func moveTo(p: CGPoint) { }
    func lineTo(p: CGPoint) { }
    func arcAt(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat) { }
}
```

    잠깐만요, 방금 모든 CGContext를 Renderer로 만든 거예요?

그는 아직 뭘 하지도 않았지만, 벌써 새로운 타입을 추가할 필요조차 없었습니다.
    
    뭘 기다리고 있어? 중괄호 안이나 채워.

금새 `CoreGraphics`로 된 렌더러가 만들어졌습니다.

크러스티가 `TestRenderer`에 무엇을 했는지 잠시 되돌아보고 싶습니다.

그는 코드가 수행하는 작업을 자세히 보여주는 테스트 컴포넌트를 연결하고 코드 전체에 이러한 접근 방식을 적용했습니다.

프로토콜로 분리하면 할수록 테스트하기 쉬워집니다.

그리고 이런 방식의 테스트는 모의 테스트(mocks)보다 훨씬 더 낫습니다. 모의 테스트는 본질적으로 취약하죠.

대상을 구현하는 중간에 테스트 컴포넌트를 연결해야 합니다.

그리고 그 취약성 때문에 Swift의 강력한 정적 타입 시스템과는 잘 어울리지 않습니다.

프로토콜은 강제적인 인터페이스를 제공하면서도, 필요한 모든 테스트 측정에 대한 연결 고리를 제공합니다.

---

#### 프로토콜 확장 (예제: 비눗방울 다이어그램)

이제 비눗방울에 대한 얘기를 하러 예제로 돌아가 보겠습니다.

우리는 다이어그램 앱이 아이들에게 인기가 있기를 원했고, 아이들은 비눗방울을 좋아합니다.

비눗방울 다이어그램은 바깥쪽 원과 하이라이트를 나타내는 안쪽 원으로 나타냅니다.

아래 코드를 문맥에 넣었을 때 크러스티는 끓어오르기 시작했고, 지루해하기 시작했습니다.

```
struct Bubble : Drawable {
    func draw(r: Renderer) {
        r.arcAt(center, radius: radius, startAngle: 0, endAngle: twoPi)
        r.arcAt(highlightCenter, radius: highlightRadius,
        startAngle: 0, endAngle: twoPi)
    }
}

struct Circle : Drawable {
    func draw(r: Renderer) {
        r.arcAt(center, radius: radius, startAngle: 0.0, endAngle: twoPi)
    }
}
```
    
    봐봐, 전부 다 동그라미야.
    난 이걸 그냥 이런식으로 적고 싶어.

```
struct Bubble : Drawable {
    func draw(r: Renderer) {
        r.circleAt(center, radius: radius)
        r.circleAt(highlightCenter, radius: highlightRadius)
    }
}

struct Circle : Drawable {
    func draw(r: Renderer) {
        r.circleAt(center, radius: radius)
    }
}
```

제가 말했죠.

    크러스티, 진정하세요.
    프로토콜에 요구사항 하나만 추가하면 되는 거죠?
    그럼 당연히 모델을 업데이트해서 TestRenderer와 CGContext에 구현하면 되잖아요.

```
protocol Renderer {
    func moveTo(p: CGPoint)
    func lineTo(p: CGPoint)
    func circleAt(center: CGPoint, radius: CGFloat)
    func arcAt(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat)
}

extension TestRenderer : Renderer {
    func arcAt(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat)
        arcAt(center, radius: radius, startAngle: 0, endAngle: twoPi)
    }
}

extension CGContext : Renderer {
    func arcAt(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat)
        arcAt(center, radius: radius, startAngle: 0, endAngle: twoPi)
    }
}
```

이제 크러스티는 부츠를 벗고 책상을 두드리고 있습니다. 여전히 코드를 다시 반복하고 있었기 때문입니다.

    나 혼자 다 해야 되네.

그는 중얼거리며 키보드를 뺏어갔어요.

그리고 Swift의 새로운 기능을 사용해 저를 가르치기 시작했죠. 프로토콜 확장입니다.

```
protocol Renderer {
    func moveTo(p: CGPoint)
    func lineTo(p: CGPoint)
    func circleAt(center: CGPoint, radius: CGFloat)
    func arcAt(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat)
}

extension Renderer {
    func circleAt(center: CGPoint, radius: CGFloat) {
        arcAt(center, radius: radius, startAngle: 0, endAngle: twoPi)
    }
}
```

이제 `circleAt` 요구사항에 대해 모든 `Renderer` 모델에는 공유되는 구현이 생겼습니다.

`extension`에 작성된 요구사항은 사용자 정의 지점을 생성한다는 의미입니다.

비교를 위해 요구사항에 없는 메서드를 `extension`에 추가하여 확인해 보겠습니다.

```
protocol Renderer {
    func moveTo(p: CGPoint)
    func lineTo(p: CGPoint)
    func circleAt(center: CGPoint, radius: CGFloat)
    func arcAt(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat)
}

extension Renderer {
    func circleAt(center: CGPoint, radius: CGFloat) { ... }
    func rectangleAt(edges: CGRect) { ... }
}
```

크러스티의 `TestRenderer`를 확장시켜 두 가지 메서드를 모두 구현할 수 있습니다.

```
extension TestRenderer : Renderer {
    func circleAt(center: CGPoint, radius: CGFloat) { ... }
    func rectangleAt(edges: CGRect) { ... }
}

let r = TestRenderer()
r.circleAt(origin, radius: 1);
r.rectangleAt(edges);
```

이 때는 두 메서드 모두 `TestRenderer`의 구현이 직접 호출되고, 프로토콜은 관여하지 않습니다. 

`Renderer` 적합성(conformance)을 제거해도 같은 결과를 얻을 수 있습니다.

```
extension TestRenderer {
    func circleAt(center: CGPoint, radius: CGFloat) { ... }
    func rectangleAt(edges: CGRect) { ... }
}

let r = TestRenderer()
r.circleAt(origin, radius: 1);
r.rectangleAt(edges);
```

하지만 Swift가 모델이 `Renderer` 타입인 것만 알고 있다고 바꿔 보겠습니다.

```
let r: Renderer = TestRenderer()
r.circleAt(origin, radius: 1);
r.rectangleAt(edges);
```

`circleAt`은 요구사항이므로 커스터마이징한 `circleAt`을 호출합니다.

하지만 `rectangleAt`은 요구사항이 아니므로, 프로토콜에서 구현한 내용에 의해 가려집니다. 

즉, 이 문맥에서는 프로토콜의 구현이 호출됩니다. 좀 이상하죠?

`rectangleAt`이 요구사항에 있어야 한다는 뜻일까요?

더 효율적인 방법으로 직사각형을 그리는 렌더러에게는 사용자 정의가 필요할 겁니다.

하지만 프로토콜 확장에 있는 모든 것이 요구사항일 필요는 없습니다.

모든 API가 커스터마이징 포인트가 되야 하는건 아니죠.

---

#### 프로토콜 확장 트릭 #1: 제약된 확장

이 새로운 기능은 우연히도 Swift 표준 라이브러리 작업에 혁신을 가져왔습니다.

이번에는 표준 라이브러리에서 프로토콜 확장으로 한 일들 중 일부를 소개하고, 몇 가지 트릭을 소개해 드리겠습니다.

먼저 메서드 `indexOf`를 보시죠.

```
extension CollectionType {
    public func indexOf(element: Generator.Element) -> Index? {
        for i in self.indices {
            if self[i] == element {
                return i
            }
        }
        return nil
    }
}
```

이것은 동일한 요소를 찾을 때까지 컬렉션의 인덱스를 조회한 다음, 그 인덱스를 반환하는 코드입니다.

찾지 못하면 `nil`을 반환하는 간단한 방식이죠.

하지만 이런 식으로 작성하면 문제가 생깁니다.

컬렉션의 요소들을 `==` 연산자로 비교할 수 없다고 나오죠.

```
extension CollectionType {
    public func indexOf(element: Generator.Element) -> Index? {
        for i in self.indices {
            // 두 개의 Generator.Element 피연산자에 이항 연산자 '=='를 적용할 수 없습니다.
            if self[i] == element {
                return i
            }
        }
        return nil
    }
}
```

이를 해결하기 위해 확장에 제약을 만들 수 있습니다.

```
extension CollectionType where Generator.Element : Equatable {
    public func indexOf(element: Generator.Element) -> Index? {
        for i in self.indices {
            if self[i] == element {
                return i
            }
        }
        return nil
    }
}
```

이 확장은 컬렉션의 `Element` 타입이 `Equatable`일 때 적용된다고 말함으로써

Swift에 동등 비교를 허용하는 데 필요한 정보를 제공한 것입니다.

---

#### 프로토콜 확장 트릭 #2: 소급 적용

제약된 확장의 간단한 예제를 살펴봤으니 이진 검색을 다시 살펴봅시다.

```
protocol Ordered {
    func precedes(other: Self) -> Bool
}

func binarySearch<T : Ordered>(sortedKeys: [T], forKey k: T) -> Int { ... }
```

`Int` 배열에 사용해 보겠습니다.

```
// 'binarySearch'를 호출할 수 없습니다. '([Int], forKey: Int)' 타입의 인자 목록으로 호출할 수 없습니다.
let position = binarySearch([2, 3, 5, 7], forKey: 5)
```

`Int`가 `Ordered`를 따르지 않으니 적합성을 추가해 줍니다.

```
extension Int : Ordered {
    func precedes(other: Int) -> Bool { return self < other }
}

let position = binarySearch([2, 3, 5, 7], forKey: 5)
```

당연히 `String`에도 작동하지 않죠. 다시 적합성을 추가해 줍니다.

```
let position = binarySearch(["2", "3", "5", "7"], forKey: "5")
extension String : Ordered {
    func precedes(other: Int) -> Bool { return self < other }
}
```

이런, 크러스티가 다시 책상을 두들기기 전에 뭔가를 해야겠네요. 

`Comparable` 프로토콜에는 '`<`연산자가 존재합니다.

그래서 `Comparable` 프로토콜을 이렇게 확장할 수 있습니다.

```
extension Comparable {
    func precedes(other: Self) -> Bool { return self < other }
}
extension Int : Ordered {}
extension String : Ordered {}
```

이제 `procedes`의 구현을 `Comparable`에서 대신 제공합니다.

정말 멋지네요. 만약 `Double`에 대한 이진 검색이 필요해지면 적합성을 추가하면 됩니다. 

```
extension Comparable {
    func precedes(other: Self) -> Bool { return self < other }
}
extension Int : Ordered {}
extension String : Ordered {}
extension Double : Ordered {}
```

한편으로는 좀 거슬립니다. `Double`에서 `Ordered` 적합성을 제거하더라도 여전히 `procedes`함수가 붙어있기 때문이죠.

`Double`에 기능을 추가할 때 좀 더 선택적으로 추가하고 싶을 수도 있습니다.

게다가 더는 이진 검색을 할 수 없기 때문에 `precedes` 함수는 아무 도움이 되지 않습니다.

```
extension Comparable {
    func precedes(other: Self) -> Bool { return self < other }
}
extension Int : Ordered {}
extension String : Ordered {}
let truth = 3.14.precedes(98.6) // 컴파일 성공

// 'binarySearch'를 호출할 수 없습니다. '([Double], forKey: Double)' 타입의 인자 목록으로 호출할 수 없습니다.
let position = binarySearch([2.0, 3.0, 5.0, 7.0], forKey: 5.0)
```

다행히도 `Ordered`에 제약된 확장을 사용하여 대상을 선택적으로 지정할 수 있습니다.

```
extension Ordered where Self : Comparable {
    func precedes(other: Self) -> Bool { return self < other }
}
extension Int : Ordered {}
extension String : Ordered {}
let truth = 3.14.precedes(98.6) //'Double'은 이름이 'precedes'인 멤버를 갖고 있지 않습니다.
```

`Comparable` 중 `Ordered`로 선언되는 타입에만 `procedes` 요구사항이 있습니다.

---

#### 프로토콜 확장 트릭 #3: 제네릭 미화

다음으로 넘어가 보겠습니다.

이것은 적절한 인덱스와 타입을 가진 모든 컬렉션에서 동작하는 일반적인 이진 검색의 시그니처입니다.

```
func binarySearch<
    C : CollectionType where C.Index == RandomAccessIndexType,
    C.Generator.Element : Ordered
>(sortedKeys: C, forKey k: C.Generator.Element) -> Int {
    ...
}

let pos = binarySearch([2, 3, 5, 7, 11, 13, 17], 5) 
```

이미 끔찍한 모습이니까 본문은 여기 쓰지 않겠습니다.

Swift 1에는 이와 같은 함수가 많이 있었습니다.

Swift 2에서는 프로토콜 확장을 사용해 이런 메서드로 만들었죠.

```
extension CollectionType where Index == RandomAccessIndexType,
    Generator.Element : Ordered {
    func binarySearch(forKey: Generator.Element) -> Int {
    ...
    }
}

let pos = [2, 3, 5, 7, 11, 13, 17].binarySearch(5)
```

모두가 간단해진 메서드 호출 부분의 개선점에 집중하고 계실텐데요.

```
let pos = [2, 3, 5, 7, 11, 13, 17].binarySearch(5)
```

저는 이진 검색을 작성하는 사람으로서, 메서드 선언과 메서드가 적용되는 조건을 분리하여 읽기 쉽도록 만든 부분이 마음에 듭니다.

더 이상 꺾쇠 괄호로 인해 눈이 아플 일은 없죠.

```
extension CollectionType where Index == RandomAccessIndexType,
    Generator.Element : Ordered {
```

---

#### 값 타입을 `Equatable`로 만들기 (예제: 다이어그램)

이제 다이어그램 예제로 돌아가 보겠습니다.

다이어그램의 모든 값 타입을 `Equatable`로 만들겠습니다.

대부분의 타입에서 `Equatable`로 만드는 방법은 간단합니다.

그냥 특정 부분이 같은지를 비교하면 됩니다.

```
func == (lhs: Polygon, rhs: Polygon) -> Bool {
    return lhs.corners == rhs.corners
}
extension Polygon : Equatable {}

func == (lhs: Circle, rhs: Circle) -> Bool {
    return lhs.center == rhs.center
    && lhs.radius == rhs.radius
}
extension Circle : Equatable {}
```

`Diagram`에서는 어떻게 적용될지 봅시다.

```
struct Diagram : Drawable {
    func draw(renderer: Renderer) { ... }
    var elements: [Drawable] = []
}

func == (lhs: Diagram, rhs: Diagram) -> Bool {
    // 두 개의 [Drawable] 피연산자에 이항 연산자 '=='를 적용할 수 없습니다.
    return lhs.elements == rhs.elements
}
```

음, 두 `elements` 간에는 비교할 수 없군요.

그렇다면 각각을 비교하면 이렇게 할 수 있습니다.

```
struct Diagram : Drawable {
    func draw(renderer: Renderer) { ... }
    var elements: [Drawable] = []
}

func == (lhs: Diagram, rhs: Diagram) -> Bool {
    return lhs.elements.count == rhs.elements.count
        && !zip(lhs.elements, rhs.elements).contains { $0 != $1 }
}
```

같은 개수인지 확인한 다음, 두 배열을 합치고 서로 다른 쌍이 없는지를 찾으면 되죠.

```
struct Diagram : Drawable {
    func draw(renderer: Renderer) { ... }
    var elements: [Drawable] = []
}

func == (lhs: Diagram, rhs: Diagram) -> Bool {
    return lhs.elements.count == rhs.elements.count
        // 두 개의 Drawable 피연산자에 이항 연산자 '!='를 적용할 수 없습니다.
        && !zip(lhs.elements, rhs.elements).contains { $0 != $1 }
}
```

사실 배열을 비교할 수 없었던 이유는 `Drawable`이 `Equatable`이 아니기 때문입니다.

`[Drawable]`에 대한 동등 연산자도 없고, `Drawable`에 대한 동등 연산자도 없으니까요.

모든 `Drawable`을 `Equatable`로 바꿔주겠습니다.

```
struct Diagram : Drawable {
    func draw(renderer: Renderer) { ... }
    var elements: [Drawable] = []
}

func == (lhs: Diagram, rhs: Diagram) -> Bool {
    return lhs.elements.count == rhs.elements.count
        && !zip(lhs.elements, rhs.elements).contains { $0 != $1 }
}

protocol Drawable : Equatable {
    func draw()
}
```

여기서 문제가 하나 있습니다.

`Equatable`에는 자체 요구사항이 있다는 것입니다.

```
protocol Equatable {
    func == (Self, Self) -> Bool
}

protocol Drawable : Equatable {
    func draw()
}
```

그러면 이제 `Drawable`에도 자체 요구사항이 생겼습니다.

자체 요구사항은 `Drawable`에게 동질성을 부여합니다.

하지만 `Diagram`에는 이질적인 `Drawable` 배열이 필요합니다.

그래야 다각형과 원을 같은 다이어그램에 넣을 수 있죠.

모순적이죠. `Drawable`은 `Equatable`일 수 없습니다.

그래서 다음과 같이 다리를 놓겠습니다.

```
struct Diagram : Drawable, Equatable {
    func draw(renderer: Renderer) { ... }
    var elements: [Drawable] = []
}

func == (lhs: Diagram, rhs: Diagram) -> Bool {
    return lhs.elements.count == rhs.elements.count
        && !zip(lhs.elements, rhs.elements).contains { !$0.isEqualTo($1) }
}

protocol Drawable {
    func isEqualTo(other: Drawable) -> Bool
    func draw()
}
```

`Drawable`에 `isEqualTo` 요구사항을 추가하는 거죠.

여전히 이질성을 유지해야 하기 때문에, 자체 요구사항을 사용할 수는 없습니다.

즉, 모든 이질적인 비교 케이스를 처리하도록 강제 다운캐스팅을 해줘야 합니다.

`Ordered` 클래스에서 대칭 연산을 사용했을 때처럼요. 

다행히도 이번에는 탈출구가 있습니다. 대칭 연산과 달리 동등 연산은 특별합니다.

타입이 일치하지 않을 때 명백한 기본 답이 있기 때문이죠.

서로 다른 두 가지 타입이 있다면 같지 않다고 말할 수 있습니다.

이 아이디어를 통해 `Drawable`에 대해 `isEqualTo`를 다음과 같이 구현할 수 있습니다.

```
extension Drawable where Self : Equatable {
    func isEqualTo(other: Drawable) -> Bool {
        if let o = other as? Self { return self == o }
        return false
    }
}
```

먼저 `other`를 `Self` 타입으로 조건부 다운캐스트합니다.

만약 성공하면 `Equatable` 적합성이 있기 때문에 동등 비교를 사용할 수 있습니다.

타입 캐스트에 이질적인 비교에 대한 부담을 넘기고 동질적인 비교가 가능하도록 만들었죠.

정적인 세계와 동적인 세계 사이에 다리를 놓은 것이죠. 

---

#### 마무리

마무리하기 전에 클래스를 언제 사용해야 하는지에 대해 몇 마디 말씀드리고 싶습니다.

클래스는 제자리가 있으니까요. 암시적 공유가 필요할 때가 있습니다.

* 인스턴스 복사 또는 비교가 말이 안되는 경우(예: `Window`)

    - 윈도우를 복사한다는 것은 새 그래픽 윈도우가 현재 윈도우 바로 위에 나타난다는 의미입니다.
        
    - 뷰 계층 구조 상 윈도우는 하나만 존재해야 합니다.

* 인스턴스의 수명이 외부 부작용과 연관된 경우(예: `TemporaryFile`)

    - 컴파일러는 임시 파일들을 자유롭게 생성하고 소멸시키면서 최적화하려고 합니다.

    - 참조 타입은 안정적인 정체성을 가지고 있어 외부 엔티티로 사용이 용이합니다.

* 인스턴스가 외부 상태에 대한 쓰기 전용 통로 역할인 경우(예: `CGContext`)

    - `CGContext`는 그리기 정보를 저장하는 역할을 수행합니다.   

    - 이 때는 `final`을 사용하고, 클래스 상속 대신 프로토콜을 추상화 사용을 권장합니다. 

우리는 객체 지향적인 세상에 살고 있고 Cocoa는 객체를 다룹니다.

프레임워크는 서브클래싱을 요구하고, 서브클래스의 API에는 객체를 기대할 겁니다.

시스템과 싸우지 마세요. 신중해야 합니다.

프로그램의 어떤 것도 너무 커져서는 안 되며 이는 마찬가지로 클래스에도 적용됩니다.

그러니 클래스에서 무언가를 리팩터링하고 팩터링할 때는 값 타입을 사용하는 것을 고려하세요.

감사합니다.
