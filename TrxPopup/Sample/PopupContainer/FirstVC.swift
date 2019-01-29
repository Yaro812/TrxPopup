//
//  FirstVC.swift
//  PopupContainer
//
//  Created by user on 28/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import TrxPopup

class FirstVC: UIViewController {
    
    @IBAction func tapButton(_ sender: Any) {
        showPopupAnimated()
    }
    
    func showPopupAnimated() {
        let containerVC = PopupVC.instantiate()
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let presententedVC = mainStoryboard.instantiateViewController(withIdentifier: "Navigator")
        let width = view.bounds.width * 0.9
        containerVC.containerSize = CGSize(width: width, height: width * 1.5)
        containerVC.add(presententedVC)
        present(containerVC, animated: true, completion: {
            print("presentation complete")
        })
    }
}

func * (left: CGSize, right: CGFloat) -> CGSize {
    return CGSize(width: left.width * right, height: left.height * right)
}
