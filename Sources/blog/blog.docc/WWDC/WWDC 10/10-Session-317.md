# Understanding Crash Reports on iPhone OS

@Metadata {
    @TitleHeading("Session 317")
    @PageColor(orange)
}

최고의 앱이라도 가끔 충돌(crash)이 발생합니다. 더 나은 앱이 될지, 고객을 잃을 것인지의 차이는 앱 충돌을 진단하고 수정하는 데에 있습니다. 충돌을 찾아 해결하고 일반적인 함정을 피하는 데 필요한 기술을 알아보세요.

### 충돌 보고서(Chash report)란?

* 애플리케이션이 충돌하면 iOS는 충돌 보고서(crash report)를 작성합니다.
* 이 보고서에는 애플리케이션 디버깅에 도움이 되는 진단 정보가 포함되어 있습니다.

&nbsp;

충돌 보고서의 예:

```
Incident Identifier: E6103EB1-FCF8-4887-AABE-7D2CE54DC204
CrashReporter Key:   7a62337857aa7d30d6bac1f9605c803f8a80d7d5
Hardware Model:      iPod3,1
Process:         SeismicXML [869]
Path:            /var/mobile/Applications/DBF2A211-F638-4D15-8A47-CD95C925FC38/SeismicXML.app/SeismicXML
Identifier:      SeismicXML
Version:         ??? (???)
Code Type:       ARM (Native)
Parent Process:  launchd [1]

Date/Time:       2010-05-21 16:35:34.652 -0700
OS Version:      iPhone OS 4.0 (8A274b)
Report Version:  104

Exception Type:  EXC_BAD_ACCESS (SIGBUS)
Exception Codes: KERN_PROTECTION_FAILURE at 0x00000000
Crashed Thread:  6

Thread 0:
0     libSystem.B.dylib          0x31227688 0x31226000 + 5768
1     libSystem.B.dylib          0x31229754 0x31226000 + 14164
2     CoreFoundation             0x325062c8 0x32494000 + 467656
3     CoreFoundation             0x32508582 0x32494000 + 476546
4     CoreFoundation             0x324b1841 0x32494000 + 121060
5     CoreFoundation             0x324b17ec 0x32494000 + 120812
6     GraphicsServices           0x304196f0 0x30416000 + 14064
7     GraphicsServices           0x3041979c 0x30416000 + 14236
8     UIKit                      0x326100e2 0x3260a000 + 24802
9     UIKit                      0x3260ecac 0x3260a000 + 19628
10    SeismicXML                 0x00002138 0x1000 + 4408
11    SeismicXML                 0x0000zobc 0x1000 + 4284

Thread 6 Crashed:
0     libobjc.A.dylib            0x348586e1 0x34e83000 + 10350
1     Foundation                 0x32144e6e 0x32139000 + 48750
2     Foundation                 0x321c9bb2 0x32139000 + 592818
3     libSystem.B.dylib          0x312a09b6 0x31226000 + 502198
4     libSystem.B.dylib          0x31296114 0x31226000 + 459028

Thread 6 crashed with ARM Thread State:
     r0: 0x32145b8d     r1: 0x3372602c     r2: 0x32145b8d     r3: 0x3372602c
     r4: 0x00b580b4     r5: 0x00000000     r6: 0x00006e07     r7: 0x06362da4
     r8: 0x321c97ed     r9: 0x001fc098    r10: 0x2fffe9e4    r11: 0x00000000
     ip: 0x3e4049c8     sp: 0x06362d6c     lr: 0x00003308     pc: 0x34e8586e
   cpsr: 0x00000030  

Binary Images:
0x1000 -     Ox7fff +SeismicXML armv6     <558ca043dbc407b84430fcazdaa1a63b> /var/mobile/Applications/DBF2A211-F638-4D15-8A47-CD95C925FC38/SeismicXML.app/SeismicXML
0x54c000 -   0x54dfff dns.so armv7        <240b8d3f07b4fcb234de598f867dela> /usr/lib/info/dns.so
0x2fe00000 - 0x2fe26fff dyld armv7        <a5c24f87740fd36d5d75d09f7e5577f8> /usr/lib/dyld
0x30005000 - 0x300adfff QuartzCore armv7  <30b70b64405d90493d485668c32572d8> /System/Library/Frameworks/QuartzCore.framework/QuartzCore
0x30188000 - 0x3018ffff libbz2.1.0.dylibarmv7  <5d079712f5a39708647292bccbd4c4e0> /usr/lib/libbz2.1.0.dylib
0x3022e000 - 0x3026cfff libVDSP.dylibarmv7  <cc8d6be7a5021266e26ebd05e9579852> /System/Library/Frameworks/Accelerate.framework/Frameworks/vecLib.framework/libvDSP.dylib
```

충돌 보고서의 첫 번째 섹션은 프로세스 정보(Process Information) 섹션입니다:

```
Incident Identifier: E6103EB1-FCF8-4887-AABE-7D2CE54DC204 # 충돌 보고서의 고유 식별자
CrashReporter Key:   7a62337857aa7d30d6bac1f9605c803f8a80d7d5 # 장치 고유 식별자(익명화)
Hardware Model:      iPod3,1 # 하드웨어 모델명
Process:         SeismicXML [869] # 충돌된 프로세스, 대체로 앱의 pid
Path:            /var/mobile/Applications/DBF2A211-F638-4D15-8A47-CD95C925FC38/SeismicXML.app/SeismicXML
Identifier:      SeismicXML
Version:         ??? (???)
Code Type:       ARM (Native)
Parent Process:  launchd [1]
```

다음 섹션은 충돌에 대한 기본적인 정보를 제공합니다:

```
Date/Time:       2010-05-21 16:35:34.652 -0700 # 발생 시간
OS Version:      iPhone OS 4.0 (8A274b) # 충돌이 발생한 OS
Report Version:  104
```

다음 섹션은 예외(Exception) 섹션입니다:

```
Exception Type:  EXC_BAD_ACCESS (SIGBUS) # 충돌의 종류
Exception Codes: KERN_PROTECTION_FAILURE at 0x00000000 # 예외 코드
Crashed Thread:  6 # 예외가 발생한 스레드
```

그 다음 섹션은 스레드 역추적(threads backtraces)입니다.

다음은 6번 스레드에 대한 역추적입니다:

```
Thread 6 Crashed:
0     libobjc.A.dylib            0x348586e1 0x34e83000 + 10350
1     Foundation                 0x32144e6e 0x32139000 + 48750
2     Foundation                 0x321c9bb2 0x32139000 + 592818
3     libSystem.B.dylib          0x312a09b6 0x31226000 + 502198
4     libSystem.B.dylib          0x31296114 0x31226000 + 459028
```

> 역추적(backtrace)이란?
> * 역추적은 충돌 지점의 모든 활성 프레임을 나열합니다.
> * 충돌이 발생한 시점의 중첩된 함수 호출 리스트(a nested list of function calls)를 보여줍니다.  
> * 4개의 열로 나뉘어져 있습니다.
>    - 첫 번째 열은 프레임 번호입니다.
>    - 두 번째 열은 해당 프레임의 바이너리 이름을 표시합니다. (Foundation 등)
>    - 세 번째 열은 호출된 함수의 주소입니다.
>    - 네 번쨰 열은 세 번째 열의 주소를 시작점(base)과 오프셋으로 구분한 것입니다.
>
> &nbsp;
>
> 다음은 4개의 열을 표시한 것입니다:
>
> ```
> #1    #2                         #3        #4  
> 0     libobjc.A.dylib            0x348586e 0x34e83000 + 10350
> ```

다음 섹션은 충돌 당시의 값과 레지스터를 보여주는 스레드 상태입니다:

```
Thread 6 crashed with ARM Thread State:
     r0: 0x32145b8d     r1: 0x3372602c     r2: 0x32145b8d     r3: 0x3372602c
     r4: 0x00b580b4     r5: 0x00000000     r6: 0x00006e07     r7: 0x06362da4
     r8: 0x321c97ed     r9: 0x001fc098    r10: 0x2fffe9e4    r11: 0x00000000
     ip: 0x3e4049c8     sp: 0x06362d6c     lr: 0x00003308     pc: 0x34e8586e
   cpsr: 0x00000030  
```

마지막 섹션은 바이너리 이미지(Binary Image)라고도 부르는데, 충돌 시 불러왔던 모든 바이너리가 나열됩니다:

```
Binary Images:
0x1000 -     Ox7fff +SeismicXML armv6     <558ca043dbc407b84430fcazdaa1a63b> /var/mobile/Applications/DBF2A211-F638-4D15-8A47-CD95C925FC38/SeismicXML.app/SeismicXML
0x54c000 -   0x54dfff dns.so armv7        <240b8d3f07b4fcb234de598f867dela> /usr/lib/info/dns.so
0x2fe00000 - 0x2fe26fff dyld armv7        <a5c24f87740fd36d5d75d09f7e5577f8> /usr/lib/dyld
0x30005000 - 0x300adfff QuartzCore armv7  <30b70b64405d90493d485668c32572d8> /System/Library/Frameworks/QuartzCore.framework/QuartzCore
0x30188000 - 0x3018ffff libbz2.1.0.dylibarmv7  <5d079712f5a39708647292bccbd4c4e0> /usr/lib/libbz2.1.0.dylib
0x3022e000 - 0x3026cfff libVDSP.dylibarmv7  <cc8d6be7a5021266e26ebd05e9579852> /System/Library/Frameworks/Accelerate.framework/Frameworks/vecLib.framework/libvDSP.dylib
```

### 충돌 보고서의 종류

* 아이폰 OS 정책: iOS에는 모든 앱이 따라야 하는 몇 가지 정책이 있습니다. 그렇지 않으면 앱이 종료됩니다.
    - 감시 시간 초과(Watchdog timeout) - 앱이 지정된 시간 내에 실행/재개/일시 중지/종료에 실패할 때 발생합니다.
    - 사용자 강제 종료(User force-quit) - 사용자가 앱을 강제 종료할(kill) 때 발생합니다.
    - 낮은 메모리 종료(Low Memory termination) - OS가 사용자와의 상호 작용을 계속하기에 충분한 메모리가 없다는 것을 깨닫는다면, OS는 낮은 메모리 알림을 앱에 보낼 것입니다. 그러나 메모리가 충분하지 않고 앱이 더 많은 메모리를 확보하지 못한다면, 앱은 종료될 것입니다.

* 버그로 인한 앱 충돌

##### 감시 시간 초과(Watchdog timeout) 충돌 보고서

예외(Exception) 섹션을 주목해보면:

```
Exception Type: 00000020 
Exception Codes: 0x8badf00d 
Highlighted Thread: 0

Application Specific Information:
com.yourcompany.SeismicXML failed to resume in time
elapsed total CPU time (seconds): 1.030 (user 0.400, system 0.630), 5% 
CPU elapsed application CPU time (seconds): 0.000, 0% CPU
```

* 감시 시간 초과 예외는 `0x8badf00d` 예외 코드를 갖습니다.
* 예외가 발생한 스레드인 스레드 `0`은 메인 스레드입니다.
* `애플리케이션 정보(Application Specific Information)`는 당시 애플리케이션이 무엇을 하려고 했는지 알려줍니다.

##### 사용자 강제 종료(User force-quit) 충돌 보고서

예외(Exception) 섹션을 주목해보면:

```
Exception Type: 00000020
Exception Codes: 0xdeadfa11
Highlighted Thread: 0
```
* 사용자 강제 종료 예외는 `0xdeadfa11` 예외 코드를 갖습니다.

##### 낮은 메모리(Low Memory) 충돌 보고서

이 경우는 충돌 발생 시 장치의 메모리 상황에 대한 자세한 정보를 알려주어야 하기 때문에 다른 충돌 유형과 다르게 보입니다:

```
Incident Identifier: D4E8B5B8-E2EA-4F60-9416-FOBD98DCEFCA
CrashReporter Key:   15dc3be0eedf85fb074fa175be304082079b99eb
Hardware Model:      iPhone2.1
OS Version:          iPhone 0S 4.0 (8A274b)
Date:                2010-06-01 15:08:15 -0700

Free pages:         581
Wired pages:        10409
Purgeable pages:    0
Largest process:    SeismicXMLMem

Processes
         Name                 UUID                    Count resident pages
   SeismicXMLMem <82789a92cdd1d50ac2b17aa21f2670e2>   38263 (jettisoned) (active)
        installd <ffda7ad4d075b2fdf02216c7e2df9888>     224
notification_pro <880cfd236aafbb1cfbd0787040bc7ced>      91
    syslog_relay <ac90e2e7d96c8ef042d1a6ebfdfa830b>      74
    syslog_relay <ac90e2e7d96c8ef042d1a6ebfdfa830b>      74
            ptpd <9ff6cd3817f1952339f1db5d946f6038>     307
    MobileSafari <c2e954c7fb0e6edaa67aa29224344579>    1873 (jettisoned)
            Maps <665a1fc907f8551a9352bc0522ee36ed>    1095 (jettisoned)
        BTServer <c358dcf48aa131eb66c1996e59809ce1>     242
MobileMusicPlaye <20df528c77dea995ce5bee36e17f59a1>     832 (jettisoned)
     Preferences <f53c80952070f73aadd91ad75c6f43e9>     692 (jettisoned)
MobileStorageMou <23bab46f41cc216fbf66efbaa1786618>     123
            iapd <aa978437f697480fffbbb9b123951d96>     266
      MobileMail <94c71d196ac73109bb6daccie7f2ad10>     985 (jettisoned)
     MobilePhone <36f0c3714659d054ebe7326fe1d1731d>     816 (jettisoned)
             lsd <35af413c617c595603182e83b5403a71>     224
         notifyd <3ecc1a4ab4fd07980d0e6deb38fc5ef9>      82
     CommeCenter <ebaaac70a366bff399c5e0bd740f2d07>     318
     SpringBoard <66c8d430dd0f0bf611428ad1f584321f>    3890 (active)
          config <ab999221c9061690fabd93859a2306a7>     358
   fairplavd.N88 <91988ebaec26a3ced3d0bafc5a1c2195>      86
```

첫 번째 섹션에서는 기본적인 프로세스 정보를 제공합니다:

```
Incident Identifier: D4E8B5B8-E2EA-4F60-9416-FOBD98DCEFCA
CrashReporter Key:   15dc3be0eedf85fb074fa175be304082079b99eb
Hardware Model:      iPhone2.1
OS Version:          iPhone 0S 4.0 (8A274b)
Date:                2010-06-01 15:08:15 -0700
```

두 번째 섹션은 메모리 부족 로그에 관한 것으로, 충돌 당시 사용 가능한 페이지 수를 알려줍니다:

```
Free pages:         581
Wired pages:        10409
Purgeable pages:    0
Largest process:    SeismicXMLMem
```

* 한 페이지는 4 킬로바이트입니다.
* 이 경우에는 `581` 페이지의 여유 공간이 있었으며 이는 약 2MB입니다.

&nbsp;

마지막 섹션에서는 모든 프로세스 목록과 각 프로세스가 사용한 메모리 양을 제공합니다:

```
Processes
         Name                 UUID                    Count resident pages
   SeismicXMLMem <82789a92cdd1d50ac2b17aa21f2670e2>   38263 (jettisoned) (active)
        installd <ffda7ad4d075b2fdf02216c7e2df9888>     224
notification_pro <880cfd236aafbb1cfbd0787040bc7ced>      91
    syslog_relay <ac90e2e7d96c8ef042d1a6ebfdfa830b>      74
    syslog_relay <ac90e2e7d96c8ef042d1a6ebfdfa830b>      74
            ptpd <9ff6cd3817f1952339f1db5d946f6038>     307
    MobileSafari <c2e954c7fb0e6edaa67aa29224344579>    1873 (jettisoned)
            Maps <665a1fc907f8551a9352bc0522ee36ed>    1095 (jettisoned)
        BTServer <c358dcf48aa131eb66c1996e59809ce1>     242
MobileMusicPlaye <20df528c77dea995ce5bee36e17f59a1>     832 (jettisoned)
     Preferences <f53c80952070f73aadd91ad75c6f43e9>     692 (jettisoned)
MobileStorageMou <23bab46f41cc216fbf66efbaa1786618>     123
            iapd <aa978437f697480fffbbb9b123951d96>     266
      MobileMail <94c71d196ac73109bb6daccie7f2ad10>     985 (jettisoned)
     MobilePhone <36f0c3714659d054ebe7326fe1d1731d>     816 (jettisoned)
             lsd <35af413c617c595603182e83b5403a71>     224
         notifyd <3ecc1a4ab4fd07980d0e6deb38fc5ef9>      82
     CommeCenter <ebaaac70a366bff399c5e0bd740f2d07>     318
     SpringBoard <66c8d430dd0f0bf611428ad1f584321f>    3890 (active)
          config <ab999221c9061690fabd93859a2306a7>     358
   fairplavd.N88 <91988ebaec26a3ced3d0bafc5a1c2195>      86
```

* 세 번째 열은 각 프로세스가 사용한 페이지 수입니다.
* 세 번째 열에는 각 프로세스의 상태도 표시됩니다.
* 폐기됨(jettisoned)은 OS가 프로세스의 메모리를 제거하고 있음을 의미합니다.

> 팁:
> * 메모리 부족 알림을 무시해서는 안됩니다.
> * 재구성 가능한 객체를 메모리에서 해제합니다.
> * 캐시를 해제합니다.

### 충돌 보고서 얻기 

* 앱 개발자가 디버그 빌드를 테스트하는 경우, Xcode의 Organizer에서 충돌 로그를 찾을 수 있습니다.
* 디버그 앱을 일부 사용자에게 배포하는 경우, 해당 사용자가 기기를 자신의 컴퓨터와 동기화하는 작업이 필요하며 로그는 다음 경로에 있습니다.
    - 맥 OS X: `~/Library/Logs/CrashReporter/MobileDevice/<DEVICE_NAME>`
    - 윈도우 XP: `C:\Documents and Settings\<USERNAME>\Application Data\Apple Computer\Logs\CrashReporter\MobileDevice\<DEVICE_NAME>`
    - 윈도우 비스타 + 7: `C:\Users\<USERNAME>\AppData\Roaming\Apple Computer\Logs\CrashReporter\MobileDevice\<DEVICE_NAME>`
    - 라이브 앱은 iTunes Connect에서 충돌 보고서를 다운로드할 수 있습니다. (현재는 Xcode의 Organizer를 통해 자동으로 수행됩니다.)

### 충돌 보고서 기호화(symbolication)

* 기호화란?

    - 스레드 역추적 내 주소 값을 기호(symbol) 이름으로 변환하여 로그를 더 잘 이해하는 데 도움이 되며, 충돌을 일으킨 코드 줄로 이동할 수도 있습니다.

&nbsp;

기호화하지 않은 충돌 보고서:

```
Thread 0:
0   libSystem.B.dylib  0x31227688 0x31226000 + 5768
1   libSystem.B.dylib  0x31229754 0x31226000 + 14164
2   CoreFoundation     0x325062c8 0x32494000 + 467656 
3   CoreFoundation     0x32508582 0x32494000 + 476546 
4   CoreFoundation     0x324b18e4 0x32494000 + 121060 
5   CoreFoundation     0x324b17ec 0x32494000 + 120812 
6   CFNetwork          0x30569228 0x30501000 + 426536
7   Foundation         0x3217bcec 0x32139000 + 273644
8   SeismicXML         0x000029d4 0x1000 + 6612
```

기호화한 충돌 보고서:

```
Thread 0:
0   libSystem.B.dylib 0x00001688 mach_msg_trap + 20
1   libSystem.B.dylib 0x00003754 mach_msg (mach_msg.c:99)
2   CoreFoundation    0x000722c8 __CFRunLoopServiceMachPort (CFRunLoop.c:1837)
3   CoreFoundation    0x00074582 __CFRunLoopRun (CFRunLoop.c:1961)
4   CoreFoundation    0x0001d8e4 CFRunLoopRunSpecific (CFRunLoop.c:2294)
5   CoreFoundation    0x0001d7ec CFRunLoopRunInMode (CFRunLoop.c:2316)
6   CFNetwork         0x00068228 CFURLConnectionSendSynchronousRequest + 244
7   Foundation        0x00042cec +[NSURLConnection sendSynchronousRequest:returningResponse:error:] + 76
8   SeismicXML        0x000029d4 -[SeismicXMLAppDelegate applicationDidFinishLaunching:] (SeismicXMLAppDelegate.m:129)
```

앱 바이너리 프레임이 있는 줄(스택 마지막 줄)을 보면 함수 이름, 파일 이름 및 줄 번호를 볼 수 있습니다.

```
8   SeismicXML        0x000029d4 -[SeismicXMLAppDelegate applicationDidFinishLaunching:] (SeismicXMLAppDelegate.m:129)
                                                # 함수 이름                                       # 파일 이름      # 줄 번호
```

충돌 로그는 XCode에서 기호화할 수 있습니다:
* Xcode에서 충돌 로그를 드래그하면 기호화를 수행합니다.
* 이를 수행하려면 해당 버전의 앱에 대한 앱 바이너리 및 .dSYM에 대한 액세스가 필요합니다.

### 일반적인 충돌

* 이미 메모리 해제된 객체에 대한 해제(Over released object)
* `Null` 포인터 역참조(dereference)
* 배열 또는 딕셔너리에 `nil` 오브젝트 추가

> 팁:
> * `EXC_BAD_ACCESS` 예외는 앱이 사용자가 소유하지 않은 메모리에 액세스하려고 한다는 의미이며, 이는 일종의 메모리 문제임을 알려줍니다.
> * `SIGABRT`는 애플리케이션이 커널에 앱의 종료를 요청한 다음 커널이 돌아와서 앱을 종료한다는 의미입니다. 이는 예외가 발생하여 포착되고 커널이 들어와 앱을 종료할 때 발생합니다. 이 경우 스레드 역추적에서 중단(abort)이라는 내용을 찾아야 합니다.
