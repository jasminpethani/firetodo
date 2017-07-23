//
//  TodoItem.swift
//  TodoListFirebase
//
//  Created by jasmin on 13/07/17.
//  Copyright © 2017 jazz. All rights reserved.
//

import Foundation
import FirebaseDatabase

class TodoItem {
     var todoId:String
     var title:String
     var text: String
     var category: String
     var isCompleted:Bool = false
     var createdAt: UInt64 = 0
     var updatedDate: UInt64 = 0
     
     init(_ title:String, desc:String, category:String ) {
          self.todoId = ""
          self.category = category
          self.title = title
          self.text = desc
     }
     
     init(_ autoKey:String, dict:[String: Any]) {
          self.todoId = autoKey
          self.title = dict[TodoConstant.title] as! String
          self.text = dict[TodoConstant.text] as! String
          self.category = dict[TodoConstant.category] as! String
          self.isCompleted = dict[TodoConstant.completed] as? Bool ?? false
     }
     
     
     func updatedFormattedDate() -> String {
          let df = DateFormatter()
          df.dateFormat = "dd-MMM-yyyy hh:ss a"
          let date = Date(timeIntervalSince1970: TimeInterval(updatedDate / 1000))
          return df.string(from: date)
     }
     
     
     var dictionary:[String: Any]  {
          let dict = [
               TodoConstant.title: title,
               TodoConstant.text: text,
               TodoConstant.category: category,
               TodoConstant.completed: isCompleted,
               TodoConstant.updatedTimeStamp: updatedDate
               ] as [String : Any]
          return dict
     }
     
     
}
