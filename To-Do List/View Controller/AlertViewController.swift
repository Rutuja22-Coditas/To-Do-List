//
//  AlertViewController.swift
//  To-Do List
//
//  Created by Coditas on 26/02/22.
//

import UIKit
import CoreData

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
//    @IBAction func datePickerSelected(_ sender: UIDatePicker) {
//        let dateFormatter = DateFormatter()
//        dateTxtFld.text = dateFormatter.string(from: datePicker.date)
//
//    }
    
    @IBOutlet weak var okButtn: UIButton!
    @IBOutlet weak var cancelButtn: UIButton!
    
    var dropDownArray = ["Low","Medium","High"]
    let dateFormatter = DateFormatter()
    var date = ""
    var task = ""
    var priority = ""

    
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
        okButtn.addTarget(self, action: #selector(dataSave), for: .touchUpInside)
        datePicker.isHidden = true
        
        
        //fetchData()

    }
    
    func alertUI(){
        alertView.layer.cornerRadius = 10
        view.isOpaque = false
        view.backgroundColor = .clear
        addTaskTxtV.layer.borderWidth = 0.5
        addTaskTxtV.layer.borderColor = UIColor.systemGray4.cgColor
        addTaskTxtV.layer.cornerRadius = 5
        
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
        dateTxtFld.isHidden = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == priorityTxtFld{
            priority = priorityTxtFld.text!
            print("priority",priority)
            dateTxtFld.isHidden = true
            datePicker.isHidden = true
            priorityPickerView.isHidden = false
        }
        else{
            dateTxtFld.isHidden = false
            priorityPickerView.isHidden = true
        }
        
        if textField == dateTxtFld{
            date = dateTxtFld.text!
            print("date",date)
            datePicker.isHidden = false
        }
        dateTxtFld.resignFirstResponder()
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
        dateTxtFld.inputView = datePicker
        datePicker.locale = .current
        datePicker.preferredDatePickerStyle = .compact
        datePicker.date = Date()
        dateTxtFld.text = "\(dateFormatter.string(from: datePicker.date))"
        datePicker.addTarget(self, action: #selector(dateCahnge), for: .valueChanged)
    }
    
    @objc func dateCahnge(){
//        dateFormatter.dateStyle = .medium
//        dateFormatter.dateFormat = "EEEE, dd MM yyyy"
        let date = dateFormatter.string(from: datePicker.date)
        dateTxtFld.text = date
        datePicker.isHidden = true
    }

    
    @objc func dataSave(){
        let toDoTask = ToDoData(context: context)
        

        print("date",dateTxtFld.text!)
        print("Priority",priorityTxtFld.text!)
        print("task",addTaskTxtV.text!)

        toDoTask.task = task
        toDoTask.date = date
        toDoTask.priority = priority
        
        saveTasks()
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveTasks(){
        do{
            try context.save()
            print("saved")
        }
        catch{
            print("error in saving data",error)
        }
    }
    
//    func fetchData(){
//        let request : NSFetchRequest<ToDoData> = ToDoData.fetchRequest()
//        do{
//            let result = try context.fetch(request)
//            print("result",result)
//            for i in result{
//                print(i.task!)
//            }
//        }
//        catch{
//            print("error in fetching data",error )
//        }
//
//    }
}



