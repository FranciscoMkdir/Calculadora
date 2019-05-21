//
//  CalculadoraViewController.swift
//  Calculadora
//
//  Created by macbook on 21/05/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit

class CalculadoraViewController: UIViewController {
    @IBOutlet weak var buttonCalculate: UIButton!{didSet{
        buttonCalculate.layer.cornerRadius = 4
        buttonCalculate.clipsToBounds = true
        }}
    @IBOutlet weak var amountTextField: UITextField!{didSet{
        amountTextField.delegate = self
        addDoneButtonOnKeyboard(textField: amountTextField)
        }}
    @IBOutlet weak var tipTextField: UITextField!{didSet{
        tipTextField.delegate = self
        tipTextField.inputView = UIView()
        tipTextField.tintColor = UIColor.clear
        }}
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var amountTotalLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!{didSet{
        pickerView.isHidden = true
        pickerView.delegate = self
        pickerView.layer.borderColor = UIColor.lightGray.cgColor
        pickerView.layer.borderWidth = 2
        }}
    let tipsPercentage = ["5", "10", "15", "20", "25", "30", "35"] // holis
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Calculadora de propinas"
    }
    
    @IBAction func calculate() {
        view.endEditing(true)
        hidePickerView()
        guard let amount = amountTextField.text,
              let tip = tipTextField.text,
              let percentage = Double(tip) else {return}
        if amount.isEmpty{
            showErrorAlert(message: "Porfavor escriba el importe a pagar")
            return
        }
        let totalTip = (Double(amount) ?? 0) * (percentage / 100)
        tipLabel.text = String(format: "Propina: $%.2f", totalTip)
        amountTotalLabel.text = String(format: "Total a pagar: $%.2f", totalTip + Double(amount)!)
    }
    
    
    func showErrorAlert(message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showPickerView(){
        pickerView.isHidden = false
    }
    
    func hidePickerView(){
        pickerView.isHidden = true
    }
}

extension CalculadoraViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tipsPercentage.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tipsPercentage[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tipTextField.text = tipsPercentage[row]
        tipTextField.endEditing(true)
        hidePickerView()
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == tipTextField{
            showPickerView()
        }else{
            hidePickerView()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == amountTextField{
            guard let amount = textField.text else {return true}
            let countdots = amount.components(separatedBy: ".").count - 1
            if countdots > 0 && string == "." {
                return false
            }
            return true
        }else{
            return true
        }
    }
}

