//
//  selectCurrencyController.swift
//  firstAppSenin
//
//  Created by Vadim on 21.09.2021.
//

import UIKit

enum FlagCurrencySelected {
    case from
    case to
}

class SelectCurrencyController: UITableViewController {

    
    
    var flagCurrencyControler = FlagCurrencySelected.from
    
    
    
    @IBAction func pushCanceButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        NotificationCenter.default.addObserver(forName: NSNotification.Name("dataRefreshed"), object: nil, queue: nil) { (notification) in
//            
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//                Model.shared.from = selectedCurrency
//                Model.shared.to = selectedCurrency
//            }
//        }

    }

    
    
    
    // MARK: - Table view data source

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return Model.shared.currencies.count
    }

  
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! currenciesViewCell

        let currentCurrency: Currency = Model.shared.currencies[indexPath.row]
        cell.initCell(currency: currentCurrency)

        return cell
    }
  
    
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCurrency: Currency = Model.shared.currencies[indexPath.row]
        if flagCurrencyControler == .from {
            Model.shared.from = selectedCurrency
            Model.shared.fromChar = selectedCurrency.charCode
            
        }
            
        if flagCurrencyControler == .to {
            Model.shared.to = selectedCurrency
            Model.shared.fromChar = selectedCurrency.charCode
        }
            
        dismiss(animated: true) {

        }
    }
}
