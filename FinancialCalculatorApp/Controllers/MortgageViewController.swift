//
//  MortgageViewController.swift
//  FinancialCalculatorApp
//
//  Created by Alfred Edwin on 2020-11-18.
//

import UIKit

class MortgageViewController: UIViewController, UITextFieldDelegate {

//    @IBOutlet weak var CalculateMortgage: UIButton!
    
    // Text Fields
    @IBOutlet weak var txtLoanAmount: UITextField!
    
    @IBOutlet weak var txtPayment: UITextField!
    
    @IBOutlet weak var txtNoOfYears: UITextField!
    
    @IBOutlet weak var txtMortgageInterest: UITextField!
    
    // Buttons
    @IBOutlet weak var btnMortgageCalculate: UIButton!
    
    // Keyboard
    let KeyboardView: Keyboard = Keyboard(frame: CGRect(x: 0, y: 0, width: 0, height: 250))
    
    var mortgage : Mortgage = Mortgage(amount: 0.0, interestRate: 0.0, noOfPayments: 0.0, payment: 0.0)

    ///An array of UITextFields
    var textFields = [UITextField]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.assignDelegates()
        self.loadDefaultsData("MortgageHistory")
        self.loadInputWhenAppOpen()
        self.ClearValues()
        
        // Custom Keyboard
        self.hideKeyboardWhenTappedAround()
        self.addKeyboardEventListeners()
        self.KeyboardView.currentView = "Mortgage"
        self.customizeTextFields()
        
        
        // Do any additional setup after loading the view.
//        txtLoanAmount.layer.cornerRadius = 25.0
//        btnMortgageCalculate.layer.cornerRadius = 25.0
//        CalculateMortgage.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
    }
    
    
    /// load history data to string array
    func loadDefaultsData(_ historyKey :String) {
        let defaults = UserDefaults.standard
        mortgage.historyStringArray = defaults.object(forKey: historyKey) as? [String] ?? [String]()
    }
    
    /// disable system keybaord popup and call view textfields from controller
    func assignDelegates() {
        txtLoanAmount.delegate = self
        txtLoanAmount.inputView = UIView()
        txtMortgageInterest.delegate = self
        txtMortgageInterest.inputView = UIView()
        txtNoOfYears.delegate = self
        txtNoOfYears.inputView = UIView()
        txtPayment.delegate = self
        txtPayment.inputView = UIView()
    }

    
    
    func ClearValues() {
        txtLoanAmount.clearButtonMode = .always
        txtLoanAmount.clearButtonMode = .whileEditing
        
        txtMortgageInterest.clearButtonMode = .always
        txtMortgageInterest.clearButtonMode = .whileEditing
        
        txtNoOfYears.clearButtonMode = .always
        txtNoOfYears.clearButtonMode = .whileEditing
        
        txtPayment.clearButtonMode = .always
        txtPayment.clearButtonMode = .whileEditing
    }
    
    @IBAction func LoanAmountTxtField(_ sender: UITextField) {
        let defaultValue = UserDefaults.standard
        defaultValue.set(txtLoanAmount.text, forKey:"mortgage_amount")
    }
    
    
    
    @IBAction func btnBackPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func PaymentTxtField(_ sender: UITextField) {
        let defaultValue = UserDefaults.standard
        defaultValue.set(txtPayment.text, forKey:"mortgage_payment")
    }
    
    
    
    @IBAction func NoOfYearsTxtField(_ sender: UITextField) {
        let defaultValue = UserDefaults.standard
        defaultValue.set(txtNoOfYears.text, forKey:"mortgage_noOfPayments")
    }
    
    
    @IBAction func InterestTxtField(_ sender: UITextField) {
        let defaultValue = UserDefaults.standard
        defaultValue.set(txtMortgageInterest.text, forKey:"mortgage_interest_rate")
    }
    

    @IBAction func btnClear(_ sender: UIButton) {
        txtLoanAmount.text! = ""
        txtMortgageInterest.text! = ""
        txtNoOfYears.text! = ""
        txtPayment.text! = ""
    }
    
    
    
    /// load data when app reopen
    func loadInputWhenAppOpen(){
        let defaultValue =  UserDefaults.standard
        let amountDefault = defaultValue.string(forKey:"mortgage_amount")
        let interestRateDefault = defaultValue.string(forKey:"mortgage_interest_rate")
        let noOfPayementsDefault = defaultValue.string(forKey:"mortgage_noOfPayments")
        let paymentDefault = defaultValue.string(forKey:"mortgage_payment")
        
        txtLoanAmount.text = amountDefault
        txtMortgageInterest.text = interestRateDefault
        txtNoOfYears.text = noOfPayementsDefault
        txtPayment.text = paymentDefault
        
    }
    
    /// keybaord user input will display textbox
    func textFieldDidBeginEditing(_ textField: UITextField) {
        KeyboardView.activeTextField = textField
    }
    
    ///A loop to customize multiple text fields at the same time using swift extensions
    func customizeTextFields() {
        textFields = [txtLoanAmount, txtMortgageInterest, txtPayment, txtNoOfYears]
        for tf in textFields {
//            tf.styleTextField()
            tf.setCustomKeyboard(self.KeyboardView)
            tf.assignDelegates(self)
            tf.tintColor = UIColor.black
        }
    }
    
    @IBAction func CalculateMortgage(_ sender: UIButton) {
        /// check whether all textbox empty or not
        if txtLoanAmount.text! == "" && txtMortgageInterest.text! == "" &&
            txtPayment.text! == "" && txtNoOfYears.text! == "" {
            
            let alertController = UIAlertController(title: "Warning Alert", message: "Please enter value(s) to calculate ", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
            
              /// check whether all textbox filled or not
            } else if txtLoanAmount.text! != "" && txtMortgageInterest.text! != "" &&
                        txtPayment.text! != "" && txtNoOfYears.text! != "" {
            
            let alertController = UIAlertController(title: "Warning Alert", message: " Need one empty field.", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in

            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
            
          /// payment calculation
        } else if txtPayment.text! == "" && txtLoanAmount.text! != "" &&
                    txtMortgageInterest.text! != "" && txtNoOfYears.text! != "" {
            
               let amountValue = Double(txtLoanAmount.text!)!
               let interestRateValue = Double(txtMortgageInterest.text!)!
               let noOfPaymentsValue = Double(txtNoOfYears.text!)!
                
               let interestDivided = interestRateValue/100
               
            
            /// payment formula - M = P[i(1+i)n] / (1+i)nt
                let payment = amountValue * ( (interestDivided/12 * pow(1 + interestDivided/12 , noOfPaymentsValue) ) / ( pow(1 + interestDivided/12 , noOfPaymentsValue) - 1 ) )
               
                //let paymentTwoDecimal = Double(round(100*payment)/100)
            txtPayment.text = String(format: "%.2f",payment )
            
          /// amount calculation
        } else if txtLoanAmount.text! == "" && txtNoOfYears.text! != "" &&
                    txtMortgageInterest.text! != "" && txtPayment.text! != ""{
          
             let noOfPaymentsValue = Double(txtNoOfYears.text!)!
             let interestRateValue = Double(txtMortgageInterest.text!)!
             let paymentValue = Double(txtPayment.text!)!
             
             let interestDivided = interestRateValue/100
           
             /// mortgage amout formula - P= (M * ( pow ((1 + R/t), (n*t)) - 1 )) / ( R/t * pow((1 + R/t), (n*t)))
            
             let Present  = (paymentValue * ( pow((1 + interestDivided / noOfPaymentsValue), (noOfPaymentsValue)) - 1 )) / ( interestDivided / noOfPaymentsValue * pow((1 + interestDivided / noOfPaymentsValue), (noOfPaymentsValue)))
             
            txtLoanAmount.text = String(format: "%.2f",Present)
            
          /// interest rate calculation
        } else if txtMortgageInterest.text! == "" && txtLoanAmount.text! != "" &&
                    txtNoOfYears.text! != "" && txtPayment.text! != "" {
            
            let alertController = UIAlertController(title: "Warning", message: "Interest rate calculation is not defined. ", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
             
                
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
      
            
          /// number of payments calculation
        } else if txtNoOfYears.text! == "" && txtMortgageInterest.text! != "" && txtLoanAmount.text! != "" && txtPayment.text! != ""{
            
            let amountValue = Double(txtLoanAmount.text!)!
            let interestRateValue = Double(txtMortgageInterest.text!)!
            let paymentValue = Double(txtPayment.text!)!
            
            let interestDivided = (interestRateValue / 100) / 12
            
            /// number of payments formula - log((PMT / i) / ((PMT / i) - P)) / log(1 + i)
            let calculatedNumOfMonths = log((paymentValue / interestDivided) / ((paymentValue / interestDivided) - amountValue)) / log(1 + interestDivided)
            
            //let   calculatedNumOfYears = round(100 * (calculatedNumOfMonths / 12)) / 100
            txtNoOfYears.text = String(format: "%.2f",calculatedNumOfMonths)
            
        } else {
        
            let alertController = UIAlertController(title: "Warning", message: "Please enter value(s) to calculate ", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
             
                
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
       
        }
    }
    
    /*
     Formula Attribute Naming
     
     P = present/principal/amount value
     F = future value
     r = interest rate
     t = (time) number of payments
     n = compound per year
     PMT = payment
     
     */
    
    @IBAction func SaveMortgage(_ sender: UIButton) {
        if txtLoanAmount.text! != "" && txtMortgageInterest.text! != "" &&
            txtPayment.text! != "" && txtNoOfYears.text! != ""
        {
        let defaults = UserDefaults.standard
             /// format of displaying history
        let historyString = "Mortgage Amount is \(txtLoanAmount.text!), Interest Rate is \(txtMortgageInterest.text!)%, No.of Payment is \(txtNoOfYears.text!), Payment is \(txtPayment.text!)"
           
           mortgage.historyStringArray.append(historyString)
           defaults.set(mortgage.historyStringArray, forKey: "MortgageHistory")
            
            let alertController = UIAlertController(title: "Success Alert", message: "Successfully Saved.", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
                
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
            
            
        }
            /// check whether fields are empty before save nill values
        else if txtLoanAmount.text == "" || txtMortgageInterest.text == "" ||
                    txtPayment.text == "" || txtNoOfYears.text == ""{
            
            let alertController = UIAlertController(title: "Warning Alert", message: "One or More Input are Empty", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
                
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
            
        }  else{
            
            
            
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
