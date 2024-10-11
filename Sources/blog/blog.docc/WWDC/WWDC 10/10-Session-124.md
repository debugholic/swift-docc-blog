# Understanding Foundation

@Metadata {
    @TitleHeading("Session 124")
    @PageColor(orange)
}

Foundation 프레임워크는 iPhone OS 및 Mac OS 개발의 근간을 제공하는 프레임워크이며, 훌륭한 Mac, iPhone 및 iPad 소프트웨어를 구축하려면 Foundation 프레임워크에 대한 이해는 필수적입니다. Foundation 프레임워크의 광범위한 기능에 대해 알아보고 컬렉션(collections), 문자열(strings), 보존(archiving), 알림(notifications), 설정(preferences), 번들(bundles) 등과 같은 기능을 사용하는 방법에 대해서 알아봅니다.

### Foundation이란?
* Foundation은 빌딩 블록 클래스를 제공합니다.
    - 모든 어플리케이션에서 사용되는 기본 유형
    - 더 높은 단계의 소프트웨어로 조립(assembled) 
* 일관된 규칙을 도입할 수 있습니다.
* 낮은 단계의 개념을 향상(raise) 시킵니다.
    - 복잡한 OS 레벨의 작업을 포장(wraps up)해서 실제로 어떻게 동작하는지 대신 해결해야할 문제 영역에만 초점을 맞출 수 있습니다.

    
### Foundation은 어디 있을까?
* Foundation은 앱에 사용되는 프레임워크 중 하나
* Foundation 자체는 CFNetwork나 CoreFoundation과 같은 다른 프레임워크에 의존 
* Foundation은 UIKit 및 AppKit과 같은 다른 프레임워크에서 사용 


### 빌딩 블록(Building blocks)

@Image(source: 10-Session-124-7.png, alt: nil)

##### 컬렉션(Collections)
* 오브젝트를 보관하는 공간
* 가장 일반적으로 사용하는 기능:
    - 반복(iterating)
    - 정렬(sorting)
    - 필터링(filtering)
    
&nbsp;

세 가지 주요 컬렉션:
| **Collection** | **Prime Directive** |
|:-- | :-- |
| *NSArray / NSMutableArray* | *순서 있음* |
| *NSDictionary / NSMutableDictionary* | *키-값 매핑* |
| *NSSet / NSMutableSet* | *고유 값, 순서 없음* |                

&nbsp;

**반복(Iteration)**

* `for`문
```
NSUInteger count = [array count];
for (NSUInteger i = 0; i < count; i++) {
  id value = [array objectAtIndex:i];
  ...
}

NSArray *values = [dictionaryOrSet allObjects];
count = [values count];
for (NSUInteger i = 0; i < count; i++) {
  id value = [values objectAtIndex:i];
  ...
}
```

* `while`문 에서 `NSEnumerator` 사용 

열거자(*enumerator)는 위치와 반복을 추적할 수 있는 Foundation 객체
```
NSEnumerator *e = [arrayOrSet objectEnumerator];
while (id object = [e nextObject]) {
  // 인덱스에 접근하려면 추가 단계 필요
  ...
}

NSEnumerator *e = [dictionary keyEnumerator];
while (id key = [e nextObject]) {
  id value = [e objectForKey:key];
  // 또는 objectEnumerator로 직접 반복 사용 (keyEnmerator 대신)
  ...
}
```

* 빠른 열거 `for...in`
    - 속도가 빠른 이유는 두 가지:
        1. 수행 속도가 실제로도 빠른데, 반복문 내에 컬렉션을 사용함으로써 컬렉션이 어떻게 생성되는 지에 대한 세부 구현 정보를 갖고 객체를 추적할 수 있기 때문
        2. 코드를 적게 써도 되니까
```
for (id object in arrayOrSet) {
  // 배열 인덱스에는 액세스하기 어려움
  ...
}

for (id key in dictionary) {
  // 객체를 가져오려면 추가 단계가 필요
  id value = [dictionary objectForKey:key];
  ...
}
```


* 블록 (Snow Leopard 및 iOS 4에 새로 추가)
```
[array enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
  // 코드 작성 위치
}];

[dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
  // 코드 작성 위치
}];

[set enumerateObjectsUsingBlock:^(id object, BOOL *stop) {
  // 코드 작성 위치
}];
```

권장 사용 방법:
* Mac OS X 10.0: for loop 또는 NSEnumerator
* Mac OS X 10.5, iPhone OS 2: for loop 또는 fast enumeration
* Mac OS X 10.6, iOS 4: Fast enumeration 또는 Block enumeration

&nbsp;

**`NSArray` 정렬(Sorting)**

다음을 사용하여 정렬 순서를 결정: 

    - C 함수
    - Objective-C 메서드
    - `NSSortDescriptor`
    - 정렬하고 싶은 속성(properties)이나 객체(object)를 지정할 수 있는 클래스 
    - 블록(Blocks)

* 불변(immutable) 배열에서는 정렬된 새 객체를 생성하는 방식을 사용합니다.
* 가변(mutable) 배열에서는 새 객체를 생성하지 않아도 정렬이 가능합니다.

&nbsp;

문자 배열을 길이 순으로 정렬하는 예:
```
NSMutableArray *names = ...; // NSString 객체 배열
[names sortUsingComparator:^(id left, id right) {
  NSComparisonResult result;
  NSUInteger lLen = [left length], rLen = [right length];
  if (lLen < rLen) {
    result = NSOrderedAscending;
  } else if (lLen > rLen) {
    result = NSOrderedDescending;
  } else {
    result = NSOrderedSame;
  }
  return result;
}];
```

&nbsp;

**필터링(Filtering)**
> ⚠️ 컬렉션을 열거하는 동안 변경하지 마십시오. 예외가 발생합니다.

컬렉션을 필터링하려면 다음 중 하나를 선택:
* 복사본(copy)을 변형
* 변경 사항을 따로 모아놨다가 적용 

후자의 예시:
```
NSMutableArray *files = ...; // NSString 객체 배열
NSIndexSet *toRemove = [files indexesOfObjectsPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
  if ([obj hasPrefix:@"."]) return YES;
    return NO;
}];

[files removeObjectsAtIndexes:toRemove];
```

&nbsp;

**그 밖의 컬렉션 기능**
* 탐색(Searching)
* 각 항목에 셀렉터(selector) 적용
* `NSArray`: 나누기(slicing)와 합치기(concatenation)
* `NSSet`: 교집합(intersection), 합집합(union), 차집합(subtraction)

&nbsp;

##### 문자열(Strings)

* `NSString`은 시스템 상의 대부분의 텍스트에 대한 객체 컨테이너
    - 유니코드 문자의 배열(array of characters)
    - 불투명(opaque) 컨테이너 - `NSString`에는 문자열을 조작하고, 다른 종류의 문자열에 대한 작업을 수행하는 매우 많은 메서드가 있습니다.

* 일반적인 용도:
    - 비교(Comparison)
    - 탐색(Searching)
    - 인코딩 변경(Converting encodings)

&nbsp;

**문자열 비교(Comparing Strings)**
```
-(NSComparisonResult)compare:(NSString *)string;
-(NSComparisonResult)localizedCompare:(NSString *)string;

/// 이것은 Apple이 생각하는 옵션에 대한 모범 사례입니다.
/// 문자열을 사용자에게 표시하려면, 문자열을 비교합니다.
/// 사용자의 현재 장소(locale) 등 모든 기본 설정을 고려합니다. 
-(NSComparisonResult)localizedStandardCompare:(NSString *)string;
-(NSComparisonResult)compare:(NSString *)string
                     options:(NSStringCompareOptions)mask
                     range:(NSRange)compareRange
                     locale:(id)locale;
```

예를 들면:
```
NSString *str1 = @"string A";
NSString *str2 = @"string B";
NSComparisonResult result = [str1 compare:str2];
// 결과 값: NSOrderedAscending

NSArray *strings = [NSArray arrayWithObjects:@"Larry", @"Curly", @"Moe", nil];
NSArray *sortedStrings = [strings sortedArrayUsingSelector:@selector(localizedCompare:)];
// 결과 값: "Curly", "Larry", "Moe"
```

&nbsp;

**문자열 탐색(Searching Strings)**

```
-(NSRange)rangeOfString:(NSString *)aString;
-(NSRange)rangeOfString:(NSString *)aString
                options:(NSStringCompareOptions)mask
                  range:(NSRange)searchRange
                 locale:(NSLocale *)locale;
```

* `NSRange`는 위치(location)와 길이(length)를 갖고 있습니다.

왜 우리가 범위(range)의 길이(length)를 알아야 하죠? `aString`과 같지 않나요?

유니코드 표현이 다르기 때문에 길이가 달라도 같은 문자열이 있을 수 있습니다. 예를 들어 José는 `José`로 저장될 수 있지만 `Jose´`로도 저장 가능(`e´`를 분해된 문자(*decomposed character*)라고 합니다.)

iPhone OS 3.2부터는, `NSStringCompareOptions`에서 `NSRegularExpressionSearch`를 지원:
```
str = @"Going going gone!";
found = [str rangeOfString:@"go(\\w*)"
                   options:NSRegularExpressionSearch
                     range:NSMakeRange(0, [str length])];
// found.location = 6, found.length = 5
```

&nbsp;

**문자열 인코딩(String Encodings)**

* 인코딩이란 숫자를 문자로 매핑하는 것
* 데이터에서 문자열을 만들 때는 항상 해당 데이터가 어떤 인코딩에 저장되어 있는지 아는 것이 중요

```
/// NSData 에서 NSString 로
NSData *data = ...;
NSString *inString = [[NSString alloc] initWithData:data 
                                           encoding:NSUTF8StringEncoding];

/// NSString 에서 NSData 로
NSString *outString = @"For Windows";
NSData *converted = [outString dataUsingEncoding:NSUTF16StringEncoding];
```

open과 같은 시스템 호출을 목적으로 `char *`를 사용하는 경우, NSString의 편의 메서드(convenience method)인 `fileSystemRepresentation` 사용해야 함.

* 이렇게 하면 파일 시스템에 대한 정확한 인코딩 데이터를 가리키는 문자 포인터가 제공됩니다.
* `char *`가 가리키는 데이터는 자동 해제(autoreleased)됩니다.

```
const char *fileName = [outString fileSystemRepresentation];
```

&nbsp;

**그 밖의 문자열 기능**
* printf 스타일 형식
* 하위 문자열, 줄, 단락 열거(Enumeration)
    - 언어 독립적인 방식(language-independent way)으로 수행 가능
* 하위 문자열 대체(replacement)
* 경로 완성(path completion)
* 가변성(mutability)
    - `NSMutableString` 사용

&nbsp;

##### 날짜와 시간(Dates and times)

* 복잡한 날짜 및 시간 계산을 캡슐화
* 사용자가 설정한 날짜와 시간을 자동으로 처리
* 일반적인 용도:
    - 달력에 날짜 표현
    - 두 날짜 사이의 시간 간격
    - 모든 로케일의 사용자에 대해 정확한 날짜 및 숫자 형식 지정

&nbsp;

**메인 클래스(Main classes)**

`NSDate`
* 불변 시점(An invariant point in time)
* 달력(calendar)과 시간대(time zone) 독립(달력과 시간대를 알아야 `NSDate`를 표시할 수 있음) 
* 시간(time)은 기준점 이후 초 단위 `Double` 값으로 측정

`NSCalendar`
* 연도의 시작(begining), 길이(length), 분할(divisions)을 정의
* 예: 그레고리력(Gregorian calendar), 히브리력(Hebrew calendar)

`NSDateComponents`
* 간단한 객체 구조
* 연, 월, 일 등의 저장 공간
* 정확한 속성의 의미는 달력에 따라 결정

일례로 2010년 크리스마스와 블랙 프라이데이 사이에 며칠이 있는지 보면:
```
// 크리스마스 찾기
NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

NSDateComponents *components = [[NSDateComponents alloc] init];
[components setYear:2010];
[components setMonth:12];
[components setDay:25];

NSDate *christmas = [cal dateFromComponents:components];

// 추수감사절 찾기
NSDateComponents *tComps = [[NSDateComponents alloc] init];
[tComps setYear:2010];
[tComps setMonth:11];
[tComps setWeekday:5]; // 5 is Thursday in NSGregorianCalendar
[tComps setWeekdayOrdinal:4];

NSDate *thanksgiving = [cal dateFromComponents:tComps];

// 블랙 프라이데이 찾기(추수감사절 다음날 (Date에 DateComponent를 추가하는 방식))
NSDateComponents *toAdd = [[NSDateComponents alloc] init];
[toAdd setDay:1];

NSDate *blackFri = [cal dateByAddingComponents:toAdd
                                        toDate:thanksgiving
                                       options:0];
// 두 날짜가 며칠 간격인지 찾기
NSDateComponents *diff = [cal components:NSDayCalendarUnit
                                fromDate:blackFri
                                  toDate:christmas
                                 options:0];
NSInteger days = [diff day]; // days == 29
```

&nbsp;

**그 밖의 날짜와 시간 기능**
* 특정 날짜의 요일 찾기
* 시간대(time zone) 계산
* 달력 간의 변환

&nbsp;

**NSFormatter**
* 값을 문자열로 변환하거나 문자열에서 변환하는 데 사용

두 가지 주요 포맷터(formatter):

* `NSDateFormatter`
    - 날짜를 문자열로 변환하거나 문자열에서 변환

* `NSNumberFormatter`
    - 숫자를 문자열로 변환하거나 문자열에서 변환

각 클래스에는 미리 정의 된 형식이 있거나, 원하는 대로 생성하여 쓸 수 있습니다.   

&nbsp;

날짜로부터 문자열을 얻으려면:

```
NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
[fmt setTimeStyle:NSDateFormatterNoStyle];
[fmt setDateStyle:NSDateFormatterLongStyle];
NSLog(@"Thanksgiving is: %@", [fmt stringFromDate:thanksgiving]);
// > Thanksgiving is: November 25, 2010

// 여기서는 현재 시스템 시간대와 달력을 사용했는데, 
// 포맷터에 따로 지정하지 않았기 때문입니다.
```

문자열을 파싱하는 경우:

```
NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
[fmt setDateFormat:@"dd/MM/yyyy HH:mm"];
[fmt setTimeZone:[NSTimeZone timeZoneWithName:@"America/Los_Angeles"]];
[fmt setCalendar:cal];
NSDate *date = [formatter dateFromString:@"10/06/2010 9:30"];
```

형식 문자열은 유니코드 표준 TR35-6(Unicode Standard TR35-6)을 준수합니다.

&nbsp;

##### 유지 및 보관(Persistence and archiving)

나중에 찾아 쓸 수 있도록 데이터를 저장:
* 프로퍼티 리스트(Property lists)
* 사용자 설정(User preferences)
* 키 지정 보관소(Keyed archives)
* 대량의 복잡한 데이터 구조

&nbsp;

**프로퍼티 리스트(Property lists) - `NSPropertyListSerialization`**
* 소량의 구조화된 데이터 저장
* 크로스 플랫폼이며 사람이 읽을 수 있음 (XML 형식)
    - 프로퍼티 리스트는 더 빠르게 동작하는 바이너리 형식도 갖고 있습니다. 필요에 따라 사용자는 어떤 포맷을 사용할 지를 선택할 수 있습니다.

* 프로퍼티 리스트에 허용된 타입:
    - `NSArray`, `NSDictionary`
    - `NSString`
    - `NSDate`
    - `NSNumber` (integer, floating point, boolean)
    - `NSData` (프로퍼티 리스트는 소량의 데이터를 다루기 위한 용도)

&nbsp;

프로퍼티 리스트 저장:
```
NSDictionary *colors = [NSDictionary dictionaryWithObjectsAndKeys:@"Verde", @"Green", @"Rojo",@"Red", @"Amarillo", @"Yellow", nil];

NSError *error = nil;
NSData *plist = [NSPropertyListSerialization dataWithPropertyList:colors
                                                           format:NSPropertyListXMLFormat_v1_0
                                                          options:0
                                                            error:&error];
if (!plist) [NSApp presentError:error];
```

에러 처리 패턴에 유의:
* `plist`가 `nil`이면, 오류 매개변수(error parameter)가 채워진 것입니다.
* `plist`가 `nil`이 아니면, 전달한 오류 매개변수에는 아무 변화도 없으며, Foundation은 어떠한 방식의 수정도 하지 않습니다. 

&nbsp;

프로퍼티 리스트 불러오기:
```
NSData *readData = [NSData dataWithContentsOfURL:urlOfFile];
NSDictionary *newColors = [NSPropertyListSerialization propertyListWithData:readData
                                                                    options:0
                                                                     format:nil
                                                                      error:&error];
if (!newColors) [NSApp presentError:error];
```

&nbsp;

**사용자 설정(User preferences) - `NSUserDefaults`**
* 사용자 설정을 나타내는 작은 값 저장
* 도메인으로 그룹화 되고, 각각의 도메인은 이름과 용도가 존재 
* 도메인 탐색 순서:
    - `NSArgumentDomain` (커맨드 라인에서 지정한 설정, 휘발성(volatile)) 
    - 애플리케이션 (앱의 저장되는 설정 값, 앱 식별자(identifier)로 식별)
    - `NSGlobalDomain` (시스템 프레임워크에서 사용, 시스템 전체 범위 설정)
    - 언어 (언어 로케일 설정, 언어명으로 식별, 휘발성)
    - `NSRegistrationDomain` (앱 시작 시의 설정을 지정, 휘발성)

&nbsp;

등록 도메인 기본값(Registration Domain Defaults) 지정: 
```
+ (void)initialize {
  NSDictionary *appDefaults = [NSDictionary
    dictionaryWithObjectsAndKeys:
      [NSNumber numberWithBool:YES], @"FrogBlastVentCore",
      @"iPad", @"DefaultDeviceName",
      [NSNumber numberWithInt:3], @"PiValue", nil];

  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

  [defaults registerDefaults:appDefaults];
}
```

사용자 기본값(User Defaults) 읽기:
```
BOOL doIt = [defaults boolForKey:@"FrogBlastVentCore"];
// doIt == YES
```

실행 파일 인수(Executable Arguments) 읽기:

```
// Run your app with:
// MyApp.app/Contents/MacOS/MyApp -ConferenceName WWDC
NSString *argPref = [defaults stringForKey:@"ConferenceName"];
// argPref 값은 "WWDC"
```

사용자 기본값(User Defaults) 설정:

```
[defaults setBool:NO forKey:@"FrogBlastVentCore"];

// 몇줄 뒤
doIt = [defaults boolForKey:@"FrogBlastVentCore"];
// doIt == NO
```

&nbsp;

**키 지정 보관소(Keyed archives)**
* 객체의 임의 그래프(arbitrary graph)를 저장
* 앱 버전의 앞뒤로 호환을 쉽게 하는 것이 주요 설계 목적
    - 키 지정 보관소(keyed archive)는 키를 객체 값과 연결하는 방식으로 작동하므로, 앱의 향후 버전에서 키를 추가할 수 있고, 이전 버전에서는 그 키를 읽을 필요가 없습니다.
* 인코딩 및 디코딩하는 동안 치환(substitution)을 허용 
* 객체는 프로퍼티 리스트 타입일 필요가 없음
* `NSCoding` 프로토콜을 구현해야 사용 가능
    - 키 지정 보관소(keyed archive)가 객체를 인코딩하고 디코딩하는 방법은 객체에 구현하는 `NSCoding` 프로토콜에 의해 결정됩니다

&nbsp;

`NSCoding`구현

다음과 같은 `Robot`에 대한 정의가 있다고 하면:

```
@interface Robot : NSObject <NSCoding> {
  NSString *name;
  Robot *nemesis;
  NSInteger model;
}
@property (copy) NSString *name;
@property (retain) Robot *nemesis;
@property NSInteger model;
@end
```

`NSCoding`을 수행하기 위해, 두 가지 매서드를 작성해야 합니다:

```
// 객체를 인코딩하려면 키 지정 보관소(keyed archive)에게
// 객체가 데이터를 프로퍼티로 저장하고 있는 방식을 알려야 합니다:
- (void)encodeWithCoder:(NSCoder *)coder {
  [coder encodeObject:name forKey:@"name"];
  [coder encodeObject:nemesis forKey:@"nemesis"];
  [coder encodeInteger:model forKey:@"model"];
}

- (id)initWithCoder:(NSCoder *)coder {
  self = [super init];
  name = [[coder decodeObjectForKey:@"name"] copy];
  nemesis = [[coder decodeObjectForKey:@"nemesis"] retain];
  model = [coder decodeIntegerForKey:@"model"];
  return self;
}
```

보관(Archiving):
```
// r1와 r2가 서로를 참조하고 있지만, 키 저장 보관자(keyed archiver)가 이를 처리합니다.
Robot *r1 = [[Robot alloc] init], *r2 = [[Robot alloc] init];
r1.name = @"Bender"; r1.nemesis = r2; r1.model = 22;
r2.name = @"Flexo";  r2.nemesis = r1; r2.model = 22;

NSData *data = [NSKeyedArchiver archivedDataWithRootObject:r2];
```

해제(Unarchiving):
```
Robot *r3 = [NSKeyedUnarchiver unarchiveObjectWithData:data];

NSLog(@"Nemesis is: %@", r3.nemesis.name);
// Nemesis is: Bender
```

&nbsp;

**대량의 복잡한 데이터 구조 - 코어 데이터(Core Data)**

특징:
* 키-값 코딩(key-value coding) 및 키-값 옵저빙(key-value observing) 지원
* 값 검증(validation of values)과 관계 지속성(consistency of relationships)
* 추적 변경(change tracking)과 실행 취소(undo)
* 정교한 쿼리(sophisticated queries)
* 증분 편집(incremental editing)

&nbsp;

**Persistence Cheat Sheet**
| **Data Type** | **Recommended Persistence Method** |
| :-- | :-- |
| 사용자 설정 | `NSUserDefaults` |
| 작은 파일, 크로스 플랫폼 | `NSPropertyListSerialization` |
| 주기(cycle)가 있는 객체 그래프, 프로퍼티 리스트가 아닌 타입 | `NSKeyedArchiver` |
| 큰 데이터 집합, 객체 관계(object relational) 데이터베이스 | Core Data |
| 전문 데이터(specialized data) | 사용자 정의 포맷 |

&nbsp;

##### 파일 및 URL

* `NSURL`은 파일 및 리소스를 참조하는 데 선호되는 방법 
* 파일 시스템에서는 `NSFileManager`를 통해 URL을 사용 
* 네트워크에서는 URL 로딩 클래스(URL loading class)를 통해 사용 

&nbsp;

URL 만들기:
```
// 로컬 URL
NSURL *file = [NSURL fileURLWithPath:@"/Users/tony/file.txt"];
NSURL *up = [file URLByDeletingLastPathComponent];
NSURL *file2 = [up URLByAppendingPathComponent:@"file2.txt"];

// 웹 URL
NSURL *aapl = [NSURL URLWithString:@"http://www.apple.com"];
```

&nbsp;

##### 번들(Bundle)
* 코드 그룹 및 리소스
* 다양한 플랫폼 및 아키텍처에 대한 코드 포함
* 현지화된(localized) 리소스 불러오기 간소화

&nbsp;

번들 리소스 불러오기:

```
NSBundle *bundle = [NSBundle mainBundle];
NSURL *url = [bundle URLForResource:@"localizedImage"
                      withExtension:@"png"];
```

&nbsp;

**번들 vs. 패키지**
| | Bundle | File Package | Bundle + File Package |
|:-- | :-- | :-- | :-- |
| Primary Class | `NSBundle` | `NSFileWrapper` | `NSBundle`
| Use | Code and Resources | User Documents | Application Code and resources
| For Example | `.framework` | `.rtfd` | `.app` |
        
* 파일 패키지는 텍스트와 대한 모든 리소스와 첨부 파일이 들어 있는 디렉트리를 하나의 문서로 취급하려는 아이디어입니다. 따라서 문서 일부를 분실하기는 불가능합니다. 
    - 리치 텍스트 문서를 더블 클릭하면 기본 편집기를 열 수 있습니다.

&nbsp;

**그 밖의 번들 기능**
* 번들에서 다른 번들 불러오기(플러그인 시스템)
* 다양한 번들 컴포넌트에 접근 가능
* 지정된 타입의 모든 리소스와 지정된 하위 디렉토리의 모든 리소스에 접근 가능
* 현지화된 문자열 지원

&nbsp;

##### 오퍼레이션 큐(Operation queues)
* 작업을 나타내는 객채 지향적인 방식
* 병행(concurrent) 애플리케이션 디자인 단순화

&nbsp;

두 가지 메인 클래스:
* 오퍼레이션(Operation)
* 오퍼레이션 큐(Operation Queues)

&nbsp;

**오퍼레이션 - `NSOperation`**
* 작업 단위를 캡슐화
* 작업을 정의하기 위해 `-main`을 서브클래싱 및 오버라이딩해서 사용
* 아니면 Foundation에서 제공하는 하위 클래스 중 하나를 사용:
    - `NSInvocationOperation` - 타겟(target)과 셀렉터(selector)를 지정할 수 있습니다.
    - `NSBlockOperation` - 작업을 블록(block)으로 지정할 수 있습니다.

&nbsp;

**오퍼레이션 큐(Operation Queues) - `NSOperationQueue`**
* 수행할 오퍼레이션의 리스트를 유지
* 작업을 순차적으로(serially) 실행하거나 동시에(concurrently) 실행 

&nbsp;

`NSOperation` 서브클래스 사용

```
@interface MyOp : NSOperation
@end
@implementation MyOp
- (void)main {
  // Your work goes here
}
@end

// 다른 어딘가에서...
NSOperationQueue *queue = [[NSOperationQueue alloc] init];
MyOp *op = [[MyOp alloc] init];
[queue addOperation:op];
```

&nbsp;

**기타 `NSOperation` 특징**
* 작업이 다른 대기열에 있더라도 작업 간의 종속성을 설정할 수 있습니다.
* 대기열(queue) 내에서 작업의 우선 순위를 설정할 수 있습니다.
* 속성(property)에 대한 키-값 옵저빙(Key-value observing) 호환(실행 중인지, 완료되었는지 등을 알 수 있음)
* 작업이 완료될 떄 블록 실행이 가능합니다.
