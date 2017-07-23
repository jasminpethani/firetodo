//
//  TodoListCell.swift
//  TodoListFirebase
//
//  Created by jasmin on 14/07/17.
//  Copyright © 2017 jazz. All rights reserved.
//

import UIKit

class TodoListCell: UITableViewCell {
     
     @IBOutlet weak var nameLabel: UILabel!
     
     @IBOutlet weak var descLabel: UILabel!
     
     @IBOutlet weak var dateLabel: UILabel!
     
     
     func configure(_ t: TodoItem) {
          nameLabel?.text = t.title
          descLabel.text = t.text
          dateLabel.text = t.updatedFormattedDate()
     }

     override func awakeFromNib() {
          super.awakeFromNib()
          nameLabel.text = nil
          descLabel.text = nil
          dateLabel.text = nil
          
          selectionStyle = .none
     }
     
     func changeUI(on isCompleted: Bool) {
          
          let lightGray_0_5 = UIColor.lightGray.withAlphaComponent(0.5)
          nameLabel.textColor = isCompleted ? lightGray_0_5 : UIColor.black
          descLabel.textColor = isCompleted ? lightGray_0_5 : UIColor.black
          dateLabel.textColor = isCompleted ? lightGray_0_5 : UIColor.lightGray.withAlphaComponent(0.8)
          
          backgroundColor = isCompleted ?  UIColor.lightGray.withAlphaComponent(0.03) : UIColor.white
     }
}
