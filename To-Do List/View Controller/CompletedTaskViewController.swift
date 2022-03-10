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

    override func viewDidLoad() {
        super.viewDidLoad()

        dataAdd()
        setUpUI()
        tableView.register(UINib(nibName: TableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TableViewCell.identifier)
            
    }
        
    func dataAdd(){
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
        cell?.setUpCell(task: taskToPrint)
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
            let keys = Array(self.dictionaryOfDateAndTask.keys)
            let task = self.dictionaryOfDateAndTask[keys[indexPath.section]]!
            let taskToPrint = task[indexPath.row]
            print("taskToPrint",taskToPrint)
            
            let vC = UIStoryboard(name: "Main", bundle: nil)
            let alertVC = vC.instantiateViewController(identifier: "AlertViewController") as? AlertViewController
            alertVC?.modalPresentationStyle = .automatic
            print("taskToPrint.task",taskToPrint.task!)
            alertVC?.caseToWorkOn = .edit
            alertVC?.taskToEdit = taskToPrint
//            alertVC?.isDismissed = {
//                 [weak self] in
//                tableView.reloadData()
//            }
            self.present(alertVC!, animated: true, completion: nil)
            tableView.reloadData()
            //let alertForEdit = UIAlertController(title: "Edit", message: "Edit the task", preferredStyle: .alert)
            //let update = UIAlertAction(title: "Update", style: .default) { (action) in
                //let updateTask = self.editTxtFld?.text!
                
                //let obj = Task()
                
                //taskToPrint = updateTask
                //obj.task = taskToPrint.task
                
//                try! self.realm.write{
//                    //self.realm.add(obj)
//                    taskToPrint.task = self.editTxtFld?.text
//                    self.realm.add(taskToPrint)
//                }
//                tableView.reloadData()
                
//                let vC = UIStoryboard(name: "Main", bundle: nil)
//                        let alertVC = vC.instantiateViewController(identifier: "AlertViewController") as? AlertViewController
//                alertVC?.modalPresentationStyle = .automatic
//                alertVC?.addTaskTxtV.text = taskToPrint.task
//                alertVC?.priorityTxtFld.text = taskToPrint.priority
//                alertVC?.okButtn.setTitle("Update", for: .normal)
//                self.dateFormatter.dateFormat = "EEEE, dd MM yyyy"
//                alertVC?.dateTxtFld.text = self.dateFormatter.string(from: taskToPrint.date!)
//
//
//                self.present(alertVC!, animated: true, completion: nil)
                
  //          }
            print("dataAfterUpdate",self.dictionaryOfDateAndTask)
            
//            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
//                print("cancel")
//            }
            
        
//            alertForEdit.addTextField { (textField) in
//                self.editTxtFld = textField
//                self.editTxtFld?.placeholder = "Update the task"
//                let keys = Array(self.dictionaryOfDateAndTask.keys)
//                let task = self.dictionaryOfDateAndTask[keys[indexPath.section]]!
//                let taskToPrint = task[indexPath.row]
//                self.editTxtFld?.text = taskToPrint.task
//            }

            //alertForEdit.addAction(update)
            //alertForEdit.addAction(cancel)
            //self.present(alertForEdit, animated: true, completion: nil)
        }

        let delete = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            print("delete")
            let keys = Array(self.dictionaryOfDateAndTask.keys)
            let task = self.dictionaryOfDateAndTask[keys[indexPath.section]]!
            //tableView.deleteRows(at: [indexPath], with: .automatic)
            
            let taskToDelete = task[indexPath.row]
            
            print("deletingTask***",taskToDelete)
            try! self.realm.write{
                self.realm.delete(taskToDelete)
            }
            
            self.dictionaryOfDateAndTask[keys[indexPath.section]]!.remove(at: indexPath.row)
//                    try! self.realmt.write{
//                        //self.realm.add(obj)
//                        self.realm.delete(taskToDelete)
//                    }
            tableView.reloadData()

            
            
            //toDoDataArray[indexPath.section].taskData.remove(at: indexPath.row)
        }
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [delete,edit])
        return swipeConfiguration
    }
    
    

}
