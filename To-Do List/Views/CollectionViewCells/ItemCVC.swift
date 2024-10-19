//
//  ItemCVC.swift
//  To-Do List
//
//  Created by Sooraj R on 19/10/24.
//

import UIKit

class ItemCVC: UICollectionViewCell {
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemDesc: UILabel!
    @IBOutlet weak var itemDueDate: UILabel!
    @IBOutlet weak var itemPriority: UILabel!
    @IBOutlet weak var itemPriorityView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }

    func setCellData(data:TaskModel){
        itemTitle.text = data.title
        itemDesc.text = data.desc
        itemDueDate.text = data.dueDate
        itemPriority.text = data.priority.capitalized
        let priority = TaskPriority(rawValue: data.priority) ?? .low
        switch priority {
        case .high:
            itemPriorityView.backgroundColor = UIColor.systemRed.withAlphaComponent(0.3)
        case .medium:
            itemPriorityView.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.3)
        case .low:
            itemPriorityView.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.3)
        }
    }
}
