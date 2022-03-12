//
//  CompletedTaskViewController.swift
//  To-Do List
//
//  Created by Coditas on 25/02/22.
//

import UIKit
import RealmSwift


class CompletedTaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, cellImageTapDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var editTxtFld : UITextField?
    
    var date = Date()
    var toDoDataArray = [ToDoData]()
    let realm = try! Realm()
    let dateFormatter = DateFormatter()
    var tasks : Results<Task>!
    var tempTasks : Results<Task>!
    var dictionaryOfDateAndTask = [String:[Task]]()
    var dictionaryForIncompleteTask = [String:[Task]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: Notification.Name("NotificationIdentifier"), object: nil)
        dataAdd()
        setUpUI()
        tableView.register(UINib(nibName: TableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TableViewCell.identifier)
            
    }
    
    @objc func reloadTableView(){
        dataAdd()
        self.tableView.reloadData()
    }
    
    func dataAdd(){
        tempTasks = realm.objects(Task.self).filter("taskCompleted = false")
        
        let form = DateFormatter()
        form.dateFormat = "dd MM yyyy"

        dictionaryOfDateAndTask = Dictionary(grouping: tempTasks, by: {form.string(from: $0.date!)})
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
        if self.tableView(tableView, numberOfRowsInSection: section) > 0{
            return headerToPrint[section]
        }
        else{
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let keys = Array(dictionaryOfDateAndTask.keys)
        let task = dictionaryOfDateAndTask[keys[section]]!
        return task.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell
        
        let keys = Array(dictionaryOfDateAndTask.keys)
        let task = dictionaryOfDateAndTask[keys[indexPath.section]]!
        let taskToPrint = task[indexPath.row]
        
        cell?.imgTapDelegate = self
        
        cell?.setUpCell(task: taskToPrint)
        return cell!
    }

    func tableCell(tableCell: UITableViewCell) {
        let index : IndexPath = tableView.indexPath(for: tableCell)!
        print("index",index)
        let currentCell = tableView.cellForRow(at: index) as? TableViewCell
        let keys = Array(dictionaryOfDateAndTask.keys)
        let task = dictionaryOfDateAndTask[keys[index.section]]!
        let taskToPrint = task[index.row]
        if currentCell!.checkmarkImgV.image == UIImage(systemName: "checkmark.circle.fill"){
                
                try! realm.write{
                    taskToPrint.taskCompleted = false
                    realm.add(taskToPrint, update: .modified)
                }
                currentCell?.checkmarkImgV.image = UIImage(systemName: "circle")
            }
            else if currentCell?.checkmarkImgV.image == UIImage(systemName: "circle"){
                try! realm.write{
                    taskToPrint.taskCompleted = true
                    realm.add(taskToPrint, update: .modified)
                }
                //taskToPrint.taskCompleted = true
                currentCell?.checkmarkImgV.image = UIImage(systemName: "checkmark.circle.fill")
            }
        
        if taskToPrint.taskCompleted == true{
           // realm.delete(taskToPrint)
            self.dictionaryOfDateAndTask[keys[index.section]]!.remove(at: index.row)
        }
        tableView.reloadData()
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let currentCell = tableView.cellForRow(at: indexPath)as? TableViewCell
        let keys = Array(dictionaryOfDateAndTask.keys)
        let task = dictionaryOfDateAndTask[keys[indexPath.section]]!
        let taskToPrint = task[indexPath.row]
        
        if currentCell!.checkmarkImgV.image == UIImage(systemName: "checkmark.circle.fill"){
                
                try! realm.write{
                    taskToPrint.taskCompleted = false
                    realm.add(taskToPrint, update: .modified)
                }
                currentCell?.checkmarkImgV.image = UIImage(systemName: "circle")
            }
            else if currentCell?.checkmarkImgV.image == UIImage(systemName: "circle"){
                try! realm.write{
                    taskToPrint.taskCompleted = true
                    realm.add(taskToPrint, update: .modified)
                }
                //taskToPrint.taskCompleted = true
                currentCell?.checkmarkImgV.image = UIImage(systemName: "checkmark.circle.fill")
            }
        //taskToPrint.taskCompleted = !taskToPrint.taskCompleted
        
       
        
        //currentCell!.checkmarkImgV.image = taskToPrint.taskCompleted == true ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle")
        
//        try! realm.write{
//            //if taskToPrint.taskCompleted ==
//            //taskToPrint.taskCompleted = !taskToPrint.taskCompleted
//            realm.add(taskToPrint, update: .modified)
//        }
        if taskToPrint.taskCompleted == true{
           // realm.delete(taskToPrint)
            self.dictionaryOfDateAndTask[keys[indexPath.section]]!.remove(at: indexPath.row)
        }
        tableView.reloadData()

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
            
        }

        let delete = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            print("delete")
            let keys = Array(self.dictionaryOfDateAndTask.keys)
            let task = self.dictionaryOfDateAndTask[keys[indexPath.section]]!
            //tableView.deleteRows(at: [indexPath], with: .automatic)
            
            let taskToDelete = task[indexPath.row]
            
            try! self.realm.write{
                self.realm.delete(taskToDelete)
            }
            
            self.dictionaryOfDateAndTask[keys[indexPath.section]]!.remove(at: indexPath.row)
            //self.dictionaryOfDateAndTask.removeAll()
            //self.dataAdd()
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
