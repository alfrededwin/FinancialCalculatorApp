//
//  Mortgage.swift
//  FinancialCalculatorApp
//
//  Created by Alfred Edwin on 2020-11-29.
//

import Foundation
import UIKit

class Mortgage {
    var amount : Double
    var interestRate : Double
    var noOfPayments : Double
    var payment : Double
    var historyStringArray : [String]
    
    init(amount: Double, interestRate: Double, noOfPayments: Double, payment: Double) {
        self.amount = amount
        self.interestRate = interestRate
        self.noOfPayments = noOfPayments
        self.payment = payment
        self.historyStringArray = [String]()
    }
}
