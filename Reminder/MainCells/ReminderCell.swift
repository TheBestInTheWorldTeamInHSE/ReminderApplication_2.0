//
//  ReminderCell.swift
//  Reminder
//
//  Created by Aleksa on 20.07.2020.
//  Copyright © 2020 Aleksa. All rights reserved.
//

import UIKit

class ReminderCell: UICollectionViewCell {

    @IBOutlet weak var reminderImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    @IBOutlet weak var titleLable: UILabel!
    
    func set(reminder: Base.Reminder){
        self.titleLable.text = reminder.title
    }

}
