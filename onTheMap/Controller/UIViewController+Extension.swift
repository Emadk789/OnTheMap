//
//  UIViewController+Extension.swift
//  onTheMap
//
//  Created by Emad Albarnawi on 06/06/2020.
//  Copyright © 2020 Emad Albarnawi. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showFailureAlert(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}
