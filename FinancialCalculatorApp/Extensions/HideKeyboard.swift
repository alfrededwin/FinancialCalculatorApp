//
//  HideKeyboard.swift
//  FinancialCalculatorApp
//
//  Created by Alfred Edwin on 2020-12-06.
//

import Foundation
import UIKit

extension UIViewController {
    
    // Hides the keyboard when touching outside of a textfield area

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }

    /// Closes the popup keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
