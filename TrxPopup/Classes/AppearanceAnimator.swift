//
//  AppearanceAnimator.swift
//  PopupContainer
//
//  Created by user on 28/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

final class PopupAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    enum Constant {
        static let duration: TimeInterval = 1.7
        static let scaleFactor: CGFloat = 0.1
        static let dampingRatio: CGFloat = 0.7
        static let gravityDirection: CGFloat = CGFloat.pi * 3 / 2
        static let gravityMagnitude: CGFloat = 10
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Constant.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let from = transitionContext.viewController(forKey: .from)
        let to = transitionContext.viewController(forKey: .to)
        if let to = to as? PopupVC {
            let animator = appearingAnimator(from: from, to: to, context: transitionContext)
            animator.startAnimation()
        } else if let from = from as? PopupVC {
            let animator = disappearingAnimator(from: from, to: to, context: transitionContext)
            animator.startAnimation()
        } else {
            transitionContext.completeTransition(true)
        }
    }
    
    private func appearingAnimator(from: UIViewController?,
                                   to: PopupVC,
                                   context: UIViewControllerContextTransitioning)
        -> UIViewPropertyAnimator
    {
        let container = context.containerView
        let toBackgroundColor = to.view.backgroundColor
        to.view.backgroundColor = .clear
        to.containerView.transform = CGAffineTransform(scaleX: Constant.scaleFactor, y: Constant.scaleFactor)
        container.addSubview(to.view)
        
        let animator = UIViewPropertyAnimator(duration: Constant.duration, dampingRatio: Constant.dampingRatio) {
            to.view.backgroundColor = toBackgroundColor
            to.containerView.transform = .identity
        }
        animator.addCompletion { position in
            context.completeTransition(true)
        }
        return animator
    }
    
    var containerAnimator: UIDynamicAnimator?
    
    private func disappearingAnimator(from: PopupVC,
                                      to: UIViewController?,
                                      context: UIViewControllerContextTransitioning)
        -> UIViewPropertyAnimator
    {
        let gravity = UIGravityBehavior(items: [from.containerView])
        gravity.setAngle(Constant.gravityDirection, magnitude: Constant.gravityMagnitude)
        
        containerAnimator = UIDynamicAnimator(referenceView: from.view)
        containerAnimator?.addBehavior(gravity)
        
        let animator = UIViewPropertyAnimator(duration: Constant.duration, dampingRatio: Constant.dampingRatio) {
            from.view.backgroundColor = .clear
        }
        animator.addCompletion { position in
            self.containerAnimator = nil
            context.completeTransition(true)
        }
        return animator
    }
    
}
