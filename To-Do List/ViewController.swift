//
//  ViewController.swift
//  To-Do List
//
//  Created by Coditas on 24/02/22.
//

import UIKit


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var toDoDataArray = [ToDoData]()
    var editTxtFld : UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupMiddleButton()
        dataAdd()
        setUpUI()
        tabBarDesign()
        tableView.register(UINib(nibName: TableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TableViewCell.identifier)
        
        let label = UILabel(frame: .init(x: 0, y: view.bounds.height - 150, width: view.bounds.width, height: 150))
        label.backgroundColor = .green
        label.text = "rrrrrr"
        view.addSubview(label)
    }
    
    func dataAdd(){
        toDoDataArray = [ToDoData(date: "Today, 24 Feb 2022", task: ["Go to Market","Go to gym"])]
    }
    
    func setUpUI(){
        tableView.sectionHeaderHeight = 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        toDoDataArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        toDoDataArray[section].task.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell
        cell?.taskLbl.text = toDoDataArray[indexPath.section].task[indexPath.row]
        
        return cell!
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        toDoDataArray[section].date
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let currentCell = tableView.cellForRow(at: indexPath)as? TableViewCell
        if currentCell?.checkmarkImgV.image == UIImage(systemName: "checkmark.circle.fill"){
            currentCell?.checkmarkImgV.image = UIImage(systemName: "circle")
        }
        else if currentCell?.checkmarkImgV.image == UIImage(systemName: "circle"){
            currentCell?.checkmarkImgV.image = UIImage(systemName: "checkmark.circle.fill")
        }
                
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
                self.toDoDataArray[indexPath.section].task[indexPath.row] = updateTask!
                tableView.reloadData()
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                print("cancel")
            }
            alertForEdit.addTextField { (textField) in
                self.editTxtFld = textField
                self.editTxtFld?.placeholder = "Update the task"
                self.editTxtFld?.text = self.toDoDataArray[indexPath.section].task[indexPath.row]
            }
            
            alertForEdit.addAction(update)
            alertForEdit.addAction(cancel)
            self.present(alertForEdit, animated: true, completion: nil)
        }
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            print("delete")
            self.toDoDataArray[indexPath.section].task.remove(at: indexPath.row)
            tableView.reloadData()
        }
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [delete,edit])
        return swipeConfiguration
    }
    
    func tabBarDesign(){
        guard let tabBar = tabBarController?.tabBar else {
            return
        }
        tabBar.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        //tabBar.bringSubviewToFront(label)
    }
    
//    func setupMiddleButton() {
//            let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
//
//            var menuButtonFrame = menuButton.frame
//            //menuButtonFrame.origin.y = view.bounds.height - menuButtonFrame.height
//            menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
//            menuButton.frame = menuButtonFrame
//
//            menuButton.backgroundColor = UIColor.red
//            menuButton.layer.cornerRadius = menuButtonFrame.height/2
//            view.addSubview(menuButton)
//
//        menuButton.frame.origin.y = self.view.bounds.height - menuButton.frame.height - self.view.safeAreaInsets.bottom
//
//            menuButton.setImage(UIImage(named: "plus"), for: .normal)
//            menuButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)
//
//            view.layoutIfNeeded()
//
//        }
    
    @objc func menuButtonAction(sender:UIButton){
        print("ok")
    }
}

