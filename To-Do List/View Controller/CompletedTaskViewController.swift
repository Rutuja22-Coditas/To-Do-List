//
//  CompletedTaskViewController.swift
//  To-Do List
//
//  Created by Coditas on 25/02/22.
//

import UIKit


class CompletedTaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var editTxtFld : UITextField?
    
    var date : Date?
    override func viewDidLoad() {
        super.viewDidLoad()
        dataAdd()
        setUpUI()
        tableView.register(UINib(nibName: TableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TableViewCell.identifier)
    }

    func dataAdd(){
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "EEEE, dd MM yyyy"
        toDoDataArray = [ToDoData(date: dateFormatter.date(from: "Monday, 10 05 2011")!, priority: "High", task: "Buy bread")]
        let filterData = toDoDataArray.filter{$0.date == date}
        print("filteredData",filterData)
       
    }
    
    func setUpUI(){
        tableView.sectionHeaderHeight = 60
    }
  
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        print("sectionCount",toDoDataArray.count)
//        return 1
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoDataArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell
        cell?.taskLbl.text = toDoDataArray[indexPath.row].task
        //cell?.taskLbl.text = toDoDataArray[indexPath.row].task
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
            tableView.deleteRows(at: [indexPath], with: .automatic)
            //toDoDataArray[indexPath.section].taskData.remove(at: indexPath.row)
            tableView.reloadData()
        }
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [delete,edit])
        return swipeConfiguration
    }
    
    

}
