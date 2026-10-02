# Advanced ScrollView Techniques

@Metadata {
    @TitleHeading("Session 104")
}

2011년 세션이라 예제가 전부 `UIScrollView`다. 컬렉션 뷰는 다음 해 iOS 6에서야 나왔기 때문에, 가로로 끝없이 넘어가는 화면이나 확대해도 선명한 화면은 스크롤 뷰 위에 직접 만들어야 했다. 이 세션은 그 수작업을 어떻게 하는지 보여 준다.

### 기초

* `contentSize`는 안쪽 콘텐츠의 크기다. 이 값이 스크롤 뷰보다 커야 스크롤이 된다.
* `contentOffset`은 지금 화면 왼쪽 위 모서리에 콘텐츠의 어느 지점이 걸려 있는지를 나타낸다. 높이 800짜리 스크롤 뷰에서 아래로 300 내리면 `contentOffset.y`는 300이다.
* 확대/축소를 하려면 세 가지가 필요하다.
    - 델리게이트에서 `viewForZooming(in:)`으로 확대할 뷰를 돌려준다.
    - 그 델리게이트를 스크롤 뷰에 연결한다.
    - `minimumZoomScale`과 `maximumZoomScale`을 서로 다르게 준다. 둘 다 기본값이 `1.0`이라 그대로 두면 확대가 안 된다.

### 고급 테크닉

세션은 네 가지를 다룬다.

1. 무한 스크롤
2. 고정된 뷰
3. 커스텀 터치 처리
4. 확대 후 다시 그리기

##### 1. 무한 스크롤

> 📚 샘플 코드 [StreetScroller](https://developer.apple.com/library/archive/samplecode/StreetScroller/StreetScroller.zip) 다운로드

여기서 말하는 무한 스크롤은 피드처럼 끝에 닿을 때마다 콘텐츠를 더 붙이는 무한 로딩이 아니다. 한 방향으로 계속 밀어도 끝에 닿지 않는 스크롤이다. 광고 배너 같은 걸 떠올리면 된다. 지금도 SwiftUI에는 이런 순환 스크롤이 없어서 직접 구현해 쓰는데, 끝에 닿기 전에 눈치 못 채게 순간이동한다는 발상은 똑같다.

계속 붙이기만 하면 안 되는 이유는 두 가지다. `contentSize`가 끝없이 커지고, 시작 지점에서 반대쪽으로는 갈 수가 없다. `contentOffset`은 0보다 작아질 수 없으니까.

그래서 크기는 고정해 두고 런닝머신처럼 만든다. 걷는 사람은 계속 앞으로 가는데 실제 위치는 늘 가운데인 것처럼.

1. `contentSize`를 화면의 두 배쯤으로 잡는다. 콘텐츠를 두 벌 복사해 두는 게 아니라 좌우로 움직일 여유 공간이다.
2. 한쪽 끝에 가까워지면 `contentOffset`을 가운데로 돌려놓는다.
3. 안의 뷰들도 같은 거리만큼 옮긴다.

2와 3은 반드시 같이 해야 한다. 오프셋만 옮기면 손가락은 그대로인데 화면이 한 프레임 만에 툭 튀어 버린다. 뷰를 같은 거리만큼 옮겨서 그 이동을 상쇄해야 사용자가 눈치채지 못한다.

이 확인은 스크롤할 때마다 해야 하고, 끼어들 자리는 두 군데다.

* `UIScrollView`를 상속해 `layoutSubviews()`를 오버라이드한다. 스크롤이나 확대로 bounds가 바뀔 때마다 불린다.
* 델리게이트의 `scrollViewDidScroll(_:)`을 쓴다.

샘플 코드는 앞의 방법을 쓴다.

```objectivec
@implementation InfiniteScrollView

// 끝없이 스크롤되는 것처럼 보이도록, 필요할 때마다 가운데로 돌려놓는다.
- (void)recenterIfNecessary
{
    CGPoint currentOffset = [self contentOffset];
    CGFloat contentWidth = [self contentSize].width;
    CGFloat centerOffsetX = (contentWidth - [self bounds].size.width) / 2.0;
    CGFloat distanceFromCenter = fabs(currentOffset.x - centerOffsetX);
    
    // 중심에서 25% 넘게 벗어나면 가운데로 돌려놓는다. 25%는 임의로 정한 값이다.
    if (distanceFromCenter > (contentWidth / 4.0)) {
        self.contentOffset = CGPointMake(centerOffsetX, currentOffset.y);
        
        // 라벨도 같은 거리만큼 옮겨서 화면이 튀지 않게 한다.
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

샘플 코드는 여기에 하나를 더 한다. 화면에 들어오는 쪽에 라벨을 새로 붙이고, 밖으로 나간 라벨은 떼어낸다. 셀 재사용과 같은 발상이다.

##### 2. 고정된 뷰

한 방향으로는 스크롤되고 다른 방향으로는 고정된 뷰다.

세션의 예시는 사진 뷰어다. 사진 위에 제목이 붙어 있고, 사진은 확대하고 스크롤할 수 있다.

* 아래로 스크롤하면 제목도 같이 밀려 올라가서 사라진다. 아래로 내린다는 건 사진을 더 보고 싶다는 뜻이니 제목이 사진을 가리지 않게 한 것 같다.
* 확대한 사진을 좌우로 밀어도 제목은 가로로 그대로다.

제목을 스크롤 뷰 밖에 두면 아예 안 움직이니까 이렇게 만들 수 없다. 그래서 스크롤 뷰 하나에 두 뷰를 넣는다.

1. 확대되지 않는 제목 뷰
2. 확대되는 `UIImageView`. `viewForZooming(in:)`으로 돌려주는 뷰다.

여기서 손볼 게 두 가지다.

* **가로 고정**: `layoutSubviews()`에서 제목의 `frame.origin.x`를 `contentOffset.x`와 같게 맞춘다. 화면에 보이는 위치는 `frame.origin.x - contentOffset.x`라서, 사진을 밀어 `contentOffset.x`가 200이 되면 제목도 200으로 따라가고 화면에서는 늘 그 자리다.
* **`contentSize` 보정**: 확대하면 스크롤 뷰가 `contentSize`를 사진의 확대된 크기로 알아서 바꾼다. 그대로 두면 사진 위에 얹힌 제목 높이만큼 아래쪽이 잘린다. 그래서 `contentSize` setter를 오버라이드해 제목 높이를 더해 준다.

##### 3. 커스텀 터치 처리

스크롤 뷰는 스크롤과 확대에 쓰는 제스처를 `panGestureRecognizer`와 `pinchGestureRecognizer`로 열어 둔다. 스크롤 뷰가 안에서 실제로 쓰는 제스처라서, 다른 제스처와의 관계를 여기에 직접 정해 줄 수 있다.

세션의 예시는 스크롤 뷰 아래쪽에서 위아래로 쓸면 스크롤 대신 다른 뷰가 올라오거나 내려가는 화면이다.

스크롤 뷰에 스와이프를 그냥 붙이면 두 제스처가 겹친다. 먼저 인식한 쪽이 이기는데, 팬은 조금만 움직여도 인식하니까 스와이프는 끝내 불리지 않는다. 그래서 우선순위와 동작 범위를 정해 줘야 한다.

우선순위는 `requireGestureRecognizerToFail:`로 정한다. 팬이 스와이프가 실패할 때까지 기다리게 하는 거다. 코드는 `loadView`나 `viewDidLoad`에 넣으면 된다.

```objectivec
UIScrollView *scrollView = [self scrollView];
UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUp:)];
swipeUp.direction = UISwipeGestureRecognizerDirectionUp;

[scrollView addGestureRecognizer:swipeUp];
// 이게 없으면 팬이 항상 먼저 인식해서 스와이프가 불리지 않는다.
[scrollView.panGestureRecognizer requireGestureRecognizerToFail:swipeUp];
```

문제는 이러면 화면 어디서든 팬이 기다린다는 거다. 손가락을 움직여도 스와이프가 포기할 때까지 화면이 안 따라와서, 제스처가 없는 것처럼 느껴진다.

그래서 동작 범위를 아래쪽으로 좁힌다. 아래쪽 75pt 밖의 터치는 스와이프가 받지 않게 해서 일부러 실패시킨다. 스와이프가 바로 실패하니 팬도 기다리지 않는다.

```objectivec
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
  UIScrollView *scrollView = [self scrollView];
  CGRect visibleBounds = [scrollView bounds];
  CGPoint touchPoint = [touch locationInView:scrollView];
  if (touchPoint.y < CGRectGetMaxY(visibleBounds) - 75)
    return NO;
  return YES;
}
```

##### 4. 확대 후 다시 그리기

> 📚 샘플 코드 [ScrollViewSuite](https://developer.apple.com/library/archive/samplecode/ScrollViewSuite/ScrollViewSuite.zip) 다운로드 
>
> 📚 샘플 코드 [PhotoScroller](https://developer.apple.com/library/archive/samplecode/PhotoScroller/PhotoScroller.zip) 다운로드

확대는 이미 그려진 걸 늘리는 거다. 스크롤 뷰는 확대하는 동안 뷰를 다시 그리지 않고 비트맵에 transform만 걸어서 키운다. 그래서 텍스트나 선을 그린 뷰도 확대할수록 흐려진다.

선명하게 하려면 다시 그려야 하는데, 손가락으로 벌리는 동안 하면 안 된다. 계속 연산이 들어가서 CPU에 부하가 너무 심하고, 배율이 매 프레임 바뀌니 그려봤자 바로바로 버려진다. 그래서 확대가 끝나고 최종 배율이 정해졌을 때 `scrollViewDidEndZooming(_:with:atScale:)`에서 한 번만 그린다.

방법은 `contentScaleFactor`를 확대 배율만큼 키우는 거다. 이 값은 뷰를 몇 배 촘촘한 픽셀로 그릴지 정한다. 화면 배율까지 곱해야 실제 픽셀에 맞는다.

```objectivec
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView
                       withView:(UIView *)view
                        atScale:(float)scale
{
  scale *= [[[scrollView window] screen] scale];
  [view setContentScaleFactor:scale];
}
```

다만 작은 콘텐츠에만 쓴다. 해상도가 너무 올라가기 때문이다. 레티나 화면에서 4배로 확대하면 가로세로 8배, 픽셀 수로는 64배다. 1000×1000짜리 뷰면 256MB쯤 된다. 큰 콘텐츠는 PhotoScroller처럼 `CATiledLayer`로 화면에 보이는 조각만 그리는 게 맞다.
