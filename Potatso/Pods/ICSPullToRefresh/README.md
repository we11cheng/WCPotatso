# ICSPullToRefresh-Swift ![MIT License](https://img.shields.io/badge/License-MIT-brightgreen.svg)

ICSPullToRefresh-Swift is a Swift version of [SVPullToRefresh](https://github.com/samvermette/SVPullToRefresh), providing PullToRefresh && InfiniteScrolling features for ```UIScrollView```

## Installation

> Embedded frameworks require a minimum deployment target of iOS 8. 

### CocoaPods

CocoaPods (>= 0.36) adds supports for Swift and embedded frameworks. 

Add ```pod 'ICSPullToRefresh'``` to your ```Podfile```: 

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'ICSPullToRefresh', '~> 0.4'
```

### Carthage

To integrate ```ICSPullToRefresh``` into your Xcode project using Carthage, specify it in your ```Cartfile```:

```
github "iCodesign/ICSPullToRefresh" >= 0.4
```

### Manually

You can also integrate ```ICSPullToRefresh``` directly with souce code. Clone the repo and copy ```ICSPullToRefresh.swift``` and ```ICSInfiniteScrolling.swift``` to your project.

## Usage

### PullToRefresh

```
UIScrollView.addPullToRefreshHandler(() -> ())
```

Start/Stop animating:

```
UIScrollView.pullToRefreshView?.startAnimating()
UIScrollView.pullToRefreshView?.stopAnimating()
```

Trigger manually:

```
UIScrollView.triggerPullToRefresh()
```

Hide pulltorefresh:

```
UIScrollView.setShowsPullToRefresh(Bool)
```

> Since after iOS7, iOS brings ```automaticallyAdjustsScrollViewInsets``` to ```UISrollView``` embedded in a ```UINavigationController``` or ```UITabBarController``` which changes ```contentInset``` of ```UISrollView``` between ```viewDidLoad``` nad ```viewDidAppear```, so you have to put the ```addPullToRefreshHandler``` in  or after ```viewDidAppear```

Example: 

```
tableView.addPullToRefreshHandler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
        // do something in the background
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.pullToRefreshView?.stopAnimating()
        })
    })
}
```

### InfiniteScrolling

```
UIScrollView.addInfiniteScrollingWithHandler(() -> ())
```

Start/Stop animating:

```
UIScrollView.infiniteScrollingView?.startAnimating()
UIScrollView.infiniteScrollingView?.stopAnimating()
```

Trigger manually:

```
UIScrollView.triggerInfiniteScrolling()
```

Hide infiniteScrolling:

```
UIScrollView.setShowsInfiniteScrolling(Bool)
```

> Since after iOS7, iOS brings ```automaticallyAdjustsScrollViewInsets``` to ```UISrollView``` embedded in a ```UINavigationController``` or ```UITabBarController``` which changes ```contentInset``` of ```UISrollView``` between ```viewDidLoad``` nad ```viewDidAppear```, so you have to put the ```addInfiniteScrollingWithHandler``` in  or after ```viewDidAppear```

Example:

```
tableView.addInfiniteScrollingWithActionHandler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
        // do something in the background
        dispatch_async(dispatch_get_main_queue(), { [unowned self] in
            self.tableView.reloadData()
            self.tableView.infiniteScrollingView?.stopAnimating()
        })
    })
}
```

## Credits

Thanks to [SVPullToRefresh](https://github.com/samvermette/SVPullToRefresh) by [Sam Vermette](http://samvermette.com).

