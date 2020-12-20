//
//  LoanViewController.swift
//  FinancialCalculatorApp
//
//  Created by Alfred Edwin on 2020-12-01.
//

import UIKit

class LoanViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var txtLoanAmount: UITextField!
    
    
    @IBOutlet weak var txtPayment: UITextField!
    
    @IBOutlet weak var txtNoOfMonths: UITextField!
    
    @IBOutlet weak var txtInterest: UITextField!
    
//    @IBOutlet weak var KeyboardView: Keyboard!
    // Keyboard
    let KeyboardView: Keyboard = Keyboard(frame: CGRect(x: 0, y: 0, width: 0, height: 250))
    
    var loan : Loan = Loan(LoanAmount: 0.0, interestRate: 0.0, noOfMonths: 0.0, payment: 0.0)
    
    ///An array of UITextFields
    var textFields = [UITextField]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.assignDelegates()
        /// load saved data for loan
        self.loadDefaultsData("LoanHistory")
        /// load typed data in to textbox
        self.loadInputWhenAppOpen()
        self.ClearValues()
        
        // Custom Keyboard
        hideKeyboardWhenTappedAround()
        addKeyboardEventListeners()
        self.KeyboardView.currentView = "Loan"
        self.customizeTextFields()
        
    }
    
    
    func ClearValues() {
        txtLoanAmount.clearButtonMode = .always
        txtLoanAmount.clearButtonMode = .whileEditing
        
        txtInterest.clearButtonMode = .always
        txtInterest.clearButtonMode = .whileEditing
        
        txtNoOfMonths.clearButtonMode = .always
        txtNoOfMonths.clearButtonMode = .whileEditing
        
        txtPayment.clearButtonMode = .always
        txtPayment.clearButtonMode = .whileEditing
    }
    
    /// load history data to string array
    func loadDefaultsData(_ historyKey :String) {
        let defaults = UserDefaults.standard
        loan.historyStringArray = defaults.object(forKey: historyKey) as? [String] ?? [String]()
    }
    
    /// disable system keybaord popup and call view textfields from controller
    func assignDelegates() {
        txtLoanAmount.delegate = self
        txtLoanAmount.inputView = UIView()
        txtInterest.delegate = self
        txtInterest.inputView = UIView()
        txtNoOfMonths.delegate = self
        txtNoOfMonths.inputView = UIView()
        txtPayment.delegate = self
        txtPayment.inputView = UIView()
    }
    
    
    /// load data to the text boxes when app reopen
    func loadInputWhenAppOpen(){
        let defaultValue =  UserDefaults.standard
        let loanAmountDefault = defaultValue.string(forKey:"loan_amount")
        let interestRateDefault = defaultValue.string(forKey:"loan_interest_rate")
        let noOfMonthsDefault = defaultValue.string(forKey:"loan_noOfMonths")
        let paymentDefault = defaultValue.string(forKey:"loan_payment")
        
        txtLoanAmount.text = loanAmountDefault
        txtInterest.text = interestRateDefault
        txtNoOfMonths.text = noOfMonthsDefault
        txtPayment.text = paymentDefault
        
    }
    
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func LoanAmountTxtField(_ sender: UITextField) {
        let defaultValue = UserDefaults.standard
        defaultValue.set(txtLoanAmount.text, forKey:"loan_amount")
    }
    
    
    @IBAction func PaymentTxtField(_ sender: UITextField) {
        let defaultValue = UserDefaults.standard
        defaultValue.set(txtPayment.text, forKey:"loan_payment")
    }
    
    
    
    @IBAction func NoOfMonths(_ sender: UITextField) {
        let defaultValue = UserDefaults.standard
        defaultValue.set(txtNoOfMonths.text, forKey:"loan_noOfMonths")
    }
    
    
    @IBAction func InterestTxtField(_ sender: UITextField) {
        let defaultValue = UserDefaults.standard
        defaultValue.set(txtInterest.text, forKey:"loan_interest_rate")
    }
    
    
    @IBAction func btnClear(_ sender: UIButton) {
        txtLoanAmount.text! = ""
        txtInterest.text! = ""
        txtNoOfMonths.text! = ""
        txtPayment.text! = ""
    }
    
    
    /// keybaord user input will display textbox
    func textFieldDidBeginEditing(_ textField: UITextField) {
        KeyboardView.activeTextField = textField
    }
    
    
    ///A loop to customize multiple text fields at the same time using swift extensions
    func customizeTextFields() {
        textFields = [txtLoanAmount, txtInterest, txtNoOfMonths, txtPayment]
        for tf in textFields {
//            tf.styleTextField()
            tf.setCustomKeyboard(self.KeyboardView)
            tf.assignDelegates(self)
            tf.tintColor = UIColor.black
        }
    }
    
    
    @IBAction func btnCalculateLoan(_ sender: UIButton) {
        
        /// check whether all textbox empty or not
        if txtLoanAmount.text! == "" && txtInterest.text! == "" &&
            txtPayment.text! == "" && txtNoOfMonths.text! == "" {
            
            let alertController = UIAlertController(title: "Warning Alert", message: "Please enter value(s) to calculate ", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
             
            
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
            
            
            
         /// check whether all textbox filled or not
            } else if txtLoanAmount.text! != "" && txtInterest.text! != "" &&
                        txtPayment.text! != "" && txtNoOfMonths.text! != "" {
            
            let alertController = UIAlertController(title: "Warning Alert", message: " Need one empty field.", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
                
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
            
          /// payment calculation
        } else if txtPayment.text! == "" && txtLoanAmount.text! != "" &&
                    txtInterest.text! != "" && txtNoOfMonths.text! != ""{
            
               let amountValue = Double(txtLoanAmount.text!)!
               let interestRateValue = Double(txtInterest.text!)!
               let noOfPaymentsValue = Double(txtNoOfMonths.text!)!
                
               let interestDivided = interestRateValue/100
               
            /// payment formula - M = P[i(1+i)n] / (1+i)nt
                let payment = amountValue * ( (interestDivided/12 * pow(1 + interestDivided/12 , noOfPaymentsValue) ) / ( pow(1 + interestDivided/12 , noOfPaymentsValue) - 1 ) )
               
               // let paymentTwoDecimal = Double(round(100*payment)/100)
            
            txtPayment.text = String(format: "%.2f",payment)
            
            /// amount calculation
        } else if txtLoanAmount.text! == "" && txtNoOfMonths.text! != "" && txtInterest.text! != "" && txtPayment.text! != "" {
                
            let noOfPaymentsValue = Double(txtNoOfMonths.text!)!
            let interestRateValue = Double(txtInterest.text!)!
            let paymentValue = Double(txtPayment.text!)!
            
            let interestDivided = interestRateValue/100
        
        /// mortgage amout formula - P= (M * ( pow ((1 + R/t), (n*t)) - 1 )) / ( R/t * pow((1 + R/t), (n*t)))
            let Present  = (paymentValue * ( pow((1 + interestDivided / noOfPaymentsValue), (noOfPaymentsValue)) - 1 )) / ( interestDivided / noOfPaymentsValue * pow((1 + interestDivided / noOfPaymentsValue), (noOfPaymentsValue)))
            
            txtLoanAmount.text = String(format: "%.2f",Present)
           
          /// interest rate calculation
        } else if txtInterest.text! == "" && txtLoanAmount.text! != "" && txtNoOfMonths.text! != "" && txtPayment.text! != "" {
            
            let alertController = UIAlertController(title: "Warning", message: "Interest rate calculation is not defined. ", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
             
                
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
            
          /// number of payments calculation
        } else if txtNoOfMonths.text! == "" && txtLoanAmount.text! != "" && txtInterest.text! != "" && txtPayment.text! != "" {
            
            let amountValue = Double(txtLoanAmount.text!)!
            let interestRateValue = Double(txtInterest.text!)!
            let paymentValue = Double(txtPayment.text!)!
            
            let interestDivided = (interestRateValue / 100) / 12
            
            /// number of payments formula - log((PMT / i) / ((PMT / i) - P)) / log(1 + i)
            let calculatNoOfMonths = log((paymentValue / interestDivided) / ((paymentValue / interestDivided) - amountValue)) / log(1 + interestDivided)
            
            //let   calculatedNumOfYears = round(100 * (calculatedNumOfMonths / 12)) / 100
            txtNoOfMonths.text = String(format: "%.2f",calculatNoOfMonths)
            
        } else {
        
            let alertController = UIAlertController(title: "Warning", message: "Please enter value(s) to calculate ", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
             
                
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
       
        }
    }
    
    
    
    @IBAction func btnSaveLoan(_ sender: UIButton) {
        
        if txtLoanAmount.text != "" && txtInterest.text != "" &&
            txtPayment.text != "" && txtNoOfMonths.text != ""{
        
        let defaults = UserDefaults.standard
       /// format of displaying history
        let historyString = "Loan Amount is \(txtLoanAmount.text!), Interest Rate is \(txtInterest.text!) %, No.of Months is \(txtNoOfMonths.text!), Payment is \(txtPayment.text!)"
           
           loan.historyStringArray.append(historyString)
           defaults.set(loan.historyStringArray, forKey: "LoanHistory")
        
            let alertController = UIAlertController(title: "Success Alert", message: "Successfully Saved.", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
                
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
            
         /// check whether fields are empty before save nill values
        } else if txtLoanAmount.text == "" || txtInterest.text == "" ||
                    txtPayment.text == "" || txtNoOfMonths.text == "" {
            
            let alertController = UIAlertController(title: "Warning Alert", message: "One or More Input are Empty", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
                
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
            
            
        } else {
            
            let alertController = UIAlertController(title: "Error Alert", message: "Please do calculate. Save Unsuccessful", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
                
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
            
        }
          
       }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
