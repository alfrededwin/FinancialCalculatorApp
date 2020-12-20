//
//  SavingsViewController.swift
//  FinancialCalculatorApp
//
//  Created by Alfred Edwin on 2020-12-01.
//

import UIKit

class CompoundSavingsViewController: UIViewController, UITextFieldDelegate {

    // Text Field
    @IBOutlet weak var txtPresentValue: UITextField!
    @IBOutlet weak var txtFutureValue: UITextField!
    @IBOutlet weak var txtInterestPerYear: UITextField!
    @IBOutlet weak var txtNoOfPayments: UITextField!
    @IBOutlet weak var txtCompoundsPerYear: UITextField!
    
//    @IBOutlet weak var KeyBoardView: Keyboard!
    // Keyboard
    let KeyboardView: Keyboard = Keyboard(frame: CGRect(x: 0, y: 0, width: 0, height: 250))
    
    var compoundSaving : CompoundSavings = CompoundSavings(presentValue: 0.0, futureValue: 0.0, interestRate: 0.0,  noOfPayments: 0.0)
    
    ///An array of UITextFields
    var textFields = [UITextField]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.assignDelegates()
        self.loadDefaultsData("CompoundSavingsInterestHistory")
        self.loadInputWhenAppOpen()
        self.ClearValues()
        txtCompoundsPerYear?.isUserInteractionEnabled = false
        
        // Custom Keyboard
        self.hideKeyboardWhenTappedAround()
        self.addKeyboardEventListeners()
        self.KeyboardView.currentView = "CompoundSavings"
        self.customizeTextFields()
    }
    
    func ClearValues() {
        txtPresentValue.clearButtonMode = .always
        txtPresentValue.clearButtonMode = .whileEditing
        
        txtFutureValue.clearButtonMode = .always
        txtFutureValue.clearButtonMode = .whileEditing
        
        txtInterestPerYear.clearButtonMode = .always
        txtInterestPerYear.clearButtonMode = .whileEditing

        txtNoOfPayments.clearButtonMode = .always
        txtNoOfPayments.clearButtonMode = .whileEditing
    }
    
    // Back Button to Navigate to Dashboard
    @IBAction func btnBackPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /// load history data to string array
    func loadDefaultsData(_ historyKey :String) {
        let defaults = UserDefaults.standard
        compoundSaving.historyStringArray = defaults.object(forKey: historyKey) as? [String] ?? [String]()
    }
    
    /// disable system keybaord popup and call view textfields from controller
    func assignDelegates() {
        txtPresentValue.delegate = self
        txtPresentValue.inputView = UIView()
        txtFutureValue.delegate = self
        txtFutureValue.inputView = UIView()
        txtInterestPerYear.delegate = self
        txtInterestPerYear.inputView = UIView()
        txtNoOfPayments.delegate = self
        txtNoOfPayments.inputView = UIView()
    }

    
    @IBAction func PresentValueTxtField(_ sender: UITextField) {
        let defaultValue = UserDefaults.standard
        defaultValue.set(txtPresentValue.text, forKey:"compound_present")
    }
    
    
    @IBAction func FutureValueTxtField(_ sender: UITextField) {
        let defaultValue = UserDefaults.standard
        defaultValue.set(txtFutureValue.text, forKey:"compound_future")
    }
    
    
    @IBAction func InterestPerYearTxtField(_ sender: UITextField) {
        let defaultValue = UserDefaults.standard
        defaultValue.set(txtInterestPerYear.text, forKey:"compound_interest")
    }
    
    
    @IBAction func NoOfPaymentsTxtField(_ sender: UITextField) {
        let defaultValue = UserDefaults.standard
        defaultValue.set(txtNoOfPayments.text, forKey:"compound_noOfPayment")
    }
    
    
    @IBAction func btnClear(_ sender: UIButton) {
        txtPresentValue.text! = ""
        txtFutureValue.text! = ""
        txtInterestPerYear.text! = ""
        txtNoOfPayments.text! = ""
    }
    
    
    
    /// load data when app reopen
    func loadInputWhenAppOpen(){
        let defaultValue =  UserDefaults.standard
        let presentDefault = defaultValue.string(forKey:"compound_present")
        let interestRateDefault = defaultValue.string(forKey:"compound_interest")
        let noOfPayementsDefault = defaultValue.string(forKey:"compound_noOfPayment")
        let futureDefault = defaultValue.string(forKey:"compound_future")
        
        txtPresentValue.text = presentDefault
        txtFutureValue.text = futureDefault
        txtInterestPerYear.text = interestRateDefault
        txtNoOfPayments.text = noOfPayementsDefault
        
    }
  
  /// keybaord user input will display textbox
    func textFieldDidBeginEditing(_ textField: UITextField) {
        KeyboardView.activeTextField = textField
    }
    
    ///A loop to customize multiple text fields at the same time using swift extensions
    func customizeTextFields() {
        textFields = [txtPresentValue, txtFutureValue, txtInterestPerYear, txtNoOfPayments]
        for tf in textFields {
//            tf.styleTextField()
            tf.setCustomKeyboard(self.KeyboardView)
            tf.assignDelegates(self)
            tf.tintColor = UIColor.black
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
    
    
    @IBAction func btnCalculateCompoundSaving(_ sender: UIButton) {
        /// check whether all textbox empty or not
        if txtPresentValue.text! == "" && txtFutureValue.text! == "" &&
            txtInterestPerYear.text! == "" && txtNoOfPayments.text! == "" {
            
            let alertController = UIAlertController(title: "Alert", message: "Please enter value(s) to calculate ", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
            
            /// check whether all textbox filled or not
            } else if txtPresentValue.text! != "" && txtFutureValue.text! != "" &&
                        txtInterestPerYear.text! != "" && txtNoOfPayments.text! != "" {
            
            let alertController = UIAlertController(title: "Warning", message: "Need one empty field.", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
                
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
            
            
            
            /// present value calculation
        } else if txtPresentValue.text! == "" && txtFutureValue.text! != "" && txtInterestPerYear.text! != "" && txtNoOfPayments.text! != ""{
            
            let futureValue = Double(txtFutureValue.text!)!
            let interestValue = Double(txtInterestPerYear.text!)!
            let noOfPaymentsValue = Double(txtNoOfPayments.text!)!
            
            let interestDivided = interestValue/100
            
            /// present value formula - P =  A/(1+rn)nt
            let presentValueCalculate = futureValue / pow(1 + (interestDivided / 12), 12 * noOfPaymentsValue)
            
            txtPresentValue.text = String(format: "%.2f",presentValueCalculate)
            
            /// future value calculation
        } else if txtFutureValue.text! == "" && txtPresentValue.text! != "" && txtInterestPerYear.text! != "" && txtNoOfPayments.text! != "" {
            
            let presentValue = Double(txtPresentValue.text!)!
            let interestValue = Double(txtInterestPerYear.text!)!
            let noOfPaymentsValue = Double(txtNoOfPayments.text!)!
            
            let interestDivided = interestValue/100
            
            ///future value formula - A = P(1+(r/n)nt)
            let futureValueCalculate = presentValue * pow (1 + (interestDivided / 12 ), 12 * noOfPaymentsValue )
            
             //let paymentTwoDecimal = Double(round(100*payment)/100)
            txtFutureValue.text = String(format: "%.2f",futureValueCalculate)
            
            /// interest rate calculation
        } else if txtInterestPerYear.text! == "" && txtPresentValue.text! != ""
        && txtFutureValue.text! != "" && txtNoOfPayments.text! != "" {
            
            let presentValue = Double(txtPresentValue.text!)!
            let futureValue = Double(txtFutureValue.text!)!
            let noOfPaymentsValue = Double(txtNoOfPayments.text!)!
             
            /// interest rate formula - r = n[(A/P)1/nt-1]
            let interestRateCalculate = 12 * ( pow ( ( futureValue / presentValue ), 1 / ( 12 * noOfPaymentsValue ) ) - 1 )
            
            txtInterestPerYear.text = String(format: "%.2f",interestRateCalculate * 100)
            
            /// no of payment calculation
        } else if txtNoOfPayments.text! == "" && txtPresentValue.text! != "" && txtFutureValue.text! != "" && txtInterestPerYear.text! != "" {
            
            let presentValue = Double(txtPresentValue.text!)!
            let futureValue = Double(txtFutureValue.text!)!
            let interestValue = Double(txtInterestPerYear.text!)!
            
            let interestDivided = interestValue/100
            
            /// number of payments formula - t = log(A/P) /n [log(1+r/n)]
            let noOfPaymentsCalculate = log (futureValue/presentValue) / (12*log(1+interestDivided/12))
            
            txtNoOfPayments.text = String(format: "%.2f",noOfPaymentsCalculate)
           
            /// output warning message when none of the above conditions are met
        } else {
            
            let alertController = UIAlertController(title: "Warning", message: "Please enter value(s) to calculate ", preferredStyle: .alert)
    
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
        
    }
    
    alertController.addAction(OKAction)
    
    self.present(alertController, animated: true, completion:nil)
        }
    }
    
    
    
    @IBAction func BtnSaveCompoundSaving(_ sender: UIButton) {
        if txtPresentValue.text! != "" && txtFutureValue.text! != "" &&
            txtInterestPerYear.text! != "" && txtNoOfPayments.text! != "" {
            
          let defaults = UserDefaults.standard
        let historyString = "Present Value is \(txtPresentValue.text!), Future Value is \(txtFutureValue.text!), Interest Rate is \(txtInterestPerYear.text!)%,  No.of Payment is \(txtNoOfPayments.text!)"
             
            compoundSaving.historyStringArray.append(historyString)
             defaults.set(compoundSaving.historyStringArray, forKey: "CompoundSavingsInterestHistory")
        
            let alertController = UIAlertController(title: "Success Alert", message: "Successfully Saved.", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
                
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
            
            
            /// check whether fields are empty before save nill values
        } else if txtPresentValue.text! == "" || txtFutureValue.text! == "" ||
                    txtInterestPerYear.text! == "" || txtNoOfPayments.text! == "" {
            
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
