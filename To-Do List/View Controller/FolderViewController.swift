//
//  FolderViewController.swift
//  To-Do List
//
//  Created by Coditas on 25/02/22.
//

import UIKit
import RealmSwift
class FolderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let realm = try! Realm()
    let dateFormatter = DateFormatter()
    var tasks : Results<Task>!
    var completedTasks : Results<Task>!
    var dictionaryOfCompletedTask = [String:[Task]]()
    
    
    var dictionary = [String:[Task]]()

    @IBOutlet weak var completedTaskTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dataAdd()

    }
    func dataAdd(){
        //tasks = realm.objects(Task.self).sorted(byKeyPath: "date", ascending: true)
        let form = DateFormatter()
        form.dateFormat = "dd MM yyyy"
        completedTasks = realm.objects(Task.self).filter("taskCompleted = true")
//        for task in completedTasks.filter("taskCompleted == false"){
//            try! self.realm.write{
//                self.realm.delete(task)
//            }
//        }
        
        dictionaryOfCompletedTask = Dictionary(grouping: completedTasks, by: {form.string(from: $0.date!)})
       completedTaskTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dictionaryOfCompletedTask.keys.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let headerToPrint = Array(dictionaryOfCompletedTask.keys)
        if self.tableView(completedTaskTableView, numberOfRowsInSection: section) > 0{
            return headerToPrint[section]
        }
        else{
            return nil
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let keys = Array(dictionaryOfCompletedTask.keys)
        let task = dictionaryOfCompletedTask[keys[section]]!
        return task.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = completedTaskTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let keys = Array(dictionaryOfCompletedTask.keys)
        let task = dictionaryOfCompletedTask[keys[indexPath.section]]!
        let taskToPrint = task[indexPath.row]
        cell.textLabel?.text = taskToPrint.task
        return cell
    }
}
