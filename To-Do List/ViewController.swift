//
//  ViewController.swift
//  To-Do List
//
//  Created by Coditas on 24/02/22.
//

import UIKit


class ViewController: UITabBarController {
    
    let addButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAddButton()
        tabBar.backgroundColor = UIColor.white
        tabBarItem.badgeColor = UIColor(red: 0/255.0, green: 197/255.0, blue: 254/255.0, alpha: 1)
    }
    
    func setUpAddButton(){
        addButton.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
        var buttnFrame = addButton.frame
        buttnFrame.origin.y = view.bounds.height - buttnFrame.height - 50
        buttnFrame.origin.x = view.bounds.width/2 - buttnFrame.size.width/2
        addButton.frame = buttnFrame
        addButton.layer.cornerRadius = buttnFrame.height/2
        addButton.imageView?.contentMode = .scaleAspectFit
        addButton.imageEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)

        
        addButton.backgroundColor = UIColor(red: 0/255.0, green: 197/255.0, blue: 254/255.0, alpha: 1)
        
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addButton.tintColor = .white
        
        addButton.addTarget(self, action: #selector(addButtonAction(sender:)), for: .touchUpInside)
        view.layoutIfNeeded()
        
        view.insertSubview(addButton, aboveSubview: self.tabBar)
        
    }
    
    @objc func addButtonAction(sender: UIButton){
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New To-Do Task", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            print("textInTxtFld",textField.text!)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField { (textFieldForPriority) in
            textFieldForPriority.placeholder = "Set Priority"
            textField = textFieldForPriority
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
   
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        // I added this line
        UITabBar.appearance().tintColor = UIColor(red: 0/255.0, green: 197/255.0, blue: 254/255.0, alpha: 1)

        return true
    }
    
    
}

