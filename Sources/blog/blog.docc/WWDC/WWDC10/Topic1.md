# Understanding Foundation
@Metadata {
    WWDC 10
}
#### Description 
Foundation 프레임워크는 iPhone OS 및 Mac OS 개발의 근간을 제공하는 프레임워크이며, 훌륭한 Mac, iPhone 및 iPad 소프트웨어를 구축하려면 Foundation 프레임워크에 대한 이해는 필수적이다. Foundation 프레임워크의 광범위한 기능에 대해 알아보고 컬렉션(collections), 문자열(strings), 아카이빙(archiving), 알림(notifications), 설정(preferences), 번들( bundles) 등과 같은 기능을 사용하는 방법에 대해서 알아본다.

* Foundation은 빓딩 블록 클래스를 제공
    - 모든 어플리케이션에서 사용되는 기본 유형
    - 더 높은 단계의 소프트웨어로 조립(assembled) 
* 일관된 규칙을 도입
* 낮은 단계의 개념을 향상(raise)
    - 복잡한 OS 레벨의 작업을 포장(wraps up)해서 실제로 어떻게 동작하는지 보다 해결해야할 문제 영역에만 초점을 맞출 수 있게함.

    
## Where is Foundation?
* Foundation은 앱에 사용되는 프레임워크 중 하나
* Foundation 자체는 CFNetwork나 CoreFoundation과 같은 다른 프레임워크에 의존 
* Foundation은 UIKit 및 AppKit과 같은 다른 프레임워크에서 사용 


## Building blocks
#### Collections
* 오브젝트를 보관하는 공간
* 가장 일반적으로 사용하는 기능:
    - 반복(iterating)
    - 정렬(sorting)
    - 필터링(filtering)
    
&nbsp;

세 가지 주요 컬렉션으로는:
| **Collection** | **Prime Directive** |
|:-- | :-- |
| *NSArray / NSMutableArray* | *순서 있음* |
| *NSDictionary / NSMutableDictionary* | *키-값 매핑* |
| *NSSet / NSMutableSet* | *고유 값, 순서 없음* |                

&nbsp;

**Collection Iteration**

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

열거자(*enumerator)는 위치와 반복을 추적할 수 있는 Foundation 오브젝트
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
        1. 수행 속도가 실제로도 빠른데, 반복문 내에 컬렉션을 사용함으로써 컬렉션이 어떻게 생성되는 지에 대한 세부 구현 정보를 갖고 오브젝트를 추적할 수 있기 때문이다.
        2. 코드를 적게 써도 되니까.
```
for (id object in arrayOrSet) {
  // 배열 인덱스에는 액세스하기 어려움
  ...
}

for (id key in dictionary) {
  // 오브젝트를 가져오려면 추가 단계가 필요
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

**`NSArray` 정렬**

Determine sort order using: 
 C function 
 Objective-C method 
- `NSSortDescriptor`
- class that lets you specify which properties on an array or an object in an array that you want to sort on. 
- Blocks

* For immutable or mutable arrays, return a new object
* For mutable arrays, method to sort in place
Example where we sort an array of strings by length:
```
NSMutableArray *names = ...; // array of NSString objects
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
**Filtering**
> ⚠️ do not mutate a collection while enumerating it, this causes an exception.

To filter a collection, either:
* Mutate a copy
* Gather changes on the side, then apply
Example of the latter:
```
NSMutableArray *files = ...; // array of NSString objects
NSIndexSet *toRemove = [files indexesOfObjectsPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
  if ([obj hasPrefix:@"."]) return YES;
    return NO;
}];

[files removeObjectsAtIndexes:toRemove];
```

**More Collection features**
* Searching
* Apply selector to each item
* `NSArray`: Slicing and concatenation
* `NSSet`: Intersection, union, set subtraction


#### Strings

* `NSString` is an object container for most text on the system
    - Array of Unicode characters
    - Treat as opaque container - `NSString` has a ton of methods on it that let you manipulate strings and do other kinds of string operations.
* Common uses:
    - Comparison
    - Searching
    - Converting encodings

**Comparing Strings**
```
-(NSComparisonResult)compare:(NSString *)string;
-(NSComparisonResult)localizedCompare:(NSString *)string;

/// This encapsulates what Apple thinks are the best practices for the options 
/// to compare strings with if you're going to display them in a manner to the user.
/// This will take into account the user's current locale, all of their preferences 
/// and so on.
-(NSComparisonResult)localizedStandardCompare:(NSString *)string;
-(NSComparisonResult)compare:(NSString *)string
                     options:(NSStringCompareOptions)mask
                     range:(NSRange)compareRange
                     locale:(id)locale;
```
Example:
```
NSString *str1 = @"string A";
NSString *str2 = @"string B";
NSComparisonResult result = [str1 compare:str2];
// result is: NSOrderedAscending

NSArray *strings = [NSArray arrayWithObjects:@"Larry", @"Curly", @"Moe", nil];
NSArray *sortedStrings = [strings sortedArrayUsingSelector:@selector(localizedCompare:)];
// result is: "Curly", "Larry", "Moe"
```
**Searching Strings**
```
-(NSRange)rangeOfString:(NSString *)aString;
-(NSRange)rangeOfString:(NSString *)aString
                options:(NSStringCompareOptions)mask
                  range:(NSRange)searchRange
                 locale:(NSLocale *)locale;
```
* `NSRange` has a location and length

Why do we need to know the length of the range? Isn't it the same as `aString`?

Because of different unicode representations. There might be cases where the same string matches strings with different lengths, for example José can be stored as `José` or as `Jose´` (`e´` is called a *decomposed character*).

As of iPhone OS 3.2, `NSStringCompareOptions` supports `NSRegularExpressionSearch`:
```
str = @"Going going gone!";
found = [str rangeOfString:@"go(\\w*)"
                   options:NSRegularExpressionSearch
                     range:NSMakeRange(0, [str length])];
// found.location = 6, found.length = 5
```

**String Encodings**
* An encoding is a map of numbers to characters
* When you create a string from data, it's always important to know what encoding that data is stored in
```
/// From NSData to NSString
NSData *data = ...;
NSString *inString = [[NSString alloc] initWithData:data 
                                           encoding:NSUTF8StringEncoding];

/// From NSString to NSData
NSString *outString = @"For Windows";
NSData *converted = [outString dataUsingEncoding:NSUTF16StringEncoding];
```

If you need a `char *` to pass through a system call (like Open), you should use NSString's convenience method `fileSystemRepresentation`.

* this will get you a character pointer that points to the data in the correct encoding for the system
* the data that's pointed to by that `char *` is autoreleased
```
const char *fileName = [outString fileSystemRepresentation];
```

**More String Features**
* printf-style formatting
* Enumeration of substrings, lines, and paragraphs (can do this in a language-independent way)
* Replacement of substrings
* Path completion
* Mutability (via `NSMutableString`)


#### Dates and times

* Encapsulate complexity of date and time calculations
* Automatically handle user preferences
* Common uses:
    - Represent a date in a calendar
    - Find amount of time between two dates
    - Format a date or number correctly for user in any locale

**Main classes**

`NSDate`
* An invariant point in time
* Calendar and time zone independent (you can't present an `NSDate` to a user without knowing a calendar and time zone)
* Time is measured as seconds since a reference point, a `Double`

`NSCalendar`
* Defines beginning, length, and divisions of a year
* Example: Gregorian calendar, Hebrew calendar

`NSDateComponents`
* Simple object structure
* Contains storage for year, month, day, etc.
* Exact meaning of properties depends on calendar

Example how many days there are between Christmas and Black Friday in 2010:
```
// Find Christmas
NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

NSDateComponents *components = [[NSDateComponents alloc] init];
[components setYear:2010];
[components setMonth:12];
[components setDay:25];

NSDate *christmas = [cal dateFromComponents:components];

// Find Thanksgiving
NSDateComponents *tComps = [[NSDateComponents alloc] init];
[tComps setYear:2010];
[tComps setMonth:11];
[tComps setWeekday:5]; // 5 is Thursday in NSGregorianCalendar
[tComps setWeekdayOrdinal:4];

NSDate *thanksgiving = [cal dateFromComponents:tComps];

// Find Black Friday (the day after Thanksgiving (shows how to add date components to dates)
NSDateComponents *toAdd = [[NSDateComponents alloc] init];
[toAdd setDay:1];

NSDate *blackFri = [cal dateByAddingComponents:toAdd
                                        toDate:thanksgiving
                                       options:0];
// Find number of days between dates
NSDateComponents *diff = [cal components:NSDayCalendarUnit
                                fromDate:blackFri
                                  toDate:christmas
                                 options:0];
NSInteger days = [diff day]; // days == 29
```

**More Dates and times features**
* Find day of the week for a date
* Time zone calculations
* Converting between calendars

**NSFormatter**
* used for converting values to and from strings

The talk focuses on two main formatters:

* `NSDateFormatter`
    - Convert date to or from a string

* `NSNumberFormatter`
    - Convert number to or from a string

Each class has a set of pre-defined styles, or use your own.
Get String from Date:
```
NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
[fmt setTimeStyle:NSDateFormatterNoStyle];
[fmt setDateStyle:NSDateFormatterLongStyle];
NSLog(@"Thanksgiving is: %@", [fmt stringFromDate:thanksgiving]);
// > Thanksgiving is: November 25, 2010

// Here I used the current system time zone and calendar, 
// because I haven't specified them to the formatter.
```

If you're parsing a string:
```
NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
[fmt setDateFormat:@"dd/MM/yyyy HH:mm"];
[fmt setTimeZone:[NSTimeZone timeZoneWithName:@"America/Los_Angeles"]];
[fmt setCalendar:cal];
NSDate *date = [formatter dateFromString:@"10/06/2010 9:30"];
```

Format strings conform to Unicode Standard TR35-6

#### Persistence and archiving

Store data to disk for later retrieval:
* Property lists
* User preferences
* Keyed archives
& Large, complex data structures

**Property lists - `NSPropertyListSerialization`**
* Stores a small amount of structured data
* Cross-platform and human readable (XML format)
    - Plists also have a binary format that is better performing. So you can choose which format to use depending on what your requirements are
* Property list allowed types:
    - `NSArray`, `NSDictionary`
    - `NSString`
    - `NSDate`
    - `NSNumber` (integer, floating point, boolean)
    - `NSData` (PLists are designed to handle small amount of data)

Store a Plist:
```
NSDictionary *colors = [NSDictionary dictionaryWithObjectsAndKeys:@"Verde", @"Green", @"Rojo",@"Red", @"Amarillo", @"Yellow", nil];

NSError *error = nil;
NSData *plist = [NSPropertyListSerialization dataWithPropertyList:colors
                                                           format:NSPropertyListXMLFormat_v1_0
                                                          options:0
                                                            error:&error];
if (!plist) [NSApp presentError:error];
```

Note the error handling pattern:
* If `plist` is `nil`, then the error parameter has been filled out
* If `plist` is not `nil`, the error parameter that you pass in will be completely untouched, Foundation will not modify it in any way

Read a PList:
```
NSData *readData = [NSData dataWithContentsOfURL:urlOfFile];
NSDictionary *newColors = [NSPropertyListSerialization propertyListWithData:readData
                                                                    options:0
                                                                     format:nil
                                                                      error:&error];
if (!newColors) [NSApp presentError:error];
```

**User preferences - `NSUserDefaults`**
* Stores small values representing user preferences
* Organized by domain, which is a group of defaults
* Domains searched in specific order:
    - Arguments to executable (volatile)
    - Application (stored in the user home directory)
    - Global (system-wide location)
    - Language (for locale-specific preferences, volatile)
    - Registration (factory settings of your application, volatile)

Set Registration Domain Defaults
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

Read User Default
```
BOOL doIt = [defaults boolForKey:@"FrogBlastVentCore"];
// doIt == YES
```

Read Executable Arguments
```
// Run your app with:
// MyApp.app/Contents/MacOS/MyApp -ConferenceName WWDC
NSString *argPref = [defaults stringForKey:@"ConferenceName"];
// argPref is "WWDC"
```

Set User Default
```
[defaults setBool:NO forKey:@"FrogBlastVentCore"];

// later...
doIt = [defaults boolForKey:@"FrogBlastVentCore"];
// doIt == NO
```

**Keyed archives**
* for storing an arbitrary graph of objects
* its primary design purpose is to enable easy backward and forward compatibility
    - because in a keyed archive, the way it works is you associated keys with your object values. You can add a key in a future version of your app, and the past versions of your app don't have to read that key, and vice versa.
* Allows for substitutions during encode and decode
* Objects do not need to be property list types
* Object must implement `NSCoding` protocol
    - The way that the keyed archiver knows how to encode and decode your objects is by the NSCoding protocol that your objects implement.

Implementing `NSCoding`.
Let's say that we have the following `Robot` definition:
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

To implement `NSCoding`, I need to fill out two methods:
```
// To encode our object, we need to tell the keyed archiver 
// how to store the data that we have as our properties:
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

Archiving:
```
// Note how r1 and r2 reference each other, but keyed archiver will handle that.
Robot *r1 = [[Robot alloc] init], *r2 = [[Robot alloc] init];
r1.name = @"Bender"; r1.nemesis = r2; r1.model = 22;
r2.name = @"Flexo";  r2.nemesis = r1; r2.model = 22;

NSData *data = [NSKeyedArchiver archivedDataWithRootObject:r2];
```

Unarchiving:
```
Robot *r3 = [NSKeyedUnarchiver unarchiveObjectWithData:data];

NSLog(@"Nemesis is: %@", r3.nemesis.name);
// Nemesis is: Bender
```

**Large, complex data structures - Core Data**

Features:
* Support for key-value coding and key-value observing
* Validation of values and consistency of relationships
* Change tracking and undo
* Sophisticated queries
* Incremental editing

**Persistence Cheat Sheet**
| **Data Type** | **Recommended Persistence Method** |
| :-- | :-- |
| User preferences | `NSUserDefaults` |
| Small files, cross-platform | `NSPropertyListSerialization` |
| Object graph with cycles, non-property list types | `NSKeyedArchiver` |
| Large data set, object relational database | Core Data |
| Specialized data | Custom Format |

#### Files and URLs

* `NSURL` is the preferred way to reference files and resources
* URLs are used with the file system through `NSFileManager`
* URLs are used with a network resource through the URL loading classes

Creating URLs
```
// Local URLs
NSURL *file = [NSURL fileURLWithPath:@"/Users/tony/file.txt"];
NSURL *up = [file URLByDeletingLastPathComponent];
NSURL *file2 = [up URLByAppendingPathComponent:@"file2.txt"];

// Web URLs
NSURL *aapl = [NSURL URLWithString:@"http://www.apple.com"];
```

#### Bundles
* Group code and resources
* Include code for different platforms and architectures
* Simplify loading localized resources

Loading a Bundle Resource
```
NSBundle *bundle = [NSBundle mainBundle];
NSURL *url = [bundle URLForResource:@"localizedImage"
                      withExtension:@"png"];
```
**Bundle vs. Packages**
| | Bundle | File Package | Bundle + File Package |
|:-- | :-- | :-- | :-- |
| Primary Class | `NSBundle` | `NSFileWrapper` | `NSBundle`
| Use | Code and Resources | User Documents | Application Code and resources
| For Example | `.framework` | `.rtfd` | `.app` |
        
* the idea of file packages is to treat a directory that contains all the appropriate resources and attachments to the text and so forth, as one document in the finder. So the user can't lose associated pieces of their documents.
    - double-clicking on a rich text document will open its default editor.

**More Bundle Features**
* Bundles can load other bundles (plug in system)
* You can locate the various components of a bundle
* You can locate list all its resources of a type or in a subdirectory
* Support for localized strings


#### Operation queues
* Object-oriented way to describe work
* Simplifies design of concurrent applications

Two main classes:
* Operations
* Operation Queues

**Operations - `NSOperation`**
* Encapsulates a work unit
* you use it by subclassing and overriding the `-main` to define your work
* Or use one of the Foundation-provided subclasses:
    - `NSInvocationOperation` - lets you specify a target and selector
    - `NSBlockOperation` - lets you specify your work as a block

**Operation Queues - `NSOperationQueue`**
* Maintains list of operations to perform
* Runs operations concurrently or serially

Using an `NSOperation` Subclass
```
@interface MyOp : NSOperation
@end
@implementation MyOp
- (void)main {
  // Your work goes here
}
@end

// elsewhere...
NSOperationQueue *queue = [[NSOperationQueue alloc] init];
MyOp *op = [[MyOp alloc] init];
[queue addOperation:op];
```

Other `NSOperation` Features
* You can set up dependencies between operations even if those operations are in different queues.
* You can set up priorities of operations within a queue
* Key-value observing compatible properties (so you can find out when it's running, when it's finished, etc.)
* you can have a block run when you're operation is finished
