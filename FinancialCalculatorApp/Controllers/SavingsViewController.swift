//
//  CompoundSavingInterestViewController.swift
//  FinancialCalculatorApp
//
//  Created by Alfred Edwin on 2020-12-01.
//

import UIKit

class SavingsViewController: UIViewController, UITextFieldDelegate {

    //Text Fields
    @IBOutlet weak var txtPresentValue: UITextField!
    
    @IBOutlet weak var txtFutureValue: UITextField!
    
    @IBOutlet weak var txtInterestPerYear: UITextField!
    
    @IBOutlet weak var txtPayment: UITextField!
    
    @IBOutlet weak var txtNoOfPaymentPerYear: UITextField!
    
    @IBOutlet weak var txtCompoundsPerYear: UITextField!
    
    @IBOutlet weak var endBeginLabel: UILabel!
    
    @IBOutlet weak var endBeginSwitch: UISwitch!

    // Keyboard
    let KeyboardView: Keyboard = Keyboard(frame: CGRect(x: 0, y: 0, width: 0, height: 250))

    var compoundSavingInterest : Savings = Savings(presentValue: 0.0, futureValue: 0.0, interestRate: 0.0,  noOfPayments: 0.0)
    
    ///An array of UITextFields
    var textFields = [UITextField]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.assignDelegates()
        self.loadDefaultsData("SavingsHistory")
        self.loadInputWhenAppOpen()
        self.ClearValues()
        txtCompoundsPerYear?.isUserInteractionEnabled = false
        
        // Custom Keyboard
        self.hideKeyboardWhenTappedAround()
        self.addKeyboardEventListeners()
        self.KeyboardView.currentView = "Savings"
        self.customizeTextFields()
    }
    
    
    
    func ClearValues() {
        txtPresentValue.clearButtonMode = .always
        txtPresentValue.clearButtonMode = .whileEditing
        
        txtFutureValue.clearButtonMode = .always
        txtFutureValue.clearButtonMode = .whileEditing
        
        txtInterestPerYear.clearButtonMode = .always
        txtInterestPerYear.clearButtonMode = .whileEditing
        
        txtNoOfPaymentPerYear.clearButtonMode = .always
        txtNoOfPaymentPerYear.clearButtonMode = .whileEditing
        
        txtPayment.clearButtonMode = .always
        txtPayment.clearButtonMode = .whileEditing
    }
    
    @IBAction func BackPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /// load history data to string array
      func loadDefaultsData(_ historyKey :String) {
          let defaults = UserDefaults.standard
        compoundSavingInterest.historyStringArray = defaults.object(forKey: historyKey) as? [String] ?? [String]()
      }
      
    /// disable system keybaord popup and call view textfields from controller
      func assignDelegates() {
        txtPresentValue.delegate = self
        txtPresentValue.inputView = UIView()
        txtFutureValue.delegate = self
        txtFutureValue.inputView = UIView()
        txtInterestPerYear.delegate = self
        txtInterestPerYear.inputView = UIView()
        txtNoOfPaymentPerYear.delegate = self
        txtNoOfPaymentPerYear.inputView = UIView()
        txtPayment.delegate = self
        txtPayment.inputView = UIView()
        
        endBeginLabel.text = "END - ON / BEGIN - OFF"
        txtCompoundsPerYear.text = "12"
      }
    
    
    @IBAction func PresentValueTxtField(_ sender: UITextField) {
        let defaultValue = UserDefaults.standard
        defaultValue.set(txtPresentValue.text, forKey:"savings_present")
    }
    
    
    @IBAction func FutureValueTxtField(_ sender: UITextField) {
        let defaultValue = UserDefaults.standard
        defaultValue.set(txtFutureValue.text, forKey:"savings_future")
    }
    
    @IBAction func InterestPerYearTxtField(_ sender: UITextField) {
        let defaultValue = UserDefaults.standard
        defaultValue.set(txtInterestPerYear.text, forKey:"savings_interest")
    }
    
    
    @IBAction func PaymentTxtField(_ sender: UITextField) {
        let defaultValue = UserDefaults.standard
        defaultValue.set(txtPayment.text, forKey:"savings_payment")
    }
    
    
    @IBAction func NoOfPaymentPerYearTxtField(_ sender: UITextField) {
        let defaultValue = UserDefaults.standard
        defaultValue.set(txtNoOfPaymentPerYear.text, forKey:"savings_noOfPayment")
    }
    
    
    
    @IBAction func BeginSwitch(_ sender: UISwitch) {
        let defaultValue = UserDefaults.standard
         defaultValue.set(endBeginSwitch.isOn, forKey:"savings_endBegin")
    }
    
    
    // Clear Button to clear all values from the Textfield
    @IBAction func btnClear(_ sender: UIButton) {
        txtPresentValue.text! = ""
        txtFutureValue.text! = ""
        txtInterestPerYear.text! = ""
        txtNoOfPaymentPerYear.text! = ""
        txtPayment.text! = ""
        
    }
    
    
    /// load data when app reopen
    func loadInputWhenAppOpen(){
        let defaultValue =  UserDefaults.standard
        let presentDefault = defaultValue.string(forKey:"savings_present")
        let interestRateDefault = defaultValue.string(forKey:"savings_interest")
        let noOfPayementsDefault = defaultValue.string(forKey:"savings_noOfPayment")
        let futureDefault = defaultValue.string(forKey:"savings_future")
        let paymentDefault = defaultValue.string(forKey:"savings_payment")
        /*let endBeginDefault =*/
        defaultValue.set(true, forKey:"savings_endBegin")
        
        txtPresentValue.text = presentDefault
        txtFutureValue.text = futureDefault
        txtInterestPerYear.text = interestRateDefault
        txtNoOfPaymentPerYear.text = noOfPayementsDefault
        txtPayment.text = paymentDefault
        //endBeginSwitch.isOn = endBeginDefault
    }
    
    /// keyboard user input will display textbox
      func textFieldDidBeginEditing(_ textField: UITextField) {
          KeyboardView.activeTextField = textField
      }
    
    
    ///A loop to customize multiple text fields at the same time using swift extensions
    func customizeTextFields() {
        textFields = [txtPresentValue, txtFutureValue, txtInterestPerYear, txtNoOfPaymentPerYear,txtPayment ]
        for tf in textFields {
//            tf.styleTextField()
            tf.setCustomKeyboard(self.KeyboardView)
            tf.assignDelegates(self)
            tf.tintColor = UIColor.black
        }
    }
    
    
    /// change label text when END / BEGIN switch ON or OFF
    
    @IBAction func EndBeginSwitch(_ sender: UISwitch) {
        if sender.isOn {
            endBeginLabel.text! = "END - ON / BEGIN - OFF"
       }
        else {
            endBeginLabel.text! = "END - OFF / BEGIN - ON"
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
    
    
    @IBAction func btnCompoundSaving(_ sender: UIButton) {
        /// check whether all textbox empty or not
        if txtPresentValue.text! == "" && txtFutureValue.text! == "" &&
            txtInterestPerYear.text! == "" && txtNoOfPaymentPerYear.text! == "" &&
            txtPayment.text! == "" {
                
                let alertController = UIAlertController(title: "Warning", message: "Please enter value(s) to calculate ", preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                    
                 
                    
                }
                
                alertController.addAction(OKAction)
                
                self.present(alertController, animated: true, completion:nil)
                
                    /// check whether all textbox filled or not
                    } else if txtPresentValue.text! != "" && txtFutureValue.text! != "" &&
                                txtInterestPerYear.text! != "" && txtNoOfPaymentPerYear.text! != ""
        && txtPayment.text! != ""{
                    
                    let alertController = UIAlertController(title: "Warning", message: "Need one empty field.", preferredStyle: .alert)
                    
                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                        
                        
                    }
                    
                    alertController.addAction(OKAction)
                    
                    self.present(alertController, animated: true, completion:nil)
                    
                /// present value calculation
        } else if txtPresentValue.text! == "" && txtFutureValue.text! != "" && txtInterestPerYear.text! != "" && txtNoOfPaymentPerYear.text! != ""{
                
               let futureValue = Double(txtFutureValue.text!)!
                let interestValue = Double(txtInterestPerYear.text!)!
                let noOfPaymentsValue = Double(txtNoOfPaymentPerYear.text!)!
                
                let interestDivided = interestValue/100
                
            /// present value formula - P = A/(1+rn)nt
                let presentValueCalculate = futureValue / pow(1 + (interestDivided / 12), 12 * noOfPaymentsValue)
                
            txtPresentValue.text = String(format: "%.2f",presentValueCalculate)
                
              
           
                /// interest rate calculation
        } else if txtInterestPerYear.text! == "" && txtPresentValue.text! != "" && txtFutureValue.text! != "" && txtNoOfPaymentPerYear.text! != ""  {
                
                let presentValue = Double(txtPresentValue.text!)!
                let futureValue = Double(txtFutureValue.text!)!
                let noOfPaymentsValue = Double(txtNoOfPaymentPerYear.text!)!
                
             /// interest rate formula - r = n[(A/P)1/nt-1]
                let interestRateCalculate = 12 * ( pow ( ( futureValue / presentValue ), 1 / ( 12 * noOfPaymentsValue ) ) - 1 )
                //let interstRateTwoDecimal = Double(round(100*interestRateCalculate)/100)
            
            txtInterestPerYear.text! = String(format: "%.2f",interestRateCalculate*100)
                
            /// number of payments calculation
        } else if txtNoOfPaymentPerYear.text! == "" && txtPresentValue.text! != ""
            && txtFutureValue.text! != "" && txtInterestPerYear.text! != ""{
                    
                let presentValue = Double(txtPresentValue.text!)!
                let futureValue = Double(txtFutureValue.text!)!
                let interestValue = Double(txtInterestPerYear.text!)!
                
                let interestDivided = interestValue/100
                
             /// number of payments formula - t = log(A/P) /n [log(1+r/n)]
                let noOfPaymentsCalculate = log (futureValue/presentValue) / (12*log(1+interestDivided/12))
                //let noOfPaymentsTwoDecimal = Double(round(100*noOfPaymentsCalculate)/100)
            
            txtNoOfPaymentPerYear.text! = String(format: "%.2f",noOfPaymentsCalculate)
            
        } else if txtFutureValue.text! == "" && txtPayment.text! == "" {
            
             let alertController = UIAlertController(title: "Warning", message: "Need payment value to calculate", preferredStyle: .alert)
                   
                   let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                       
                       
                       
                   }
                   
                   alertController.addAction(OKAction)
                   
                   self.present(alertController, animated: true, completion:nil)
            
            /// regular contribution with future value calculation
        } else if txtPayment.text! != "" && endBeginSwitch.isOn == true && txtPresentValue.text! != "" && txtNoOfPaymentPerYear.text! != "" && txtInterestPerYear.text! != "" {
            
            let presentValue = Double(txtPresentValue.text!)!
            let interestValue = Double(txtInterestPerYear.text!)!
            let noOfPaymentsValue = Double(txtNoOfPaymentPerYear.text!)!
            let paymentValue = Double(txtPayment.text!)!
            
            let compoundPerYear = 12.00
            
            let interestDivided = interestValue/100
            
            ///regular contribution with future value formula, when END selected - principal = P * pow( 1 + ( r / n ),n * t )
            let compoundInterestPrincipal = presentValue * pow( 1.00 + ( interestDivided / compoundPerYear ),compoundPerYear * noOfPaymentsValue )
            ///regular contribution with future value formula, when END selected  - future vlaue series = PMT * (  pow(( 1 + r / n  ), n * t  ) - 1) /  ( r / n )
            let futureValueSeries = paymentValue * (  pow(( 1.00 + interestDivided / compoundPerYear  ), compoundPerYear * noOfPaymentsValue  ) - 1.00) /  ( interestDivided / compoundPerYear )
            
             let  totalA = compoundInterestPrincipal + futureValueSeries
            
            txtFutureValue.text! = String(format: "%.2f",totalA)
            
            
        } else if txtPayment.text! != "" && endBeginSwitch.isOn == false && txtPresentValue.text! != "" && txtNoOfPaymentPerYear.text! != "" && txtInterestPerYear.text! != ""{
            
            
             let presentValue = Double(txtPresentValue.text!)!
             let interestValue = Double(txtInterestPerYear.text!)!
             let noOfPaymentsValue = Double(txtNoOfPaymentPerYear.text!)!
             let paymentValue = Double(txtPayment.text!)!
             
             let compoundPerYear = 12.00
             
             let interestDivided = interestValue/100
             
              ///regular contribution with future value formula, when BEGIN selected - principal = P * pow( 1 + ( r / n ),n * t )
             let compoundInterestPrincipal = presentValue * pow( 1.00 + ( interestDivided / compoundPerYear ),compoundPerYear * noOfPaymentsValue )
            ///regular contribution with future value formula, when BEGIN selected  - future vlaue series = PMT * (  pow(( 1 + r / n  ), n * t  ) - 1) /  ( r / n )*  (1 + r / n)
             let futureValueSeries = paymentValue * (  pow(( 1.00 + interestDivided / compoundPerYear  ), compoundPerYear * noOfPaymentsValue  ) - 1.00) /  ( interestDivided / compoundPerYear ) *  (1 + interestDivided / compoundPerYear)
             
              let  totalA = compoundInterestPrincipal + futureValueSeries
             
            txtFutureValue.text! = String(format: "%.2f",totalA)
            
        /// this condition will pass when all the text box filled other than payment text box and switch on
        } else if txtPayment.text! == "" && endBeginSwitch.isOn == true && txtPresentValue.text! != "" && txtNoOfPaymentPerYear.text! != "" && txtInterestPerYear.text! != "" {
            
            let alertController = UIAlertController(title: "Warning", message: "Payment value calculate is not defined.", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
                
                
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
          
            
           /// this condition will pass when all the text box filled other than payment text box and switch off
        } else if txtPayment.text! == "" && endBeginSwitch.isOn == false && txtPresentValue.text! != "" && txtNoOfPaymentPerYear.text! != "" && txtInterestPerYear.text! != "" {
            
            let alertController = UIAlertController(title: "Warning", message: "Payment value calculation is not defined.", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
                
                
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
            
            } else {
            
            let alertController = UIAlertController(title: "Warning", message: " Please enter value(s) to calculate.", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
                
                
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
            
          }
    }
    
    
    @IBAction func btnSaveCompoundSaving(_ sender: UIButton) {
        if txtPresentValue.text! != "" && txtFutureValue.text! != "" &&
            txtInterestPerYear.text! != "" && txtNoOfPaymentPerYear.text! != ""
        && txtPayment.text! != "" {
        
          let defaults = UserDefaults.standard
            let historyString = "Present Value is \(txtPresentValue.text!), Future Value is \(txtFutureValue.text!), Interest Rate is \(txtInterestPerYear.text!)%, No. of Payments is  \(txtNoOfPaymentPerYear.text!), Payment is  \(txtPayment.text!), END - \(endBeginSwitch.isOn)"
             
            compoundSavingInterest.historyStringArray.append(historyString)
             defaults.set(compoundSavingInterest.historyStringArray, forKey: "SavingsHistory")
        
            
            let alertController = UIAlertController(title: "Success Alert", message: "Successfully Saved.", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
                
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
            
      
        }
             /// check whether fields are empty before save nill values
        else if txtPresentValue.text! == "" || txtFutureValue.text! == "" ||
                    txtInterestPerYear.text! == "" || txtNoOfPaymentPerYear.text! == "" ||
                    txtPayment.text! == "" {
            
            let alertController = UIAlertController(title: "Warning Alert", message: "One or More Input are Empty", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
                
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
            
        }
        else {
            
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
