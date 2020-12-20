//
//  HistoryViewController.swift
//  FinancialCalculatorApp
//
//  Created by Alfred Edwin on 2020-12-01.
//

import UIKit

class HistoryViewController: UITableViewController {

    var history : [String] = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initHistoryInfo()

        // Do any additional setup after loading the view.
    }
    
    /// load history data when history view switched
    func initHistoryInfo() {
        if let vcs = self.navigationController?.viewControllers {
            let previousVC = vcs[vcs.count - 2]
            
            if previousVC is MortgageViewController {
                loadDefaultsData("MortgageHistory")
            }
            
            if previousVC is CompoundSavingsViewController {
                loadDefaultsData("CompoundSavingsInterestHistory")
            }
            
            if previousVC is SavingsViewController {
                loadDefaultsData("SavingsHistory")
            }
        
            if previousVC is LoanViewController {
                loadDefaultsData("LoanHistory")
            }
        }
    }
    
    
    /// load history data to string array
   func loadDefaultsData(_ historyKey :String) {
       let defaults = UserDefaults.standard
       history = defaults.object(forKey: historyKey) as? [String] ?? [String]()
   }
   
    /// perform additional display history data in each row
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    
    /// perform additional tabelview row data with idetifier name
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableHistoryCell")!
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = history[indexPath.row]
        return cell
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
