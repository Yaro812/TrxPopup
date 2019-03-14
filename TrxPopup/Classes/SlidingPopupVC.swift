//
//  SlidingPopupVC.swift
//  TrxPopup
//
//  Created by user on 29/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

public class SlidingPopupVC: UIViewController {
    
    // MARK: Public static functions
    
    public static func instantiate() -> SlidingPopupVC {
        let vc = SlidingPopupVC(nibName: nil, bundle: nil)
        return vc
    }
    
    // MARK: Public properties
    
    /// Animator that handles appearing and disappearing animations
    public var animator: UIViewControllerAnimatedTransitioning = SlidingPopupAnimator()
    
    public private(set) lazy var slidingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    public private(set) lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Close", for: .normal)
        button.tintColor = UIColor.black.withAlphaComponent(0.7)
        button.addTarget(self, action: #selector(tapClose), for: .touchUpInside)
        return button
    }()
    
    public var containerSize: CGSize = CGSize(width: 200, height: 300) {
        didSet {
            if isViewLoaded {
                updateViewConstraints()
            }
        }
    }
    
    /// will be called just before closing animations begins
    public var onWillClose: (() -> Void)?
    /// will be called right after closing animations end
    public var onClosed: (() -> Void)?
    
    // MARK: Private properties
    
    private var containerWidthConstraint: NSLayoutConstraint!
    private var containerHeightConstraint: NSLayoutConstraint!
    internal var sliderBotomInsetConstraint: NSLayoutConstraint!
    
    // MARK: Lifecycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        modalPresentationStyle = .overFullScreen
        setupViews()
        transitioningDelegate = self
    }
    
    override public func updateViewConstraints() {
        containerWidthConstraint.constant = containerSize.width
        containerHeightConstraint.constant = containerSize.height + 50
        super.updateViewConstraints()
    }
    
    // MARK: Public functions
    
    public func resizeContainer(in viewController: UIViewController) {
        let width = viewController.view.bounds.width * 0.9
        containerSize = CGSize(width: width, height: width * 1.5)
    }
    
    /// add a child view controller to be presented in container view
    public func add(_ viewController: UIViewController) {
        loadViewIfNeeded()
        viewController.view?.frame = containerView.bounds
        containerView.addSubview(viewController.view)
        addChild(viewController)
        viewController.didMove(toParent: self)
    }
    
    // MARK: Private functions
    
    @objc
    private func tapClose(_ sender: UIButton) {
        onWillClose?()
        dismiss(animated: true, completion: onClosed)
    }
    
    private func setupViews() {
        view.addSubview(slidingView)
        slidingView.addSubview(containerView)
        slidingView.addSubview(closeButton)
        
        containerWidthConstraint = slidingView.widthAnchor.constraint(equalToConstant: containerSize.width)
        containerHeightConstraint = slidingView.heightAnchor.constraint(equalToConstant: containerSize.height + 50)
        sliderBotomInsetConstraint = slidingView.topAnchor.constraint(equalTo: view.bottomAnchor)
//        let safeArea = view.safeAreaLayoutGuide
        let constraints: [NSLayoutConstraint] = [
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sliderBotomInsetConstraint,
            containerWidthConstraint,
            containerHeightConstraint,
            closeButton.centerXAnchor.constraint(equalTo: slidingView.centerXAnchor),
            closeButton.topAnchor.constraint(equalTo: slidingView.topAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: 50),
            containerView.leadingAnchor.constraint(equalTo: slidingView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: slidingView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: slidingView.bottomAnchor),
            containerView.topAnchor.constraint(equalTo: closeButton.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension SlidingPopupVC: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController,
                                    presenting: UIViewController,
                                    source: UIViewController)
        -> UIViewControllerAnimatedTransitioning?
    {
        return animator
    }
    
    public func animationController(forDismissed dismissed: UIViewController)
        -> UIViewControllerAnimatedTransitioning?
    {
        return animator
    }
}
