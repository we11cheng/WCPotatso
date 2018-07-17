//
//  ICSInfiniteScrolling.swift
//  ICSPullToRefresh
//
//  Created by LEI on 3/17/15.
//  Copyright (c) 2015 TouchingAPP. All rights reserved.
//

import UIKit

fileprivate var infiniteScrollingViewKey: Void?

fileprivate struct Constants {
    static let observeKeyContentOffset = "contentOffset"
    static let observeKeyContentSize = "contentSize"
    static let observeKeyContentInset = "contentInset"

    static let infiniteScrollingViewValueKey = "ICSInfiniteScrollingView"

    static let infiniteScrollingViewHeight: CGFloat = 60
}

public extension UIScrollView{
    
    public var infiniteScrollingView: InfiniteScrollingView? {
        get {
            return objc_getAssociatedObject(self, &infiniteScrollingViewKey) as? InfiniteScrollingView
        }
        set(newValue) {
            willChangeValue(forKey: Constants.infiniteScrollingViewValueKey)
            objc_setAssociatedObject(self, &infiniteScrollingViewKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            didChangeValue(forKey: Constants.infiniteScrollingViewValueKey)
        }
    }
    
    public var showsInfiniteScrolling: Bool {
        guard let infiniteScrollingView = infiniteScrollingView else {
            return false
        }
        return !infiniteScrollingView.isHidden
    }
    
    public func addInfiniteScrollingWithHandler(_ actionHandler: @escaping ActionHandler){
        if infiniteScrollingView == nil {
            infiniteScrollingView = InfiniteScrollingView(frame: CGRect(x: CGFloat(0), y: contentSize.height, width: bounds.width, height: Constants.infiniteScrollingViewHeight))
            addSubview(infiniteScrollingView!)
            infiniteScrollingView?.autoresizingMask = .flexibleWidth
            infiniteScrollingView?.scrollViewOriginContentBottomInset = contentInset.bottom
        }
        infiniteScrollingView?.actionHandler = actionHandler
        setShowsInfiniteScrolling(true)
    }
    
    public func triggerInfiniteScrolling() {
        infiniteScrollingView?.state = .triggered
        infiniteScrollingView?.startAnimating()
    }
    
    public func setShowsInfiniteScrolling(_ showsInfiniteScrolling: Bool) {
        guard let infiniteScrollingView = infiniteScrollingView else {
            return
        }
        infiniteScrollingView.isHidden = !showsInfiniteScrolling
        if showsInfiniteScrolling {
            addInfiniteScrollingViewObservers()
        } else {
            removeInfiniteScrollingViewObservers()
            infiniteScrollingView.setNeedsLayout()
            infiniteScrollingView.frame = CGRect(x: CGFloat(0), y: contentSize.height, width: infiniteScrollingView.bounds.width, height: Constants.infiniteScrollingViewHeight)
        }
    }
    
    fileprivate func addInfiniteScrollingViewObservers() {
        guard let infiniteScrollingView = infiniteScrollingView, !infiniteScrollingView.isObserving else {
            return
        }
        addObserver(infiniteScrollingView, forKeyPath: Constants.observeKeyContentOffset, options:.new, context: nil)
        addObserver(infiniteScrollingView, forKeyPath: Constants.observeKeyContentSize, options:.new, context: nil)
        infiniteScrollingView.isObserving = true
    }
    
    fileprivate func removeInfiniteScrollingViewObservers() {
        guard let infiniteScrollingView = infiniteScrollingView, infiniteScrollingView.isObserving else {
            return
        }
        removeObserver(infiniteScrollingView, forKeyPath: Constants.observeKeyContentOffset)
        removeObserver(infiniteScrollingView, forKeyPath: Constants.observeKeyContentSize)
        infiniteScrollingView.isObserving = false
    }
}

open class InfiniteScrollingView: UIView {
    open var actionHandler: ActionHandler?
    open var isObserving: Bool = false
    
    open var scrollView: UIScrollView? {
        return self.superview as? UIScrollView
    }
    
    open var scrollViewOriginContentBottomInset: CGFloat = 0
    
    public enum State {
        case stopped
        case triggered
        case loading
        case all
    }
    
    open var state: State = .stopped {
        willSet {
            if state != newValue {
                setNeedsLayout()
                switch newValue {
                case .loading:
                    setScrollViewContentInsetForInfiniteScrolling()
                    if state == .triggered {
                        actionHandler?()
                    }
                default:
                    break
                }
            }
        }

        didSet {
            switch state {
            case .stopped:
                resetScrollViewContentInset()

            default:
                break
            }
        }
    }
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViews()
    }
    
    open func startAnimating() {
        state = .loading
    }
    
    open func stopAnimating() {
        state = .stopped
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == Constants.observeKeyContentOffset {
            srollViewDidScroll((change?[NSKeyValueChangeKey.newKey] as AnyObject).cgPointValue)
        } else if keyPath ==  Constants.observeKeyContentSize {
            setNeedsLayout()
            if let _ = (change?[NSKeyValueChangeKey.newKey] as AnyObject).cgPointValue {
                self.frame = CGRect(x: CGFloat(0), y: scrollView!.contentSize.height, width: self.bounds.width, height:  Constants.infiniteScrollingViewHeight)
            }
        }
    }
    
    fileprivate func srollViewDidScroll(_ contentOffset: CGPoint?) {
        guard let scrollView = scrollView, let contentOffset = contentOffset else {
            return
        }
        guard state != .loading else {
            return
        }
        let scrollViewContentHeight = scrollView.contentSize.height
        var scrollOffsetThreshold = scrollViewContentHeight - scrollView.bounds.height + 40
        if (scrollViewContentHeight < self.scrollView!.bounds.height) {
            scrollOffsetThreshold = 40 - self.scrollView!.contentInset.top
        }

        activityIndicator.hidesWhenStopped = !(
            scrollView.isDragging &&
            scrollViewContentHeight > self.scrollView!.bounds.height
        )

        if !scrollView.isDragging && state == .triggered {
            state = .loading
        } else if contentOffset.y > scrollOffsetThreshold && state == .stopped && scrollView.isDragging {
            state = .triggered
        } else if contentOffset.y < scrollOffsetThreshold && state != .stopped {
            state = .stopped
        }
    }
    
    fileprivate func setScrollViewContentInset(_ contentInset: UIEdgeInsets) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: { () -> Void in
            self.scrollView?.contentInset = contentInset
        }, completion: nil)
    }
    
    fileprivate func resetScrollViewContentInset() {
        guard let scrollView = scrollView else {
            return
        }
        var currentInset = scrollView.contentInset
        currentInset.bottom = scrollViewOriginContentBottomInset
        setScrollViewContentInset(currentInset)
    }
    
    fileprivate func setScrollViewContentInsetForInfiniteScrolling() {
        guard let scrollView = scrollView else {
            return
        }
        var currentInset = scrollView.contentInset
        currentInset.bottom = scrollViewOriginContentBottomInset +  Constants.infiniteScrollingViewHeight
        setScrollViewContentInset(currentInset)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        defaultView.frame = self.bounds
        activityIndicator.center = defaultView.center
        switch state {
        case .stopped:
            activityIndicator.stopAnimating()
        case .loading:
            activityIndicator.startAnimating()
        default:
            break
        }
    }
    
    open override func willMove(toSuperview newSuperview: UIView?) {
        guard newSuperview == nil, let _ = superview, let showsInfiniteScrolling = scrollView?.showsInfiniteScrolling, showsInfiniteScrolling else {
            return
        }
        scrollView?.removeInfiniteScrollingViewObservers()
    }
    
    // MARK: Basic Views
    
    fileprivate func initViews() {
        addSubview(defaultView)
        defaultView.addSubview(activityIndicator)
    }
    
    fileprivate lazy var defaultView: UIView = {
        let view = UIView()
        return view
    }()
    
    fileprivate lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()

    open func setActivityIndicatorColor(_ color: UIColor) {
        activityIndicator.color = color
    }

    open func setActivityIndicatorStyle(_ style: UIActivityIndicatorViewStyle) {
        activityIndicator.activityIndicatorViewStyle = style
    }
    
}
