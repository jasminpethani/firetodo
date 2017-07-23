//
//  TodoItemDetailViewController.swift
//  TodoListFirebase
//
//  Created by jasmin on 13/07/17.
//  Copyright © 2017 jazz. All rights reserved.
//

import UIKit
import FirebaseDatabase

class TodoItemDetailViewController: UIViewController {
     
     private var isEditMode: Bool = false
     var todosDBRef:DatabaseReference!
     var todoItem: TodoItem!
     
     private var titleTextField:UITextField!
     private var categoryTextField:UITextField!
     private var dateTextField:UITextField!
     private var noteTextView: UITextView!
     
     private  var editButton:UIBarButtonItem {
         return UIBarButtonItem(image: #imageLiteral(resourceName: "img_edit"), style: .plain, target: self, action: #selector(edit(_:)))
     }
     
    private  var deleteButton:UIBarButtonItem {
         return UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteTodo(_:)))
     }
     
     // Action methods
     
     @objc func deleteTodo(_ sender: Any) {
          //TODO: confirm this with user
          
          todosDBRef.child(todoItem.todoId).removeValue()
          
          self.navigationController?.popViewController(animated: true)
     }
     
     @objc func edit(_ sender: Any) {
          isEditMode = !isEditMode
          
          changeAppearanceOnEditMode()
          
          if !isEditMode {
               let dict = [
                    TodoConstant.title: titleTextField.text ?? "",
                    TodoConstant.text: noteTextView.text ?? "",
                    TodoConstant.category: categoryTextField.text ?? "",
                    TodoConstant.updatedTimeStamp: dateTextField.text ?? ""
               ]
               todosDBRef.child(todoItem.todoId).updateChildValues(dict)
          }
          
     }
     
     private func changeAppearanceOnEditMode() {
          titleTextField.isEnabled = isEditMode
          categoryTextField.isEnabled = isEditMode
          dateTextField.isEnabled = isEditMode
          noteTextView.isEditable = isEditMode
     }
     
     private func updateItemDetails() {
          titleTextField.text = todoItem.title
          categoryTextField.text = todoItem.category
          dateTextField.text = todoItem.updatedFormattedDate()
          noteTextView.text = todoItem.text
     }
     
     // MARK:- View Life cycle methods
     
     override func viewDidLoad() {
          super.viewDidLoad()
          self.title = todoItem.title
          
          self.navigationItem.rightBarButtonItems = [deleteButton, editButton]
          
          
          // View has been loaded
          titleTextField = view.viewWithTag(101) as! UITextField
          categoryTextField = view.viewWithTag(102) as! UITextField
          dateTextField = view.viewWithTag(103) as! UITextField
          noteTextView = view.viewWithTag(104) as! UITextView
          
          updateItemDetails()
          changeAppearanceOnEditMode()
     }
}


extension TodoItemDetailViewController: UITextFieldDelegate {
     
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          textField.resignFirstResponder()
          return true
     }
}
