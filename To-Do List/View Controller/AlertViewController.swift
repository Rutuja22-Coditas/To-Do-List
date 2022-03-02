//
//  AlertViewController.swift
//  To-Do List
//
//  Created by Coditas on 26/02/22.
//

import UIKit
import RealmSwift

class AlertViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertViewHt: NSLayoutConstraint!
    @IBOutlet weak var alertTitle: UILabel!
  
    @IBOutlet weak var addTaskTxtV: UITextView!
    @IBOutlet weak var addTaskTxtVHt: NSLayoutConstraint!
    
    @IBOutlet weak var priorityTxtFld: UITextField!
    @IBOutlet weak var priorityPickerView: UIPickerView!
    
    @IBOutlet weak var dateTxtFld: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var okButtn: UIButton!
    @IBOutlet weak var cancelButtn: UIButton!
    
    var dropDownArray = ["Low","Medium","High"]
    let dateFormatter = DateFormatter()
    
    var date : Date? = nil
    var task = ""
    var priority = ""
    let realm = try! Realm()
    
    var realmData = Task()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "EEEE, dd MM yyyy"
        
        priorityTxtFld.delegate = self
        dateTxtFld.delegate = self
        addTaskTxtV.delegate = self
        
        alertUI()
        setDatePicker()
        
        cancelButtn.addTarget(self, action: #selector(cancelButtnCliked), for: .touchUpInside)
        okButtn.addTarget(self, action: #selector(okButtnClicked), for: .touchUpInside)
        
        print("realm", Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setToolBarForDatePicker()
    }
    
    func alertUI(){
        alertView.layer.cornerRadius = 10
        view.isOpaque = false
        view.backgroundColor = .clear
        addTaskTxtV.layer.borderWidth = 0.5
        addTaskTxtV.layer.borderColor = UIColor.systemGray4.cgColor
        addTaskTxtV.layer.cornerRadius = 5
        priorityPickerView.backgroundColor = .white
        priorityPickerView.layer.cornerRadius = 5
                
    }
    
    @objc func cancelButtnCliked(){
        self.dismiss(animated: true, completion: nil)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        dropDownArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        view.endEditing(true)
        return dropDownArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        priorityTxtFld.text = dropDownArray[row]
        pickerView.isHidden = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == priorityTxtFld{
            priority = priorityTxtFld.text!
            print("priority",priority)
            datePicker.isHidden = true
            priorityPickerView.isHidden = false
        }
        else{
            priorityPickerView.isHidden = true
        }
        
        if textField == dateTxtFld{
//            dateTxtFld.text = dateFormatter.string(from: datePicker.date)
//            print("date", dateTxtFld.text!)
            datePicker.isHidden = false
            dateTxtFld.resignFirstResponder()

        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == addTaskTxtV{
            datePicker.isHidden = true
            priorityPickerView.isHidden = true
            // view.endEditing(true)
        }
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        task = textView.text!
        
    }
    func setDatePicker(){
        //let toolBar = UIToolbar()
        //toolBar.sizeToFit()
        dateTxtFld.inputView = datePicker
        datePicker.locale = .current
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.date = Date()
        datePicker.backgroundColor = .white
        datePicker.layer.cornerRadius = 10
        //dateTxtFld.inputAccessoryView = toolBar

        //ToolbarPiker()

        //let doneButtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtnClkOnDatePicker))
        //let doneButtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtnClkOnDatePicker))
        //let cancelButtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClkedOnDatePicker))
        //toolBar.setItems([doneButtn,cancelButtn], animated: true)
        //toolBar.backgroundColor = .black
        //dateTxtFld.text = "\(dateFormatter.string(from: datePicker.date))"
        datePicker.addTarget(self, action: #selector(dateCahnge), for: .valueChanged)
    }
    func setToolBarForDatePicker() {

        let toolBar = UIToolbar()

        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(doneButtnClkOnDatePicker))
        let cancelButtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)

        toolBar.setItems([doneButton, cancelButtn], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        dateTxtFld.inputAccessoryView = toolBar
        
    }
    @objc func doneButtnClkOnDatePicker(){
        dateTxtFld.text = dateFormatter.string(from: datePicker.date)
        print("selected date",dateTxtFld.text!)
        self.view.endEditing(true)
    }
    @objc func cancelClkedOnDatePicker(){
        print("cancel")
    }
    @objc func dateCahnge(){
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "EEEE, dd MM yyyy"
        let date = dateFormatter.string(from: datePicker.date)
        dateTxtFld.text = date
        print("after change", dateTxtFld.text!)
        datePicker.isHidden = true
    }

    
    @objc func okButtnClicked(){

        realmData.task = addTaskTxtV.text
        realmData.priority = priorityTxtFld.text
        
        realmData.date = dateFormatter.date(from: dateTxtFld.text!)

        try! realm.write{
            realm.add(realmData)
        }
        
        let results = realm.objects(Task.self)
        print("result",results)

        
        self.dismiss(animated: true, completion: nil)
    }
    
  
}



