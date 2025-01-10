# #1 가장 많이 받은 선물 (LV.1)
2024 KAKAO WINTER INTERNSHIP 

@Metadata {
    @CallToAction(
        purpose: link,
        url: "https://school.programmers.co.kr/learn/courses/30/lessons/258712",
        label: "문제로 이동")
    @PageKind(sampleCode)
}

## 개요

---

##### 문제 설명

선물을 직접 전하기 힘들 때 카카오톡 선물하기 기능을 이용해 축하 선물을 보낼 수 있습니다. 당신의 친구들이 이번 달까지 선물을 주고받은 기록을 바탕으로 다음 달에 누가 선물을 많이 받을지 예측하려고 합니다.

* 두 사람이 선물을 주고받은 기록이 있다면, 이번 달까지 두 사람 사이에 더 많은 선물을 준 사람이 다음 달에 선물을 하나 받습니다.
    - 예를 들어 `A`가 `B`에게 선물을 5번 줬고, `B`가 `A`에게 선물을 3번 줬다면 다음 달엔 `A`가 `B`에게 선물을 하나 받습니다.
* 두 사람이 선물을 주고받은 기록이 하나도 없거나 주고받은 수가 같다면, 선물 지수가 더 큰 사람이 선물 지수가 더 작은 사람에게 선물을 하나 받습니다.
    - 선물 지수는 이번 달까지 자신이 친구들에게 준 선물의 수에서 받은 선물의 수를 뺀 값입니다.
    - 예를 들어 A가 친구들에게 준 선물이 3개고 받은 선물이 10개라면 `A`의 선물 지수는 -7입니다. `B`가 친구들에게 준 선물이 3개고 받은 선물이 2개라면 B의 선물 지수는 1입니다. 만약 `A`와 `B`가 선물을 주고받은 적이 없거나 정확히 같은 수로 선물을 주고받았다면, 다음 달엔 `B`가 `A`에게 선물을 하나 받습니다.
    - 만약 두 사람의 선물 지수도 같다면 다음 달에 선물을 주고받지 않습니다.

위에서 설명한 규칙대로 다음 달에 선물을 주고받을 때, 당신은 선물을 가장 많이 받을 친구가 받을 선물의 수를 알고 싶습니다.

친구들의 이름을 담은 1차원 문자열 배열 `friends` 이번 달까지 친구들이 주고받은 선물 기록을 담은 1차원 문자열 배열 `gifts`가 매개변수로 주어집니다. 이때, 다음달에 가장 많은 선물을 받는 친구가 받을 선물의 수를 return 하도록 solution 함수를 완성해 주세요.

---

##### 제한사항

* 2 ≤ `friends`의 길이 = 친구들의 수 ≤ 50
    - `friends`의 원소는 친구의 이름을 의미하는 알파벳 소문자로 이루어진 길이가 10 이하인 문자열입니다.
    - 이름이 같은 친구는 없습니다.
* 1 ≤ `gifts`의 길이 ≤ 10,000
    - `gifts`의 원소는 `"A B"`형태의 문자열입니다. `A`는 선물을 준 친구의 이름을 `B`는 선물을 받은 친구의 이름을 의미하며 공백 하나로 구분됩니다.
    - `A`와 `B`는 `friends`의 원소이며 `A`와 `B`가 같은 이름인 경우는 존재하지 않습니다.

---

##### 입출력 예

| `friends` | `gifts` | `result` |
| -- | -- | -- |
| ["muzi", "ryan", "frodo", "neo"] | ["muzi frodo", "muzi frodo", "ryan muzi", "ryan muzi", "ryan muzi", "frodo muzi", "frodo ryan", "neo muzi"] | 2 |
| ["joy", "brad", "alessandro", "conan", "david"] | ["alessandro brad", "alessandro joy", "alessandro conan", "david alessandro", "alessandro david"] | 4 |
| ["a", "b", "c"] | ["a b", "b a", "c a", "a c", "a c", "c a"] | 0 |

---

##### 입출력 예 설명

**입출력 예 #1**

주고받은 선물과 선물 지수를 표로 나타내면 다음과 같습니다.

| ↓준 사람 \ 받은 사람→ | muzi | ryan | frodo | neo |
| -- | -- | -- | -- | -- |
| muzi | - | 0 | 2 | 0 |
| ryan | 3 | - | 0 | 0 |
| frodo | 1 | 1 | - | 0 |
| neo | 1 | 0 | 0 | - |

| 이름 | 준 선물 | 받은 선물 | 선물 지수 |
| -- | -- | -- | -- |
| muzi | 2 | 5 | -3 |
| ryan | 3 | 1 | 2 |
| frodo | 2 |2 | 0 |
| neo | 1 | 0 | 1 |

`muzi`는 선물을 더 많이 줬던 `frodo`에게서 선물을 하나 받습니다.

`ryan`은 선물을 더 많이 줬던 `muzi`에게서 선물을 하나 받고, 선물을 주고받지 않았던 `neo`보다 선물 지수가 커 선물을 하나 받습니다.

`frodo`는 선물을 더 많이 줬던 `ryan`에게 선물을 하나 받습니다.

`neo`는 선물을 더 많이 줬던 `muzi`에게서 선물을 하나 받고, 선물을 주고받지 않았던 `frodo`보다 선물 지수가 커 선물을 하나 받습니다.

다음달에 가장 선물을 많이 받는 사람은 `ryan`과 `neo`이고 2개의 선물을 받습니다. 따라서 2를 return 해야 합니다.

**입출력 예 #2**

주고받은 선물과 선물 지수를 표로 나타내면 다음과 같습니다.

| ↓준 사람 \ 받은 사람→ | joy | brad | alessandro | conan | david |
| -- | -- | -- | -- | -- | -- |
| joy | - | 0 | 0 | 0 | 0 |
| brad | 0 | - | 0 | 0 | 0 |
| alessandro | 1 | 1 | - | 1 | 1 |
| conan | 0 | 0 | 0 | - | 0 |
| david | 0 | 0 | 1 | 0 | - |

| 이름 | 준 선물 | 받은 선물 | 선물 지수 |
| -- | -- | -- | -- |
| joy | 0 | 1 | -1 |
| brad | 0 | 1 | -1 |
| alessandro | 4 | 1 | 3 |
| conan | 0 | 1 | -1 |
| david | 1 | 1 | 0 |


`alessandro`가 선물을 더 많이 줬던 `joy`, `brad`, `conan`에게서 선물을 3개 받습니다. 선물을 하나씩 주고받은 `david`보다 선물 지수가 커 선물을 하나 받습니다.

`david`는 선물을 주고받지 않았던 `joy`, `brad`, `conan`보다 선물 지수가 커 다음 달에 선물을 3개 받습니다.

`joy`, `brad`, `conan`은 선물을 받지 못합니다.

다음달에 가장 선물을 많이 받는 사람은 `alessandro`이고 4개의 선물을 받습니다. 따라서 4를 `return` 해야 합니다.

**입출력 예 #3**

`a`와 `b`, `a`와 `c`, `b`와 `c` 사이에 서로 선물을 주고받은 수도 같고 세 사람의 선물 지수도 0으로 같아 다음 달엔 아무도 선물을 받지 못합니다. 따라서 0을 return 해야 합니다.

---

## 풀이

##### 문제 정의하기

먼저 찾아야 하는 답을 정의합니다. 

    다음 달에 선물을 가장 많이 받을 친구가 받을 선물의 수 찾기

다음 달에 선물을 받는 조건의 값을 '친구'마다 계산하고, 정렬하여 찾으면 될 것 같습니다.

답을 정의 했으니, 값을 계산하기 위한 조건에 대해서 봅시다.

    조건 #1 서로 선물을 주고 받은 경우, 둘 중에 더 많이 선물을 준 친구 + 1
    조건 #2 서로 선물을 주고 받지 않거나, 선물을 주고 받은 횟수가 같으면 선물 지수가 높은 친구 + 1

주고 받은 선물에 대한 데이터 `gifts`를 사용하여 '선물을 더 많이 준 친구'를 찾아야 합니다.

또, 선물 지수 값을 계산해서 `friends` 데이터에 대응시켜야 합니다. 

선물 지수는 '준 선물 - 받은 선물' 값으로 정의되어 있습니다.

##### 문제 풀기

이제 문제를 풀어봅니다.

필요한 데이터는 친구 이름을 Key로 하는 Key-Value 타입으로 정의하여 빠르게 조회하도록 만듭니다.

선물 지수를 저장할 `points`, 다음 달에 받을 선물을 저장할 `reserved`를 선언합니다.

`gifts` 데이터는 다루기 까다롭기 때문에 약간 다듬어서 `(String, String)`의 튜플로 변경합니다.

```
import Foundation

func solution(_ friends:[String], _ gifts:[String]) -> Int {
    var points = [String: Int]()
    var reserved = [String: Int]()
    
    // 초기화
    friends.forEach {
        points[$0] = 0
        reserved[$0] = 0
    }
    
    // Tuple 데이터로 변경
    let gifts: [(String, String)] = gifts.compactMap {
        let friends = $0.split(separator: " ")
        if let sender = friends.first, let receiver = friends.last {
            return (String(sender), String(receiver))
        } else {
            return nil
        }
    }

    // 선물 지수 계산
    friends.forEach { friend in
        let sending = gifts.filter({ $0.0 == friend }).count
        let receiving = gifts.filter({ $0.1 == friend }).count
        points[friend] = sending - receiving
    }

    // 다음 달에 받을 선물 계산
    for sender in friends {
        for receiver in friends {
            // 선물을 준 친구와 선물을 받은 친구 간의 교환 횟수 계산
            let count = gifts.filter({ $0.0 == sender && $0.1 == receiver }).count - gifts.filter({ $0.0 == receiver && $0.1 == sender }).count
            
            // 선물을 더 많이 준 친구가 있는 경우, 선물을 보낸 친구가 다음 달에 받을 선물 + 1
            if count > 0 {
                reserved[sender] = (reserved[sender] ?? 0) + 1
            
            // 선물을 더 많이 준 친구가 없는 경우, 선물 지수가 높은 친구가 다음 달에 받을 선물 + 1
            } else if count == 0 && (points[sender] ?? 0) > (points[receiver] ?? 0) {
                reserved[sender] = (reserved[sender] ?? 0) + 1
            }
        }
    }

    // 다음 달에 받을 선물 개수 중 가장 큰 값 return
    return reserved.values.max() ?? 0
}
```

이대로 제출하면 전체 케이스를 만족하는 정답이 됩니다.

문제는 알고리즘의 구조 상 반드시 이중 반복문이 들어가게 되어 있는데, 선물을 주고 받은 횟수를 계산하려고 전체 `gifts`를 조회한다(filter)는 것입니다.

이렇게 되면 삼중 반복문이 되어 시간복잡도가 늘어나 지금보다 큰 데이터에서 실패할 가능성이 아주 높습니다.

따라서 `gifts` 데이터도 Key-Value 타입으로 정의하여 빠르게 조회할 수 있도록 하겠습니다.

튜플을 Key로 사용할 수 없으므로 `Hashable`을 요구 사항으로 갖는 모델 `Gift`를 만듭니다.

```
struct Gift: Hashable {
    let sender: String
    let receiver: String
    
    static func == (lhs: Gift, rhs: Gift) -> Bool {
        lhs.sender == rhs.sender && lhs.receiver == rhs.receiver
    }
    
    var reversed: Gift {
        Gift(sender: receiver, receiver: sender)
    }
}
```

모델을 만든 김에 `Gift`의 `sender`와 `receiver`를 뒤집어 return 하는 `reversed` 속성도 추가합니다.

생각해보면 `A`가 `B`에게 선물을 줬다는 말은 반대로 `B`가 `A`에게 선물을 받았다는 말입니다.

즉, 한번의 선물 교환에서는 선물을 주는 행동, 선물을 받는 행동이 동시에 발생합니다.

선물을 받으면 -1, 선물을 주면 +1로 계산하면 누가 더 많은 선물을 줬는지 알 수 있습니다.

선물 교환 행동을 `exchanges`라고 하고 다음과 같이 구현합니다.

```
import Foundation

struct Gift: Hashable {
    let sender: String
    let receiver: String
    
    static func == (lhs: Gift, rhs: Gift) -> Bool {
        lhs.sender == rhs.sender && lhs.receiver == rhs.receiver
    }
    
    var reversed: Gift {
        Gift(sender: receiver, receiver: sender)
    }
}

func solution(_ friends:[String], _ gifts:[String]) -> Int {
    var points = [String: Int]()
    var reserved = [String: Int]()
    
    // 초기화
    friends.forEach {
        points[$0] = 0
        reserved[$0] = 0
    }
    
    // 선물 교환을 계산
    var exchanges = [Gift: Int]()
    gifts.forEach {
        let friends = $0.split(separator: " ")
        if let sender = friends.first, let receiver = friends.last {
            let gift = Gift(sender: String(sender), receiver: String(receiver))
            exchanges[gift] = (exchanges[gift] ?? 0) + 1
            exchanges[gift.reversed] = (exchanges[gift.reversed] ?? 0) - 1
        }
    }
   
    // 선물 지수 계산
    friends.forEach { friend in
        var sending = 0
        for key in exchanges.keys.filter({ $0.sender == friend }) {
            sending += exchanges[key] ?? 0
        }
        var receiving = 0
        for key in exchanges.keys.filter({ $0.receiver == friend }) {
            receiving += exchanges[key] ?? 0
        }
        points[friend] = sending - receiving
    }

    // 다음 달에 받을 선물 계산
    for sender in friends {
        for receiver in friends {
            let gift = Gift(sender:sender, receiver: receiver)

            // 선물 교환에 저장된 값이 교환 마진을 의미
            let count = exchanges[gift] ?? 0
            
            // 선물을 더 많이 준 친구가 있는 경우, 선물을 보낸 친구가 다음 달에 받을 선물 + 1
            if count > 0 {
                reserved[sender] = (reserved[sender] ?? 0) + 1
            
            // 선물을 더 많이 준 친구가 없는 경우, 선물 지수가 높은 친구가 다음 달에 받을 선물 + 1
            } else if count == 0 && (points[sender] ?? 0) > (points[receiver] ?? 0) {
                reserved[sender] = (reserved[sender] ?? 0) + 1
            }
        }
    }
    return reserved.values.max() ?? 0
}
```

이렇게 구현하면 알고리즘 완성입니다.
