//
//  TestVC.swift
//  PopupContainer
//
//  Created by user on 28/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class TestVC: UIViewController {
    public static func instantiate() -> TestVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "\(self)") as? TestVC else {
            fatalError()
        }
        
        return vc
    }
}
