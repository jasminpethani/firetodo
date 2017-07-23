//
//  ViewController.swift
//  TodoListFirebase
//
//  Created by jasmin on 13/07/17.
//  Copyright © 2017 jazz. All rights reserved.
//

import UIKit

import FirebaseDatabase
import FirebaseAuthUI


class TodoListViewController: UIViewController {
     
     @IBOutlet weak var todoTableView: UITableView!
     
     fileprivate var todoList:[TodoItem] = []
     fileprivate var databaseRef:DatabaseReference!
     fileprivate var _refHandle:DatabaseHandle!
     fileprivate var _refDeleteHandle: DatabaseHandle!
     
     
     var todoDatabaseRef:DatabaseReference! {
          return databaseRef.child(TodoConstant.todos)
     }
     
     struct TodoListConstants {
          static let todoDetailNavigate = "@todoDetail"
          struct TodoCellIdentifiers {
               static let todoItemCellIdentifier = "TodoItemCell"
          }
     }
     
     
     // MARK:- Firebase Observables
     
     fileprivate func observeValueChange() {
          _refHandle = todoDatabaseRef
               .observe(.value, with: { [unowned self] (snapshot) in
                    
                    if snapshot.exists() {
                         var todos:[TodoItem] = []
                         for snap in snapshot.children.allObjects as! [DataSnapshot] {
                              if let dict = snap.value as? [String:Any] {
                                   let todo = TodoItem(snap.key, dict: dict)
                                   todo.updatedDate = dict[TodoConstant.updatedTimeStamp] as! UInt64
                                   todos.append(todo)
                              }
                         }
                         
                         self.todoList = todos.sorted {  $0.updatedDate > $1.updatedDate }
                         
                    } else {
                         debugPrint("No snapshot records founds")
                    }
                    
                    DispatchQueue.main.async {
                         self.todoTableView.reloadData()
                    }
          })
     }
     
     fileprivate func observeChildRemove() {
          _refDeleteHandle = todoDatabaseRef.observe(.childRemoved, with: {
               [unowned self] (snapshot) in
               
               DispatchQueue.main.async {
                    for (i, todo) in self.todoList.enumerated() where todo.todoId == snapshot.key {
                         self.todoTableView.beginUpdates()
                         self.todoList.remove(at: i)
                         let index = IndexPath(row: i, section: 0)
                         self.todoTableView.deleteRows(at: [index], with: .fade)
                         self.todoTableView.endUpdates()
                    }
               }
          })
     }
  
     
     
     @IBAction func addTodoItem() {
          let alert = UIAlertController(title: _appName_, message: nil, preferredStyle: .alert)
          alert.message = "Type of title and text of Todo here."
          alert.addTextField { (textField) in
               textField.placeholder = "Title"
          }
          alert.addTextField { (textField) in
               textField.placeholder = "Text"
          }
          
          let addAction = UIAlertAction(title: "Add", style: .default, handler: {
               [unowned self] (action) -> Void in
               
               let title = alert.textFields?[0].text  ?? "[title]"
               let text = alert.textFields?[1].text ?? "[text]"
               
               let dict:[String : Any] = [
                    TodoConstant.title: title,
                    TodoConstant.text: text,
                    TodoConstant.category: "[category]",
                    TodoConstant.completed: false,
                    TodoConstant.updatedTimeStamp: ServerValue.timestamp(),
               ]
               
               self.todoDatabaseRef.childByAutoId().setValue(dict)
               
               DispatchQueue.main.async {
                    self.todoTableView.reloadData()
               }
          })
          
          alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
          alert.addAction(addAction)
          
          self.present(alert, animated: true, completion: nil)
     }
     
     
     // Actions
     
     func onLoginButton(_ sender: UIBarButtonItem) {
          Auth.auth().addStateDidChangeListener { (auth, user) in
               if user != nil {
                    debugPrint("Logged in with userId: \(String(describing: user!.email))")
               } else {
                    
                    if let authCtrl = FUIAuth.defaultAuthUI()?.authViewController() {
                         self.present(authCtrl, animated: true, completion: nil)
                    }
               }
          }
     }
     
     
     private func configDB() {
          databaseRef = Database.database().reference()
          
          // Observers
          
          observeValueChange()
          observeChildRemove()
     }
     
     // MARK:- Life cycle methods
     
     override func viewDidLoad() {
          super.viewDidLoad()
          
          todoTableView.separatorInset = .zero
          todoTableView.rowHeight = UITableViewAutomaticDimension
          todoTableView.estimatedRowHeight = 65
          todoTableView.tableFooterView = UIView()
          
          // FIXME: store it somewhere
//          todoTableView.setEditing(true, animated: true)
          
          configDB()
          
        
          self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Login", style: .done, target: self, action: #selector(TodoListViewController.onLoginButton(_:)))
          
     }
     
     deinit {
          databaseRef.removeObserver(withHandle: _refHandle)
          databaseRef.removeObserver(withHandle: _refDeleteHandle)
     }
     
     // Navigation
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == TodoListConstants.todoDetailNavigate {
               let itemDetail = segue.destination as! TodoItemDetailViewController
               itemDetail.todosDBRef = self.todoDatabaseRef
               itemDetail.todoItem  = sender as! TodoItem
          }
     }
     
}



extension TodoListViewController: UITableViewDataSource, UITableViewDelegate {
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return todoList.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let t = todoList[indexPath.row]
          let cell = tableView.dequeueReusableCell(withIdentifier: TodoListConstants.TodoCellIdentifiers.todoItemCellIdentifier, for: indexPath) as! TodoListCell
          
          cell.changeUI(on: t.isCompleted)
          cell.configure(t)
          return cell
     }
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          let todo = self.todoList[indexPath.row]
          if !todo.isCompleted {
               self.performSegue(withIdentifier: TodoListConstants.todoDetailNavigate, sender: todo)
          }
     }
     
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
          let todo = self.todoList[indexPath.row]
          return !todo.isCompleted
     }
     
//     func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
//          return UITableViewCellEditingStyle(rawValue: 3)! // checkbox
//     }
     
     func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
          
          let completed  =  UITableViewRowAction(style: .normal, title: "Done", handler: {
               [unowned self] (rowAction, indexPath) in
               let todo = self.todoList[indexPath.row]
               todo.isCompleted = true
               self.todoDatabaseRef.child(todo.todoId).updateChildValues(todo.dictionary)
               
               DispatchQueue.main.async {
                    tableView.beginUpdates()
                    tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.right)
                    tableView.endUpdates()
               }
          })
          completed.backgroundColor = UIColor(red:0.20, green:0.60, blue:0.46, alpha:1.00)
          
          let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") {
               [unowned self]  (rowAction, indexPath) in
               let todo = self.todoList[indexPath.row]
               self.todoDatabaseRef.child(todo.todoId).removeValue()
          }
          
          return [completed, deleteAction]
     }
}


