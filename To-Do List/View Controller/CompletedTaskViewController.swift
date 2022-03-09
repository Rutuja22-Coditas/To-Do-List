//
//  CompletedTaskViewController.swift
//  To-Do List
//
//  Created by Coditas on 25/02/22.
//

import UIKit
import RealmSwift


class CompletedTaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var editTxtFld : UITextField?
    
    var date = Date()
    var toDoDataArray = [ToDoData]()
    let realm = try! Realm()
    let dateFormatter = DateFormatter()
    var tasks : Results<Task>!
    var dictionaryOfDateAndTask = [String:[Task]]()
//        var groupedItems = [Date:Results<Task>]()
//        var itemDates = [Date]()
//    var dateToPrintAsHeader = [String]()
//
//    var taskDates = [Date]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataAdd()
        setUpUI()
        tableView.register(UINib(nibName: TableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TableViewCell.identifier)
        
//        let tmp = dictionaryOfDateAndTask.sorted { (d1, d2) -> Bool in
//            let date1 = form.date(from: d1.key)!
//            let date2 = form.date(from: d2.key)!
//            return date1 < date2
//        }
//
//        dictionaryOfDateAndTask.removeAll()
//
//        for element in tmp.enumerated(){
//            print(element)
//            dictionaryOfDateAndTask[element.element.key] = element.element.value
//        }
        
            print("dictionaryOfDateAndTask",dictionaryOfDateAndTask)
        
        
//        let items = realm.objects(Task.self)
//               //Find each unique day for which an Item exists in your Realm
//               itemDates = items.reduce(into: [Date](), { results, currentItem in
//                   let date = currentItem.date!
//                   let beginningOfDay = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: date), month: Calendar.current.component(.month, from: date), day: Calendar.current.component(.day, from: date), hour: 0, minute: 0, second: 0))!
//                print("beginningOfDay",beginningOfDay)
//                   let endOfDay = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: date), month: Calendar.current.component(.month, from: date), day: Calendar.current.component(.day, from: date), hour: 23, minute: 59, second: 59))!
//                print("endOfDay",endOfDay)
//                   //Only add the date if it doesn't exist in the array yet
//                   if !results.contains(where: { addedDate->Bool in
//                       return addedDate >= beginningOfDay && addedDate <= endOfDay
//                   }) {
//                       results.append(beginningOfDay)
//                   }
//               })
//               //Filter each Item in realm based on their date property and assign the results to the dictionary
//               groupedItems = itemDates.reduce(into: [Date:Results<Task>](), { results, date in
//                   let beginningOfDay = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: date), month: Calendar.current.component(.month, from: date), day: Calendar.current.component(.day, from: date), hour: 0, minute: 0, second: 0))!
//                   let endOfDay = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: date), month: Calendar.current.component(.month, from: date), day: Calendar.current.component(.day, from: date), hour: 23, minute: 59, second: 59))!
//                   results[beginningOfDay] = realm.objects(Task.self).filter("date >= %@ AND date <= %@", beginningOfDay, endOfDay)
//               })
//        let results = realm.objects(Task.self)
//        dateFormatter.dateStyle = .medium
//        dateFormatter.dateFormat = "EEEE, dd MM yyyy"
//        var a = [String]()
//        var b = realm.objects(Task.self).sorted(byKeyPath: "date", ascending: true)
//
//        for i in b{
//            let convertedDate = dateFormatter.string(from: i.date!)
//            a.append(convertedDate)
//            print("convertedDate",convertedDate)
//            print("sortedDate",a)
//        }
//        let b = realm.objects(Task.self).sorted(byKeyPath: "date", ascending: true)
//
//        print("!!!!!!!", b)
        
        //a = a.sorted(by: {$0.date!.compare($1.date!) == .orderedDescending})
        
        
        
//        for i in itemDates{
//            let a = dateFormatter.string(from: i)
//            dateToPrintAsHeader.append(a)
//        }
        
        
    }
  
    func dataAdd(){
//        dateFormatter.dateStyle = .medium
//        dateFormatter.dateFormat = "EEEE, dd MM yyyy"
//        toDoDataArray = [ToDoData(date: dateFormatter.date(from: "Monday, 10 05 2011")!, priority: "High", task: "Buy bread")]
        tasks = realm.objects(Task.self).sorted(byKeyPath: "date", ascending: true)
        print("tasks",tasks!)
        
        let form = DateFormatter()
        form.dateFormat = "dd MM yyyy"
        dictionaryOfDateAndTask = Dictionary(grouping: tasks, by: {form.string(from: $0.date!)})
    }
    
    func setUpUI(){
        tableView.sectionHeaderHeight = 40
    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dictionaryOfDateAndTask.keys.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let headerToPrint = Array(dictionaryOfDateAndTask.keys)
        return headerToPrint[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let keys = Array(dictionaryOfDateAndTask.keys)
        let task = dictionaryOfDateAndTask[keys[section]]!
        return task.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell
        //let itemsForDate = groupedItems[itemDates[indexPath.section]]!.sorted(byKeyPath: "date")

        //cell?.taskLbl.text = itemsForDate[indexPath.row].task
        
        let keys = Array(dictionaryOfDateAndTask.keys)
        let task = dictionaryOfDateAndTask[keys[indexPath.section]]!
        let taskToPrint = task[indexPath.row]
        cell?.taskLbl.text = taskToPrint.task
        return cell!
    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        toDoDataArray[section].date
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let currentCell = tableView.cellForRow(at: indexPath)as? TableViewCell
        if currentCell?.checkmarkImgV.image == UIImage(systemName: "checkmark.circle.fill"){
            currentCell?.checkmarkImgV.image = UIImage(systemName: "circle")
        }
        else if currentCell?.checkmarkImgV.image == UIImage(systemName: "circle"){
            currentCell?.checkmarkImgV.image = UIImage(systemName: "checkmark.circle.fill")
        }
         
        //print("Priority",toDoDataArray[indexPath.section].taskData[indexPath.section].priority[indexPath.row])
    }
   
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Edit") { (_, _, _) in
            print("edit")
            let alertForEdit = UIAlertController(title: "Edit", message: "Edit the task", preferredStyle: .alert)
            let update = UIAlertAction(title: "Update", style: .default) { (action) in
                //let updateTask = self.editTxtFld?.text!
                
                //let obj = Task()
                let keys = Array(self.dictionaryOfDateAndTask.keys)
                let task = self.dictionaryOfDateAndTask[keys[indexPath.section]]!
                let taskToPrint = task[indexPath.row]
                //taskToPrint = updateTask
                //obj.task = taskToPrint.task
                
                try! self.realm.write{
                    //self.realm.add(obj)
                    taskToPrint.task = self.editTxtFld?.text
                    self.realm.add(taskToPrint)
                }
               
                tableView.reloadData()
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                print("cancel")
            }
            alertForEdit.addTextField { (textField) in
                self.editTxtFld = textField
                self.editTxtFld?.placeholder = "Update the task"
                let keys = Array(self.dictionaryOfDateAndTask.keys)
                let task = self.dictionaryOfDateAndTask[keys[indexPath.section]]!
                let taskToPrint = task[indexPath.row]
                self.editTxtFld?.text = taskToPrint.task
            }

            alertForEdit.addAction(update)
            alertForEdit.addAction(cancel)
            self.present(alertForEdit, animated: true, completion: nil)
        }

        let delete = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            print("delete")
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            var keys = Array(self.dictionaryOfDateAndTask.keys)
            let task = self.dictionaryOfDateAndTask[keys[indexPath.section]]!
            let taskToDelete = task[indexPath.row]
            //tableView.deleteRows(at: [indexPath], with: .automatic)
            
            try! self.realm.write{
                //self.realm.add(obj)
                self.realm.delete(taskToDelete)

            }
            let inex = [IndexPath(row: indexPath.row, section: indexPath.section)]
            tableView.deleteRows(at: [indexPath], with: .automatic)
            //toDoDataArray[indexPath.section].taskData.remove(at: indexPath.row)
            tableView.reloadData()
        }
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [delete,edit])
        return swipeConfiguration
    }
    
    

}
