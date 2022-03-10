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
    
    @IBAction func doneButtnOfDatePicker(_ sender: UIButton) {
//        dateTxtFld.text = dateFormatter.string(from: datePicker.date)
//        print("selected date",dateTxtFld.text!)
//        self.view.endEditing(true)
        
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "EEEE, dd MM yyyy"
        let date = dateFormatter.string(from: datePicker.date)
        dateTxtFld.text = date
       // print("after change", dateTxtFld.text!)
        datePicker.isHidden = true
        buttonsForDatePicker.isHidden = true
    }
    
    @IBAction func cancelButtonOfDatePicker(_ sender: UIButton) {
        buttonsForDatePicker.isHidden = true
        datePicker.isHidden = true
    }
    
    var dropDownArray = ["Low","Medium","High"]
    let dateFormatter = DateFormatter()
    
    //var date : Date? = nil
    var task = ""
    var priority = ""
    
    let realm = try! Realm()

    var caseToWorkOn:conditions?

    var taskToEdit : Task?
    
    let realmData = Task()

    var isDismissed: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        
    }
    func addDataToEditTheTasks(task:Task){
        addTaskTxtV.text = task.task
        priorityTxtFld.text = task.priority
        dateTxtFld.text = dateFormatter.string(from: task.date!)

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
//            priority = priorityTxtFld.text!
//            print("priority",priority)
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
            dateTxtFld.resignFirstResponder()
        }
        else{
            buttonsForDatePicker.isHidden = true
            datePicker.isHidden = true
        }
        
       
    }
//
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == addTaskTxtV{
            datePicker.isHidden = true
            buttonsForDatePicker.isHidden = true
            priorityPickerView.isHidden = true
            // view.endEditing(true)
        }

    }
//    func textViewDidEndEditing(_ textView: UITextView) {
//        task = textView.text!
//
//    }
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
        if caseToWorkOn == .add{
            realmData.taskId = UUID().uuidString //new
            try! realm.write{
                realm.add(realmData)
            }
        }
         else if caseToWorkOn == .edit{
            //update directly
            //realm.add(realmData, update: .modified)

            try! realm.write{
                realm.add(realmData, update: .modified)
            }
        }
        
        self.dismiss(animated: true, completion: nil)
        //self.isDismissed?()
        
    }

    func dataSorting(){
        let realm = try! Realm()
            var groupedItems = [Date:Results<Task>]()
            var itemDates = [Date]()
        
        let items = realm.objects(Task.self)
               //Find each unique day for which an Item exists in your Realm
               itemDates = items.reduce(into: [Date](), { results, currentItem in
                   let date = currentItem.date!
                   let beginningOfDay = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: date), month: Calendar.current.component(.month, from: date), day: Calendar.current.component(.day, from: date), hour: 0, minute: 0, second: 0))!
                   let endOfDay = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: date), month: Calendar.current.component(.month, from: date), day: Calendar.current.component(.day, from: date), hour: 23, minute: 59, second: 59))!
                   //Only add the date if it doesn't exist in the array yet
                   if !results.contains(where: { addedDate->Bool in
                       return addedDate >= beginningOfDay && addedDate <= endOfDay
                   }) {
                       results.append(beginningOfDay)
                   }
               })
               //Filter each Item in realm based on their date property and assign the results to the dictionary
               groupedItems = itemDates.reduce(into: [Date:Results<Task>](), { results, date in
                   let beginningOfDay = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: date), month: Calendar.current.component(.month, from: date), day: Calendar.current.component(.day, from: date), hour: 0, minute: 0, second: 0))!
                   let endOfDay = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: date), month: Calendar.current.component(.month, from: date), day: Calendar.current.component(.day, from: date), hour: 23, minute: 59, second: 59))!
                   results[beginningOfDay] = realm.objects(Task.self).filter("date >= %@ AND date <= %@", beginningOfDay, endOfDay)
               })
        
        print("grouped items",groupedItems)
    }
    
    
    func validationForTxtFields(textField: UITextField){
        if textField.text == ""{
            
        }
    }
}


