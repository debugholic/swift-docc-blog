# Protocol-Oriented Programming in Swift

스위프트 디자인의 중심에는 두 가지 믿기지 않는 강력한 아이디어가 있습니다: 프로토콜 지향 프로그래밍(protocol-oriented progmamming)과 일급 값 의미론(first-class value semantics). 각각은 예측 가능성 및 성능 그리고 생산성에 도움이 되지만, 함께 사용하면 우리가 프로그래밍할 때의 사고를 바꿀 수도 있습니다. 당신이 작성한 코드를 개선하기 위해 이러한 아이디어를 어떻게 적용할 수 있는지 알아보세요.

@Metadata {
    @CallToAction(purpose: link,
                  url:"https://devstreaming-cdn.apple.com/videos/wwdc/2015/408509vyudbqvts/408/408_hd_protocoloriented_programming_in_swift.mp4",
                  label: "보기 (45분)")
    @TitleHeading("Session 408")
}

#### 크러스티를 소개합니다(Meet Crusty)
---
@Image(source: 15-Session-408-1.png, alt: nil)

크러스티는 디버거를 신용하지 않고, IDE도 사용하지 않는 구식 프로그래머입니다.

어느 날, 크러스티와 개발에 대해서 이야기를 나누던 중, 그가 이런 말을 합니다.
    
    나는 객재지향은 안해!

객체지향 프로그래밍은 1970년대 이후부터 쭉 있었고, 최신 유행의 프로그래밍 유행이 전혀 아닙니다.

저는 그의 구식 칠판으로 걸어가서 그에게 말했습니다.
    
    객체지향은 멋진 방법입니다. 클래스를 통해서 무엇을 할 수 있는지 보세요.

#### 클래스는 훌륭합니다(Classes Are Awesome)
---
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

무엇보다 중요한 점은 클래스는 우리에게 복잡함을 관리하도록 한다는 것입니다.
    
그것이 바로 소프트웨어 개발에서 해결하려고 노력하는 문제이고, 클래스는 이를 해결합니다.

Crusty는 코웃음을 치며 말했습니다.

    나는 구조체와 열거형을 가지고 그 모든 걸 할 수 있다고
    
맞는 말입니다. Swift에서 우리가 명명한 모든 자료형(Types)은 일급 객체이고 따라서 이 모든 이점을 얻을 수 있습니다.
    
저는 이전으로 돌아가서, 객체지향으로 개발할 때 어떤 주요 기능이 이 모든 것을 가능하게 하는지 되새겨 보았습니다.

#### 상속
---
역시 상속과 같은 클래스로만 할 수 있는 것에서 비롯되어야 합니다.

그리고 이러한 구조가 갖는 코드 공유와 사용자 정의 측면의 이점을 구체적으로 생각했습니다. 

* 코드 공유

    - 슈퍼클래스에서 메소드를 정의하면, 상속을 받는 것만으로 모든 작업을 수행할 수 있습니다.
    
* 사용자 정의

    - 슈퍼클래스에서 오버라이딩 할 수 있는 지점으로 연산을 나누고, 중첩하여 확장이 가능합니다.

이제 나는 그를 이겼음을 확신했습니다.  
    
    클래스의 힘 앞에 무릎 꿇어야 할 겁니다.

그가 대답했습니다.

    잠시만 기다려.    
    
    우선, 나는 구조체를 통해서 이미 커스터마이징를 하거든! 그리고, 클래스 좋지.
    근데 비용에 대해서 얘기해볼까? 나는 클래스에 세 가지 불만이 있어!
        
그리고 그는 불만 사항을 늘여놓기 시작했습니다.

#### 암시적인 공유(Implicit Sharing)
---
    먼저, 자동으로 되는 공유.

@Image(source: 15-Session-408-3.png, alt: nil)

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

다행히 이는 Swift에 적용되지 않습니다. 왜냐하면 Swift 컬렉션은 모두 값 타입이기 때문입니다.

Swift에서 열거와 수정은 각각 따로 동작합니다.

#### 모든 것에 대한 상속(Inheritance All Up In Your Business)
---
    두 번째로, 클래스 상속은 아주 거슬려.

* 하나 뿐인 슈퍼클래스, 잘 골라야 합니다!

    - 딱 하나의 클래스밖에 상속받지 못합니다.

    - 여러 속성을 추상화한 데이터 모델이 필요하다면?

* 상속 한번에 걸리는 높은 부하
    
    - 하나의 슈퍼클래스에 관련된 모든 것이 들어가게 딥니다.

* 소급적용이 없는 모델링

    - 나중에 조금씩 확장하는 것이 아니라, 클래스를 정의하는 순간에 슈퍼클래스를 정해야 합니다.

* 슈퍼클래스의 저장 속성

    - 슈퍼클래스에 저장 속성이 있다면 수용해야 합니다. 선택권이 없죠. 

    - 게다가 저장 속성 때문에 초기화를 해야합니다.

    - 불변성을 깨지 않고 슈퍼 클래스와 상호 작용하는 방법도 이해해야 합니다.

* 메소드 사용처 예측하기 
    
    - 클래스 작성자는 메소드가 해야 할 것을 알고 있는 것처럼 코드를 작성해야 합니다. 
    
    - final을 사용하지 않고, 메소드를 오버라이딩 할 기회를 열어두면서 말이죠.


Cocoa 프로그래머에게 이런 것들은 별로 새롭지 않습니다.

이런 이유로 우리는 Cocoa의 모든 곳에 위임 패턴(delegate pattern)을 만듭니다.
 
#### 관계의 부재(Lost Type Relationships)
---
    그리고 클래스는 타입 간의 관계가 중요한 상황에 적합하지 않아.
    예를 들면, 비교와 같은 대칭 연산 말이야. 너도 그런적 있을걸?
 
우리가 일반화된 정렬이나 이진 검색을 작성하려는 경우, 두 요소를 비교할 방법이 필요합니다.

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

위와 같은 코드에서 Swift는 `precedes` 메서드의 바디를 먼저 작성하기를 요구합니다.

하지만 우리는 아직 `Ordered` 인스턴스에 대해 아무것도 모릅니다.

그저 트랩을 만드는 것 외에는 방법이 없죠.

```
class Ordered {
    func precedes(other: Ordered) -> Bool { 
        fatalError("implement me!") 
    }
}
```

이 방식은 우리가 타입 시스템과 싸우고 있다는 신호입니다.

우리는 각 하위 클래스가 메서드를 구현하도록 제쳐두고, 그저 하위 클래스가 해야할 문제로 여기죠.

여기 `Double` 값을 가진 서브 클래스 `Number`가 있고 `precedes`를 오버라이딩 했습니다.

```
class Number: Ordered {
    var value: Double = 0 
    override func precedes(other: Ordered) -> Bool {
        // Ordered에는 value 프로퍼티가 없음.
        return value < other.value  
    }
}
```

이때, 메서드 시그니처(signature) `other`에는 `value` 프로퍼티가 있을지 알 수 없습니다. 

실제로는 `text` 프로퍼티를 가진 `Label`일 수도 있죠.

```
class Label: Ordered { var text: String = "" ... }
```

그래서 올바른 유형을 찾기 위해 다운캐스팅을 해야 합니다.

```
class Number: Ordered {
    var value: Double = 0 
    override func precedes(other: Ordered) -> Bool {
        return value < (other as! Number).value
    }
}
```

만약에 `other`가 `Label`로 밝혀졌다고 가정해봅시다. 다시 트랩으로 가겠죠?

슈퍼클래스에서 `precedes`메서드를 작성할 때와 비슷한 코드 스멜(code smell)이 발생했어요.

이는 클래스에서는 `self`의 타입과 `other`의 타입 사이의 중요한 타입 관계(type relationship)를 표현하지 못하기 때문입니다.

우리에게 필요한 것은 더 나은 추상화(abstraction) 메커니즘입니다.

#### 프로토콜로 재시작하기 (Starting Over with Protocols)
---
* 값 타입 (및 클래스) 지원 (Supports value types (and classes))

* 정적 타입 관계 (및 동적 디스패치) 지원 (Supports static type relationships (and dynamic dispatch))

* 비독단적 (Non-monolithic)

* 소급 적용 모델링 지원 (Supports retroactive modeling)

* 인스턴스 데이터 강요하지 않음 (Doesn’t impose instance data on models)

* 초기화 부담을 강요하지 않음 (Doesn’t impose initialization burdens on models)

* 구현이 필요한 대상에 대한 명확함 (Makes clear what to implement)

프로토콜은 이 모든 장점을 가지고 있고, 그래서 Swift는 최초의 프로토콜 지향 프로그래밍 언어로 만들어졌습니다. 물론 Swift는 객체 지향 프로그래밍에도 적합합니다.

마지막 예제를 보겠습니다.

먼저 우리는 프로토콜이 필요하죠. 이때 Swift는 메서드 바디를 넣을 수 없다고 말합니다.

```
protocol Ordered {
    // 프로토콜 메서드는 바디를 가질 수 없음.
    func precedes(other: Ordered) -> Bool { fatalError("implement me!") }
}

class Number : Ordered {
    var value: Double = 0
    override func precedes(other: Ordered) -> Bool {
    return self.value < (other as! Number).value
    }
}
```

사실 이건 꽤 좋은 의미인데, `precedes`가 구현된 상태에서의 정적인 검사에서, 동적인 런타임 검사로 전환한다는 의미이기 때문입니다.

```
protocol Ordered {
    func precedes(other: Ordered) -> Bool
}

class Number : Ordered {
    var value: Double = 0
    override func precedes(other: Ordered) -> Bool {
        return self.value < (other as! Number).value
    }
}
```

다음으로, 우리가 아무 것도 오버라이딩하지 않는다고 불평합니다.

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

물론이죠. 더 이상 베이스 클래스가 없으니까요. 슈퍼클래스도 없고 오버라이딩도 없으니까요.

숫자처럼 동작하길 원하면 `Number`를 처음부터 클래스로 만들지 않을 수도 있겠죠.

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

이제 프로토콜이 예제의 첫번째 버전에서 클래스가 했던 것과 똑같은 역할을 하고 있습니다.

확실히 조금 더 나아졌습니다. 치명적인 오류가 더 이상 발생하지 않으니까요.

하지만 여전히 강제 다운캐스트가 필요하기 때문에, `other`를 `Number`로 만들고 타입 캐스트를 삭제하고 싶습니다.

이제 Swift가 시그니처가 일치하지 않는다고 불평하겠죠?

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

이 문제를 해결하려면 프로토콜 시그니처에서 `Ordered`를 `Self`로 바꿔야 합니다. 이를 자체 요구사항(Self requirement)이라고 합니다.

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

이것은 `Ordered` 배열이 클래스일 때 작동했던 이진 검색입니다.

`Ordered` 배열이란 이질적인(heterogeneous) `Ordered` 타입을 처리하겠다는 말이죠. 배열 내에는 `Number`와 `Label`이 섞여 있을 겁니다.

그동안 `Ordered`에 대해 수정이 있었고, 자체 요구사항도 추가했으니, 컴파일러는 아마 이것을 동질하게(homogeneous) 만들도록 강제할 것입니다.

이것을 정렬된 단일 타입 'T'의 동질한 배열로 작업한다고 말합니다.

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

하지만 생각해 보면 사실 원래의 시그니처는 거짓이었습니다.

트랩을 만드는 것 말고는 이질적인 유형을 제대로 처리한 적이 없었으니까요.

프로토콜에 자체 요구사항을 추가하면 프로토콜은 클래스와 매우 다른 종류의 것이 됩니다.

| **Without Self Requirement** | **With Self Requirement** |
|:-- | :-- |
| *타입으로 사용 가능* | *제네릭으로만 사용 가능* |
| *`func sort(inout a: [Ordered])`* | *`func sort<T : Ordered>(inout a: [T])`* |
| *이질적(heterogeneous)* | *동질적(homogeneous)* |
| 각 모델들이 다른 모든 타입의 모델을 처리해야 함 | 모델 타입 간의 상호 작용에서 자유로움 |
| 동적 디스패치 | 정적 디스패치 |
| 낮은 최적화 | 높은 최적화 | 

#### 크러스티의 과제(A Challenge for Crusty)
---
프로토콜의 정적인 부분이 어떻게 작동하는지는 알겠습니다.

하지만 프로토콜이 정말 클래스를 대체할 수 있다는 크러스티의 말에는 확신이 서지 않았죠.

그래서 저는 크러스티에게 우리가 보통 객체지향을 사용하지만 프로토콜로 대체할 수 있는 무언가를 만들어보라는 과제를 내줬어요.

저는 도형을 드래그 앤 드롭해서 도형과 상호작용할 수 있는 작은 다이어그램 앱을 염두에 두고 있었어요.

그래서 크러스티에게 디스플레이 모델을 만들어 달라고 부탁했죠.

그가 생각해낸 것은 다음과 같습니다.

먼저 그는 드로잉 프리미티브(primitive)를 만들었습니다.

```
struct Renderer {
    func moveTo(p: CGPoint) { print("moveTo(\(p.x), \(p.y))") }
    func lineTo(p: CGPoint) { print("lineTo(\(p.x), \(p.y))") }
    func arcAt(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat) {
        print("arcAt(\(center), radius: \(radius)," + " startAngle: \(startAngle), endAngle: \(endAngle))")
    }
}
```

그리고 모든 그리기 요소에 공통 인터페이스를 제공하는 `drawable` 프로토콜을 만들었죠. 

```
protocol Drawable {
    func draw(renderer: Renderer)
}
```

그 다음으로 `Polygon`을 만들기 시작했습니다.

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

`Polygon`에서 가장 먼저 눈에 띄는 것은 값 타입으로 구성된 값 타입이라는 점입니다. 그저 점의 배열이 있는 구조체인거죠.

다각형을 그리려면 마지막 모서리로 이동한 다음 모든 모서리를 순환하며 선을 그리면 됩니다.

이번에는 `Circle`을 봅시다.

```
struct Circle : Drawable {
    func draw(renderer: Renderer) {
        renderer.arcAt(center, radius: radius, startAngle: 0.0, endAngle: twoPi)
    }
    var center: CGPoint
    var radius: CGFloat
}
```

`Circle` 역시 값 타입으로 만들어진 값 타입으로, `center`와 `radius`을 포함하는 구조체입니다.

원을 그리기 위해서는 0에서 2π 라디안까지 이어지는 호를 만듭니다.

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

지금까지의 모든 `Drawable`은 값 타입이고, `Drawable`의 배열도 값 타입이기 때문입니다.

`Diagram`을 그리려면 모든 `elements`를 반복해서 하나씩 `draw`하면 됩니다.

테스트해 봅시다.

크러스티는 중심과 반지름이 특정한 `circle`을 만들었습니다.

그런 다음 `triangle`을 추가하고 마지막으로 `diagram`을 만들어 그리라고 지시했습니다.

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
    화면에 그림을 그리는 것처럼 실제로 효과가 있는 작업이라면 이 데모가 훨씬 더 매력적으로 느껴졌을 텐데요.

짜증을 가라앉히고, 저는 `CorGraphics`를 사용해 그의 `Renderer`를 다시 작성하기로 결정했습니다.

    잠깐 기다려 봐, 애송이.
    그렇게 해버리면 내가 어떻게 내 코드를 테스트할 수 있겠어?

그는 테스트 중 무언가가 변경될 때 즉시 결과를 확인할 수 있는 그럴싸한 사례가 있다며, 프로토콜 지향 프로그래밍을 해보자고 제안했습니다.

그리고 `Renderer`를 프로토콜로 만들었습니다.

```
protocol Renderer {
    func moveTo(p: CGPoint)
    func lineTo(p: CGPoint)
    func arcAt(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat)
}
```

구현 부분을 작성한 다음, 원래 `Renderer`의 이름을 바꾸고 적절하게 만들었습니다.

```
struct TestRenderer : Renderer {
    func moveTo(p: CGPoint) { print("moveTo(\(p.x), \(p.y))") }
    func lineTo(p: CGPoint) { print("lineTo(\(p.x), \(p.y))") }
    func arcAt(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat) {
        print("arcAt(\(center), radius: \(radius)," + " startAngle: \(startAngle), endAngle: \(endAngle))")
    }
}
```

이 모든 리팩터링 작업은 저를 조급하게 만들었고 화면에서 이걸 빨리 보고 싶었습니만, 크러스티가 코드를 다시 테스트할 때까지 기다려야 했습니다.

이윽고 마침내 만족스러워졌을 때 그가 말했습니다.

    Renderer에 뭘 넣을 건데?

저는 대답했죠.

    CGContext요.

`CGContext`에는 기본적으로 렌더러에 필요한 모든 것이 있습니다. C 인터페이스 범위 내라면 그 자체로 렌더러라고 볼 수 있죠.

그가 말했습니다.

    훌륭하군. 키보드 줘봐.

그리고 키보드를 낚아채고는 너무 빨리 뭔가를 해버려서 거의 보이지도 않았습니다.

```
extension CGContext : Renderer {
    func moveTo(p: CGPoint) { }
    func lineTo(p: CGPoint) { }
    func arcAt(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat) { }
}
```

    잠깐만요, 방금 모든 CGContext를 Renderer로 만든 거예요?

그는 아직 뭘 하지 않았지만, 벌써 새로운 타입을 추가할 필요조차 없었습니다.
    
    뭘 기다리고 있어? 중괄호 안이나 채워.

그래서 저는 필요한 `CoreGraphics` 한 스쿱을 플레이그라운드(Playground)에 부어 넣었습니다.

```
extension CGContext : Renderer {
    func moveTo(p: CGPoint) {
        CGContextMoveToPoint(self, position.x, position.y)
    }
    func lineTo(p: CGPoint) {
        CGContextAddLineToPoint(self, position.x, position.y)
    }
    func arcAt(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat) {
        let arc = CGPathCreateMutable()
        CGPathAddArc(arc, nil, c.x, c.y, radius, startAngle, endAngle, true)
        CGContextAddPath(self, arc)
    }
}
```

#### 테스트 가능성을 위한 프로토콜 및 제네릭(Protocols and Generics for Testability)
---
크러스티가 `TestRenderer`에 무엇을 했는지 잠시 되돌아보고 싶습니다. 꽤 훌륭하거든요.

```
struct TestRenderer : Renderer {
    func moveTo(p: CGPoint) { print("moveTo(\(p.x), \(p.y))") }
    func lineTo(p: CGPoint) { print("lineTo(\(p.x), \(p.y))") }
    func arcAt(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat) {
        print("arcAt(\(center), radius: \(radius)," + " startAngle: \(startAngle), endAngle: \(endAngle))")
    }
}
```

그는 코드가 수행하는 모든 작업을 자세히 보여주는 측정 컴포넌트를 연결할 수 있었습니다.

그리고 코드 전체에 이 접근 방식을 적용했습니다.

이것으로 인해 프로토콜로 더 많은 것을 분리할 수록 모든 것을 테스트할 수 있다는 것을 알게 되었습니다.

이런 부류의 테스트는 모의 테스트(mocks)와 비슷하지만 훨씬 더 낫습니다. 모의 테스트는 본질적으로 취약하죠.

테스트 코드를 테스트 대상의 구현 사이에 연결해야 합니다.

그리고 그 취약성 때문에 Swift의 강한 정적안 타입 시스템과 잘 어울리지 않습니다.

프로토콜은 강제적인 인터페이스를 제공하면서도, 필요한 모든 측정에 대한 연결 고리를 제공합니다.

이제 비눗방울에 대한 얘기를 하러 예제로 돌아가 보겠습니다.

우리는 이 다이어그램 앱이 아이들에게 인기가 있기를 원했고, 당연하게도 아이들은 비눗방울을 좋아합니다.

다이어그램에서 비눗방울은 바깥쪽 원과 하이라이트를 나타내는 안쪽 원으로 나타냅니다.

이 코드를 문맥에 넣었을 때 크러스티는 부들거리기 시작했고, 모든 코드 반복은 그를 지루하게 만들었습니다.

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
    
    봐봐, 전부 다 완전한 원이야.
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

이제 크러스티는 부츠를 벗고 책상을 두드리고 있습니다. 여기서도 코드를 다시 반복하고 있었기 때문입니다.

    나 혼자 다 해야 되네.

그는 중얼거리며 키보드를 뺏어갔어요.

그리고는 Swift의 새로운 기능을 사용해 저를 가르치기 시작했죠.

#### 프로토콜 확장(Protocol Extension)
---

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

이 코드의 의미는 `Renderer`의 모든 모델에 `circleAt`에 대한 구현이 있다는 말입니다.

모든 `Renderer` 모델에는 공유되는 구현이 생겼고, 여전히 프로토콜에는 `circleAt` 요구사항이 있는 것이 보입니다.

`extension`에서 작성된 요구사항이 있다는 것의 의미를 물어보실 수 있습니다.

좋은 질문입니다. 그것은 프로토콜의 요구사항이 사용자 정의 지점을 생성한다는 의미입니다.

요구사항에 없는 다른 메서드를 `extension`에 추가하여 어떻게 작동하는지 확인해 보겠습니다.

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

이제 크러스티의 `TestRenderer`를 확장시켜 이 두 가지 메서드를 모두 구현할 수 있습니다.

```
extension TestRenderer : Renderer {
    func circleAt(center: CGPoint, radius: CGFloat) { ... }
    func rectangleAt(edges: CGRect) { ... }
}

let r = TestRenderer()
r.circleAt(origin, radius: 1);
r.rectangleAt(edges);
```

그냥 호출하면 됩니다. 전혀 놀랍지도 않죠.

`TestRenderer`의 구현이 직접 호출되고, 프로토콜은 관여하지도 않습니다. 

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

하지만 이제 Swift가 모델이 `Renderer` 타입인 것만 알고 있다고 바꿔 보겠습니다.

```
let r: Renderer = TestRenderer()
r.circleAt(origin, radius: 1);
r.rectangleAt(edges);
```

`circleAt`은 요구사항이므로 우리가 만든 모델은 사용자 정의 권한을 갖고 커스터마이징한 `circleAt`을 호출합니다.

하지만 `rectangleAt`은 요구사항이 아니므로, `TestRenderer`에서의 구현은 프로토콜에 있는 것의 그림자일 뿐입니다.

따라서 이 문맥에서는 프로토콜의 구현이 호출됩니다. 좀 이상하죠?

`rectangleAt`이 요구사항에 있어야 한다는 뜻일까요?

더 효율적인 방법으로 직사각형을 그리는 렌더러에게는 사용자 정의가 필요할 수도 있습니다.

하지만 프로토콜 확장에 있는 모든 것이 요구사항으로 뒷받침되어야 할까요? 반드시 그렇지는 않습니다.

모든 API가 커스터마이징 포인트가 되야 하는건 아니죠.

가끔은 모델이 요구사항을 가리지 않는 것도 해결책일 수 있습니다.

####더 많은 프로토콜 확장 트릭(More Protocol Extension Tricks)
---
이 새로운 기능은 우연히도 Swift 표준 라이브러리 작업에 혁신을 가져왔습니다.

가끔 프로토콜 확장을 통해 할 수 있는 일들이 마법처럼 느껴질 때가 있죠.

우리가 이 기능을 적용하고 업데이트하면서 즐거웠던 만큼 여러분도 이 최신 라이브러리로 즐겁게 작업해 주셨으면 좋겠어요.

잠시 이야기를 잠시 접어두고 표준 라이브러리에서 프로토콜 확장으로 한 일들 중 일부를 소개하고, 몇 가지 트릭을 소개해 드리겠습니다.

먼저 새로운 메서드 인덱스가 있습니다.

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

이것은 우리가 찾고 있는 것과 동일한 요소를 찾을 때까지 컬렉션의 인덱스를 조회한 다음, 그 인덱스를 반환하는 코드입니다.

찾지 못하면 `nil`을 반환하는 간단한 방식이죠.

하지만 이런 식으로 작성하면 문제가 생깁니다.

컬렉션의 요소들을 == 연산자로 비교할 수 없다고 나오죠.

```
extension CollectionType {
    public func indexOf(element: Generator.Element) -> Index? {
        for i in self.indices {
            // 두 개의 Generator.Element 피연산자에 이진 연산자 '=='를 적용할 수 없습니다.
            if self[i] == element {
                return i
            }
        }
        return nil
    }
}
```

이를 해결하기 위해 확장자를 제한할 수 있습니다.

이것이 이 새로운 기능의 또 다른 측면입니다.

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

이 확장은 컬렉션의 요소 유형이 `equatable`일 때 적용된다고 말함으로써, 우리는 Swift에 동등성 비교를 허용하는 데 필요한 정보를 제공한 것입니다.

이제 제약된 확장의 간단한 예제를 살펴봤으니 이진 검색을 다시 살펴봅시다.

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

`Int`가 `Ordered`를 따르지 않네요.

```
extension Int : Ordered {
    func precedes(other: Int) -> Bool { return self < other }
}

let position = binarySearch([2, 3, 5, 7], forKey: 5)
```

간단한 수정이죠?

준수(Conformance)를 추가하기만 하면 됩니다.

이제 `String`은 어떨까요?

당연히 `String`에서는 작동하지 않죠. 

```
// 'binarySearch'를 호출할 수 없습니다. '([String], forKey: String)' 타입의 인자 목록으로 호출할 수 없습니다.
let position = binarySearch(["2", "3", "5", "7"], forKey: "5")
```

다시 해봅시다.

```
extension String : Ordered {
    func precedes(other: Int) -> Bool { return self < other }
}
```

크러스티가 책상을 두들기기 전에 얼른 처리해야겠죠?

`comparable` 프로토콜에는 더 작은 연산자가 존재합니다.

그래서 `comparable` 프로토콜을 이렇게 확장할 수 있습니다.

now we're providing the proceeds for those performances.
이제 우리는 그 공연에 대한 수익금을 제공하고 있습니다.

so on the one hand this is really nice, right?
한편으로는 정말 멋지지 않나요?

when I want a binary search for doubles well all I have to do is add this conformance and I can do it.
복식에 대한 이진 검색을 원할 때 이 적합성을 추가하기만 하면 되니까요.

on the other hand, it's kind of Vicky because even if I take away this conformance I still have this precedes function that's been glommed onto doubles which already have enough of an interface. right?
반면에, 이 적합성을 제거하더라도 이미 복식 검색에 붙어있는 이미 충분한 인터페이스가 있는 더블에 붙어있으니까요. 그렇죠?

we maybe would like to be a little bit more selective about adding stuff to double.
더블에 기능을 추가할 때 좀 더 선택적으로 추가하고 싶을 수도 있습니다.

and even though I can do thatI can't binary search with it so it's really that precedes function is buys me nothing.
그리고 그렇게 할 수는 있지만 이진 검색을 할 수 없기 때문에 실제로는 precedes 함수가 저에게 아무 도움이 되지 않습니다.

fortunately I can be more selective about what gets a precedes API by using a constrained extension on ordered.
다행히도 Ordered에 제약된 확장자를 사용하여 앞의 API를 가져오는 대상을 보다 선택적으로 지정할 수 있습니다.

so this says that a type that is comparable and is also declared to be ordered will automatically be able to satisfy the proceeds requirement which is exactly what we want.
따라서 이것은 비슷하고 주문 된 것으로 선언 된 유형이 자동으로 우리가 원하는 수익 요구 사항을 충족 할 수 있다고 말합니다.

I'm sorry but I think that's just really cool.
죄송하지만 정말 멋지다고 생각합니다.

we've got the same abstraction, the same logical abstraction coming from two different places and we've just made them interoperate 
seamlessly. 
서로 다른 두 곳에서 동일한 추상화, 동일한 논리적 추상화를 가져와서 서로 원활하게 상호 운용되도록 만들었습니다. 

thank you for the Applause but I just I think it's cool.
박수 보내주셔서 감사하지만 전 그냥 멋지다고 생각해요.

okay, ready for a pallet?
좋아요, 팔레트 준비됐나요?

cleanser that's just showing it work.
클렌저가 작동하는 것을 보여줍니다.

okay this is the signature of a fully generalized binary search that works on any collection with the appropriate index and element types.
좋아, 이것은 적절한 인덱스와 요소 유형을 가진 모든 컬렉션에서 작동하는 완전히 일반화된 이진 검색의 시그니처입니다.

now I can already hear you guys getting uncomfortable out there.
이제 여러분들이 불편해하는 소리가 벌써 들리네요.

I’m not going to write the body out here because this is already pretty awful to look at, right?
이미 보기에도 끔찍하기 때문에 본문은 여기 쓰지 않겠습니다.

Swift one had lots of generic free functions like this.
Swift 1에는 이와 같은 일반적인 무료 함수가 많이 있었습니다.

in Swift 2 we use protocol extensions to make them into methods like this which is awesome, right?
Swift 2에서는 프로토콜 확장을 사용해 이런 메서드로 만들었는데, 정말 멋지지 않나요?

now everybody focuses on the Improvement this makes at the call site which is now clearly full, chalk full of method goodness, right?
이제 모든 사람들이 메서드의 장점으로 가득 찬 호출 사이트에서 이것이 만들어내는 개선점에 집중하고 있죠?

but as the guy writing binary search, I love what it did for the signature by separating the conditions under which this method applies from the rest of the Declaration which now just reads like a regular method.
하지만 이진 검색을 작성하는 사람으로서 저는 이 메서드가 적용되는 조건을 선언의 나머지 부분과 분리하여 이제 일반 메서드처럼 읽히는 서명에 대해 한 일이 마음에 듭니다.

no more angle bracket blindness. thank you very much.
더 이상 꺾쇠 괄호로 인한 실명은 없습니다. 정말 감사합니다.

okay, last trick before we go back to our story.
이야기로 돌아가기 전 마지막 트릭입니다.

this is a playground containing a minimal model of Swift's new Option set type protocol.
이것은 Swift의 새로운 옵션 세트 타입 프로토콜의 최소한의 모델이 포함된 플레이그라운드입니다.

it's just a struct with a readon int property called raw value.
원시값이라는 읽기 전용 int 프로퍼티가 있는 구조체일 뿐입니다.

now take a look at the broad setlik interface, you actually get for free once you've done that.
이제 광범위한 setlik 인터페이스를 살펴보겠습니다.

all of this comes from protocol extensions.
이 모든 것은 프로토콜 확장에서 비롯됩니다.

and when you get a chance I invite you to take a look at how those extensions are declared in the standard library because several layers are working together to provide this Rich API.
기회가 된다면 표준 라이브러리에서 이러한 확장이 어떻게 선언되는지 살펴보시기 바랍니다. 여러 계층이 함께 작동하여 이 리치 API를 제공하기 때문입니다.

okay, so those are some of the cool things that you can do with protocol extensions.
지금까지 프로토콜 확장으로 할 수 있는 몇 가지 멋진 일들을 살펴보았습니다.

now for the I'd like to return to our diagramming example.
이제 다이어그램 예제로 돌아가 보겠습니다.

always make value types equatable. why?
항상 값 유형을 동등하게 만드세요. 왜죠?

because I said so. also eat your vegetables.
제가 그렇게 말했으니까요. 채소도 먹으세요.

no actually if you want to know why go to this session on Friday which I've told you about already.
아니요, 그 이유를 알고 싶으시다면 금요일에 제가 이미 말씀드린 이 세션에 가보세요.

uh it's a really cool talk and they're going to discuss this issue in detail.
정말 멋진 강연이고 이 문제에 대해 자세히 논의할 거예요.

anyway, equatable is easy for most types.
어쨌든 이퀄러블은 대부분의 유형에서 간단합니다.

you just compare corresponding parts for equality like this.
이렇게 동등성을 위해 해당 부분을 비교하면 됩니다.

but now let's see what happens with diagram.
하지만 이제 다이어그램은 어떻게 되는지 봅시다.

uhoh. we can't compare two arrays of drawable for equality.
두 개의 배열이 같은지 비교할 수 없습니다.

all right maybe we can do it by comparing the individual Elements which looks something like this.
개별 엘리먼트를 비교하면 이렇게 될 것 같습니다.

okay, I'll I'll go through it for you.
좋아요, 제가 설명해드릴게요.

first, you make sure they have the same number of elements then you zip the two arrays together if they do have the same number of elements and you look for one where you have a pair that's not equal, right?
먼저 두 배열의 요소 수가 같은지 확인한 다음 요소 수가 같으면 두 배열을 합치고 같지 않은 한 쌍이 있는 배열을 찾으면 되죠.

you can take my word for it. this isn't the interesting part of the problem.
제 말을 믿어도 됩니다. 이 문제는 흥미로운 부분이 아닙니다.

oops, right? this is the whole reason we couldn't compare the arrays is because drawables aren't equatable.
배열을 비교할 수 없었던 이유는 드로어블이 같지 않기 때문이죠.

so we didn't have an equality operator for the arrays, we don't have an equality operator for the underlying drawables.
배열에 대한 같음 연산자가 없고, 기본 드로어블에 대한 같음 연산자도 없으니까요.

so can we just make all drawables equatable? we change our design like this?
그럼 모든 드로어블을 동일하게 만들 수 있을까요? 이렇게 디자인을 변경하면 되겠죠?

well, the problem with this is that equatable has self- requirements, which means that drawable now has self- requirements.
문제는 이퀄러블에 자체 요구사항이 있다는 것인데, 이는 드로어블에도 자체 요구사항이 있다는 뜻입니다.

and a self requirement puts drawable squarely in the homogeneous statically dispatched world.
그리고 자체 요구사항은 드로어블을 동질적인 정적으로 파견된 세계에 정사각형으로 배치한다는 거죠.

but diagram really needs a heterogeneous array of drawables, right.
하지만 다이어그램에는 이질적인 드로어블 배열이 필요합니다.

so we can put polygons and circles in the same diagram.
그래야 다각형과 원을 같은 다이어그램에 넣을 수 있죠.

so drawable has to stay in the heterogeneous dynamically dispatched world.
그래서 드로어블은 동적으로 파견된 이질적인 세계에 머물러야 합니다.

and we've got a contradiction making drawable equatable is not going to work.
드로어블을 동등하게 만드는 것은 작동하지 않는 모순이 있습니다.

we'll need to do something like this, which means that adding a new is equal to requirement to drawable.
새로운 것을 추가하는 것이 드로어블에 대한 요구 사항과 같다는 뜻입니다.

but oh no, we can't use self, right?
하지만 안 돼요, self는 사용할 수 없죠?

because we need to stay heterogeneous and without self this is just like implementing ordered with classes was.
왜냐하면 우리는 이질성을 유지해야 하고 self가 없으면 이것은 클래스로 정렬을 구현하는 것과 마찬가지이기 때문입니다.

we're now going to force all drawables to handle the heterogeneous comparison case.
이제 모든 드로어블이 이질적인 비교 케이스를 처리하도록 강제할 것입니다.

fortunately, there's a way out this time.
다행히도 이번에는 탈출구가 있습니다.

unlike most symmetric operations equality is special.
대부분의 대칭 연산과 달리 같음은 특별합니다.

because there's an obvious default answer when the types don't match up, right?
유형이 일치하지 않을 때 명백한 기본 답이 있기 때문이죠?

we can say if you have two different types they're not equal.
서로 다른 두 가지 유형이 있다면 같지 않다고 말할 수 있습니다.

with that Insight, we can Implement is equal to to for all drawables when they're equable like this.
이 인사이트를 통해 이렇게 같을 때 모든 드로어블에 대해 is equal to를 구현할 수 있습니다.

so let me walk you through it.
그럼 제가 설명해드리겠습니다.

the extension is just what we said it's for all drawables that are equatable.
확장자는 우리가 말한 대로 모든 드로어블이 같을 때를 위한 것입니다.

okay, first we uh conditionally downcast other to the self type, right?
좋아요, 먼저 조건부로 다른 것을 자기 타입으로 다운캐스트하는 거죠?

and if that succeeds then we can go ahead use equality comparison because we have an equable conformance.
그리고 성공하면 동등한 적합성이 있기 때문에 동등 비교를 사용할 수 있습니다.

otherwise the instances are deemed unequal.
그렇지 않으면 인스턴스는 불평등하다고 간주됩니다.

okay, so big picture of what just happened here.
좋아요, 방금 무슨 일이 있었는지 큰 그림을 그려보세요.

we made a deal with the implementers of drawable.
드로어블 구현자와 거래를 했습니다.

we said if you really want to go and handle the heterogeneous case “be my guest, go Implement” is equal to.
정말 이질적인 케이스를 처리하고 싶으시다면  “마음대로 하세요, 구현하세요"와 같다고요.

but if you want to just use the regular way we express homogeneous comparison, we'll handle all the burdens of the heterogeneous comparison for you.
하지만 동종 비교를 표현하는 일반적인 방법을 사용하고 싶다면 이질적인 비교의 모든 부담을 저희가 대신 처리해드리겠습니다.

so Building Bridges between the static and dynamic worlds it's a fascinating design space.
정적인 세계와 동적인 세계 사이에 다리를 놓는 것은 흥미로운 디자인 공간입니다.

and I encourage you to look into it more this particular problem we solved using a special property of equality but the problems aren't all like that.
평등이라는 특수한 속성을 이용해 해결한 이 문제를 좀 더 자세히 살펴보시길 권합니다.

and um there's lots of really cool stuff you can do.
여러분이 할 수 있는 정말 멋진 일들이 많이 있습니다.

so that property of equality doesn't necessarily apply but what does apply almost universally? protocol based design.
따라서 평등의 속성이 반드시 적용되는 것은 아니지만 거의 보편적으로 적용되는 것은 프로토콜 기반 설계입니다.

okay, so I want to say a few words before we wrap up about when to use classes.
클래스를 언제 사용해야 하는지에 대해 마무리하기 전에 몇 마디 말씀드리고 싶습니다.

because they do have their place, okay?
클래스는 제자리가 있으니까요.

there are times when you really do want implicit sharing.
암시적 공유가 정말 필요할 때가 있습니다.

for example, when the fundamental operations of a value type don't make any sense like copying this thing what would a copy mean if you can't figure out what that means then maybe you really do want it to be a reference type, or comparison, the same thing that's another fundamental part of being a value.
예를 들어 값 타입의 기본 연산이 이해가 되지 않을 때 복사하는 것이 무슨 의미인지 알 수 없다면 참조 타입이나 비교, 값의 또 다른 기본 부분인 동일한 것을 원할 수도 있습니다.

so for example a window, what would it mean to copy a window would you actually want to see you know a new graphical window what right on top of the other one? I don't know.
예를 들어 창을 복사한다는 것은 실제로 다른 창 바로 위에 새로운 그래픽 창이 있다는 것을 알고 싶을 때 어떤 의미가 있을까요? 글쎄요.

it wouldn't be part of your view hierarchy. doesn't make sense.
뷰 계층 구조의 일부가 아닐 테니까요. 말이 안 되죠.

so another case, where the lifetime of your instance is tied to some external side effect like files appearing on your desk.
인스턴스의 수명이 책상에 나타나는 파일과 같은 외부 부작용과 연관된 또 다른 경우가 있습니다.

part of this is because values get created very liberally by the compiler and created and destroyed and we try to optimize that as well as possible.
이 중 일부는 컴파일러가 값을 매우 자유롭게 생성하고 생성 및 소멸하기 때문에 가능한 한 최적화하려고 노력하기 때문입니다.

It's the reference types have this stable identity so if you're going to make something that corresponds to an external entity you might want to make it a reference type, a class.
참조 타입은 안정적인 정체성을 가지고 있기 때문에 외부 엔티티에 해당하는 무언가를 만들려면 참조 타입, 즉 클래스로 만드는 것이 좋습니다.

another case is where the instance of the abstraction are just syncs like our renderers for example.
또 다른 경우는 예를 들어 렌더러처럼 추상화 인스턴스가 동기화되는 경우입니다.

so we're just pumping we're just pumping information into that thing into that renderer right we tell it to draw a line.
그래서 우리는 렌더러에 선을 그리라고 지시하면 렌더러에 정보를 펌핑하는 것입니다.

so for example, if you wanted to make a test renderer that accumulated the text output of these commands into a string instead of just dumping them to the console you might do it like this.
예를 들어 이러한 명령의 텍스트 출력을 콘솔에 덤프하는 대신 문자열로 누적하는 테스트 렌더러를 만들고 싶다면 이렇게 할 수 있습니다.

but notice a couple of things about this.
하지만 여기서 몇 가지 주의할 점이 있습니다.

first, it's final, right?
첫째, 최종적이죠?

second, it doesn't have a base class. that's still a protocol.
둘째, 기본 클래스가 없습니다. 여전히 프로토콜입니다.

I'm using the protocol for the abstraction.
추상화를 위해 프로토콜을 사용하고 있습니다.

okay, a couple of more cases.
좋아, 몇 가지 더

so we live in an object-oriented world right Cocoa and Cocoa touch deal in objects.
우리는 객체 지향 세상에 살고 있고 코코아와 코코아 터치는 객체를 다루죠.

they're going to give you base classes and expect you to subclass them they're going to expect objects in their apis.
기본 클래스를 제공하고 서브클래스를 기대할 거고, 그 서브클래스의 API에 객체를 기대할 겁니다.

don't fight the system.
시스템과 싸우지 마세요.

okay, that would just be feudal.
그건 봉건적일 뿐이죠.

but at the same, time be circumspect about it.
하지만 동시에 신중해야 합니다.

nothing in your program should ever get too big and that goes for classes just as well well as anything else.
프로그램의 어떤 것도 너무 커져서는 안 되며 이는 다른 모든 것과 마찬가지로 클래스에도 적용됩니다.

so when you're refactoring and factoring something out of a class consider using a value type instead.
따라서 클래스에서 무언가를 리팩터링하고 팩터링할 때는 대신 값 타입을 사용하는 것을 고려하세요.

okay, to sum up.
좋아요, 요약하자면

protocol is much greater than super classes for abstraction.
프로토콜은 추상화를 위해 슈퍼 클래스보다 훨씬 더 뛰어납니다.

second, protocol extensions. this new feature let you do almost magic things.
둘째, 프로토콜 확장. 이 새로운 기능을 사용하면 거의 마법 같은 일을 할 수 있습니다.

third, did I mention you should go see the this talk on Friday? go see this talk on Friday?
셋째, 금요일에 이 강연을 보러 가야 한다고 말씀드렸나요? 금요일에 이 강연을 보러 가세요?

eat your vegetables.
채소를 드세요.

be like crusty. thank you very much.
크러스티처럼 되세요. 정말 감사합니다.

