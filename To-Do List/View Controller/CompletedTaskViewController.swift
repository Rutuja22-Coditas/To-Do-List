//
//  CompletedTaskViewController.swift
//  To-Do List
//
//  Created by Coditas on 25/02/22.
//

import UIKit
import CoreData

var toDoDataArray = [ToDoData]()
let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


class CompletedTaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var editTxtFld : UITextField?
    
    let request : NSFetchRequest<ToDoData> = ToDoData.fetchRequest()
  

    override func viewDidLoad() {
        super.viewDidLoad()
        dataAdd()
        setUpUI()
        tableView.register(UINib(nibName: TableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TableViewCell.identifier)
        
    }
    
    func setUpUI(){
        tableView.sectionHeaderHeight = 60
    }
    
    func dataAdd(){
//        toDoDataArray = [
//            ToDoData(date: "Today, 24 Feb 2022", taskData: [PriorityAndTask(priority: "High", task: "Buy bread"), PriorityAndTask(priority: "Low", task: "Buy Egg"),PriorityAndTask(priority: "Low", task: "Buy xyz")]), ToDoData(date: "Thursday, 28 Feb 2022", taskData: [PriorityAndTask(priority: "Low", task: "abcd")])
//        ]

        do{
            let result = try context.fetch(request)
            for i in result{
                toDoDataArray.append(i)
                print("!!!!!!!", toDoDataArray)
            }
        }
        catch{
            print("error",error)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("sectionCount",toDoDataArray.count)
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoDataArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell
        //cell?.taskLbl.text = toDoDataArray[indexPath.section].taskData[indexPath.row].task
        cell?.taskLbl.text = toDoDataArray[indexPath.row].task
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
                let updateTask = self.editTxtFld?.text!
                //toDoDataArray[indexPath.section].taskData[indexPath.section].task[indexPath.row] = updateTask!
                //toDoDataArray[indexPath.section].taskData[indexPath.row].task = updateTask!
                tableView.reloadData()
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                print("cancel")
            }
            alertForEdit.addTextField { (textField) in
                self.editTxtFld = textField
                self.editTxtFld?.placeholder = "Update the task"
               // self.editTxtFld?.text = toDoDataArray[indexPath.section].taskData[indexPath.row].task
            }

            alertForEdit.addAction(update)
            alertForEdit.addAction(cancel)
            self.present(alertForEdit, animated: true, completion: nil)
        }

        let delete = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            print("delete")
            context.delete(toDoDataArray[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .automatic)
            //toDoDataArray[indexPath.section].taskData.remove(at: indexPath.row)
            tableView.reloadData()
        }
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [delete,edit])
        return swipeConfiguration
    }
    
    

}
