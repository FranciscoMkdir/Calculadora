//
//  CalculadoraViewController.swift
//  Calculadora
//
//  Created by macbook on 21/05/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit

class CalculadoraViewController: UIViewController {
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var tipTextField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var amountTotalLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Calculadora de propinas"
        amountTextField.delegate = self
        addDoneButtonOnKeyboard(textField: amountTextField)
    }
    
    @IBAction func calculate() {
        view.endEditing(true)
        guard let amount = amountTextField.text else {return}
        if amount.isEmpty{
            showErrorAlert(message: "Porfavor escriba el importe a pagar")
            return
        }
    }
    
    
    func showErrorAlert(message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


extension CalculadoraViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func addDoneButtonOnKeyboard(textField: UITextField) {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Aceptar", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneButtonAction))
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        textField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
}
