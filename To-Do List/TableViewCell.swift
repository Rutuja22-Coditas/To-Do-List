//
//  TableViewCell.swift
//  To-Do List
//
//  Created by Coditas on 24/02/22.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var checkmarkImgV: UIImageView!
    @IBOutlet weak var taskLbl: UILabel!
    @IBOutlet weak var priorityView: UIView!
    
    static let identifier = String(describing: TableViewCell.self)

    override func awakeFromNib() {
        super.awakeFromNib()
        priorityView.layer.cornerRadius = 5.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkmarkImgV.image = selected ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle")
    }
    
    func setUpCell(task :Task){
        taskLbl.text = task.task
    }
    
}
