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
    
    static let identifier = String(describing: TableViewCell.self)

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkmarkImgV.image = selected ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle")
    }
    
}
