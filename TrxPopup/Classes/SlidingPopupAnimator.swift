//
//  SlidingPopupAnimator.swift
//  TrxPopup
//
//  Created by user on 29/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

final class SlidingPopupAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    enum Constant {
        static let duration: TimeInterval = 1.0
        static let scaleFactor: CGFloat = 0.1
        static let dampingRatio: CGFloat = 0.7
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Constant.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let from = transitionContext.viewController(forKey: .from)
        let to = transitionContext.viewController(forKey: .to)
        if let to = to as? SlidingPopupVC {
            let animator = appearingAnimator(from: from, to: to, context: transitionContext)
            animator.startAnimation()
        } else if let from = from as? SlidingPopupVC {
            let animator = disappearingAnimator(from: from, to: to, context: transitionContext)
            animator.startAnimation()
        } else {
            transitionContext.completeTransition(true)
        }
    }
    
    private func appearingAnimator(from: UIViewController?,
                                   to: SlidingPopupVC,
                                   context: UIViewControllerContextTransitioning)
        -> UIViewPropertyAnimator
    {
        let container = context.containerView
        let toBackgroundColor = to.view.backgroundColor
        to.view.backgroundColor = .clear
        container.addSubview(to.view)
        
        to.sliderBotomInsetConstraint.constant = 0
        container.setNeedsLayout()
            container.layoutIfNeeded()
        to.sliderBotomInsetConstraint.constant = -to.containerSize.height
        let animator = UIViewPropertyAnimator(duration: Constant.duration, dampingRatio: Constant.dampingRatio) {
            to.view.backgroundColor = toBackgroundColor
            to.view.layoutIfNeeded()
        }
        animator.addCompletion { position in
            context.completeTransition(true)
        }
        return animator
    }
    
    private func disappearingAnimator(from: SlidingPopupVC,
                                      to: UIViewController?,
                                      context: UIViewControllerContextTransitioning)
        -> UIViewPropertyAnimator
    {
        from.view.layoutIfNeeded()
        from.sliderBotomInsetConstraint.constant = 0
        let animator = UIViewPropertyAnimator(duration: Constant.duration, dampingRatio: Constant.dampingRatio) {
            from.view.backgroundColor = .clear
            from.view.layoutIfNeeded()
        }
        animator.addCompletion { position in
            context.completeTransition(true)
        }
        return animator
    }
    
}
