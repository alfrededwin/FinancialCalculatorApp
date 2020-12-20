//
//  KeyboardDelegates.swift
//  FinancialCalculatorApp
//
//  Created by Alfred Edwin on 2020-12-06.
//

import Foundation
import UIKit

extension UITextField {
    
    /// Replaces the default keyboard with the custom keyboard for all the input views (text fields etc.)
    func setCustomKeyboard(_ customKeyboard: Keyboard) {
        self.inputView = customKeyboard
    }
    
    func assignDelegates(_ viewController: UITextFieldDelegate) {
        self.delegate = viewController
    }
}
