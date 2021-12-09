//
//  UIAnimatable.swift
//  Bridge Rail
//
//  Created by Blair Zhou on 10/10/21.
//

import Foundation
import MBProgressHUD

protocol UIAnimatable where Self: UIViewController {
    func showLoadingAnimation()
    func hideLoadingAnimation()
}


extension UIAnimatable {
    
    func showLoadingAnimation() {
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
    }
    
    func hideLoadingAnimation() {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}
