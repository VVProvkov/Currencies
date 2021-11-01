//
//  ConverterViewController.swift
//  firstAppSenin
//
//  Created by Vadim on 21.09.2021.
//

import UIKit



class ConverterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var lableCourseDate: UILabel!
    
    @IBOutlet weak var buttonFrom: UIButton!
    @IBOutlet weak var buttonTo: UIButton!
    @IBOutlet weak var buttonDone: UIBarButtonItem!
    
    
    @IBOutlet weak var textFrom: UITextField!
    @IBOutlet weak var textTo: UITextField!
    
    
    @IBAction func pushFromAction(_ sender: Any) {
        let nc = storyboard?.instantiateViewController(withIdentifier: "selectedCurrencyStoryBoardID") as! UINavigationController
        (nc.viewControllers[0] as! SelectCurrencyController).flagCurrencyControler = .from
        present(nc, animated: true, completion: nil)
    }
    @IBAction func pushDoneAction(_ sender: Any) {
        textFrom.resignFirstResponder()
        navigationItem.backBarButtonItem = nil
    }
    
    @IBAction func pushToAction(_ sender: Any) {
        let nc = storyboard?.instantiateViewController(withIdentifier: "selectedCurrencyStoryBoardID") as! UINavigationController
        (nc.viewControllers[0] as! SelectCurrencyController).flagCurrencyControler = .to
        present(nc, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFrom.delegate = self
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem = nil
        let amount = Double(textFrom.text!)
        textTo.text = Model.shared.convert(amount: amount)
        self.refreshButtons()
        textFromEditingChanged(self)
        print("привет")
    }
    
    @IBAction func textFromEditingChanged(_ sender: Any) {
        let amount = Double(textFrom.text!)
        textTo.text = Model.shared.convert(amount: amount)
        
        
    }
    
    func refreshButtons() {
        buttonFrom.setTitle(Model.shared.from.charCode, for: UIControl.State.normal)
        
        buttonTo.setTitle(Model.shared.to.charCode, for: UIControl.State.normal)

    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        navigationItem.rightBarButtonItem = buttonDone
        return true
    }
    
   
}

