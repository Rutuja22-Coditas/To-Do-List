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
    
    @IBOutlet weak var buttonsForDatePicker: UIView!
    
    @IBOutlet weak var alertLblOfTxtV: UILabel!
    @IBOutlet weak var alertLblOfPriorityTxtFld: UILabel!
    @IBOutlet weak var alertLblOfDateTxtFld: UILabel!
    
    @IBAction func doneButtnOfDatePicker(_ sender: UIButton) {

        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "EEEE, dd MM yyyy"
        let date = dateFormatter.string(from: datePicker.date)
        dateTxtFld.text = date
        alertLblOfDateTxtFld.isHidden = true
       // print("after change", dateTxtFld.text!)
        datePicker.isHidden = true
        buttonsForDatePicker.isHidden = true
        checkForValidation()
    }
    
    @IBAction func cancelButtonOfDatePicker(_ sender: UIButton) {
        buttonsForDatePicker.isHidden = true
        datePicker.isHidden = true
    }
    
    var dropDownArray = ["Low","Medium","High"]
    let dateFormatter = DateFormatter()
    
    //var date : Date? = nil
    var task1 = ""
    var priority1 = ""
    var date1 = ""
    let realm = try! Realm()

    var caseToWorkOn:conditions?

    var taskToEdit : Task?
    
    let realmData = Task()

    //var isDismissed: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTaskTxtV.text = "Add task"
        addTaskTxtV.textColor = UIColor.lightGray
        
        buttonsForDatePicker.isHidden = true
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
        
        
        
        switch caseToWorkOn {
        case .edit:
            print("EDIT DATA")
            addDataToEditTheTasks(task: taskToEdit!)
        case .add:
            print("ADD DATA")

        case .none:
            print("No changes")
        }
        //priorityTxtFld.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .allEditingEvents)
        //dateTxtFld.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .allEditingEvents)
    }
    
//    @objc func textFieldDidChange(_ textField: UITextField){
//        if textField == priorityTxtFld{
//            if priorityTxtFld.text == "High" || priorityTxtFld.text == "Low" || priorityTxtFld.text == "Medium"{
//                alertLblOfPriorityTxtFld.isHidden = true
//            }
//            else{
//                alertLblOfPriorityTxtFld.isHidden = false
//            }
//        }
//        if textField == dateTxtFld{
//            if dateTxtFld.text!.count > 0{
//                alertLblOfDateTxtFld.isHidden = true
//            }
//            else{
//                alertLblOfDateTxtFld.isHidden = false
//            }
//        }
//        checkForValidation()
//    }
    
//    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
//        addTaskTxtV.resignFirstResponder()
//        priorityTxtFld.resignFirstResponder()
//        dateTxtFld.resignFirstResponder()
//    }

    func textViewDidChange(_ textView: UITextView) {
        alertLblOfTxtV.isHidden = false
        if addTaskTxtV.text.isEmpty{
            alertLblOfTxtV.isHidden = false
        }
        else{
            alertLblOfTxtV.isHidden = true
        }
        checkForValidation()
    }
    
    func checkForValidation(){
        if alertLblOfTxtV.isHidden && alertLblOfPriorityTxtFld.isHidden && alertLblOfDateTxtFld.isHidden{
            okButtn.isEnabled = true
        }
        else{
            okButtn.isEnabled = false
        }
    }
    func addDataToEditTheTasks(task:Task){
        addTaskTxtV.textColor = UIColor.black

        alertLblOfTxtV.isHidden = true
        alertLblOfPriorityTxtFld.isHidden = true
        alertLblOfDateTxtFld.isHidden = true
        checkForValidation()
        addTaskTxtV.text = task.task
        task1 = addTaskTxtV.text
        priorityTxtFld.text = task.priority
        priority1 = priorityTxtFld.text!
        dateTxtFld.text = dateFormatter.string(from: task.date!)
        date1 = dateFormatter.string(from: task.date!)
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
        alertLblOfPriorityTxtFld.isHidden = true
        pickerView.isHidden = true
        checkForValidation()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == priorityTxtFld{
            datePicker.isHidden = true
            buttonsForDatePicker.isHidden = true
            priorityPickerView.isHidden = false
        }
        else{
            priorityPickerView.isHidden = true
        }
        
        if textField == dateTxtFld{
//            dateTxtFld.text = dateFormatter.string(from: datePicker.date)
//            print("date", dateTxtFld.text!)
            buttonsForDatePicker.isHidden = false
            datePicker.isHidden = false
        }
        else{
            buttonsForDatePicker.isHidden = true
            datePicker.isHidden = true
        }
        
       
    }
//
    func textViewDidBeginEditing(_ textView: UITextView) {
//        textView.becomeFirstResponder()
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
//        self.view.addGestureRecognizer(tapGesture)
        if textView.textColor == UIColor.lightGray{
            textView.text = nil
            textView.textColor = UIColor.black
        }
        
        
        if textView == addTaskTxtV{
            datePicker.isHidden = true
            buttonsForDatePicker.isHidden = true
            priorityPickerView.isHidden = true
            // view.endEditing(true)
        }

    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == addTaskTxtV{
            if textView.text.isEmpty {
                  textView.text = "Add Task"
                textView.textColor = UIColor.lightGray
              }

        }
    }
    
    func setDatePicker(){
        dateTxtFld.inputView = datePicker
        datePicker.locale = .current
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.date = Date()
        datePicker.backgroundColor = .white
        datePicker.layer.cornerRadius = 10
        
    }

    @objc func okButtnClicked(){
        print("caseToWorkOn",caseToWorkOn!)
        realmData.task = addTaskTxtV.text
        realmData.priority = priorityTxtFld.text
        //print("to save date",dateTxtFld.text!)
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "EEEE, dd MM yyyy"
        dateFormatter.timeZone = TimeZone.current
                
        let dateInString = dateFormatter.date(from: dateTxtFld.text!)!
        realmData.date = dateInString
        //if caseToWorkOn == .edit{
//        if caseToWorkOn == .add{
//            realmData.taskId = UUID().uuidString //new
//            try! realm.write{
//                realm.add(realmData)
//            }
//        }
//         else if caseToWorkOn == .edit{
//            //update directly
//            //realm.add(realmData, update: .modified)
//
//            try! realm.write{
//                realm.add(realmData, update: .modified)
//            }
//        }
        switch caseToWorkOn {
        
        case .edit:
            if addTaskTxtV.text != task1 || priorityTxtFld.text != priority1 || dateTxtFld.text != date1{
                try! realm.write{
                    realm.add(realmData, update: .modified)
                }
            }
            else{
                print("data not changed")
            }
        case .add:
            realmData.taskId = UUID().uuidString //new
            try! realm.write{
                realm.add(realmData)
            }
       
        case .none:
            print("no case")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil, userInfo: nil)
            self.dismiss(animated: true, completion: nil)
        }
        

        //self.isDismissed?()
        
        
    }

}


