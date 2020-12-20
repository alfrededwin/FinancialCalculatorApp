//
//  Loan.swift
//  FinancialCalculatorApp
//
//  Created by Alfred Edwin on 2020-12-01.
//

import Foundation
import UIKit

class Loan {
    var LoanAmount : Double
    var interestRate : Double
    var noOfMonths : Double
    var payment : Double
    var historyStringArray : [String]
    
    init(LoanAmount: Double, interestRate: Double, noOfMonths: Double, payment: Double) {
        self.LoanAmount = LoanAmount
        self.interestRate = interestRate
        self.noOfMonths = noOfMonths
        self.payment = payment
        self.historyStringArray = [String]()
    }
}
