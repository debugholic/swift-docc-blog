# Advanced ScrollView Techniques

@Metadata {
    @TitleHeading("Session 104")
}

1차원이나 2차원에서 무한 스크롤 형태를 구현하는 방법에 대해 알아봅시다. 또한 이미 그려져 있는 콘텐츠를 확대/축소(zooming)하는 도중에 `CATiledLayer`를 사용하지 않으면서 해상도를 변경하는 방법도 살펴보겠습니다.

### 기초(Basics)

* `UIScrollView`에서 스크롤이 가능하게 하려면 콘텐츠의 크기를 `UIScrollView`에 알려 주는 `contentSize`를 설정하세요.
* 현재 화면에 표시되는 콘텐츠 위치를 확인하려면 `UIScrollView`의 `contentOffset`을 사용하세요. 이것은 스크롤 뷰 프레임 내에서 현재 표시되는 화면의 왼쪽 상단 지점의 위치(스크롤 뷰의 원점(origin)으로부터 스크롤 위치까지의 오프셋)를 나타냅니다.
* 스크롤 뷰에서 확대/축소(zoom) 작업을 수행하려면:
    - `UIScrollViewDelegate`를 따르는(conforming) 타입을 만들고 `viewForZooming(in:)`을 구현합니다.
    - 이 타입의 인스턴스를 `UIScrollView`의 인스턴스 델리게이트(instance delegate)로 설정합니다.
    - `UIScrollView` 인스턴스의 `minimumZoomScale`과 `maximumZoomScale`을 다른 값으로 설정합니다.(둘다 기본 값은 `1.0`입니다.)

### 고급 테크닉(Advanced Techniques)

1. 무한 스크롤(Infinite scrolling)
2. 고정된 뷰(Stationary views)
3. 커스텀 터치 핸들링(Custom touch handling)
4. 확대/축소 후 다시 그리기(Redraw after zooming)

##### 1. 무한 스크롤(Infinite scrolling)

> 📚 샘플 코드 [StreetScroller](https://developer.apple.com/library/archive/samplecode/StreetScroller/StreetScroller.zip) 다운로드

사용자는 한 방향으로 스크롤을 계속할 수 있으며 콘텐츠의 가장 자리에 부딪히지 않습니다. (예: 포토 캐러셀(photo carousel))

구현 방법:

1. `contentSize`를 화면에 표시되는 크기의 두 배 정도 크기로 만듭니다.
2. 사용자가 콘텐츠 가장자리 부근에 도달하려고 하면, `contentOffset`을 조정하여 `contentSize`(스크롤 가능한 영역)의 중앙으로 이동 시킵니다.
3. 콘텐츠 하위 뷰의 프레임을 `contentOffset`과 같은 양으로 조정하여, 계속 콘텐츠 영역의 가운데에 위치하도록 만듭니다.

마지막 두 단계는 동시에 수행되어야 하며 사용자는 이를 알아차릴 수 없습니다.

사용자가 스크롤할 때마다 해당 하위 뷰를 다시 레이아웃(re-layout)하는 것이 아이디어입니다.

두 가지 방법이 있습니다:

* `UIScrollView`의 하위 클래스를 만들고 `layoutSubviews()` 메서드를 오버라이딩합니다. `layoutSubviews()`는 확대/축소와 스크롤 시의 모든 프레임에서(다른 말로, 스크롤 뷰 경계가 변경될 때마다) 호출됩니다.
* `UIScrollViewDelegate`의 `scrollViewDidScroll(_:)` 사용

다음은 가로 방향 무한 스크롤 뷰 코드입니다:

```
@implementation InfiniteScrollView

// 무한 스크롤의 느낌을 내기 위해 주기적으로 콘텐츠를 최신 상태로 유지합니다.
- (void)recenterIfNecessary
{
    CGPoint currentOffset = [self contentOffset];
    CGFloat contentWidth = [self contentSize].width;
    CGFloat centerOffsetX = (contentWidth - [self bounds].size.width) / 2.0;
    CGFloat distanceFromCenter = fabs(currentOffset.x - centerOffsetX);
    
    // 오프셋이 중심에서 25% 이상 벗어나면 중심을 다시 조정합니다. 딱히 정해진 것은 아닙니다(arbitrary).
    if (distanceFromCenter > (contentWidth / 4.0)) {
        self.contentOffset = CGPointMake(centerOffsetX, currentOffset.y);
        
        // 콘텐츠를 같은 양만큼 이동하여 가만히 있는 것처럼 보이도록 합니다.
        for (UILabel *label in self.visibleLabels) {
            CGPoint center = [self.labelContainerView convertPoint:label.center toView:self];
            center.x += (centerOffsetX - currentOffset.x);
            label.center = [self convertPoint:center toView:self.labelContainerView];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self recenterIfNecessary];
}

...

@end
```

##### 2. 고정된 뷰(Stationary views)

한 차원/방향에서는 고정된 상태로 유지되지만 다른 축에서는 스크롤 콘텐츠와 함께 스크롤되는 뷰입니다. 헤더(header)와 푸터(footer)처럼 생각해보세요.

이는 확대/축소 또는 스크롤할 때에, 콘텐츠 영역 중 일정 영역은 움직이지 않아야 하는 경우입니다.(예: 이미지의 제목)

다음과 같은 시나리오를 상상해 봅시다:

* 스크롤 뷰 위에 붙는 이미지 제목이 있습니다.
* 이미지를 스크롤하고 확대/축소할 수 있지만 제목은 그대로 유지됩니다.
* 제목은 사용자가 이미지를 아래로 스크롤할 때에는 사라지므로 이미지 전체를 볼 수 있습니다.
* 그 밖의 상호 작용(확대/축소 또는 스크롤하면 제목이 다시 표시됨)

구성하기:

전체 공간을 차지하는 하나의 스크롤 뷰가 있으며 내부에 두 개의 하위 뷰가 있습니다.

1. 확대/축소할 수 없는 헤더/타이틀 뷰
2. 확대/축소할 수 있는 `UIImageView`가 있으며, `viewForZooming(in:)`으로 반환(return)하는 뷰입니다.

다음 할 일:

* `UIImageView`만 스크롤할 수 있으므로, 가장 먼저 해야 할 일은 이미지 뷰에서 확대/축소/스크롤 시 헤더 뷰가 가로 중앙에 유지되는지 확인하는 것입니다. 이는 `layoutSubviews()`에서 헤더의 `frame.origin.x`을 `contentOffset.x`과 동일한 값으로 설정하면 해결됩니다.
* 스크롤 뷰를 확대하면 스크롤 뷰 콘텐츠의 크기가 `viewForZooming(in:)`에 반환되는 뷰의 확대된 크기로 자동 업데이트됩니다. 스크롤 뷰에 포함된 헤더 뷰의 크기를 고려하도록 `contentSize` 설정자(setter)를 오버라이딩해야 합니다.

##### 3. 맞춤형 터치 처리

> 이 세션에서는 스크롤 뷰의 하위 뷰에 멀티터치 핸들러를 추가하는 방법을 중점적으로 다룹니다.

`UIScrollView`의 팬(pan) 및 핀치(pinch) 제스처 인식기(recognizer)는 `panGestureRecognizer` 및 `pinchGestureRecognizer` 속성을 통해 가져올 수 있습니다. 이는 각각 스크롤 및 확대/축소용 제스처를 관리하기 위해 `UIScrollView`가 사용하는 것과 동일한 인식기입니다.

이 세션에서는 다음과 같은 시나리오를 구현합니다:

* 스크롤 뷰의 아래쪽에서 위/아래로 스와이프하면 스크롤 뷰에서 스크롤하는 대신 다른 뷰가 나타나거나 사라집니다.

구현(이 코드는 `loadView()/viewDidLoad()`에 추가할 수 있습니다):

```
UIScrollView *scrollView = [self scrollView]:
UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action: @selector (handleSwipeUp:)];
swipeUp.direction = UISwipeGestureRecognizerDirectionUp;

[scrollView addGestureRecognizer: swipeUp];
// 👇🏻 이것은 필수입니다. 그렇지 않으면 위로 스와이프하기 전에 항상 scrollView.panGestureRognizer가 트리거됩니다.
// 👇🏻 this is required, otherwise the scrollView.panGestureRecognizer would always trigger before our swipe up
[scrollView.panGestureRecognizer requireGestureRecognizerToFail:swipeUp];
```

이 구현에서는 제스처가 스와이프가 아닌지를 확인해야 하므로 스크롤 뷰 팬 제스처가 트리거될 때까지 기다리게 됩니다. 그러나 우리는 전체 화면이 아닌 스크롤 뷰의 하단에 대해서만 이 동작을 원합니다. 따라서 대상 영역을 제한할 수 있습니다:

```
- (BOOL) gestureRecognizer: (UIGestureRecognizer *)gestureRecognizer
        shouldReceiveTouch: (UITouch *) touch
{
  UIScrollView #scrollView = [self scrollView];
  CGRect  visibleBounds = [scrollView bounds]:
  CGPoint touchPoint = [touch locationInView:scrollView];
  if (touchPoint.y < CGRectGetMaxY(visibleBounds) - 75)
    return NO:
  return YES;
}
```

##### 4. 확대/축소 후 다시 그리기

> 📚 샘플 코드 [ScrollViewSuite](https://developer.apple.com/library/archive/samplecode/ScrollViewSuite/ScrollViewSuite.zip) 다운로드 
>
> 📚 샘플 코드 [PhotoScroller](https://developer.apple.com/library/archive/samplecode/PhotoScroller/PhotoScroller.zip) 다운로드

> 이 세션은 사용자가 확대/축소를 완료한 후 다시 그려야 하는 작은 콘텐츠에 중점을 둡니다.

콘텐츠가 확대되면 흐릿해지기(blurry) 시작하므로 다시 그려서 다시 선명하게 만들고 싶다는 것이 이 세션의 아이디어입니다.

이 다시 그리기는 사용자가 확대/축소하는 동안이 아니라 확대/축소가 종료된 후에만 수행합니다(그 이유는 이 작업이 비용이 많이 들고 사용자가 계속 확대/축소할 때 계속 버리게 되기 때문입니다): `scrollViewDidEndZooming(_:with:atScale:)`을 통해 얻을 수 있으며, 최종 배율이 무엇인지 알려주기도 합니다.

방법(⚠️ 작은 콘텐츠의 경우에만 해당):

```
- (void)scrollViewDidEndZooming: (UIScrollView *) sv
                       withView: (UIView *) view
                       atScale: (float)scale
{
  scale *= [[[scrollView window] screen] scale]z:
  [view setContentScaleFactor:scale]:
}
```

뷰의 `contentScaleFactor`는 기본적으로 뷰의 바운드 크기에 적용되는 승수(multiplier)로, 뷰를 뒷받침하는 스토리지의 크기를 결정하는 데 사용됩니다.
