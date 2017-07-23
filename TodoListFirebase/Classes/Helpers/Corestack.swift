//
//  Corestack.swift
//  TodoListFirebase
//
//  Created by jasmin on 13/07/17.
//  Copyright © 2017 jazz. All rights reserved.
//

import Foundation
import CoreData

struct Corestack {
     
     lazy var persistentContainer: NSPersistentContainer = {
          let container = NSPersistentContainer(name: "TodoListFirebase")
          container.loadPersistentStores(completionHandler: { (storeDescription, error) in
               if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
               }
          })
          return container
     }()
     
     
     mutating func saveContext () {
          let context = persistentContainer.viewContext
          if context.hasChanges {
               do {
                    try context.save()
               } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
               }
          }
     }
}
