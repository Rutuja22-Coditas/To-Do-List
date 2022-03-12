//
//  TableViewCell.swift
//  To-Do List
//
//  Created by Coditas on 24/02/22.
//

import UIKit
import RealmSwift

protocol cellImageTapDelegate {
    func tableCell(tableCell:UITableViewCell)
}

class TableViewCell: UITableViewCell {

    @IBOutlet weak var checkmarkImgV: UIImageView!
    @IBOutlet weak var taskLbl: UILabel!
    @IBOutlet weak var priorityView: UIView!
    
    static let identifier = String(describing: TableViewCell.self)
    let realm = try! Realm()
    var imgTapDelegate : cellImageTapDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        priorityView.layer.cornerRadius = 5.0
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        checkmarkImgV.isUserInteractionEnabled = true
        tapGestureRecognizer.numberOfTapsRequired = 1
        checkmarkImgV.addGestureRecognizer(tapGestureRecognizer)

    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        imgTapDelegate?.tableCell(tableCell: self)

        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //checkmarkImgV.image = selected ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle")
    }
    
    func setUpCell(task :Task){
        
        if task.taskCompleted == true{
            checkmarkImgV.image = UIImage(systemName: "checkmark.circle.fill")
        }
        else if task.taskCompleted == false{
            checkmarkImgV.image = UIImage(systemName: "circle")

        }
        
        //if checkmarkImgV.image = UIImage(systemName: "circle")
        
        //checkmarkImgV.image = task.taskCompleted == false ? UIImage(systemName: "circle"):UIImage(systemName: "checkmark.circle.fill")
        taskLbl.text = task.task
                
        if task.priority == "High"{
            priorityView.backgroundColor = UIColor.red
        }
        else if task.priority == "Medium"{
            priorityView.backgroundColor = UIColor.yellow
        }
        else if task.priority == "Low"{
            priorityView.backgroundColor = UIColor.green
        }
    }
    
}
