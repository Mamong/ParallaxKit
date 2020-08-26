#  ParallaxKit

A  tool written in swift to generate parallax animation during sliding a scroll view.


## usage

1.create a ParallaxManager with a scrollview
```
pm = ParallaxManager.init(with: scrollView, direction: .down)
```
2.set backgroundImage, not required
```
pm?.backgroundImage = UIImage.init(named: "bg2.jpg")
```
3.addKeyFrameAnimation, certainly you should create several pages in advance
```
pm?.addKeyFrameAnimation(animation: [
    "wrapper" : intro,
    "duration" : "100%",
    "animations" :  [
        [
            "view"    : intro.nameLabel,
            "translateY"  : -140,
            "opacity"     : 0
        ] , [
            "view"    : intro.descLabel,
            "translateY"  : -110,
            "opacity"     : 0
        ]
    ]
])
```
Key Frame Animation is described using dictionary literal.

4.you should call generateKeyFrameAnimations() when you finish step 3.
```
pm?.generateKeyFrameAnimations()
```

5.in UIScrollviewDelegate method scrollViewDidScroll(_:), you should call the same method to perform animations.
```
pm?.scrollViewDidScroll(scrollView)
```

## screenshot
![]()
