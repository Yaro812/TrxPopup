//
//  ViewController.swift
//  PopupContainer
//
//  Created by user on 28/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

public class PopupVC: UIViewController {
    
    // MARK: Public static functions
    
    public static func instantiate() -> PopupVC {
        let vc = PopupVC(nibName: nil, bundle: nil)
        return vc
    }
    
    // MARK: Public properties
    
    /// Animator that handles appearing and disappearing animations
    public var animator: UIViewControllerAnimatedTransitioning = PopupAnimator()
    
    public private(set) lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    public lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Close", for: .normal)
        button.tintColor = UIColor.white.withAlphaComponent(0.7)
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
        containerHeightConstraint.constant = containerSize.height
        super.updateViewConstraints()
    }
    
    // MARK: Public functions
    
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
        view.addSubview(containerView)
        view.addSubview(closeButton)
        
        containerWidthConstraint = containerView.widthAnchor.constraint(equalToConstant: containerSize.width)
        containerHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: containerSize.height)
        let safeArea = view.safeAreaLayoutGuide
        let constraints: [NSLayoutConstraint] = [
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerWidthConstraint,
            containerHeightConstraint,
            closeButton.leadingAnchor.constraint(equalToSystemSpacingAfter: safeArea.leadingAnchor, multiplier: 1.0),
            closeButton.topAnchor.constraint(equalToSystemSpacingBelow: safeArea.topAnchor, multiplier: 1.0)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension PopupVC: UIViewControllerTransitioningDelegate {
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
